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
int count_bb = 0;
char* bibliography[200];

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
%token <str> T_ITEM
%token T_CITE
%token <str> T_MAKETITLE
%token T_IG
%token T_BIBITEM	
%token <str> BREAK_LINE
%token <str> WHITESPACE

%type <str> header body text whitespace multspaces skipblanks content

%start html_doc

%error-verbose

%%

html_doc: skipblanks header skipblanks T_BEGIN_DOC skipblanks body skipblanks T_END_DOC skipblanks {
			FILE *output = fopen("output.html", "w");

			fprintf(output,"<html>\n<head>\n");
			fprintf(output,"<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js\"></script>");
			fprintf(output,"<script>$(function(){$('a.cite').each(function(i, elem) {var id = $(elem).attr(\"href\"); $(elem).text('[' + $(id).attr('data-id') + ']');});});</script>");
			fprintf(output,"<script type=\"text/x-mathjax-config\">MathJax.Hub.Config({tex2jax:{inlineMath:[['$','$']]}});</script>");
			fprintf(output,"<script src='https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'></script>\n");
			if (maketitle)
				fprintf(output,"<title>%s</title>\n", $2);
			fprintf(output,"</head>");
			fprintf(output,"<body>%s\n</body>\n</html>", $6);

		}

header: T_TITLE '{' text '}' { $$ = $3; }

body: content { $$ = $1; }
	| body skipblanks content skipblanks{ $$ = concat(3, $1, $2, $3); }
	| body skipblanks text skipblanks{ $$ = concat(3, $1, $2, $3); }
	;

content: T_MAKETITLE  { maketitle = 1; }      
		| T_BF '{' text '}' { $$ = concat(3,"<b>",$3,"</b>"); }
		| T_IT '{' text '}' { $$ = concat(3,"<i>",$3,"</i>"); }
		| T_IG '{' text '}' { $$ = concat(3,"<img src='",$3,"' />"); }
		| T_BEGIN_ITEM { $$ = "<ul>"; }
		| T_ITEM  skipblanks text skipblanks { $$ = concat(3, "<li>",$3,"</li>"); } 
		| T_ITEM  '[' text ']' skipblanks text skipblanks { $$ = concat(6, "<li style='list-style-type: none;'>", "<b>", $3, "</b> ", $6, "</li>"); } 
		| T_END_ITEM { $$ = "</ul>"; }
		| T_BEGIN_BIB { $$ = "<h2>References</h2><ol start=\"0\">"; }
		| T_BIBITEM '{' text '}' skipblanks text skipblanks { 
							char buff[100];
							sprintf(buff, "%d", count_bb++);
							$$ = concat(7,"<li id=\"",$3,"\" data-id=\"", buff, "\">", $6,"</li>");
			}
		| T_END_BIB skipblanks  { $$ = "</ol>"; }
		| T_CITE '{' text '}' { 
			$$ = concat(3,"<a class=\"cite\" href=\"#", $3, "\"></a>");
		}
		;


text: text skipblanks T_STRING { $$ = concat(3,$1,$2,$3); }
	| T_STRING { $$ = $1; }	
	;

skipblanks:
	/*vaziozao*/
	| multspaces
;

whitespace:
	WHITESPACE
	| BREAK_LINE  { $$ = "<br>"; }
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
int main() {
	yyparse();
	return 0;
}
