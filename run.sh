#!/bin/sh
lex lexicalAnalyzer.l
yacc -d syntaxAnalyzer.y
gcc lex.yy.c y.tab.c -w -g
./a.out input.c
rm y.tab.c y.tab.h lex.yy.c a.out
echo "\n\n===============CONSTANT TABLE==============="
cat constantTable.txt
echo "\n\n\n===============SYMBOL TABLE==============="
cat symbolTable.txt
echo "\n\n\n===============PARSED TABLE==============="
cat parsedTable.txt
echo "\n"
rm constantTable.txt symbolTable.txt parsedTable.txt