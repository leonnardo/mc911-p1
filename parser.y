%{

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>


int yywrap(void);
int yyerror(const char* errmsg);

char *concat(int count, ...);
char * title;
char * author;
int maketitle = 0;

%}

%union {
	char *str;
}

%token <str> T_STRING
%token T_TITLE
%token T_BEGIN_DOC
%token T_BEGIN_ITEM
%token T_BEGIN_BIB
%token T_END_DOC
%token T_END_ITEM
%token T_END_BIB
%token T_BF
%token T_IT
%token T_ITEM
%token T_CITE
%token <str> T_MAKETITLE
%token T_BIBITEM
%token T_IG
%token T_DOC
%token T_ITEMIZE
%token T_TB
%token <str> BREAK_LINE
%token <str> WHITESPACE

%type <str> header body text whitespace multspaces skipblanks content

%start html_doc

%error-verbose

%%

html_doc: skipblanks header skipblanks T_BEGIN_DOC skipblanks body skipblanks T_END_DOC skipblanks {
			printf("<html><header>\n");
			if (maketitle)
				printf("<title>%s</title>", $2);
			printf("</header>");
			printf("<body>%s</body></html>", $6);

		}

header: T_TITLE '{' text '}' { $$ = $3; }

body: content { $$ = $1; }
	| body skipblanks content skipblanks{ $$ = concat(3, $1, $2, $3); }
	| body skipblanks text skipblanks{ $$ = concat(3, $1, $2, $3); }
	;

content: T_MAKETITLE  { maketitle = 1; }      
		| T_BF '{' text '}' { $$ = concat(3,"<b>",$3,"</b>"); }
		| T_IT '{' text '}' { $$ = concat(3,"<i>",$3,"</i>"); }
		;

text: text skipblanks T_STRING { $$ = concat(3,$1,$2,$3); }
	| T_STRING { $$ = $1; }	

skipblanks:
	/*vaziozao*/
	| multspaces
;

whitespace:
	WHITESPACE
	| BREAK_LINE
;

multspaces:
	whitespace
	| multspaces whitespace
;

%%

char* concat(int count, ...)
{
    va_list ap;
    int len = 1, i;

    va_start(ap, count);
    for(i=0 ; i<count ; i++)
        len += strlen(va_arg(ap, char*));
    va_end(ap);

    char *result = (char*) calloc(sizeof(char),len);
    int pos = 0;

    // Actually concatenate strings
    va_start(ap, count);
    for(i=0 ; i<count ; i++)
    {
        char *s = va_arg(ap, char*);
        strcpy(result+pos, s);
        pos += strlen(s);
    }
    va_end(ap);

    return result;
}

int yyerror(const char* errmsg) {
	printf("\n*** Erro: %s\n", errmsg);
}

int yywrap(void) { return 1; }
int parseMain(int argc, char** argv) {
	yyparse();
	return 0;
}
