/* A Bison parser, made by GNU Bison 3.5.2.  */

/* Skeleton interface for Bison GLR parsers in C

   Copyright (C) 2002-2015, 2018-2020 Free Software Foundation, Inc.

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

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 20 "parser.y"

    char* node;

#line 103 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
