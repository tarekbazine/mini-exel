%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

%}

%token <val> NOMBRE 
%token MOY SIP VARIANCE MIN MAX SOMME
%token  PLUS  MOINS FOIS  DIVISE 
%token  PARENTHESE_GAUCHE PARENTHESE_DROITE
%token  FIN EQ

%union {
	struct valTab{
		float vals[100];
		int size;
	} valTab;  
	float  val;
} 

%error-verbose

%type <valTab> L
%type <val> E F Ligne T FONCTION

%start s
%%
s : Ligne s 
| Ligne;

Ligne: EQ E FIN  { printf("Resultat : %f\n",$2); }
  ;

E : E PLUS T { $$=$1+$3; }
| E MOINS T { $$=$1-$3; }
| T 
;

T : T FOIS F { $$=$1*$3; }
| T DIVISE F { $$=$1/$3; }
| F
;

F :PARENTHESE_GAUCHE E PARENTHESE_DROITE  { $$=$2; }
| NOMBRE {$$ = $1;}
| FONCTION {$$ = $1;}
;

FONCTION : MOY PARENTHESE_GAUCHE L PARENTHESE_DROITE { 
				float m = 0;
				for(int i=0;i<$3.size;i++){
					m = m + $3.vals[i];
				}
				$$ = m / $3.size; }
|MIN PARENTHESE_GAUCHE L PARENTHESE_DROITE { 
				float min = $3.vals[0];
				for(int i=1;i<$3.size;i++){
					if($3.vals[i]<min) min = $3.vals[i];
				}
				$$ = min; }
|MAX PARENTHESE_GAUCHE L PARENTHESE_DROITE { 
				float max = $3.vals[0];
				for(int i=1;i<$3.size;i++){
					if($3.vals[i]>max) max = $3.vals[i];
				}
				$$ = max; }
|SOMME PARENTHESE_GAUCHE L PARENTHESE_DROITE { 
				float som = 0;
				for(int i=0;i<$3.size;i++){
					som = som + $3.vals[i];
				}
				$$ = som ; }
|VARIANCE PARENTHESE_GAUCHE L PARENTHESE_DROITE { 
				float m = 0,sommeDiffCarre = 0;
				for(int i=0;i<$3.size;i++){
					m = m + $3.vals[i];
				}
				m = m / $3.size;
				
				for(int i=0;i<$3.size;i++){
					sommeDiffCarre = sommeDiffCarre + pow( m - $3.vals[i] , 2 );
				}
				$$ = sommeDiffCarre / $3.size;
 				}
;

L : L SIP E {
	printf("bfffLIST : %f  size: %d\n",$3,$$.size);
	$$.vals[$$.size] = $3; 
	$$.size++;
	printf("AdddLIST : %f size: %d vallist %f\n\n",$3,$$.size,$$.vals[0]);  }
| E { 
	printf("Bfff : %f  size: %d\n",$1,$$.size);
	$$.vals[$$.size] = $1; 
	$$.size++;
	printf("Addd : %f size: %d\n\n",$1,$$.size); }
;

%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
}
