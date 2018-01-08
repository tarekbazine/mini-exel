%{

#include "a.tab.h"

#include <stdlib.h>

extern YYSTYPE yylval;
%}

blancs    [ \t]+

chiffre   [0-9]
entier    {chiffre}+
reel	  {entier}\.{entier}

%%

{blancs}  { /* On ignore */ }

{entier}    {
      yylval.val =atoi(yytext);
      return(NOMBRE);
    }

{reel}    {
      yylval.val =atof(yytext);
      return(NOMBRE);
    }

"+"   return(PLUS);
"-"   return(MOINS);

"*"   return(FOIS);
"/"   return(DIVISE);

"("   return(PARENTHESE_GAUCHE);
")"   return(PARENTHESE_DROITE);

"\n"  return(FIN);

"moy"  return(MOY);

","  return(SIP);

"=" return(EQ);

