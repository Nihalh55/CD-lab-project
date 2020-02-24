#!/bin/bash
yacc -d syntaxAnalyzer.y -v
lex lexicalAnalyzer.l
gcc -w -g y.tab.c -ly -ll -o parser.out