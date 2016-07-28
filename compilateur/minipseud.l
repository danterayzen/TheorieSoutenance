%option noyywrap
%{

#include "minipseud.h"
#include <stdlib.h>
#include "minipseudtree.h"

%}

empty    [ \t]+

num   [0-9]
int    {num}+
exp  [eE][+-]?{int}

real      {int}("."{int})?{exp}?

var  [a-z][a-zA-Z0-9]*

%%

{empty}  { /* Nothing */ }

{var}    {
    yylval.node = createNode(NTVAR);
    yylval.node->var = (char*)_strdup(yytext);
    return(VAR);
    }

"("   return(OP_PAR);
")"   return(CL_PAR);


{real}    {
    yylval.node = createNode(NTNUM);
    yylval.node->val = atof(yytext);
    return(NUM);
    }

"+"   { yylval.node = createNode(NTPLUS); return(PLUS); }
"-"   { yylval.node = createNode(NTMIN); return(MIN); }
"*"   { yylval.node = createNode(NTMULT); return(MULT); }
"/"   { yylval.node = createNode(NTDIV); return(DIV); }
"^"   { yylval.node = createNode(NTPOW); return(POW); }




"VRAI" { yylval.node = createNode(NTTRUE); return(TRUE); }
"FAUX" { yylval.node = createNode(NTFALSE); return(FALSE); }

"=="  { yylval.node = createNode(NTEQ); return(EQ); }
"!="  { yylval.node = createNode(NTNEQ); return(NEQ); }
">"   { yylval.node = createNode(NTGT); return(GT); }
"<"   { yylval.node = createNode(NTLT); return(LT); }
">="  { yylval.node = createNode(NTGET); return(GET); }
"<="  { yylval.node = createNode(NTLET); return(LET); }

"ET"  { yylval.node = createNode(NTAND); return(AND); }
"OU"  { yylval.node = createNode(NTOR); return(OR);}
"NON" { yylval.node = createNode(NTNOT); return(NOT); }


"="       { yylval.node = createNode(NTAFF); return(AFF); }
"AFFICHER" { yylval.node = createNode(NTPRINT); return(PRINT); }
"SI"      { yylval.node = createNode(NTIF); return(IF); }
"ALORS"   { yylval.node = createNode(NTTHEN); return(THEN); }
"SINON"   { return(ELSE); }
"FIN"     { return(END); }
"TANTQUE" { yylval.node = createNode(NTWHILE); return(WHILE); }
"FAIRE"   { return(DO); }


"GRAPH"   { return(GRAPH); }
"QUITTER" { return(QUIT); }

";"    { return(COLON); }

"\n"   { return(EOL); }
