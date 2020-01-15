#ifndef TOKEN_H
#define TOKEN_H

enum keywords
{
  INT=100,
  CHAR,
  FLOAT,
  SIGNED,
  UNSIGNED,
  SHORT,
  LONG,
  LONGLONG,
  CONST,
  RETURN,
  IF,
  ELSE,
  FOR,
  WHILE,
  BREAK,
  CONTINUE,
  VOID,
  ENUM
};

enum IDENTIFIER
{
  IDENTIFIER=200
};

enum constants
{
  HEXCONSTANT=300,
  FLOATCONSTANT,
  DECIMALCONSTANT,
  CHARCONSTANT,
  STR,
  HEADERFILE
};

enum operators
{
  MINUS=400,
  INCREMENT,
  DECREMENT,
  NOT,
  PLUS,
  MULT,
  DIV,
  MOD,
  EQUAL,
  NOTEQUAL,
  GREATER,
  LESSER,
  GREATEREQUAL,
  LESSEREQUAL,
  ASSIGNMENT,
  LOGICALAND,
  LOGICALOR,
  ADDASSIGN,
  SUBTRACTASSIGN,
  MULTASSIGN,
  DIVIDEASSIGN,
  MODASSIGN
};

enum special_symbols
{
  DELIMITER=500,
  LEFTBRACKET,
  RIGHTBRACKET,
  LEFTBRACE,
  RIGHTBRACE,
  LEFTPARANTHESES,
  RIGHTPARANTHESES,
  COMMA,
  SEMICOLON
};

#endif