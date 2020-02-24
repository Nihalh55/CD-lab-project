%{

#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

#include "table.h"
#include "y.tab.h"
table_t* constant_table;

int start = 0;

%}

LETTER              [a-zA-Z]
DIGIT               [0-9]
WS                  [ \t\r\f\v]+
IDENTIFIER_C        (_|{LETTER})({LETTER}|{DIGIT}|_)*
HEX                 [0-9a-f]

%x COMMENT

%%
\n                              {yylineno++;}

"#include"({WS})?"<"({LETTER})*".h>" {}
"#include"({WS})?"\""({LETTER})*".h\"" {}

"#define"({WS})""({LETTER})""({LETTER}|{DIGIT})*""({WS})""({DIGIT})+"" 				{ }
"#define"({WS})""({LETTER}({LETTER}|{DIGIT})*)""({WS})""(({DIGIT}+)\.({DIGIT}+))"" 		{ }
"#define"({WS})""({LETTER}({LETTER}|{DIGIT})*)""({WS})""({LETTER}({LETTER}|{DIGIT})*)"" 	{ }


"int"                             {return INT;}
"char"                            {return CHAR;}
"float"                           {return FLOAT;}
"void"                            {return VOID;}
"long"                            {return LONG;}
"long long"                       {return LONGLONG;}
"short"                           {return SHORT;}
"signed"                          {return SIGNED;}
"unsigned"                        {return UNSIGNED;}
"for"                             {return FOR;}
"while"                           {return WHILE;}
"break"                           {return BREAK;}
"continue"                        {return CONTINUE;}
"if"                              {return IF;}
"else"                            {return ELSE;}
"return"                          {return RETURN;}


{DIGIT}+({LETTER}|_)+                                   {printf("ERROR AT %d: INVALID IDENTIFIER FORMAT \n",yylineno);}
{IDENTIFIER_C}                                          {
                                                            if (strlen(yytext)>32) {
                                                                printf("ERROR AT %d : IDENTIFIER TOO LONG\n", yylineno);
                                                            }
                                                            else {
                                                                return IDENTIFIER;
                                                            }
                                                        }

"//".*                                                  ;

"/*"                                                    {start = yylineno; BEGIN(COMMENT);}
<COMMENT>.|{WS}                                         ;
<COMMENT>\n                                             {yylineno++;}
<COMMENT>"*/"                                           {BEGIN(INITIAL);}
<COMMENT><<EOF>>                                        {printf("ERROR AT %d: UNTERMINATED COMMENT\n", start); yyterminate();}
"*/"                                                    {printf("ERROR AT %d: NESTED COMMENT\n", start);}

{WS}                                                    ;


[+\-]?[0][x|X]{HEX}+[lLuU]?                             { insert(constant_table,yytext,(int)strtol(yytext, NULL, 16),INT, -1, -1); return  HEXCONSTANT;}
[+\-]?{DIGIT}+[lLuU]?                                   { insert(constant_table,yytext,atoi(yytext),INT, -1, -1); return  DECIMALCONSTANT;}
[+\-]?{DIGIT}+\.{DIGIT}+([eE][-+]?[0-9]+)?              { insert(constant_table,yytext,atof(yytext),FLOAT, -1, -1); return FLOATCONSTANT;}


\"[^\n|^\"]*[\n]                                        {printf("%-40s - ERROR: UNTERMINATED STRINGn", yytext);}
\"[^\n]*\"                                              {insert(constant_table,yytext,INT_MAX,STR,-1, -1); return STR;}
\'({LETTER}|{DIGIT})({LETTER}|{DIGIT})+\'               {printf("%-40s - ERROR: UNTERMINATED CHAR\n", yytext);}
\'.\'                                                   {insert(constant_table,yytext,yytext[1],CHAR, -1, -1); return CHARCONSTANT;}

"--"			                {return DECREMENT;}
"++"			                {return INCREMENT;}
"+="                      {return ADDASSIGN;}
"-="                      {return SUBTRACTASSIGN;}
"*="                      {return MULASSIGN;}
"%="                      {return MODASSIGN;}


"&&"			                {return LOGICALAND;}
"||"			                {return LOGICALOR;}
"<="			                {return LESSEREQUAL;}
">="			                {return GREATEREQUAL;}
"=="			                {return EQUAL;}
"!="		                  {return NOTEQUAL;}

.                         {return yytext[0];}

%%
