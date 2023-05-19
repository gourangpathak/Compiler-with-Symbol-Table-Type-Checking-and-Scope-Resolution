
%{

// Header Files
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

// Maximum
#define MAXIMUM 1000

// DataStructure to store name and type.
typedef struct Symbol {
char name[100];
char type[100];
} Symbol;

// The following data structure is used to point to a symbol table for current scope. 
// For each scope this data structure will be created and when we move out of that scope this data structure will be popped.

typedef struct SymbolTable {
    Symbol symbol_table[MAXIMUM];
    int num_symbols;
    struct SymbolTable* parent; // Pointer to the parent symbol table
} SymbolTable;


SymbolTable* current_symbol_table; // Pointer to the current symbol table

// This data structure is used as the return type for lookup operation. Lookup operation will return the index and the symbol table in which that identifier is found.
typedef struct returnLookup{
    int index;
    SymbolTable* indexTable;
}returnLookup;



// Function prototypes
void init_symbol_table();
void push_symbol_table();
void pop_symbol_table();
returnLookup* lookup_symbol_table(char* name);
returnLookup* lookup_symbol_table_parent(char*, SymbolTable* );
void add_symbol_table(char* name, char* type);

int yylex(void);
int yyerror(char *);

// Universal variable to store the type
char decl_type[100];

%}

%union{
char* stringval;
}

%token INTEGER_CONSTANT FLOAT_CONSTANT SEMICOLON COMMA ASSIGN IF ELSE RELOP AND OR NOT EQ GE LE LT GT NE WHILE RETURN FOR
%token <stringval> ID INT FLOAT BOOL
%type <stringval> EXP TERM FACTOR type

%%

// Production Rules

prog     : funcDef{ printf("Accepted\n"); }; 
funcDef  : type ID {  add_symbol_table($2, $1); push_symbol_table(); } '(' argList ')' '{' declList stmtList '}' { if(!strcmp($2,"main")){   // If main function, it will print its symbol table
    printf("\n-------------------------------Main Function Symbol Table-----------------------------------\n");
	for(int i=0; i< current_symbol_table->num_symbols; i++){
	    printf("ID:  %s - TYPE: %s\n", current_symbol_table->symbol_table[i].name, current_symbol_table->symbol_table[i].type);
	}
	printf("\n--------------------------------------------------------------------------------------------\n");


 }
 pop_symbol_table(); };
argList  : arg ',' arg | ;
arg      : type ID { add_symbol_table($2, $1); };
declList : decl SEMICOLON declList | ;
decl     : type { strcpy(decl_type, $1); } varList;
varList  : ID COMMA varList { add_symbol_table($1, decl_type); } | ID { add_symbol_table($1, decl_type); };
type     : INT { $$ = $1; } | FLOAT { $$ = $1; } | BOOL { $$ = $1; };
stmtList : stmtList stmt | stmt;
stmt : assignStmt | ifStmt | whileStmt | elseStmt | elseIfStmt | forStmt | declassignstmt;
declassignstmt : type ID ASSIGN EXP SEMICOLON { 

        returnLookup* rl= lookup_symbol_table($2);;

        int flag = rl->index; 
        if(flag>=0){
            printf("\nWarning: The identifier %s is already declared above.\n\n", $2);
        }
        else{
            add_symbol_table($2, $1);
        }

 };


assignStmt : ID ASSIGN EXP SEMICOLON
{               

                returnLookup* rl= lookup_symbol_table($1);;
                int flag = rl->index;

                
                // This will check if assignment passes the typecheck
                if(flag >= 0){
                    if( !strcmp(rl->indexTable->symbol_table[flag].type,"int") && !strcmp($3,"boolean")){
                        printf("\nWarning: The left side: %s is integer and a boolean value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"boolean") && !strcmp($3,"int")){
                        printf("\nWarning: The left side: %s is boolean and an integer value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"float") && !strcmp($3,"int")){
                        printf("\nWarning: The left side: %s is float and an integer value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"int") && !strcmp($3,"float")){
                        printf("\nWarning: The left side: %s is int and an float value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"boolean") && !strcmp($3,"float")){
                        printf("\nWarning: The left side: %s is boolean and a float value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"float") && !strcmp($3,"boolean")){
                        printf("\nWarning: The left side: %s is float and a boolean value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type, $3)){
                        
                    }
                    else{
                       printf("\n\nWarning: Identifier not declared  \n\n");
                    }
                }
                else{
                    printf("\n\nWarning: Identifier %s not declared. \n\n", $1);
                }
            }
| ID ASSIGN EXP
{               

                returnLookup* rl= lookup_symbol_table($1);;
                int flag = rl->index; 

                //printf("\n %d \n \n",flag);
                           //     printf("\n %s, %s \n",symbol_table[flag].type, $3);
                // This will check if assignment passes the typecheck
                if(flag >= 0){
                    if( !strcmp(rl->indexTable->symbol_table[flag].type,"int") && !strcmp($3,"boolean")){
                        printf("\nWarning: The left side: %s is integer and a boolean value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"boolean") && !strcmp($3,"int")){
                        printf("\nWarning: The left side: %s is boolean and an integer value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"float") && !strcmp($3,"int")){
                        printf("\nWarning: The left side: %s is float and an integer value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"int") && !strcmp($3,"float")){
                        printf("\nWarning: The left side: %s is int and an float value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"boolean") && !strcmp($3,"float")){
                        printf("\nWarning: The left side: %s is boolean and a float value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type,"float") && !strcmp($3,"boolean")){
                        printf("\nWarning: The left side: %s is float and a boolean value is assigned to it.\n\n", $1);
                    }
                    else if(!strcmp(rl->indexTable->symbol_table[flag].type, $3)){
                        
                    }
                    else{
                       printf("\n\nWarning: Identifier not declared  \n\n");
                    }
                }
                else{
                    printf("\n\nWarning: Identifier %s not declared. \n\n", $1);
                }
            }
;



elseStmt     :IF '(' bExp ')' '{' { push_symbol_table();} stmtList '}' { pop_symbol_table(); }  ELSE  '{' { push_symbol_table(); } stmtList '}' { pop_symbol_table(); } | IF '(' bExp ')' '{' { push_symbol_table(); } stmtList '}' { pop_symbol_table(); } elseIfStmtList ELSE '{' { push_symbol_table(); } stmtList '}' { pop_symbol_table(); };
elseIfStmtList : elseIfStmtList elseIfStmt | elseIfStmt ;
elseIfStmt   : ELSE IF '(' bExp ')' '{' { push_symbol_table();}  stmtList '}' { pop_symbol_table(); };
ifStmt : IF '(' bExp ')' '{' { push_symbol_table();} stmtList '}' { pop_symbol_table(); };
whileStmt : WHILE '(' bExp ')' { push_symbol_table(); } '{' stmtList '}' { pop_symbol_table(); };
forStmt  : FOR '(' assignStmt bExp SEMICOLON assignStmt')' { push_symbol_table(); } '{' stmtList '}' { pop_symbol_table(); };
bExp     : EXP RELOP EXP | bExp AND bExp | bExp OR bExp | NOT '(' bExp ')' | EXP AND EXP | EXP OR EXP | NOT '(' EXP ')';


EXP        : EXP '+' TERM {if (!strcmp($1, $3)) {strcpy($$, $1);} else if (!strcmp($1, "undeclared") || !strcmp($3, "undeclared")) {strcpy($$, "undeclared");} else if (!strcmp($1, "float") || !strcmp($3, "float")) {strcpy($$, "float");} else {strcpy($$, "int");}}
           | EXP '-' TERM {if (!strcmp($1, $3)) {strcpy($$, $1);} else if (!strcmp($1, "undeclared") || !strcmp($3, "undeclared")) {strcpy($$, "undeclared");} else if (!strcmp($1, "float") || !strcmp($3, "float")) {strcpy($$, "float");} else {strcpy($$, "int");}}
           | TERM {strcpy($$, $1);};


TERM     : TERM '*' FACTOR {if (!strcmp($1, $3)) {strcpy($$, $1);} else if (!strcmp($1, "undeclared") || !strcmp($3, "undeclared")) {strcpy($$, "undeclared");} else if (!strcmp($1, "float") || !strcmp($3, "float")) {strcpy($$, "float");} else {strcpy($$, "int");}} | TERM '/' FACTOR {if (!strcmp($1, $3)) {strcpy($$, $1);} else if (!strcmp($1, "undeclared") || !strcmp($3, "undeclared")) {strcpy($$, "undeclared");} else if (!strcmp($1, "float") || !strcmp($3, "float")) {strcpy($$, "float");} else {strcpy($$, "int");}} | FACTOR {strcpy($$, $1);};


FACTOR   : ID {
            returnLookup* rl= lookup_symbol_table($1);;
            int flag = rl->index;           
            if (flag == -1) {strcpy($$, "undeclared");} 
            else {strcpy($$, rl->indexTable->symbol_table[flag].type);}
            
            } | INTEGER_CONSTANT {strcpy($$, "int");} | FLOAT_CONSTANT{strcpy($$, "float");};



%%

int main(int argc, char **argv) {
    init_symbol_table(); 
    push_symbol_table();
    yyparse();
    
    printf("\n---------------------------------Universal Symbol Table-------------------------------------\n");
	for(int i=0; i< current_symbol_table->num_symbols; i++){
	    printf("ID:  %s - TYPE: %s\n", current_symbol_table->symbol_table[i].name, current_symbol_table->symbol_table[i].type);
	}
	printf("\n--------------------------------------------------------------------------------------------\n");
	
    return 0;
}


int yyerror(char *s)
{
    fprintf(stderr, "An error in the parser : %s\n", s);
}

// This initialises the symbol table at the start of Parsing.
void init_symbol_table() {
    current_symbol_table = (SymbolTable*)malloc(sizeof(SymbolTable));
    current_symbol_table->num_symbols = 0;
    current_symbol_table->parent = NULL;
}

// This pushes a new symbol table to the stack with its parent pointer pointing to current symbol.
void push_symbol_table() {

    SymbolTable* new_table = (SymbolTable*)malloc(sizeof(SymbolTable));
    new_table->num_symbols = 0;
    new_table->parent = current_symbol_table;
    current_symbol_table = new_table;
}

// When we move out of the scope it pops the symbol table from the stack.
void pop_symbol_table() {
    SymbolTable* old_table = current_symbol_table;
    current_symbol_table = current_symbol_table->parent;
    free(old_table);
}

returnLookup* lookup_symbol_table(char* name) {
    // Search for the symbol in the current scope and its parents
    SymbolTable* table = current_symbol_table;
    while (table != NULL) {
        for (int i = 0; i < table->num_symbols; i++) {
            if (strcmp(table->symbol_table[i].name, name) == 0) {
                returnLookup* rl= (returnLookup*)malloc(sizeof(returnLookup));
                rl->index=i;
                rl->indexTable = table;
                return rl;
            }
        }
        table = table->parent;
    }
     //If not found, Return index -1
     
    returnLookup* rl= (returnLookup*)malloc(sizeof(returnLookup));
    rl->index=-1;
    rl->indexTable = current_symbol_table;
    printf("The identifier is not declared.\n");
    return rl;
}


// This function adds identifier or function with type to the symbol table of current scope.
void add_symbol_table(char* name, char* type) {

    returnLookup* rl= lookup_symbol_table(name);
    int flag = rl->index;

    // Check if the symbol is already declared in the current scope
    if (flag >= 0) {
        printf("Error: The Identifier/Function %s is already declared above\n", name);
        exit(1);
    }    
    
    int count = current_symbol_table->num_symbols;
    SymbolTable* table = current_symbol_table;
    if (count >= MAXIMUM) {
        printf("Error: Symbol table overflow\n");
        exit(1);
    }
    
    strcpy(table->symbol_table[table->num_symbols].name, name);
    strcpy(table->symbol_table[table->num_symbols].type, type);
    table->num_symbols++;
    
    
}

// // This returns the index and the symbol table which contains that identifier or function.
// returnLookup* lookup_symbol_table(char* name) {
//     int i;
//     for (i = 0; i < current_symbol_table->num_symbols; i++) {
//         if (!strcmp(current_symbol_table->symbol_table[i].name, name)) {
//             returnLookup* rl= (returnLookup*)malloc(sizeof(returnLookup));
//             rl->index=i;
//             rl->indexTable = current_symbol_table;
//             return rl;
//         }
//     }
    
//     if (current_symbol_table->parent != NULL) {
//         //printf("\nDebugging\n");
//         return lookup_symbol_table_parent(name, current_symbol_table->parent);
//     }
    
//     returnLookup* rl= (returnLookup*)malloc(sizeof(returnLookup));
//     rl->index=-1;
//     rl->indexTable = current_symbol_table;
//     return rl;
    
// }

// returnLookup* lookup_symbol_table_parent(char* name, SymbolTable* table) {

//    // printf("Debugging:  %d  \n\n",table->num_symbols);
//     int i;
//     for (i = 0; i < table->num_symbols; i++) {

//         if (!strcmp(table->symbol_table[i].name, name)) {
//             returnLookup* rl= (returnLookup*)malloc(sizeof(returnLookup));
//             rl->index=i;
//             rl->indexTable = table;
//             return rl;
//         }
//     }
    
//     if (table->parent != NULL) {
//         return lookup_symbol_table_parent(name, table->parent);
//     }
    
//     returnLookup* rl= (returnLookup*)malloc(sizeof(returnLookup));
//     rl->index=-1;
//     rl->indexTable = current_symbol_table;
//     return rl;
// }
