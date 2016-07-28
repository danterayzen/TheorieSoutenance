#ifndef MINIPSEUDEVAL
# define MINIPSEUDEVAL

typedef struct VarValList {
    char* var;
    double val;
    struct VarValList *next;
    struct VarValList *prev;
} VarValList;


VarValList* setVal(VarValList *ctx, char *var, double val);

double getVal(VarValList *ctx, char *var, jmp_buf env);

#endif