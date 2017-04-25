
#define NSYMS 30	   /* numero maximo de simbolos */

struct symtab {
  char *name;                    
  char *type;                    
} symtab[NSYMS];

struct symtab *symlook(char *string);
