EnableExplicit

CompilerIf #PB_Compiler_LineNumbering
  Declare.i ErrorHandler()
  
  OnErrorCall(@ErrorHandler())
  
CompilerEndIf