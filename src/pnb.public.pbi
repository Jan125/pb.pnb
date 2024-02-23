EnableExplicit

EnumerationBinary PNB_TYPE 0
  #PNB_TYPE_NONE
  #PNB_TYPE_LIST = 1
  #PNB_TYPE_SUBLIST
  #PNB_TYPE_COMMAND
  
  
  #PNB_TYPE_UBYTE
  #PNB_TYPE_CHARACTER
  #PNB_TYPE_UWORD
  
  #PNB_TYPE_BYTE
  #PNB_TYPE_WORD
  #PNB_TYPE_LONG
  #PNB_TYPE_INTEGER
  #PNB_TYPE_EPIC
  
  #PNB_TYPE_FLOAT
  #PNB_TYPE_DOUBLE
  
  #PNB_TYPE_POINTER
  
  #PNB_TYPE_STRING
  #PNB_TYPE_NAME
EndEnumeration

Structure TriList
  List Child.TriList()
  *Data
  Flags.i
EndStructure

Global NewMap Func.TriList()
Global NewMap FuncParam.TriList()
Global NewMap FuncParamDefault.TriList()

Global NewMap Vari.TriList()

Global MutexFunMap.i
Global MutexVarMap.i
Global MutexMemMap.i

Declare.s EvalString(String.s)