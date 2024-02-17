EnableExplicit

CompilerIf #PB_Compiler_LineNumbering
  Procedure.i ErrorHandler()
    MessageRequester("Error", ErrorMessage(ErrorCode())+#CRLF$+"File: "+ErrorFile()+#CRLF$+"Line: "+ErrorLine())
  EndProcedure
  
CompilerEndIf