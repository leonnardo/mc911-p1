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

{WHITESPACE};

"documentclass"     { return T_DOCCLASS; }
"usepackage"        { return T_USEPACKAGE;}
"title"			    { return T_TITLE; }
"author" 		    { return T_AUTHOR; }
"begin"			    { return T_BEGIN; }
"end"			    { return T_END; }
"textbf"		    { return T_BF; }
"textit" 		    { return T_IT; }
"item"			    { return T_ITEM; }
"maketitle"		    { return T_MAKETITLE; }
"cite"			    { return T_CITE; }
"bibitem"           { return T_BIBITEM; }
"includegraphics"   { return T_IG; }
"document"          { return T_DOC; }
"itemize"           { return T_ITEMIZE; }
"thebibliography"   { return T_TB; }    

"$"				{ return '$'; }
"\\"			{ return '\\'; }
"{"				{ return '{'; }
"}"				{ return '}'; }


{STRING} {	
		yylval.str = (char *) strdup(yytext);
			return T_STRING;
}

{ANY_CHAR} {
		printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
		   }
