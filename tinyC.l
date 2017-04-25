%{
    #include <stdlib.h> 
    #include "y.tab.h" 
    #include "table.h" 
    int numberLines = 1;
%}


DIGIT		[0-9]|[1-9][0-9]*
EXPONENTIAL [0-9]*"."[0-9]+[e|E][-|+]?[0-9]+
HEX			0(x|X)[0-9A-Fa-f]+
OCTAL		0(c|C)[0-7]+
ID       	[A-Za-z_][A-Za-z0-9_]*
RELATIONAL 	<|<=|>|>=|!=|==
ASSIGNMENT	:=
%x COMMENT


%%
"/*"              BEGIN(COMMENT); 

<COMMENT>{
     "*/"      BEGIN(INITIAL); 
     [^*\n]+   
     "*"       
     \n        numberLines++; 
}

"//".* 

{DIGIT} {return INT_NUM; }

{DIGIT}"."{DIGIT}+ {    
            return FLOAT_NUM;
}

{HEX} { return INT_NUM; } 
{OCTAL} { return INT_NUM; } 


"if" { return IF; }
"then" { return THEN; }
"else" { return ELSE; }
"int" { return INT; }
"float" { return FLOAT; }
"while" { return WHILE; }
"do" { return DO; }
"read" { return READ; }
"write" { return WRITE; }

"{" { return LBRACE; }
"}" { return RBRACE; }
"(" { return LPAREN; }
")" { return RPAREN; }
";" { return SEMICOLON; }
"," 


"+" { return PLUS; }
"-" { return MINUS; }
"*" { return TIMES; }
"/" { return DIV; }


{ASSIGNMENT} {
    return ASSIGNMENT;
}

{RELATIONAL} {
    return RELATIONAL;
}

{EXPONENTIAL} { return FLOAT_NUM; } 
{ID} {
  yylval.symp = symlook(yytext); 
  return ID;
}

[ \t]+          

\n             numberLines++; 

. {             
             printf("Unknown token %s found in line %d \n\n", yytext, numberLines);
             exit(-1);
}
%%