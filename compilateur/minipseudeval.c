#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <setjmp.h>
#include "minipseudtree.h"
#include "minipseudvartable.h"

# define DONE " - Fait -\n"

// To return from errors gracely
jmp_buf env; 

VarValList *currentCtx = NULL;

int printDepth = 0;
int funcDepth = 0;

double evalExpr(Node *node) {
	switch ( node->type ) {
	case NTEMPTY:  return 0.0;
	case NTNUM: return node->val;
	case NTVAR: return getVal(currentCtx, node->var, env);
	case NTTRUE: return 1.0;
	case NTFALSE: return 0.0;
	case NTOR: return evalExpr(node->children[0])
			|| evalExpr(node->children[1]);
	case NTAND: return evalExpr(node->children[0])
			&& evalExpr(node->children[1]);
	case NTNOT: return !evalExpr(node->children[0]);
	case NTEQ: return evalExpr(node->children[0])
			== evalExpr(node->children[1]);
	case NTNEQ: return evalExpr(node->children[0])
			!= evalExpr(node->children[1]);
	case NTGT: return evalExpr(node->children[0])
			> evalExpr(node->children[1]);
	case NTLT: return evalExpr(node->children[0])
			< evalExpr(node->children[1]);
	case NTGET: return evalExpr(node->children[0])
			>= evalExpr(node->children[1]);
	case NTLET: return evalExpr(node->children[0])
			<= evalExpr(node->children[1]);
	case NTPLUS: return evalExpr(node->children[0])
			+ evalExpr(node->children[1]);
	case NTMIN: return evalExpr(node->children[0])
			- evalExpr(node->children[1]);
	case NTMULT: return evalExpr(node->children[0])
			* evalExpr(node->children[1]);
	case NTDIV: return evalExpr(node->children[0])
			/ evalExpr(node->children[1]);
	case NTPOW: return pow(evalExpr(node->children[0]),
			evalExpr(node->children[1]));
	default: 
		printf("Error in evalExpr ... Wrong node type: %s\n", node2String(node));
		exit(1);
	};
}


void evalInst(Node* node) {
	double val;
	switch ( node->type ) {
	case NTEMPTY: return;
	case NTINSTLIST:
		evalInst(node->children[0]);
		evalInst(node->children[1]);
		return; 
	case NTAFF:
		val = evalExpr(node->children[1]);
		currentCtx = setVal(currentCtx, node->children[0]->var, val);
		if (printDepth == 0)
			printf("%s <- %f\n", node->children[0]->var, val);
		return;
	case NTPRINT:
		printf("%f\n", evalExpr(node->children[0]));
		return;
	case NTIF:
		printDepth += 1;
		if (evalExpr(node->children[0]))
			evalInst(node->children[1]->children[0]);
		else
			evalInst(node->children[1]->children[1]);
		printDepth -= 1;
		if (printDepth == 0)
			printf(DONE);
		return;
	case NTWHILE:
		printDepth += 1;
		while (evalExpr(node->children[0]))
			evalInst(node->children[1]);
		printDepth -= 1;
		if (printDepth == 0)
			printf(DONE);
		return;

	// For expressions, call evalExpr	
	case NTTRUE:
	case NTFALSE:
	case NTNUM:
	case NTVAR:
	case NTOR:
	case NTAND:
	case NTNOT:
	case NTEQ:
	case NTNEQ:
	case NTGT:
	case NTLT:
	case NTGET:
	case NTLET:
	case NTPLUS:
	case NTMIN:
	case NTMULT:
	case NTDIV:
	case NTPOW:
		printf("%f\n", evalExpr(node));
		return;
	//case 31: return node->val;
	//case 32: return 0.0; // TODO --> Context table for vars ...
	default:
		printf("Error in evalInst ... Wrong node type: %s\n", node2String(node));
		exit (1);
	};
}

void eval(Node *node) {
	int i;

	i = setjmp(env);
	if (i != 0) return;
	evalInst(node);
}