%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

%}

%token <val> NOMBRE 
%token MOY SIP
%token  PLUS  MOINS FOIS  DIVISE 
%token  PARENTHESE_GAUCHE PARENTHESE_DROITE
%token  FIN EQ

%union {
	struct moy{
		float  val;
		int size;
	} moy;  
	float tab[100];
	float  val;
	int size;
} 

%error-verbose

%type <moy> E F L Ligne T

%start s
%%
s : Ligne s 
| Ligne;

Ligne: EQ E FIN  { printf("Resultat : %f\n",$2.val); }
  ;

E : E PLUS T { $$.val=$1.val+$3.val; }
| E MOINS T { $$.val=$1.val-$3.val; }
| T 
;

T : T FOIS F { $$.val=$1.val*$3.val; }
| T DIVISE F { $$.val=$1.val/$3.val; }
| F
;

F :PARENTHESE_GAUCHE E PARENTHESE_DROITE  { $$.val=$2.val; }
| NOMBRE {$$.val = $1;}
| MOY PARENTHESE_GAUCHE L PARENTHESE_DROITE { 
				//float m = 0;
				//for(int i=0;i<size;i++){
				//	m = 
				//}
				$$.val = $3.val/($3.size+1); }
;

L : L SIP E { 
	printf("bfffLIST : %f  size: %d\n",$3.val,$$.size);
	$$.val=$$.val +$3.val; 
	$$.size++;
	printf("AdddLIST : %f size: %d vallist %f\n\n",$3.val,$$.size,$$.val);  }
| E { 
	printf("Bfff : %f  size: %d\n",$1.val,$$.size);
	$$.val= $1.val; 
	//$$.size++;
	printf("Addd : %f size: %d\n\n",$1.val,$$.size); }
;

%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
}
