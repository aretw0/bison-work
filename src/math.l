%{ 
// analisador léxico para um interpretador de expressões matemáticas 
// com suporte a definição de variáveis 
#include <string>
#include "parser.h"
%}

%option yylineno
%option noyywrap


DIGIT       [0-9]
LETTER	    [a-zA-Z_]

PONTDIG     {DIGIT}*"."?{DIGIT}+
DIGPONT     {DIGIT}+"."

NUM         {PONTDIG}|{DIGPONT}
ID		    {LETTER}({LETTER}|{DIGIT})*

SQRT        "sqrt"
POW         "pow"
PRINT       "print"
IF          "if"

TEXT        \"(\\.|[^\\"])*\"	

%%
[\t ]+		; // ignora espaço em branco
{IF}        yylval.bval = true; return IF;
{SQRT}      return SQRT;
{POW}       return POW;
{PRINT}     return PRINT;
{NUM}       yylval.num = atof(yytext); return NUM;
{ID}		strcpy(yylval.id, yytext); return ID;
{TEXT}      {
                int lenght = strlen(yytext) - 2;
                int i;
                for (i = 0; i < (lenght);i++){
                    yytext[i] = yytext[i+1];
                }
                yytext[lenght] = '\0';
                strcpy(yylval.str, yytext);
                return TEXT;
            }
"=="        return EQUAL;
"!="        return NOTEQUAL;
">="        return GREATEQ;
"<="        return LESSEQ;
.|\n		return yytext[0];
%%