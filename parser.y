%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

//char *concat(int count, ...);
char * title;
char * author;
%}

%union {
	char *str;
	int *intval;
}

%token <str> T_STRING
%token T_DOCCLASS
%token T_USEPACKAGE
%token T_TITLE
%token T_AUTHOR
%token T_BEGIN
%token T_END
%token T_BF
%token T_IT
%token T_ITEM
%token T_CITE
%token T_MAKETITLE
%token T_BIBITEM
%token T_IG
%token T_DOC
%token T_ITEMIZE
%token T_TB
%token BREAK_LINE

%type <str> command bgparam endparam

%start stmt_list

%error-verbose

%%


stmt_list : stmt_list stmt
			| stmt	
			;

stmt:	T_STRING
		| BREAK_LINE
		| command
		;

command:   '\\' T_DOCCLASS
		 | '\\' T_USEPACKAGE
		 | '\\' T_AUTHOR '{' T_STRING '}' { author = strdup($4); }
		 | '\\' T_BEGIN '{' bgparam '}' 
		 | '\\' T_END '{' endparam '}'
		 | '\\' T_TITLE '{' T_STRING '}' { title = strdup($4); }
		 | '\\' T_MAKETITLE { printf("%s - from %s\n", title, author); }
		 | '\\' T_ITEM T_STRING
		 | '\\' T_IT '{' T_STRING '}'
		 | '\\' T_BF '{' T_STRING '}'
		 | '\\' T_BIBITEM '{' T_STRING '}' T_STRING
		 ;
		 
bgparam:  T_DOC
        | T_ITEMIZE
        | T_TB
        ;

endparam: T_DOC
        | T_ITEMIZE
        | T_TB
        ;      


%%

int yyerror(const char* errmsg) {
	printf("\n*** Erro: %s\n", errmsg);
}

int yywrap(void) { return 1; }
int main(int argc, char** argv) {
	yyparse();
	return 0;
}
