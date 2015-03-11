/* Projeto 1 - MC 911 
   Alunos: Leonnardo Chagas Rabello - RA106786
   		   Milton Akio Ide Junior - RA092410

*/

/* Definições do flex */
%{
#include <stdio.h>
#include "parser.h"
%}


STRING [A-Za-z][A-Za-z0-9_-]*
WHITESPACE [ \r\t]+
BREAK_LINE [\n]
ANY_CHAR .

%%

/* ignora espacos em branco */
{WHITESPACE};

/* comandos do TeX */
"documentclass" { return T_DOCCLASS; }
"usepackage"    { return T_USEPACKAGE;}
"title"			{ return T_TITLE; }
"author" 		{ return T_AUTHOR; }
"begin"			{ return T_BEGIN; }
"end"			{ return T_END; }
"textbf"		{ return T_BF; }
"textit" 		{ return T_IT; }
"item"			{ return T_ITEM; }

/* caracteres especiais do TeX */
"$"				{ return '$'; }
"\"				{ return '\'; }
"{"				{ return '{'; }
"}"				{ return '}'; }


/* duplica a string e retorna o token */
{STRING} {	
		yylval.str = (char *) strdup(yytext);
			return T_STRING;
}

{ANY_CHAR} {
		printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
		   }
