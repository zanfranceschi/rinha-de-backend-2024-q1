import http from 'k6/http';
import {sleep, check} from 'k6';

export let options = {
    stages: [
        { duration: '1s', target: 6 },
        { duration: '10s', target: 4 },
    ]
};

export default function () {

    const transactionUrl1 = 'http://localhost:8081/clientes/0/transacoes';
    const extratoUrl1 = 'http://localhost:8081/clientes/0/extrato';
    const transactionUrl2 = 'http://localhost:8082/clientes/0/transacoes';
    const extratoUrl2 = 'http://localhost:8082/clientes/0/extrato';
    const headers = { 'Content-Type': 'application/json' };

    // Alternating transaction type for each iteration
    const transactionType = (__ITER % 2 === 0) ? "c" : "d";
    const payload = JSON.stringify({
        valor: 1,
        tipo: transactionType,
        descricao: "warmup"
    });

    // Set request timeout options
    const requestOptions = {
        headers: headers,
        timeout: '1s' // Set timeout to 1 second
    };

    // Perform a transaction with a timeout
    let transactionRes1 = http.post(transactionUrl1, payload, requestOptions);
    check(transactionRes1, { 'transaction status was 200': (r) => r.status == 200 });
    let transactionRes2 = http.post(transactionUrl2, payload, requestOptions);
    check(transactionRes2, { 'transaction status was 200': (r) => r.status == 200 });

    // Retrieve the account statement with a timeout
    let extratoRes1 = http.get(extratoUrl1, { timeout: '1s' }); // Apply timeout to GET request
    check(extratoRes1, { 'extrato status was 200': (r) => r.status == 200 });
    let extratoRes2 = http.get(extratoUrl2, { timeout: '1s' }); // Apply timeout to GET request
    check(extratoRes2, { 'extrato status was 200': (r) => r.status == 200 });
}
