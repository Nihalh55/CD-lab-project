/* A Bison parser, made by GNU Bison 3.5.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDENTIFIER = 258,
    HEADERFILE = 259,
    INT = 260,
    CHAR = 261,
    FLOAT = 262,
    SIGNED = 263,
    UNSIGNED = 264,
    SHORT = 265,
    LONG = 266,
    LONGLONG = 267,
    CONST = 268,
    ENUM = 269,
    VOID = 270,
    RETURN = 271,
    IF = 272,
    WHIL = 273,
    ELSE = 274,
    FOR = 275,
    WHILE = 276,
    BREAK = 277,
    CONTINUE = 278,
    HEXCONSTANT = 279,
    DECIMALCONSTANT = 280,
    FLOATCONSTANT = 281,
    CHARCONSTANT = 282,
    STR = 283,
    INCREMENT = 284,
    DECREMENT = 285,
    EQUAL = 286,
    NOTEQUAL = 287,
    GREATEREQUAL = 288,
    LESSEREQUAL = 289,
    LOGICALAND = 290,
    LOGICALOR = 291,
    ADDASSIGN = 292,
    SUBTRACTASSIGN = 293,
    MULASSIGN = 294,
    DIVIDEASSIGN = 295,
    MODASSIGN = 296,
    LOGICAL_OR = 297,
    LOGICAL_AND = 298,
    NO_ELSE = 299,
    UNARY = 300
  };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define HEADERFILE 259
#define INT 260
#define CHAR 261
#define FLOAT 262
#define SIGNED 263
#define UNSIGNED 264
#define SHORT 265
#define LONG 266
#define LONGLONG 267
#define CONST 268
#define ENUM 269
#define VOID 270
#define RETURN 271
#define IF 272
#define WHIL 273
#define ELSE 274
#define FOR 275
#define WHILE 276
#define BREAK 277
#define CONTINUE 278
#define HEXCONSTANT 279
#define DECIMALCONSTANT 280
#define FLOATCONSTANT 281
#define CHARCONSTANT 282
#define STR 283
#define INCREMENT 284
#define DECREMENT 285
#define EQUAL 286
#define NOTEQUAL 287
#define GREATEREQUAL 288
#define LESSEREQUAL 289
#define LOGICALAND 290
#define LOGICALOR 291
#define ADDASSIGN 292
#define SUBTRACTASSIGN 293
#define MULASSIGN 294
#define DIVIDEASSIGN 295
#define MODASSIGN 296
#define LOGICAL_OR 297
#define LOGICAL_AND 298
#define NO_ELSE 299
#define UNARY 300

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 19 "parser.y"

    int data_type;
    char* str;

#line 152 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
