This is the last part of the project. It takes programs in the miniRA format and translates them to MIPS Assembly.

The main file is called P5.java, if A.RA contains a program to be assembled then

$ javac P5.java  
$ java P5 < A.miniRA > A.s  

will create A.s in MIPS assembly form such that it is semantically equivalent to A.miniRA.
