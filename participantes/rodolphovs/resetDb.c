#include <stdio.h>
#include <stdlib.h>

#define ERROR -1
#define SUCCESS 0

#define raiseIfError(result) \
    if (result == ERROR) {   \
        return ERROR;        \
    }

#define errIfNull(pointer) \
    if (pointer == NULL) { \
        return ERROR;      \
    }

int initDb();

// Initial database setup
const int userInitialLimits[] = {100000, 80000, 1000000, 10000000, 500000};
const int numberInitialUsers = sizeof(userInitialLimits) / sizeof(int);

int main() {
    system("mkdir data");
    int resetDbResult = initDb();
    raiseIfError(resetDbResult);
    return SUCCESS;
}

// Open file mode
#define WRITE_BINARY "wb"

// User File name template
const char* userFileTemplate = "data/user%d.bin";

// move right on a circular array
#define moveRightInTransactions(index) (index = (index + 1) % MAX_TRANSACTIONS)

// User struct constants
#define MAX_TRANSACTIONS 10
#define DATE_SIZE 32
#define DESCRIPTION_SIZE 32
#define FILE_NAME_SIZE 32

typedef struct TRANSACTION {
    int valor;
    char tipo;
    char descricao[DESCRIPTION_SIZE];
    char realizada_em[DATE_SIZE];
} Transaction;

typedef struct USER {
    int id;
    int limit, total;
    int nTransactions;
    int oldestTransaction;
    Transaction transactions[MAX_TRANSACTIONS];
} User;

int writeUser(User* user);

int initDb() {
    User user;
    user.total = 0;
    user.nTransactions = 0;
    user.oldestTransaction = 0;

    for (int id = 0; id < numberInitialUsers; id++) {
        user.id = id + 1;
        user.limit = userInitialLimits[id];
        int writeResult = writeUser(&user);
        if (writeResult == ERROR) {
            return ERROR;
        }
    }

    return SUCCESS;
}

int writeUser(User* user) {
    char fname[FILE_NAME_SIZE];
    sprintf(fname, userFileTemplate, user->id);
    FILE* fpTotals = fopen(fname, WRITE_BINARY);
    errIfNull(fpTotals);
    int fpTotalsFileDescriptor = fileno(fpTotals);
    fwrite(user, sizeof(User), 1, fpTotals);
    fclose(fpTotals);
    return SUCCESS;
}
