#ifndef MINIPSEUDTREE
# define MINIPSEUDTREE
    
enum NodeType {
	NTEMPTY = 0,
	NTINSTLIST = 1,
	
	NTAFF   = 101,
	NTPRINT = 102,
	NTIF    = 103,
	NTTHEN  = 104,
	NTWHILE = 105,

	NTNUM   = 201,
	NTVAR   = 202,
	NTTRUE  = 203,
	NTFALSE = 204,

	NTOR    = 301,
	NTAND   = 302,
	NTNOT   = 303,

	NTEQ    = 311,
	NTNEQ   = 312,
	NTGT    = 313,
	NTLT    = 314,
	NTGET   = 315,
	NTLET   = 316,

	NTPLUS  = 321,
	NTMIN   = 322,
	NTMULT  = 323,
	NTDIV   = 324,
	NTPOW   = 325

};
   
typedef struct Node {
	enum NodeType type;
	union { 
		double val;
		char* var;
		struct Node** children;
	} ;
} Node;

Node* createNode(int type);

Node* nodeChildren(Node* father, Node *child1, Node *child2);

const char* node2String(Node *node);

void printGraph(Node *root);

#endif
