import { Elysia, t } from "elysia";
import { Database } from "bun:sqlite";

const CHECK_IF_USER_EXISTS = `SELECT 1 FROM clientes WHERE id = $clientId;`;

const READ_TRANSACTION_SQL = `
SELECT valor, tipo, descricao, realizada_em
FROM transacoes t
JOIN clientes c on c.id = t.cliente_id
WHERE c.id = $clientId
ORDER BY t.realizada_em DESC
LIMIT 10;`;

const READ_ACCOUNT_STATEMENT_SQL = `
SELECT c.limite as limite, datetime('now', 'localtime') as data_extrato, s.valor as total 
FROM clientes c 
JOIN saldos s on c.id = s.cliente_id 
WHERE c.id = $clientId;`;

const SELECT_ACCOUNT_STATEMENT_FOR_UPDATE = `
SELECT c.limite as limite, s.valor as total
FROM clientes c 
JOIN saldos s on c.id = s.cliente_id 
WHERE c.id = $clientId;`;

const UPDATE_ACCOUNT_STATEMENT = `UPDATE saldos SET valor = $novoSaldo WHERE cliente_id = $clientId;`;

const INSERT_TRANSACTION = `INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES ($clientId, $valor, $tipo, $descricao);`;

const checkForClientId = (id) => {
  return !isNaN(Number(id)) ? Number(id) : undefined;
};

const clientNotFound = (set) => {
  set.status = 404;
  set.headers["Content-Type"] = "application/json";
  return "client not found";
};

const validateTransactionFields = (valor, tipo, descricao) => {
  if (isNaN(Number(valor)) || Number(valor) <= 0 || !Number.isInteger(valor)) {
    return {
      status: 422,
      message: "valor must be greater then zero",
    };
  } else if (tipo !== "d" && tipo !== "c") {
    return {
      status: 422,
      message: "tipo must be d || c",
    };
  } else if (!descricao || descricao?.length < 1 || descricao?.length > 10) {
    return {
      status: 422,
      message: "descricao must be between 1 and 10 characters",
    };
  }
  return {
    status: 200,
  };
};

const accountStatement = async ({ params: { id }, store, set }) => {
  const clientId = checkForClientId(id);
  if (!clientId) return clientNotFound(set);
  const get_balance = store.db.prepare(READ_ACCOUNT_STATEMENT_SQL);
  const get_transactions = store.db.prepare(READ_TRANSACTION_SQL);
  const db_transaction = db.transaction((clientId) => {
    const balance = get_balance.get(clientId);
    if (balance) {
      const transactions = get_transactions.all(clientId);
      return { balance, transactions };
    }
    return undefined;
  });
  const data = db_transaction.exclusive({ $clientId: clientId });
  if (!data) return clientNotFound(set);
  return { saldo: data.balance, ultimas_transacoes: data.transactions };
};

const transaction = async ({ body, params: { id }, store, set }) => {
  const clientId = checkForClientId(id);
  if (!clientId) return clientNotFound(set);

  const { valor, tipo, descricao } = body;
  const respose = validateTransactionFields(valor, tipo, descricao);
  if (respose.status !== 200) {
    set.status = respose.status;
    return respose.message;
  }

  const user_exists = store.db.prepare(CHECK_IF_USER_EXISTS);
  const select_saldo = store.db.prepare(SELECT_ACCOUNT_STATEMENT_FOR_UPDATE);
  const update_saldo = store.db.prepare(UPDATE_ACCOUNT_STATEMENT);
  const insert_transaction = store.db.prepare(INSERT_TRANSACTION);

  const db_transaction = db.transaction(
    ({ clientId, valor, tipo, descricao }) => {
      let efetuado = false;
      let novoSaldo = 0;

      const record = user_exists.get({ $clientId: clientId });
      if (record) {
        const { limite, total } = select_saldo.get({ $clientId: clientId });

        novoSaldo = total + valor;
        if (tipo === "d") {
          novoSaldo = total - valor;
          if (novoSaldo < -limite) efetuado = true;
        }

        if (!efetuado) {
          update_saldo.run({ $novoSaldo: novoSaldo, $clientId: clientId });
          insert_transaction.run({
            $clientId: clientId,
            $valor: valor,
            $tipo: tipo,
            $descricao: descricao,
          });
        }
        return { saldo: novoSaldo, limite, efetuado };
      }
      return undefined;
    }
  );
  // db_transaction.exclusive -> BEGIN EXCLUSIVE
  const data = db_transaction.exclusive({ clientId, valor, tipo, descricao });
  if (!data) return clientNotFound(set);
  set.status = !data.efetuado ? 200 : 422;
  return { saldo: data.saldo, limite: data.limite };
};

const db = new Database("/src/data/rinhabackend.db");
db.exec("PRAGMA journal_mode = WAL;");
db.exec("PRAGMA synchronous = NORMAL;");
db.exec("PRAGMA busy_timeout = 15000;");

const app = new Elysia();
app
  .onBeforeHandle(({ store }) => {
    store.db = db;
  })
  .get("/clientes/:id/extrato", accountStatement)
  .post("/clientes/:id/transacoes", transaction);

app.listen(8080, () => {
  console.log(`🦊 Elysia is running at ${app.server?.hostname}:${9999}`);
});
