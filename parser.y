%{
    /* C Declarations and Includes*/
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "lex.yy.c"
    #include <ctype.h>
    #include "table.h"

    table_t *symbol_table;
    table_t *constant_table;

    int current;
	char type[100];
	int yyerror(char* msg);

%}

%union {
    int data_type;
    char* str;
}

%token <str> IDENTIFIER HEADERFILE
%token INT CHAR FLOAT SIGNED UNSIGNED SHORT LONG LONGLONG CONST ENUM VOID
%token RETURN IF WHIL ELSE FOR WHILE BREAK CONTINUE
%token <str> HEXCONSTANT DECIMALCONSTANT
%token <str> FLOATCONSTANT CHARCONSTANT STR
%token INCREMENT DECREMENT EQUAL NOTEQUAL
%token GREATEREQUAL LESSEREQUAL LOGICALAND LOGICALOR
%token ADDASSIGN SUBTRACTASSIGN MULASSIGN DIVIDEASSIGN MODASSIGN

%left ','
%right '='
%left LOGICAL_OR
%left LOGICAL_AND
%left EQUAL NOTEQUAL
%left '<' '>' LESSEREQUAL GREATEREQUAL
%left '+' '-'
%left '*' '/' '%'
%right '!'

%nonassoc NO_ELSE
%nonassoc ELSE
%nonassoc UNARY

%start start

%%

start
    : declaration
    | start declaration
    ;

declaration
    : function
    | declaration_stmt
    ;

function
    : datatype IDENTIFIER '(' arguments ')' comp_statement
	| VOID IDENTIFIER '(' arguments ')' comp_statement
    ;

datatype
    : type pointer
	| VOID pointer
    | type
    ;

pointer
    : '*' pointer
    | '*'
    ;

type
    : sign type_specifier
    | type_specifier
    ;

sign
    : SIGNED
    | UNSIGNED
    ;

type_specifier
    : INT                       {current = INT; strcpy(type,"int");}
    | CHAR                      {current = CHAR; strcpy(type,"char");}
    | FLOAT                     {current = FLOAT; strcpy(type,"float");}
    | LONG                      {current = LONG; strcpy(type,"long");}
    | SHORT                     {current = SHORT; strcpy(type,"short");}
    | LONGLONG                  {current = LONGLONG; strcpy(type,"long long");}
    | LONG INT                  {current = LONG; strcpy(type,"long");}
    | SHORT INT                 {current = SHORT; strcpy(type,"short");}
    | LONGLONG INT              {current = LONGLONG; strcpy(type,"long long");}
    ;

arguments
    : args
    | VOID
	|
    ;

args
    : arguments ',' arg
    | arg
    ;

arg
    : datatype IDENTIFIER
    ;

comp_statement
    : '{' statements '}'
    ;

statements
    : statement statements
    |
    ;

statement
    : comp_statement
    | stmt
    ;

stmt
    : declaration_stmt
    | if_stmt
    | for_stmt
    | while_stmt
    | fn_call ';'
    | RETURN ';'
	| CONTINUE ';'
    | BREAK ';'
    | RETURN kt_expr ';'
    ;

declaration_stmt
    : datatype variable_list ';'
    | variable_list ';'
    | unary_expr ';'
    ;

variable_list
    : variable_list ',' variable
    | variable
    ;

variable
    : IDENTIFIER {insert(symbol_table, $1, current, type);}
    | assignment_expr
    | array
    ;

array
    : IDENTIFIER '{' kt_expr '}'
	;

assignment_expr
    : IDENTIFIER assign_op  arithmetic_expr    {insert(symbol_table, $1, current, type);}
    | IDENTIFIER assign_op  array              {insert(symbol_table, $1, current, type);}
    | IDENTIFIER assign_op  fn_call            {insert(symbol_table, $1, current, type);}
    | IDENTIFIER assign_op  unary_expr         {insert(symbol_table, $1, current, type);}
    | IDENTIFIER '=' string      {insert(symbol_table, $1, current, type);}
    ;

assign_op
    : '='
    | ADDASSIGN
    | SUBTRACTASSIGN
    | MULASSIGN
    | DIVIDEASSIGN
    | MODASSIGN
    ;

kt_expr
    : kt_expr EQUAL kt_expr
    | kt_expr NOTEQUAL kt_expr
    | kt_expr '<' kt_expr
    | kt_expr '>' kt_expr
    | kt_expr GREATEREQUAL kt_expr
    | kt_expr LESSEREQUAL kt_expr
    | kt_expr LOGICALAND kt_expr
    | kt_expr LOGICALOR kt_expr
    | '!' kt_expr
    | arithmetic_expr
    | assignment_expr
    | unary_expr
	;

arithmetic_expr
	:'(' arithmetic_expr ')'
	| arithmetic_expr '+' arithmetic_expr
    | arithmetic_expr '-' arithmetic_expr
    | arithmetic_expr '*' arithmetic_expr
    | arithmetic_expr '/' arithmetic_expr
    | arithmetic_expr '%' arithmetic_expr
    | '-' arithmetic_expr %prec UNARY
    | IDENTIFIER
    | constant
	| FLOATCONSTANT     {insert(constant_table, $1, FLOATCONSTANT, "float");}
    ;

constant
    : DECIMALCONSTANT   {insert(constant_table, $1, DECIMALCONSTANT, "int");}
    | HEXCONSTANT       {insert(constant_table, $1, HEXCONSTANT, "int");}
    | CHARCONSTANT      {insert(constant_table, $1, CHARCONSTANT, "char");}
    ;

string
	:STR
	;

unary_expr
    : IDENTIFIER INCREMENT
    | IDENTIFIER DECREMENT
    | DECREMENT IDENTIFIER
    | INCREMENT IDENTIFIER
	;


fn_call
    : IDENTIFIER '(' parameters ')'
    | IDENTIFIER '(' ')'
    ;

parameters
    : parameters ','  param
    | param
    ;

param
    : kt_expr
    | STR
    ;


expression
    : expression ',' kt_expr
    | kt_expr
    ;

if_stmt
    : IF '(' expression ')' statement %prec NO_ELSE
    | IF '(' expression ')' statement ELSE statement
    ;

while_stmt
    : WHILE '(' expression ')' statement
    ;

for_expr
    : expression ';'
    | ';'
    ;

for_stmt
    : FOR '(' for_expr for_expr expression ')' statement
    | FOR '(' for_expr for_expr ')' statement
    ;

%%

int yyerror(char *msg)
{
	printf("ERROR AT %d: %s, TOKEN: %s\n", yylineno, msg, yytext);
}


int main(int argc, char *argv[])
{
    symbol_table = create_table();
	constant_table = create_table();
	yyin = fopen(argv[1], "r");

	if(!yyparse())
	{
		printf("\nParsing complete\n");
	}
	else
	{
		printf("\nParsing failed\n");
	}

    display(symbol_table, "Symbol Table");
    display(constant_table, "Constant Table");

    fclose(yyin);
    return 0;
}
