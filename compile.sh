#!/bin/bash
yacc -d parser.y -v
lex scanner.l
gcc -w -g y.tab.c -ly -ll -o parser.out