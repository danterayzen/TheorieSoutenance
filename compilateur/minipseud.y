%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "minipseudtree.h"
#include "minipseudeval.h"

extern int  yyparse();
extern FILE *yyin;

# define PROMPT "MiniPseud:>"
# define PROMPTG "MiniPseud-Graph:>"
# define BYE "Au revoir ...\n"
# define USAGE "\nMinispeud Usage:\n  minipseud -i                  --> Interactive mode\n  minipseud -f filename         --> File mode\n\n"

Node root;
int pgraph = 0;
int interactive = 1;

%}

%union {
	struct Node *node;
}


%token   <node> NUM VAR
%token   <node> PLUS MIN MULT DIV POW
%token   <node> TRUE FALSE
%token   <node> AND OR NOT EQ NEQ GT LT GET LET 
%token   <node> AFF PRINT IF THEN WHILE
%token   OP_PAR CL_PAR ELSE DO END COLON
%token   EOL
%token   GRAPH QUIT

%type   <node> Instlist
%type   <node> Inst
%type   <node> Expr
  

%left OR
%left AND
%left EQ NEQ
%left GT LT GET LET
%left PLUS  MIN
%left MULT  DIV
%left NEG NOT
%right  POW

%start Input
%%

Input:
      {/* Nothing ... */ }
  | Line Input { /* Nothing ... */ }


Line:
    EOL { if (interactive) return; }
  | Instlist EOL { exec($1); if (interactive) return;}
  | GRAPH EOL { pgraph_change(); if (interactive) return;}
  | QUIT EOL { quit(); exit(0); }
  ; 

Instlist:
    Inst { $$ = nodeChildren(createNode(NTINSTLIST), $1, createNode(NTEMPTY)); } 
  | Instlist Inst { $$ = nodeChildren(createNode(NTINSTLIST), $1, $2); }
  ;

Inst:
    VAR AFF Expr COLON { $$ = nodeChildren($2, $1, $3); }
  | PRINT OP_PAR Expr CL_PAR COLON {
     $$ = nodeChildren($1, $3, createNode(NTEMPTY)); }
  | IF Expr THEN Instlist END COLON { 
      $$ = nodeChildren($1, $2, nodeChildren($3, $4, createNode(NTEMPTY))); }
  | IF Expr THEN Instlist ELSE Instlist END COLON {
      $$ = nodeChildren($1, $2, nodeChildren($3, $4, $6)); }
  | WHILE Expr DO Instlist END COLON { $$ = nodeChildren($1, $2, $4); }
  | Expr COLON { $$ = $1; } 
  ;


Expr:
  TRUE      { $$ = $1;}
  | FALSE   { $$ = $1;}
  | NUM			{ $$ = $1; }
  | VAR     { $$ = $1; } 
  | Expr OR Expr       { $$ = nodeChildren($2, $1, $3); }
  | Expr AND Expr      { $$ = nodeChildren($2, $1, $3); }
  | NOT Expr           { $$ = nodeChildren($1, $2, createNode(NTEMPTY)); }
  | Expr EQ Expr       { $$ = nodeChildren($2, $1, $3); }
  | Expr NEQ Expr      { $$ = nodeChildren($2, $1, $3); }
  | Expr GT Expr       { $$ = nodeChildren($2, $1, $3); }
  | Expr LT Expr       { $$ = nodeChildren($2, $1, $3); }
  | Expr GET Expr      { $$ = nodeChildren($2, $1, $3); }
  | Expr LET Expr      { $$ = nodeChildren($2, $1, $3); }
  | Expr PLUS Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr MIN Expr      { $$ = nodeChildren($2, $1, $3); }
  | Expr MULT Expr     { $$ = nodeChildren($2, $1, $3); }
  | Expr DIV Expr      { $$ = nodeChildren($2, $1, $3); }
  | MIN Expr %prec NEG { $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
  | Expr POW Expr      { $$ = nodeChildren($2, $1, $3); }
  | OP_PAR Expr CL_PAR { $$ = $2; }
  ;


%%

int prompt() {
  if (interactive) printf("%s", (pgraph)?PROMPTG:PROMPT);
}

int quit() {
  printf(BYE);
  exit(0);
}

int exec(Node *node) {
  if (pgraph) {
    printf("Graph:\n");
    printGraph(node);
    printf("\n");
  } 
  eval(node);
}

int pgraph_change() {
  pgraph = !pgraph;
}

int yyerror(char *s) {
  printf("%s\n", s);
}

int interactive_shell() {
  while (1) {
    prompt();
    yyparse();
  }
}

int main(int arc, char **argv) {
  if ((arc == 2) && (strcmp(argv[1], "-i") == 0)) {
    interactive_shell();
  } else if ((arc == 3) && (strcmp(argv[1], "-f") == 0)) {
    interactive = 0;
    FILE *fp=fopen(argv[2],"r");
    if(!fp) {
      printf("Impossible d'ouvrir le fichier à executer.\n");
      exit(0);
    }      
    yyin=fp;
    yyparse();
    fclose(fp);
  } else
    printf(USAGE);
  exit(0);
}
