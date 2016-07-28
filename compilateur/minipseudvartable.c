#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <setjmp.h>
#include "minipseudvartable.h"

VarValList* setVal(VarValList *ctx, char *var, double val) {
    VarValList *tmpctx = ctx;
    while (tmpctx != NULL) {
        if (strcmp(tmpctx->var, var) == 0) {
            tmpctx->val = val;
            return ctx;
        }
        tmpctx = tmpctx->next;
    }
    VarValList *newVarVal = (VarValList *)malloc(sizeof(VarValList));
    newVarVal->var = (char *)malloc(sizeof(char) * strlen(var));
    strcpy(newVarVal->var, var);
    newVarVal->val = val;
    newVarVal->next = ctx;
    return newVarVal;
}

double getVal(VarValList *ctx, char *var, jmp_buf env) {
    while (ctx != NULL) {
        if (strcmp(ctx->var, var) == 0) {
            return ctx->val;
        }
        ctx = ctx->next;
    }
    printf("La variable \"%s\" n'a pas encore déclarée.\n", var);
    longjmp(env, 1);
}