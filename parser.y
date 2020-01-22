%{
    /* C Declarations and Includes*/
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "lex.yy.c"
    #include <ctype.h>
    #include "table.h"

    table_t *symbol_table;
    extern table_t *constant_table;

    int curr_type;
    int decl = 0;
    int loop = 0;
    int func = 0;
    int func_type;
    int scope_level = 0;
    int p_list[10];
    int p_id = 0;
    int p = 0;
    int right = 0;

    int scope_id = 0;

    int yyerror(char* msg);
    void type_check(int,int,int);

    char stack[100][10], _i[2] = "0";
    int top = 0;

    void push(char *a) {
        top++;
        strcpy(stack[top], a);
    }

    void push3(char *a, char *b, char *c) {
        push(a);
        push(b);
        push(c);
    }

    char* icg_code;
    char t[2] = "t";

    void gencode() {
        strcpy(t,"t");
        strcat(t,_i);
        printf("%s = %s %s %s\n",t,stack[top-2],stack[top-1],stack[top]);
        top-=2;
        strcpy(stack[top],t);
        _i[0]++;
    }

    void gencode_assgn() {
        printf("%s = %s\n",stack[top-2],stack[top]);
        top-=2;
    }



%}

%union
{
    int type;
    node_t* node;
}

%token <node> IDENTIFIER
%token <node> DEC_CONSTANT HEX_CONSTANT CHAR_CONSTANT FLOAT_CONSTANT
%token STRING
%token LOGICAL_AND LOGICAL_OR LS_EQ GR_EQ EQ NOT_EQ
%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token INCREMENT DECREMENT
%token SHORT INT LONG LONG_LONG SIGNED UNSIGNED CONST VOID CHAR FLOAT
%token IF FOR WHILE CONTINUE BREAK RETURN

%type <node> identifier
%type <node> constant
%type <node> array_index

%type <type> kt_expr
%type <type> unary_expr
%type <type> arithmetic_expr
%type <type> assignment_expr
%type <type> fn_call
%type <type> array
%type <type> operand

%left ','
%right '='
%left LOGICAL_OR
%left LOGICAL_AND
%left EQ NOT_EQ
%left '<' '>' LS_EQ GR_EQ
%left '+' '-'
%left '*' '/' '%'
%right '!'


%nonassoc UNARY
%nonassoc NO_ELSE
%nonassoc ELSE

%start start

%%

start
    : declaration
    | declaration start
    ;

declaration
    : function
    | declaration_stmt
    ;

function
    : datatype
      identifier    {
                        func_type = curr_type;
                        decl = 0;
                        scope_level++;
                        scope_id++;
                    }

    '(' argument_list ')'   {
                                decl = 0;
                                fpl($2,p_list,p_id);
                                p_id = 0;
                                func = 1;
                                p=1;
                            }

    comp_statement  {
                        func = 0;
                    }
    ;

datatype
    : type pointer     {decl = 1; }
    | type             {decl = 1; }
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
    : INT                    {curr_type = INT;}
    | SHORT INT              {curr_type = SHORT;}
    | SHORT                  {curr_type = SHORT;}
    | LONG                   {curr_type = LONG;}
    | LONG INT               {curr_type = LONG;}
    | LONG_LONG              {curr_type = LONG_LONG;}
    | LONG_LONG INT          {curr_type = LONG_LONG;}
    | CHAR                   {curr_type = CHAR;}
    | FLOAT                  {curr_type = FLOAT;}
    | VOID                   {curr_type = VOID;}
    ;

argument_list 
    : arguments
    |
    ;

arguments
    : arguments ',' arg
    | arg
    ;

arg 
    : datatype identifier       { p_list[p_id++] = $2->type; }
    ;

comp_statement
    : '{'               {

                            if(!p){ scope_level++; scope_id++; }
                            else p = 0;
                        }
    statements '}'      {scope_level--;}
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
    : if_stmt
    | for_stmt
    | while_stmt
    | declaration_stmt
    | fn_call ';'
    | RETURN ';'        {
                            if(func) {
                                if(func_type != VOID)
                                    yyerror("return type (VOID) does not match function type");
                            }
                            else yyerror("return statement not inside function definition");
                        }

    | CONTINUE ';'          { if(!loop) {yyerror("Illegal use of continue");} }
    | BREAK ';'             { if(!loop) {yyerror("Illegal use of break");} }
    | RETURN kt_expr ';'    {
                                if(func) {
                                    if(func_type != $2)
                                        yyerror("Type mismatch on function return");
                                }
                                else yyerror("Function does not return anything");
                            }
    ;

declaration_stmt
    : datatype variable_list ';' {decl = 0; }
    | variable_list ';'
    | unary_expr ';'
    ;

variable_list
    : variable_list ',' variable
    | variable
    ;

variable
    : identifier
    | assignment_expr
    | array
    ;


for_stmt
    : FOR '(' expression_stmt  expression_stmt ')' {loop = 1;} statement {loop = 0;}
    | FOR '(' expression_stmt expression_stmt expression ')' {loop = 1;} statement {loop = 0;}
    ;

if_stmt
    : IF '(' expression ')' statement %prec NO_ELSE
    | IF '(' expression ')' statement ELSE statement
    ;

while_stmt
    : WHILE '(' expression ')' {loop = 1;} statement {loop = 0;}
    ;

expression_stmt
    : expression ';'
    | ';'
    ;

expression
    : expression ',' kt_expr
    | kt_expr
    ;

kt_expr
    : kt_expr '>'           {push(">");}  kt_expr   {type_check($1,$3,2); gencode(); $$ = $1;}
    | kt_expr '<'           {push("<");}  kt_expr   {type_check($1,$3,2); gencode(); $$ = $1;}
    | kt_expr EQ            {push("==");} kt_expr   {type_check($1,$3,2); gencode(); $$ = $1;}
    | kt_expr NOT_EQ        {push("!=");} kt_expr   {type_check($1,$3,2); gencode(); $$ = $1;}
    | kt_expr LS_EQ         {push("<=");} kt_expr   {type_check($1,$3,2); gencode(); $$ = $1;}
    | kt_expr GR_EQ         {push(">=");} kt_expr   {type_check($1,$3,2); gencode(); $$ = $1;}
    | kt_expr LOGICAL_AND   {push("&&");} kt_expr   {type_check($1,$3,2); gencode(); $$ = $1;}
    | kt_expr LOGICAL_OR    {push("||");} kt_expr   {type_check($1,$3,2); gencode(); $$ = $1;}
    | '!' kt_expr           {$$ = $2;}
    | arithmetic_expr       {$$ = $1;}
    | assignment_expr       {$$ = $1;}
    | unary_expr            {$$ = $1;}
    ;


assignment_expr
    : operand assign_op  arithmetic_expr    {type_check($1,$3,1); $$ = $3; right=0;}
    | operand assign_op  array              {type_check($1,$3,1); $$ = $3; right=0;}
    | operand assign_op  fn_call            {type_check($1,$3,1); $$ = $3; right=0;}
    | operand assign_op  unary_expr         {type_check($1,$3,1); $$ = $3; right=0;}
    | unary_expr assign_op  unary_expr      {type_check($1,$3,1); $$ = $3; right=0;}
    ;

unary_expr
    : identifier INCREMENT              {if($1) $$ = $1->type;}
    | identifier DECREMENT              {if($1) $$ = $1->type;}
    | DECREMENT identifier              {if($2) $$ = $2->type;}
    | INCREMENT identifier              {if($2) $$ = $2->type;}

operand
    : identifier                        {if($1) $$ = $1->type;}
    | array                             {$$ = $1;}
    ;

identifier
    : IDENTIFIER    {
                        if (decl && !right) {
                            $1 = findall(symbol_table, yytext, scope_level);
                            if($1) {
                                yyerror("Redeclaration of variable");
                            }
                            $1 = insert(symbol_table,yytext,INT_MAX,curr_type,scope_level, scope_id);
                            // if($1 == NULL) yyerror("Redeclaration of variable");
                        }
                        else {
                            $1 = findallless(symbol_table, yytext, scope_level);
                            if($1 == NULL) yyerror("Variable not declared");
                        }
                        push($1->lexeme);
                        $$ = $1;
                    }
    ;

assign_op
    : '=' {right=1;}
    | ADD_ASSIGN {right=1;} 
    | SUB_ASSIGN {right=1;}
    | MUL_ASSIGN {right=1;}
    | DIV_ASSIGN {right=1;}
    | MOD_ASSIGN {right=1;}
    ;

arithmetic_expr
    : arithmetic_expr '+' {push("+");} arithmetic_expr       {type_check($1,$3,0); gencode();}
    | arithmetic_expr '-' {push("-");} arithmetic_expr       {type_check($1,$3,0); gencode();}
    | arithmetic_expr '*' {push("*");} arithmetic_expr       {type_check($1,$3,0); gencode();}
    | arithmetic_expr '/' {push("/");} arithmetic_expr       {type_check($1,$3,0); gencode();}
    | arithmetic_expr '%' {push("%");} arithmetic_expr       {type_check($1,$3,0); gencode();}
    | '(' arithmetic_expr ')'                   {$$ = $2;}
    | '-' arithmetic_expr %prec UNARY           {$$ = $2;}
    | identifier                                {if($1) $$ = $1->type;}
    | constant                                  {if($1) $$ = $1->type;}
    ;

constant
    : DEC_CONSTANT      {$1->is_constant=1; $$ = $1;}
    | FLOAT_CONSTANT    {$1->is_constant=1; $$ = $1;}
    | HEX_CONSTANT      {$1->is_constant=1; $$ = $1;}
    | CHAR_CONSTANT     {$1->is_constant=1; $$ = $1;}
    ;

array
    : identifier '[' array_index ']'    {
                                            if(decl) {
                                                if ($3->value <= 0)
                                                    yyerror("size of array is not positive");

                                                else if ($3->is_constant && !right)
                                                    $1->array_dimension = $3->value;
                                                
                                                else if (right) {
                                                    if($3->value > $1->array_dimension)
                                                        yyerror("Array index out of bound");

                                                    if($3->value < 0)
                                                        yyerror("Array index cannot be negative");
                                            
                                                }
                                            }

                                            else if($3->is_constant) {
                                                if($3->value > $1->array_dimension)
                                                    yyerror("Array index out of bound");

                                                if($3->value < 0)
                                                    yyerror("Array index cannot be negative");
                                            }
                                            if($1) $$ = $1->type;
                                        }

array_index
    : constant      {$$ = $1;}
    | identifier    {$$ = $1;}
    ;

fn_call
    : identifier '(' parameter_list ')'     {
                                                if($1) $$ = $1->type;
                                                cpl($1,p_list,p_id);
                                                p_id = 0;
                                            }

    | identifier '(' ')'                    {
                                                if($1) $$ = $1->type;
                                                cpl($1,p_list,p_id);
                                                p_id = 0;
                                            }
    ;

parameter_list
    : parameter_list ','  parameter
    | parameter
    ;

parameter
    : kt_expr      {p_list[p_id++] = $1;}
    | STRING        {p_list[p_id++] = STRING;}
    ;

%%

void type_check(int left, int right, int flag)
{
    if(left != right)
    {
        if((left == INT || left == LONG || left == LONG_LONG) && (right == INT || right == LONG || right == LONG_LONG)) return;
        switch(flag)
        {
            case 0: yyerror("Type mismatch in arithmetic expression"); break;
            case 1: yyerror("Type mismatch in assignment expression"); break;
            case 2: yyerror("Type mismatch in logical expression"); break;
        }
    }
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

int yyerror(char *msg)
{
	printf("ERROR AT %d: %s, TOKEN: %s\n", yylineno, msg, yytext);
}
