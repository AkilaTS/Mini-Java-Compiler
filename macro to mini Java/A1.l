DIGIT [0-9]
INTEGER {DIGIT}+

%%

[ ] { }

\t { }

\n { }

"//".*		;

"/*"("*"[^/]|[^*])*"*/"      ;

"#defineStmt" { 
yylval.tok=strdup(yytext);
return DEF_STMT; 
}

"#defineStmt0" { 
yylval.tok=strdup(yytext);
return DEF_STMT0; 
}

"#defineStmt1" { 
yylval.tok=strdup(yytext);
return DEF_STMT1; 
}

"#defineStmt2" { 
yylval.tok=strdup(yytext);
return DEF_STMT2; 
}

"#defineExpr" { 
yylval.tok=strdup(yytext);
return DEF_EXP; 
}

"#defineExpr0" { 
yylval.tok=strdup(yytext);
return DEF_EXP0; 
}

"#defineExpr1" { 
yylval.tok=strdup(yytext);
return DEF_EXP1; 
}

"#defineExpr2" { 
yylval.tok=strdup(yytext);
return DEF_EXP2; 
}

"int" { 
yylval.tok=strdup(yytext);
return INT; 
}

"boolean" { 
yylval.tok=strdup(yytext);
return BOOL; 
}

"class" {
yylval.tok=strdup(yytext);
return CLASS;
}

"public" {
yylval.tok=strdup(yytext);
return PUBLIC;
}

"static" {
yylval.tok=strdup(yytext);
return STATIC;
}

"void" {
yylval.tok=strdup(yytext);
return VOID;
}

"main" {
yylval.tok=strdup(yytext);
return MAIN;
}

"String" { 
yylval.tok=strdup(yytext);
return STRING; 
}

"System.out.println" {
yylval.tok=strdup(yytext);
return PRNT_STMT;
}

"extends" { 
yylval.tok=strdup(yytext);
return EXTENDS; 
}

"return" {
yylval.tok=strdup(yytext);
return RETURN;
}

"new" {
yylval.tok=strdup(yytext);
return NEW;
}

"this" {
yylval.tok=strdup(yytext);
return THIS;
}

"true" {
yylval.tok=strdup(yytext);
return TRUE;
}

"false" {
yylval.tok=strdup(yytext);
return FALSE;
}

"if" {
yylval.tok=strdup(yytext);
return IF;
}

"else" {
yylval.tok=strdup(yytext);
return ELSE;
}

"while" {
yylval.tok=strdup(yytext);
return WHILE;
}

"length" {
yylval.tok=strdup(yytext);
return LEN;
}

"," { 
yylval.tok=strdup(yytext);
return Comma; 
}

";" { 
yylval.tok=strdup(yytext);
return SemiColon; 
}

"=" { 
yylval.tok=strdup(yytext);
return EQ; 
}

"(" { 
yylval.tok=strdup(yytext);
return LeftB; 
}

")" { 
yylval.tok=strdup(yytext);
return RightB; 
}

"{" { 
yylval.tok=strdup(yytext);
return LeftC; 
}

"}" { 
yylval.tok=strdup(yytext);
return RightC; 
}

"[" { 
yylval.tok=strdup(yytext);
return LeftBB; 
}

"]" { 
yylval.tok=strdup(yytext);
return RightBB; 
}

[-+*/] {
yylval.tok=strdup(yytext);
return OP;
}

"&&" {
yylval.tok=strdup(yytext);
return OP;
}

"||" {
yylval.tok=strdup(yytext);
return OP;
}

"<=" {
yylval.tok=strdup(yytext);
return OP;
}

"!=" {
yylval.tok=strdup(yytext);
return OP;
}

"!" {
yylval.tok=strdup(yytext);
return NOT;
}

"." {
yylval.tok=strdup(yytext);
return DOT;
}

{INTEGER} {
        yylval.tok = strdup(yytext);
	return INTEGER_LITERAL;
}

[A-Za-z_]([A-Za-z0-9_])* {
  yylval.tok = strdup(yytext);
	return ID;
}

. { printf ("//Failed to parse input code\n"); exit (1); }
