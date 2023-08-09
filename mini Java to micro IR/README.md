This part of the project, starts with a type checked Minijava program and generates the corresponding program in MircoIR format.

The main file is called P2.java. If A.java contains the mini Java program, then

$ javac P2.java
$ java P2 < A.java > A.microIR

will create A.microIR in MicroIR form such that it is semantically equivalent to A.java.
