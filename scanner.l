/* Projeto 1 - MC 911 
   Alunos: Leonnardo Chagas Rabello - RA106786
   		   Milton Akio Ide Junior - RA092410

*/

/* Definições do flex */
%{
#include <stdio.h>
#include "parser.h"
%}

STRING [A-Za-z0-9_,.?!%*$@#%&\\()$-]*
WHITESPACE [ \r\t]+
BREAK_LINE [\n]
ANY_CHAR .
	
%%

\\documentclass(\[.*\])?\{.*\}
\\usepackage(\[.*\])?\{.*\}
\\author\{.*\}

"\\title"			   				{ return T_TITLE; }
"\\begin{document}"					{ return T_BEGIN_DOC; }
"\\begin{itemize}"					;//{ return T_BEGIN_ITEM; }
"\\begin{thebibliography}" 			;//{ return T_BEGIN_BIB; }
"\\end{document}"					{ return T_END_DOC; }
"\\end{itemize}"					;//{ return T_END_ITEM; }
"\\end{thebibliography}" 			;//{ return T_END_BIB; }
"\\textbf"		    				{ return T_BF; }
"\\textit" 		    				{ return T_IT; }
"\\item"			    			;//{ return T_ITEM; }
"\\maketitle"		    			{ return T_MAKETITLE; }
"\\cite"			    			;//{ return T_CITE; }
"\\includegraphics"   				{ return T_IG; }
"\\thebibliography"   				;//{ return T_TB; }    

"{"									{ return '{'; }
"}"									{ return '}'; }

{WHITESPACE} {
		yylval.str = (char *) strdup(yytext);
		return WHITESPACE;
}
{BREAK_LINE} {
	yylval.str = (char *) strdup(yytext);
	return BREAK_LINE;
}


{STRING} {	
		yylval.str = (char *) strdup(yytext);
			return T_STRING;
}

{ANY_CHAR} {
		printf ("Caracter '%c' (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}

%%

YYSTYPE yylval;

int main(int argc, char** argv)
{
	if (0) {
		int token;
		while ((token = yylex()) != 0)
			printf("Token: %d (%s)\n", token, yytext);
		return 0;
	} else {
		return parseMain(argc, argv);
	}
     return 0;
}
