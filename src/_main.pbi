EnableExplicit

DeclareModule PNB
  
  IncludeFile "pnb.public.pbi"
  IncludeFile "lexer.public.pbi"
  IncludeFile "util.public.pbi"
  
EndDeclareModule

Module PNB
  
  IncludeFile "pnb.internal.pbi"
  IncludeFile "lexer.internal.pbi"
  IncludeFile "util.internal.pbi"
  
  IncludeFile "pnb.code.pbi"
  IncludeFile "lexer.code.pbi"
  IncludeFile "util.code.pbi"
  
EndModule
