%{
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
 
 int yylex (void);
 void yyerror (const char *);

 struct macro_stmt
 {
   char* name;
   int n;
   char args[40][40];
   char* exp;
 };
 
 struct macro_exp
 {
   char* name;
   int n;
   char args[40][40];
   char* exp;
 };
 
 struct macro_exp list_exp[100];
 int exp_last=0;
 
 struct macro_stmt list_stmt[100];
 int stmt_last=0;
 
 
 int search_func(char* key)
 {
    for(int k=0;k<exp_last;k++)
    {
      if(strcmp(list_exp[k].name,key)==0)
       return 1;
    }
    
    for(int k=0;k<stmt_last;k++)
    {
      if(strcmp(list_stmt[k].name,key)==0)
       return 1;
    }
    
    return 0;
 }
 
 //function to remember the macro expression
 void save_macro_exp(char* p_name, char* p_arguments, char* p_exp){
  
   //macro with this name alreday exists, overloadin not allowed
   if(search_func(p_name)==1)
   {
     //ERROR!
     printf("//Failed to parse input code\n");
     exit(1);
   }
 
   list_exp[exp_last].name=(char*) malloc (strlen(p_name)+1);
   list_exp[exp_last].exp=(char*) malloc (strlen(p_exp)+1);
   
   strcpy(list_exp[exp_last].name,p_name);
   strcpy(list_exp[exp_last].exp,p_exp);
   
   
   if(p_arguments==NULL)
     list_exp[exp_last].n=0;
   else
   {
      int count=0;
            
      for(int p=0;p<strlen(p_arguments);p++)
      {
         if(p_arguments[p]==',')
           count++;
      }
      
      list_exp[exp_last].n=count+1;
   }
   
   if(list_exp[exp_last].n>0)
   {
   
   int arg_no=0;  
   int arg_l=0;
   
   for(int p=0;p<strlen(p_arguments);p++)
   {
     char ch=p_arguments[p];
     
     if(ch==' ')
     {
      continue;
     }
     else if(ch==',')
     {
        arg_no++;
        arg_l=0;
     }
     else
     {
        list_exp[exp_last].args[arg_no][arg_l]=ch;
        arg_l++;
     }
     
   }
   
   }
   
   if(exp_last<99)
    exp_last++;  
   
 }
 
 //function to replace the macro expression call
 char* rep_macro_exp(char* p_name, char* p_args){
    
 int i;
   
 for(i=0;i<exp_last;i++)
 {
    if(strcmp(list_exp[i].name,p_name)==0)
    {
       break;
    }      
 }
   
 if(i==exp_last)  
   return NULL;  

 if(list_exp[i].n==0)
 {
    if((p_args)!=NULL)
    {
       //number of argumnets not matching
       printf("//Failed to parse input code\n");
       exit(1);
    }
 } 
     
 if(p_args==NULL)
 {     
   return list_exp[i].exp;
 } 
   
 char **curr_args = (char**) malloc(list_exp[i].n * sizeof(char *));  
 for(int h=0;h<list_exp[i].n;h++)
 {
    curr_args[h]=(char*) malloc (40*sizeof(char));
 }
   
 int curr_arg_no=0;
 for(int p=0;p<strlen(p_args);p++)
 {
   char ch=p_args[p];
   if(ch==' ')
     continue;
   else if(ch==',')
     curr_arg_no++;
   else
   {
      strncat(curr_args[curr_arg_no],&ch,1);
   }
   if(curr_arg_no>=list_exp[i].n)
   {
     //number of arguments not matching
      printf("//Failed to parse input code\n");
      exit(1);
   }
 }
 
 //number of arguments not matching
 if(curr_arg_no!=(list_exp[i].n-1))
 {
    //RETURN ERROR!
    printf("//Failed to parse input code\n");
    exit(1);
 }
   
 char* e=list_exp[i].exp;   
 char* rep_str=(char*) malloc (100*sizeof(char));
 char* temp=(char*) malloc(50*sizeof(char));
   
 for(int q=0;q<strlen(e);q++)
 {
    if((e[q]>='a'&&e[q]<='z')||(e[q]>='A'&&e[q]<='Z')||e[q]=='_'||(e[q]>='0'&&e[q]<='9'))
    {
      strncat(temp,&e[q],1);
    }
    else
    {
      if(strcmp(temp,"")==0)
      {
         strncat(rep_str,&e[q],1);
      }
      else
      {
            int u=0;
            for(u=0;u<list_exp[i].n;u++)
            {
               if(strcmp(list_exp[i].args[u],temp)==0)
               {
                  strcat(rep_str,curr_args[u]);
                  break;
               }
            }
            if(u==list_exp[i].n)
            {
              strcat(rep_str,temp);
            }
            strncat(rep_str,&e[q],1);
            strcpy(temp,"");
      }
       
    }
 }
   
 int u;
 for(u=0;u<list_exp[i].n;u++)
 {
     if(strcmp(list_exp[i].args[u],temp)==0)
     {
         strcat(rep_str,curr_args[u]);
         strcat(rep_str," ");
         break;
     }
 }
 if(u==list_exp[i].n)
 {
       strcat(rep_str,temp);
       strcat(rep_str," ");
  }
  strcpy(temp,"");
    
  return rep_str;   
 }
 
 //function to remember the macro statement
 void save_macro_stmt(char* p_name, char* p_arguments, char* p_exp){
 
   //macro with this name already exists, overloading not allowed
   if(search_func(p_name)==1)
   {
     //ERROR!
     printf("//Failed to parse input code\n");
     exit(1);
   }
   
   list_stmt[stmt_last].name=(char*) malloc (strlen(p_name)+1);
   list_stmt[stmt_last].exp=(char*) malloc (strlen(p_exp)+1);
   
   strcpy(list_stmt[stmt_last].name,p_name);
   strcpy(list_stmt[stmt_last].exp,p_exp);
   
   if(p_arguments==NULL)
     list_stmt[stmt_last].n=0;
   else
   {
      int count=0;
      
      for(int p=0;p<strlen(p_arguments);p++)
      {        
         if(p_arguments[p]==',')
           count++;
      }
      
      list_stmt[stmt_last].n=count+1;
   }
   
   if(list_stmt[stmt_last].n>0)
   {
   
   int arg_no=0;  
   int arg_l=0;
   
   for(int p=0;p<strlen(p_arguments);p++)
   {
     char ch=p_arguments[p];
     if(ch==' ')
       continue;
     else if(ch==',')
     {
        arg_no++;
        arg_l=0;
     }
     else
     {
        list_stmt[stmt_last].args[arg_no][arg_l]=ch;
        arg_l++;
     }
     
   }
   
   }
      
   if(stmt_last<99)
    stmt_last++;   
   
 }
 
 //function to replace the macro statement call
 char* rep_macro_stmt(char* p_name, char* p_args){
    
   int i;
   
   for(i=0;i<stmt_last;i++)
   {
      if(strcmp(list_stmt[i].name,p_name)==0)
      {
         break;
      }      
   }
   
   if(i==stmt_last)  
     return NULL;   
     
   if(list_stmt[i].n==0)
   {
      if(p_args!=NULL)
      {
        //number of arguments not matching
        printf("//Failed to parse input code\n");
        exit(1);
      }
   }
     
   if(p_args==NULL)
   {     
     return list_stmt[i].exp;
   } 
    
   char curr_args[40][40];   
   int curr_arg_no=0;
   int curr_arg_l=0;
   
   for(int p=0;p<strlen(p_args);p++)
   {
     char ch=p_args[p];
     if(ch==' ')
       continue;
     else if(ch==',')
     {
        curr_args[curr_arg_no][curr_arg_l]='\0';  
        curr_arg_no++;
        curr_arg_l=0;
     }
     else
     {
        curr_args[curr_arg_no][curr_arg_l]=ch;
        curr_arg_l++;
     }
     if(curr_arg_no>=list_stmt[i].n)
     {
        //number of arguments not matching
        printf("//Failed to parse input code\n");
        exit(1);
     }
   }
   
   curr_args[curr_arg_no][curr_arg_l]='\0';   

   //number of arguments not matching
   if(curr_arg_no!=(list_stmt[i].n-1))
   {
      //RETURN ERROR!
      printf("//Failed to parse input code\n");
      exit(1);
   }
   
   
   char* e=list_stmt[i].exp;   
   char* rep_str=(char*) malloc (sizeof(char)*100);
   char* temp=(char*) malloc (sizeof(char)*50);
   
   for(int q=0;q<strlen(e);q++)
   {
      if((e[q]>='a'&&e[q]<='z')||(e[q]>='A'&&e[q]<='Z')||e[q]=='_'||(e[q]>='0'&&e[q]<='9'))
      {
        strncat(temp,&e[q],1);
      }
      else
      {
            int u;
            for(u=0;u<list_stmt[i].n;u++)
            {
               if(strcmp(list_stmt[i].args[u],temp)==0)
               {                  
                  strcat(rep_str,curr_args[u]);
                  break;
               }
            }
            if(u==list_stmt[i].n)
            {
               strcat(rep_str,temp);
            }
            strncat(rep_str,&e[q],1);
            strcpy(temp,"");
      }
   }
   int u;
   for(u=0;u<list_stmt[i].n;u++)
   {
       if(strcmp(list_stmt[i].args[u],temp)==0)
       {
           strcat(rep_str,curr_args[u]);
           strcat(rep_str," ");
           break;
       }
   }
   if(u==list_stmt[i].n)
   {
       strcat(rep_str,temp);
       strcat(rep_str," ");
   }
   strcpy(temp,"");
   
   return rep_str;   
 }
 
%}

%union {
        char* tok;
}

%define parse.error detailed

%token <tok> INTEGER_LITERAL ID EQ OP
%token <tok> DOT CLASS PUBLIC STATIC VOID MAIN
%token <tok> THIS STRING EXTENDS PRNT_STMT RETURN NEW
%token <tok> Comma NOT TRUE FALSE IF ELSE WHILE LEN SemiColon
%token <tok> LeftB RightB LeftC RightC LeftBB RightBB
%token <tok> DEF_STMT DEF_STMT0 DEF_STMT1 DEF_STMT2 DEF_EXP DEF_EXP0 DEF_EXP1 DEF_EXP2 INT BOOL

%type <tok> Goal
%type <tok> MainClass
%type <tok> TypeDecRec
%type <tok> Macro_Rec
%type <tok> MacroDefinition
%type <tok> Exp
%type <tok> PrimExp
%type <tok> TypeDeclaration
%type <tok> TypeIDRec
%type <tok> MethDec
%type <tok> MethDecRec
%type <tok> Type
%type <tok> CommaExpRec
%type <tok> CommaTypeIDRec
%type <tok> CommaIDRec
%type <tok> StatementRec
%type <tok> Statement
%type <tok> MacroDefExp
%type <tok> MacroDefStmt

%%

 Goal : MainClass YYEOF {sprintf($$,"%s\n",$1); printf("%s\n",$$);} 
        | MainClass TypeDecRec YYEOF {sprintf($$,"%s %s\n",$1,$2); printf("%s\n",$$);}
        | Macro_Rec MainClass  YYEOF {sprintf($$,"%s\n",$2); printf("%s\n",$$);}
        | Macro_Rec MainClass TypeDecRec YYEOF {sprintf($$,"%s %s\n",$2,$3); printf("%s\n",$$);}
 ;
  
 TypeDecRec : TypeDeclaration    {sprintf($$,"%s",$1);}
              | TypeDecRec TypeDeclaration    {sprintf($$,"%s %s",$1,$2);}
 ;
 
 Macro_Rec : MacroDefinition  {sprintf($$,"%s",$1);} 
             | Macro_Rec MacroDefinition  {sprintf($$,"%s %s",$1,$2);}  
 ;
  
 MacroDefinition : MacroDefExp  {sprintf($$,"%s",$1);}  
                   | MacroDefStmt        {sprintf($$,"%s",$1);}  
 ;
 
 MacroDefExp : DEF_EXP ID LeftB ID Comma ID Comma ID RightB LeftB Exp RightB   {char* temp3=(char*) malloc(strlen($4)+strlen($6)+strlen($8)+7); sprintf(temp3,"%s , %s , %s",$4,$6,$8); save_macro_exp($2,temp3,$11);} /* More than 2 arguments */
               | DEF_EXP ID LeftB ID Comma ID Comma ID CommaIDRec RightB LeftB Exp RightB {char* temp4=(char*) malloc(strlen($4)+strlen($6)+strlen($8)+strlen($9)+8); sprintf(temp4,"%s , %s , %s %s",$4,$6,$8,$9); save_macro_exp($2,temp4,$12);} /* More than 2 arguments */
               | DEF_EXP0 ID LeftB RightB LeftB Exp RightB    {save_macro_exp($2,NULL,$6);}
               | DEF_EXP1 ID LeftB ID RightB LeftB Exp RightB    {save_macro_exp($2,$4,$7);}
               | DEF_EXP2 ID LeftB ID Comma ID RightB LeftB Exp RightB {char* temp1=(char*) malloc(strlen($4)+strlen($6)+4); sprintf(temp1,"%s , %s",$4,$6); save_macro_exp($2,temp1,$9);}
 ;
 
 CommaIDRec : CommaIDRec Comma ID    {sprintf($$,"%s %s %s",$1,$2,$3);}
              | Comma ID    {sprintf($$,"%s %s",$1,$2);}
 ;
 
 MacroDefStmt : DEF_STMT ID LeftB ID Comma ID Comma ID RightB LeftC RightC    {char* temp2=(char*) malloc(strlen($4)+strlen($6)+strlen($8)+7); sprintf(temp2,"%s , %s , %s",$4,$6,$8); save_macro_stmt($2,temp2,NULL);} /* More than 2 arguments */
                | DEF_STMT ID LeftB ID Comma ID Comma ID RightB LeftC StatementRec RightC  {char* temp5=(char*) malloc(strlen($4)+strlen($6)+strlen($8)+7); sprintf(temp5,"%s , %s , %s",$4,$6,$8); save_macro_stmt($2,temp5,$11);} /* More than 2 arguments */ 
                | DEF_STMT ID LeftB ID Comma ID Comma ID CommaIDRec RightB LeftC RightC   {char* temp6=(char*) malloc(strlen($4)+strlen($6)+strlen($8)+strlen($9)+8); sprintf(temp6,"%s , %s , %s %s",$4,$6,$8,$9); save_macro_stmt($2,temp6,NULL);} /* More than 2 arguments */
                | DEF_STMT ID LeftB ID Comma ID Comma ID CommaIDRec RightB LeftC StatementRec RightC {char* temp7=(char*) malloc(strlen($4)+strlen($6)+strlen($8)+strlen($9)+8); sprintf(temp7,"%s , %s , %s %s",$4,$6,$8,$9); save_macro_stmt($2,temp7,$12);} /* More than 2 arguments */                
                | DEF_STMT0 ID LeftB RightB LeftC RightC  {save_macro_stmt($2,NULL,NULL);}
                | DEF_STMT0 ID LeftB RightB LeftC StatementRec RightC                {save_macro_stmt($2,NULL,$6);}
                | DEF_STMT1 ID LeftB ID RightB LeftC RightC    {save_macro_stmt($2,$4,NULL);}
                | DEF_STMT1 ID LeftB ID RightB LeftC StatementRec RightC   {save_macro_stmt($2,$4,$7);}             
                | DEF_STMT2 ID LeftB ID Comma ID RightB LeftC RightC         {char* temp9=(char*) malloc(strlen($4)+strlen($6)+4); sprintf(temp9,"%s , %s",$4,$6); save_macro_stmt($2,temp9,NULL);}  
                | DEF_STMT2 ID LeftB ID Comma ID RightB LeftC StatementRec RightC     {char* temp10=(char*) malloc(strlen($4)+strlen($6)+4); sprintf(temp10,"%s , %s",$4,$6); save_macro_stmt($2,temp10,$9);}  
 ;
 
 MainClass : CLASS ID LeftC PUBLIC STATIC VOID MAIN LeftB STRING LeftBB RightBB ID RightB LeftC PRNT_STMT LeftB Exp RightB SemiColon RightC RightC {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21);}
 ;
 
 TypeDeclaration : CLASS ID LeftC RightC   {sprintf($$,"%s %s %s %s",$1,$2,$3,$4);}
                   | CLASS ID LeftC MethDecRec RightC    {sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);}
                   | CLASS ID LeftC TypeIDRec RightC     {sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);}
                   | CLASS ID LeftC TypeIDRec MethDecRec RightC  {sprintf($$,"%s %s %s %s %s %s",$1,$2,$3,$4,$5,$6);}
                   | CLASS ID EXTENDS ID LeftC RightC            {sprintf($$,"%s %s %s %s %s %s",$1,$2,$3,$4,$5,$6);}
                   | CLASS ID EXTENDS ID LeftC MethDecRec RightC     {sprintf($$,"%s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7);}
                   | CLASS ID EXTENDS ID LeftC TypeIDRec RightC      {sprintf($$,"%s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7);}
                   | CLASS ID EXTENDS ID LeftC TypeIDRec MethDecRec RightC    {sprintf($$,"%s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8);}
 ;
 
 TypeIDRec : TypeIDRec Type ID SemiColon  {sprintf($$,"%s %s %s %s",$1,$2,$3,$4);}
             | Type ID SemiColon          {sprintf($$,"%s %s %s",$1,$2,$3);}
 ;
 
 CommaTypeIDRec : CommaTypeIDRec Comma Type ID    {sprintf($$,"%s %s %s %s",$1,$2,$3,$4);}
                  | Comma Type ID    {sprintf($$,"%s %s %s",$1,$2,$3);}
 ;
            
 MethDec : PUBLIC Type ID LeftB RightB LeftC RETURN Exp SemiColon RightC    {sprintf($$,"%s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10);}
           | PUBLIC Type ID LeftB RightB LeftC StatementRec RETURN Exp SemiColon RightC      {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11);}             
           | PUBLIC Type ID LeftB RightB LeftC TypeIDRec RETURN Exp SemiColon RightC         {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11);}
           | PUBLIC Type ID LeftB RightB LeftC TypeIDRec StatementRec RETURN Exp SemiColon RightC {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12);}                  
           | PUBLIC Type ID LeftB Type ID RightB LeftC RETURN Exp SemiColon RightC   {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12);}                  
           | PUBLIC Type ID LeftB Type ID RightB LeftC StatementRec RETURN Exp SemiColon RightC      {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13);}                                     
           | PUBLIC Type ID LeftB Type ID RightB LeftC TypeIDRec RETURN Exp SemiColon RightC         {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13);}                                     
           | PUBLIC Type ID LeftB Type ID RightB LeftC TypeIDRec StatementRec RETURN Exp SemiColon RightC   {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14);}                                                   
           | PUBLIC Type ID LeftB Type ID CommaTypeIDRec RightB LeftC RETURN Exp SemiColon RightC           {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13);}                                                   
           | PUBLIC Type ID LeftB Type ID CommaTypeIDRec RightB LeftC StatementRec RETURN Exp SemiColon RightC      {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14);}                                                                
           | PUBLIC Type ID LeftB Type ID CommaTypeIDRec RightB LeftC TypeIDRec RETURN Exp SemiColon RightC         {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14);}                                                                
           | PUBLIC Type ID LeftB Type ID CommaTypeIDRec RightB LeftC TypeIDRec StatementRec RETURN Exp SemiColon RightC   {sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15);}                                                                     
 ;
 
 MethDecRec : MethDecRec MethDec    {sprintf($$,"%s %s",$1,$2);}
              | MethDec             {sprintf($$,"%s",$1);}
 ;
 
 Statement : LeftC RightC  {sprintf($$,"%s %s",$1,$2);}
             | LeftC StatementRec RightC  {sprintf($$,"%s %s %s",$1,$2,$3);}
             | PRNT_STMT LeftB Exp RightB SemiColon  {sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);}
             | ID EQ Exp SemiColon    {sprintf($$,"%s %s %s %s",$1,$2,$3,$4);}
             | ID LeftBB Exp RightBB EQ Exp SemiColon    {sprintf($$,"%s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7);}
             | IF LeftB Exp RightB Statement    {sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);}
             | IF LeftB Exp RightB Statement ELSE Statement    {sprintf($$,"%s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7);}
             | WHILE LeftB Exp RightB Statement    {sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);}
             | ID LeftB RightB SemiColon      {char* rep=rep_macro_stmt($1,NULL); if(rep!=NULL) {sprintf($$,"%s %s %s %s","{",rep,"}",$4);} else {printf("//Failed to parse input code\n"); exit(1);}}/* Macro stmt call */
             | ID LeftB Exp RightB SemiColon      {char* rep=rep_macro_stmt($1,$3); if(rep!=NULL) {sprintf($$,"%s %s %s %s","{",rep,"}",$5);} else {printf("//Failed to parse input code\n"); exit(1);}}/* Macro stmt call */
             | ID LeftB Exp CommaExpRec RightB SemiColon      {char* temp12=(char*) malloc(strlen($3)+strlen($4)+1);; strcpy(temp12,$3); strcat(temp12,$4); char* rep=rep_macro_stmt($1,temp12); if(rep!=NULL) {sprintf($$,"%s %s %s %s","{",rep,"}",$6);} else {printf("//Failed to parse input code\n"); exit(1);}}/* Macro stmt call */
 ;
 
 StatementRec: StatementRec Statement    {sprintf($$,"%s %s",$1,$2);}
               | Statement    {sprintf($$,"%s",$1);}
 ;
                
 
 Type : INT    {sprintf($$,"%s",$1);}
        | BOOL    {sprintf($$,"%s",$1);}
        | INT LeftBB RightBB    {sprintf($$,"%s %s %s",$1,$2,$3);} 
        | ID       {sprintf($$,"%s",$1);}
 ;
             
 Exp : PrimExp OP PrimExp    {sprintf($$,"%s %s %s",$1,$2,$3);}
       | PrimExp LeftBB PrimExp RightBB    {sprintf($$,"%s %s %s %s",$1,$2,$3,$4);}
       | PrimExp DOT LEN                   {sprintf($$,"%s %s %s",$1,$2,$3);}
       | PrimExp                           {sprintf($$,"%s",$1);}
       | PrimExp DOT ID LeftB RightB       {sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);}
       | PrimExp DOT ID LeftB Exp RightB   {sprintf($$,"%s %s %s %s %s %s",$1,$2,$3,$4,$5,$6);}
       | PrimExp DOT ID LeftB Exp CommaExpRec RightB    {sprintf($$,"%s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7);}
       | ID LeftB RightB   {char* rep=rep_macro_exp($1,NULL); if(rep!=NULL) {sprintf($$,"%s %s %s",$2,rep,$3);} else {printf("//Failed to parse input code\n"); exit(1);}} /* Macro expr call */
       | ID LeftB Exp RightB {char* rep=rep_macro_exp($1,$3); if(rep!=NULL) {sprintf($$,"%s %s %s",$2,rep,$4);} else {printf("//Failed to parse input code\n"); exit(1);}} /* Macro expr call */
       | ID LeftB Exp CommaExpRec RightB   {char* temp11=(char*) malloc (strlen($3)+strlen($4)+1); strcpy(temp11,$3); strcat(temp11,$4); char* rep=rep_macro_exp($1,temp11); if(rep!=NULL) {sprintf($$,"%s %s %s",$2,rep,$5);} else {printf("//Failed to parse input code\n"); exit(1);}} /* Macro expr call */
 ;  
 
 CommaExpRec : Comma Exp    {sprintf($$,"%s %s",$1,$2);}
               | CommaExpRec Comma Exp    {sprintf($$,"%s %s %s",$1,$2,$3);}
 ;
 
 PrimExp : INTEGER_LITERAL    {sprintf($$,"%s",$1);}
           | TRUE             {sprintf($$,"%s",$1);}
           | FALSE            {sprintf($$,"%s",$1);}
           | ID               {sprintf($$,"%s",$1);}
           | THIS             {sprintf($$,"%s",$1);}
           | NEW INT LeftBB Exp RightBB      {sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);}
           | NEW ID LeftB RightB             {sprintf($$,"%s %s %s %s",$1,$2,$3,$4);}
           | NOT Exp                         {sprintf($$,"%s %s",$1,$2);}
           | LeftB Exp RightB                {sprintf($$,"%s %s %s",$1,$2,$3);}
 ;
 
%%

void yyerror (const char *s) {
  printf ("//Failed to parse input code\n");
}

int main () {
  yyparse ();
	return 0;
}

#include "lex.yy.c"
