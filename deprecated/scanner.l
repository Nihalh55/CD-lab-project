%{

#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include "token.h"

int start = 0;
struct symbol
{
	char token[100];	
	char type[100];		
}symbolTable[100000], constantTable[100000];

int i=0; 
int c=0; 

int symbolLookup(char* tokenName)
{
	int k=0,flag=0;
	for(k=0;k<=i;k++)
	{
		if(strcmp(symbolTable[k].token,tokenName)==0)
		{
			flag=1;
			break;
		}	
	}
	return flag;
}

void symbolInsert(struct symbol table[], int index, char* tokenName, char* tokenType)
{
	int flag;
	flag=symbolLookup(tokenName);
	if(flag==0)
	{
		strcpy(table[index].token, tokenName);
  		strcpy(table[index].type, tokenType);
		i++;
	}
}

void constantInsert(struct symbol table[], int index, char* constant, char* constantType)
{
	strcpy(table[index].token, constant);
	strcpy(table[index].type, constantType);
	c++;
}

void display()
{
	int k=0;
	printf("\nSYMBOL TABLE \n\n");
	printf("%-10s \t\t\t %s\n","Symbol","Type");
	for(k=0;k<=i;k++)
		printf("%-10s\t\t\t%-40s\n",symbolTable[k].token,symbolTable[k].type);
	printf("\nCONSTANT TABLE \n\n");	
	printf("%-10s \t\t\t %s\n","Constant","Type");
	for(k=0;k<=c;k++)
		printf("%-10s\t\t\t%-40s\n",constantTable[k].token,constantTable[k].type);
	
}

%}

LETTER              [a-zA-Z]
DIGIT               [0-9]
WS                  [ \t\r\f\v]+
IDENTIFIER_C        (_|{LETTER})({LETTER}|{DIGIT}|_)* 
HEX                 [0-9a-f]

%x COMMENT
%x PREPROCESSOR

%%
\n                                                                                                      {yylineno++;}

"#include"                                                                                              {BEGIN(PREPROCESSOR);}
<PREPROCESSOR>({WS})?"<"({LETTER})*".h>"                                                                {printf("%-40s - HEADER FILE - %d\n",yytext,HEADERFILE); BEGIN(INITIAL);}
<PREPROCESSOR>({WS})?"\""({LETTER})*".h\""                                                              {printf("%-40s - HEADER FILE - %d\n",yytext,HEADERFILE); BEGIN(INITIAL);}
<PREPROCESSOR>.                                                                                         {printf("ERROR AT %d: ILLEGAL HEADER FORMAT \n", yylineno); BEGIN(INITIAL);}

"int"                                                                                                   {printf("%-40s - KEYWORD - %d\n",yytext,INT);}
"char"                                                                                                  {printf("%-40s - KEYWORD - %d\n",yytext,CHAR);}
"float"                                                                                                 {printf("%-40s - KEYWORD - %d\n",yytext,FLOAT);}
"void"                                                                                                  {printf("%-40s - KEYWORD - %d\n",yytext,VOID);}
"long"                                                                                                  {printf("%-40s - KEYWORD - %d\n",yytext,LONG);}
"long long"                                                                                             {printf("%-40s - KEYWORD - %d\n",yytext,LONGLONG);}
"short"                                                                                                 {printf("%-40s - KEYWORD - %d\n",yytext,SHORT);}
"signed"                                                                                                {printf("%-40s - KEYWORD - %d\n",yytext,SIGNED);}
"unsigned"                                                                                              {printf("%-40s - KEYWORD - %d\n",yytext,UNSIGNED);}
"for"                                                                                                   {printf("%-40s - KEYWORD - %d\n",yytext,FOR);}
"while"                                                                                                 {printf("%-40s - KEYWORD - %d\n",yytext,WHILE);}
"break"                                                                                                 {printf("%-40s - KEYWORD - %d\n",yytext,BREAK);}
"continue"                                                                                              {printf("%-40s - KEYWORD - %d\n",yytext,CONTINUE);}
"if"                                                                                                    {printf("%-40s - KEYWORD - %d\n",yytext,IF);}
"else"                                                                                                  {printf("%-40s - KEYWORD - %d\n",yytext,ELSE);}
"return"                                                                                                {printf("%-40s - KEYWORD - %d\n",yytext,RETURN);}
"const"                                                                                                 {printf("%-40s - KEYWORD - %d\n",yytext,CONST);}
"enum"                                                                                                  {printf("%-40s - KEYWORD - %d\n",yytext,ENUM);}
"switch"                                                                                                {printf("%-40s - KEYWORD - %d\n",yytext,SWITCH);}

{DIGIT}+({LETTER}|_)+                                                                                   {printf("ERROR AT %d: INVALID IDENTIFIER FORMAT \n",yylineno);}
{IDENTIFIER_C}                                                                                          {
                                                                                                            if (strlen(yytext)>32) {
                                                                                                                printf("ERROR AT %d: IDENTIFIER TOO LONG\n", yylineno);
                                                                                                            }
                                                                                                            else {
                                                                                                                printf("%-40s - IDENTIFIER - %d\n",yytext,IDENTIFIER);
														                                                        symbolInsert(symbolTable,i,yytext,"IDENTIFIER");
                                                                                                            }
                                                                                                        }

"//".*                                                                                                  {}

"/*"                                                                                                    {start = yylineno; BEGIN(COMMENT);}
<COMMENT>.|{WS}                                                                                         {}
<COMMENT>\n                                                                                             {yylineno++;}
<COMMENT>"*/"                                                                                           {BEGIN(INITIAL); }
<COMMENT><<EOF>>                                                                                        {printf("ERROR AT %d: UNTERMINATED COMMENT\n", start); yyterminate();}
"*/"                                                                                                    {printf("ERROR AT %d: NESTED COMMENT\n", start);}

{WS}                                                                                                    {}

[+\-]?[0][x|X]{HEX}+[lLuU]?                                                                             {printf("%-40s - CONSTANT - %d\n",yytext,HEXCONSTANT);constantInsert(constantTable,c,yytext,"HEX CONSTANT");}
[+\-]?{DIGIT}+[lLuU]?                                                                                   {printf("%-40s - CONSTANT - %d\n",yytext,DECIMALCONSTANT); constantInsert(constantTable,c,yytext,"INTEGER CONSTANT");}
[+\-]?{DIGIT}+\.{DIGIT}+([eE][-+]?[0-9]+)?                                                              {printf("%-40s - CONSTANT - %d\n",yytext,FLOATCONSTANT); constantInsert(constantTable,c,yytext,"FLOAT CONSTANT");}

\"[^\n|^\"]*[\n]                                                                                        {printf("ERROR AT %d: UNTERMINATED STRING\n", yylineno);}
\"[^\n]*\"                                                                                              {printf("%-40s - CONSTANT - %d\n",yytext,STR); constantInsert(constantTable,c,yytext,"STRING");}
\'({LETTER}|{DIGIT})({LETTER}|{DIGIT})+\'                                                               {printf("ERROR AT %d: UNTERMINATED CHAR\n", yylineno);}
\'.\'                                                                                                   {printf("%-40s - CONSTANT - %d\n",yytext,CHARCONSTANT); constantInsert(constantTable,c,yytext,"CHAR");}

"["                                                                                                     {printf("%-40s - SPECIAL SYMBOL - %d\n",yytext,LEFTBRACKET);}
"]"                                                                                                     {printf("%-40s - SPECIAL SYMBOL - %d\n",yytext,RIGHTBRACKET);}
"{"                                                                                                     {printf("%-40s - SPECIAL SYMBOL - %d\n",yytext,LEFTBRACE);}
"}"                                                                                                     {printf("%-40s - SPECIAL SYMBOL - %d\n",yytext,RIGHTBRACE);}
"("                                                                                                     {printf("%-40s - SPECIAL SYMBOL - %d\n",yytext,LEFTPARANTHESES);}
")"                                                                                                     {printf("%-40s - SPECIAL SYMBOL - %d\n",yytext,RIGHTPARANTHESES);}
";"                                                                                                     {printf("%-40s - SPECIAL SYMBOL - %d\n",yytext,SEMICOLON);}
","                                                                                                     {printf("%-40s - SPECIAL SYMBOL - %d\n",yytext,COMMA);}

"++"                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,INCREMENT);}
"--"                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,DECREMENT);}
"=="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,EQUAL);}
"!="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,NOTEQUAL);}
">="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,GREATEREQUAL);}
"<="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,LESSEREQUAL);}
"&&"                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,LOGICALAND);}
"||"                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,LOGICALOR);}
"+="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,ADDASSIGN);}
"-="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,SUBTRACTASSIGN);}
"*="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,MULTASSIGN);}
"/="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,DIVIDEASSIGN);}
"%="                                                                                                    {printf("%-40s - OPERATOR - %d\n",yytext,MODASSIGN);}

"-"                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,MINUS);}
"!"                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,NOT);}
"+"                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,PLUS);}
"*"                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,MULT);}
"/"                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,DIV);}
"%"                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,MOD);}
">"                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,GREATER);}
"<"                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,LESSER);}
"="                                                                                                     {printf("%-40s - OPERATOR - %d\n",yytext,ASSIGNMENT);}

.                                                                                                       {printf("ERROR AT %d: ILLEGAL CHARACTER\n", yylineno);}

%%




int yywrap(){}
int main(){
    int newtoken;
    yyin = fopen("test2.c","r");
    yylex();
    display();
    return 0;
}

