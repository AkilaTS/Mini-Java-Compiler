This part of the project takes in programs in microIR format and translates them to miniRA. Register Allocation is carried out using the Linear Scan algorithm.

The main file is called P4.java. If A.microIR contains the program to be register allocated then

$ javac P4.java
$ java P4 < A.microIR > A.RA

will create A.RA in miniRA form such that it is semantically equivalent to A.microIR.
