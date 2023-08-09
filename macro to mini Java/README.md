This part of the project implements a MacroJava to MiniJava translator using Flex and Bison.

If X.java is a valid MacroJava program, then the following commands will generate the corresponding MiniJava code in Y.java. 

$ bison A1.y
$ flex A1.l
$ gcc A1.tab.c -lfl -o A1
$ ./A1 < X.java > Y.java

If the X.java file is not a valid MacroJava program, then the output will be "//Failed to parse input code".
