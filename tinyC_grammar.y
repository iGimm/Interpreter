%{
	#include "table.h"  
	#include <string.h> 
	#include <stdio.h>  
	#include <stdlib.h> 

	void yyerror (char *string); /* Implementación de la función yyerror */

	extern int yylex(void); 
	extern int numberLines;
%}

%union{
	int intVal;     /* valor entero */
	float floatVal; /* valor flotante */
	char *string;   /* string */
	struct symtab *symp; /* apuntador a la tabla */
}

%token <intVal> INT_NUM
%token <floatVal> FLOAT_NUM
%token <symp> ID 
%token LBRACE
%token RBRACE
%token LPAREN
%token RPAREN
%token SEMICOLON
%token IF
%token THEN
%token ELSE
%token INT
%token FLOAT
%token WHILE
%token DO
%token READ
%token WRITE
%token PLUS
%token MINUS
%token TIMES
%token DIV
%token ASSIGNMENT
%token RELATIONAL

 
%type <string> type


%nonassoc NOT_ELSE
%nonassoc ELSE


%%
program: var_dec stmt_seq
		 ;

var_dec: var_dec single_dec
		 | epsilon
		 ;

single_dec: type ID SEMICOLON {
	$2->type = strdup($<string>1);
}
			;

type: INT {$<string>$ = "int";} 
	  | FLOAT {$<string>$ = "float";}
	  ;

stmt_seq: stmt_seq stmt
		  | epsilon
		  ;

stmt: IF exp THEN stmt %prec NOT_ELSE 
	  | IF exp THEN stmt ELSE stmt
	  | WHILE exp DO stmt
	  | variable ASSIGNMENT exp SEMICOLON
	  | READ LPAREN variable RPAREN SEMICOLON
	  | WRITE LPAREN exp RPAREN SEMICOLON
	  | block
	  ;

block: LBRACE stmt_seq RBRACE
	   ;

exp: simple_exp RELATIONAL simple_exp
	 | simple_exp
	 ;

simple_exp: simple_exp PLUS term
			| simple_exp MINUS term
			| term
			;

term: term TIMES factor
	  | term DIV factor
	  | factor
	  ;

factor: LPAREN exp RPAREN
		| INT_NUM
		| FLOAT_NUM
		| variable
		;

variable: ID
		;

epsilon: ;
%%

void yyerror(char *string){
   printf("Error en la linea %d \n\n", numberLines);
   exit(-1); 
}

struct symtab *symlook(char *s) {
    char *p;
    struct symtab *sp;
    for(sp = symtab; sp < &symtab[NSYMS]; sp++) {

        if(sp->name && !strcmp(sp->name, s))
            return sp;

        if(!sp->name) {
            sp->name = strdup(s);
            return sp;
        }
    }

    yyerror("exceeded");
    exit(1);
} 

void printTable(){
	struct symtab *sp;
	for(sp = symtab; sp < &symtab[NSYMS]; sp++){
		if(sp->name){
			printf("%5s | %5s \n", sp->type, sp->name);
		}
	}
}

int main(){
   yyparse();

   printf("No hay errores \n\n");

	 printf("type | actual symbol \n");
	 printTable();
   return 0;
}
