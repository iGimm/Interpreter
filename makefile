

all: tinyC

y.tab.c y.tab.h:	tinyC_grammar.y
		bison -yd tinyC_grammar.y

lex.yy.c:	tinyC.l
		flex tinyC.l

tinyC:	y.tab.c lex.yy.c
		gcc y.tab.c lex.yy.c -o tinyC -ll

clean:
		rm tinyC y.tab.c y.tab.h lex.yy.c
