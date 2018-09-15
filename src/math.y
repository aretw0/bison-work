%{
// analisador sintático para um interpretador de expressões matemáticas 
// com suporte a definição de variáveis 
#include <iostream>
#include <stdio.h>
#include <string>
#include <typeinfo>
#include <math.h> 
#include <unordered_map>

using namespace std;

extern FILE *yyin;
// protótipos das funções especiais
int yylex(void);
int yyparse(void);
void yyerror(const char *);

bool ifcall = false;
bool ifres = true;

// tabela de símbolos 
unordered_map<string,double> variables; 
%}

%union {
	bool bval;
	double num;
	char id[16];
	char str[100];
}

%token SQRT POW PRINT 
%token <bval> IF
%token <str> TEXT

%token <id> ID
%token <num> NUM

%type <num> expr
%type <str> exprlist
%type <bval> bexpr

%left '+' '-'
%left '*' '/'
%nonassoc '<' '>'
%nonassoc GREATEQ EQUAL NOTEQUAL LESSEQ
// %precedence '='
%precedence NEG  /* negação unária */

%%
math: math calc
	| calc
	| math calc '\n'
	| calc '\n'
	;
if: IF '(' bexpr ')' {
						ifres = ifres ? ($3 ? true : false) : ifres;
					}
  ;

calc: expr
	| print
	| if calc
	; 

print: PRINT '(' TEXT ',' exprlist ')'  { if (ifres) cout << $3 << " " << $5 << "\n"; else ifres = true; }
	 | PRINT '(' exprlist ',' TEXT ')'  { if (ifres) cout << $3 << " " << $5 << "\n"; else ifres = true; }
	 | PRINT '(' exprlist ')'     		{ if (ifres) cout << $3 << "\n"; else ifres = true; }
	 | PRINT '(' TEXT ')'     			{ if (ifres) cout << $3 << "\n"; else ifres = true; }
	 ;
exprlist: exprlist ',' expr		{
									string listEx($1 + string(" ") + to_string($3));
									listEx.copy($$,listEx.size()+1);
									$$[listEx.size()] = '\0';
								}
		| expr					{
									string listEx = to_string($1);
									listEx.copy($$,listEx.size()+1);
									$$[listEx.size()] = '\0';
								}
		;

expr: SQRT '(' expr ')'			{
									$$ = sqrt($3);
								}
	| POW '(' expr ',' expr ')'	{
									$$ = pow($3,$5);
								}
	| ID '=' expr 				{
									$$ = $3;
									if (ifres) {
										variables[$1] = $3;
									} else {
										ifres = true;
									}
								} 	
	| expr '+' expr				{
									$$ = $1 + $3;
								}
	| expr '-' expr   			{
									$$ = $1 - $3;
								}
	| expr '*' expr				{
									$$ = $1 * $3;
								}
	| expr '/' expr				{ 
									if ($3 == 0)
										yyerror("divisão por zero");
									else {
										$$ = $1 / $3;
									 
									}
								}
	| '(' expr ')'				{
									$$ = $2;
								}
	| '-' expr %prec NEG		{
									$$ = - $2;
								}
	| ID						{
									$$ = variables[$1];
								}
	| NUM						{
									$$ = $1;
								}
	;

bexpr: expr						{ $$ = ($1 ? true : false); }
	 | expr EQUAL expr			{ $$ = ($1 == $3);	}
	 | expr NOTEQUAL expr		{ $$ = ($1 != $3);	} 
	 | expr GREATEQ expr		{ $$ = ($1 >= $3);	}
	 | expr LESSEQ expr			{ $$ = ($1 <= $3);	}
	 | expr '>' expr			{ $$ = ($1 > $3);	}
	 | expr '<' expr			{ $$ = ($1 < $3);	}
	 | '(' bexpr ')'			{ $$ = ($2 ? true : false); }
	 ;
%%

int main(int argc, char ** argv)
{
	if (argc > 1) 
	{
		yyin = fopen(argv[1], "r");
		if (!yyin) 
        {
			cout << "Arquivo " << argv[1] << " não pode ser aberto!\n";
			exit(EXIT_FAILURE);
		}
	}
	yyparse();
}

void yyerror(const char * s)
{
	extern int yylineno;    // definido no analisador léxico
	extern char * yytext;   // definido no analisador léxico 
    cout << "Erro (" << s << "): símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
}