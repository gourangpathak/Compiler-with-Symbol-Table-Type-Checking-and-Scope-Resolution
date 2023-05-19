%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

%}

digit [0-9]

%%
\n           { printf("A newline is detected\n"); }
[ \t\r]+ ;
[0-9]+       { printf("An integer constant %s is detected\n", yytext); return INTEGER_CONSTANT;}
{digit}+"."{digit}+             { printf("A float : %s is encountered\n", yytext);return FLOAT_CONSTANT; }
"+"|"*"|"/"|"-"|"+="|"−="|"∗="|"/=" { printf("An arithmetic operator : %s is encountered\n", yytext); return yytext[0]; }         
";"                                     {printf("A semicolon is encountered\n");return SEMICOLON;}
","                                     {printf("A comma is encountered\n");return COMMA;}
"="                                     {printf("An assignment operator is encountered\n");return ASSIGN;}
"if"                                    {printf("An if operator is encountered\n");return IF;}
"else"                                  {printf("An else operator is encountered\n");return ELSE;}
"for"                                   {printf("A for operator is encountered\n");return FOR;}
"&&"                                    {printf("An and operator is encountered\n");return AND;}
"||"                                    {printf("An or operator is encountered\n");return OR;}
"!"                                     {printf("A not operator is encountered\n");return NOT;}
"<="|">="|"<"|">"|"=="|"!="             {printf("Conditional operator is encountered\n");return RELOP;}
"while"                                 {printf("A while operator is encountered\n");return WHILE;}
"return"                                {printf("Return is encountered\n");return RETURN;}
"int"                                   {printf("Int is detected\n"); yylval.stringval = strdup(yytext); return INT;}
"float"                                 {printf("Float is detected\n"); yylval.stringval = strdup(yytext); return FLOAT;}
"boolean"                               {printf("Boolean is detected\n"); yylval.stringval = strdup(yytext); return BOOL;}
[_a-zA-Z][_a-zA-Z0-9]*                  { printf("An identifier %s is detected\n", yytext); yylval.stringval = strdup(yytext); return ID; }
.                                       { printf("Other character %s is detected\n", yytext); return yytext[0];}

%%
