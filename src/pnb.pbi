EnableExplicit
DeclareModule PNB
  CompilerIf #PB_Compiler_Thread = 1
    Global MutexFunMap.i
    Global MutexVarMap.i
    Global MutexMemMap.i
  CompilerEndIf
  Declare.s nListEvalString(String.s)
  Declare.i nListEnableBinary(Toggle.i)
EndDeclareModule
Module PNB
  
  Structure nList
    List nList.nList()
    Flags.i
    StructureUnion
      a.a
      c.c
      u.u
      b.b
      w.w
      l.l
      i.i
      q.q
      f.f
      d.d
      *p
    EndStructureUnion
    s.s
  EndStructure
  
  Structure nListThread
    List nList.nList()
  EndStructure
  
  Declare.s nListEvalString(String.s)
  Declare.i nListEvalThread(*nList.nListThread)
  Declare.i nListEvalThreadFork(*nList.nListThread)
  Declare.i nListEnableBinary(Toggle.i)
  
  Global EnableBinary.i
  Procedure.i nListEnableBinary(Toggle.i)
    EnableBinary = Toggle
  EndProcedure
  
  CompilerIf #PB_Compiler_ExecutableFormat = #PB_Compiler_DLL Or #PB_Compiler_Thread = 1
    Global MutexFunMap.i
    Global MutexVarMap.i
    Global MutexMemMap.i
  CompilerEndIf
  
  CompilerIf #PB_Compiler_ExecutableFormat <> #PB_Compiler_DLL And #PB_Compiler_Thread = 1
    MutexFunMap = CreateMutex()
    MutexVarMap = CreateMutex()
    MutexMemMap = CreateMutex()
  CompilerEndIf
  EnumerationBinary PNB_TYPE 0
    #PNB_TYPE_NONE
    #PNB_TYPE_LIST = 1
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
  
  
  
  Procedure.i nListGetHighestType(Flags.i)
    If Flags & #PNB_TYPE_LIST
      ProcedureReturn #PNB_TYPE_LIST
    ElseIf Flags & #PNB_TYPE_NAME
      ProcedureReturn #PNB_TYPE_NAME
    ElseIf Flags & #PNB_TYPE_STRING
      ProcedureReturn #PNB_TYPE_STRING
    ElseIf Flags & #PNB_TYPE_POINTER
      ProcedureReturn #PNB_TYPE_POINTER
    ElseIf Flags & #PNB_TYPE_DOUBLE
      ProcedureReturn #PNB_TYPE_DOUBLE
    ElseIf Flags & #PNB_TYPE_FLOAT
      ProcedureReturn #PNB_TYPE_FLOAT
    ElseIf Flags & #PNB_TYPE_EPIC
      ProcedureReturn #PNB_TYPE_EPIC
    ElseIf Flags & #PNB_TYPE_INTEGER
      ProcedureReturn #PNB_TYPE_INTEGER
    ElseIf Flags & #PNB_TYPE_LONG
      ProcedureReturn #PNB_TYPE_LONG
    ElseIf Flags & #PNB_TYPE_WORD
      ProcedureReturn #PNB_TYPE_WORD
    ElseIf Flags & #PNB_TYPE_BYTE
      ProcedureReturn #PNB_TYPE_BYTE
    ElseIf Flags & #PNB_TYPE_UWORD
      ProcedureReturn #PNB_TYPE_UWORD
    ElseIf Flags & #PNB_TYPE_CHARACTER
      ProcedureReturn #PNB_TYPE_CHARACTER
    ElseIf Flags & #PNB_TYPE_UBYTE
      ProcedureReturn #PNB_TYPE_UBYTE
    EndIf
    ProcedureReturn #PNB_TYPE_NONE
  EndProcedure
  
  Procedure.i nListTypeFromList(List nList.nList())
    Protected Flags.i
    If ListSize(nList())
      PushListPosition(nList())
      ForEach nList()
        Flags | nList()\Flags
      Next
      PopListPosition(nList())
    EndIf
    ProcedureReturn Flags
  EndProcedure
  
  Procedure nListConvert(List nList.nList(), DesiredType.i, ConvertPointers.i = 0)
    Protected *PTR
    PushListPosition(nList())
    ForEach nList()
      Select nListGetHighestType(nList()\Flags)
        Case #PNB_TYPE_LIST
          PopListPosition(nList())
          ProcedureReturn
        Case #PNB_TYPE_NAME
          Select DesiredType
            Case #PNB_TYPE_STRING
              nList()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\p = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\p = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\p = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\q = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\q = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\d = ValD(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\l = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\l = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\f = ValF(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\q = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\q = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\q = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\i = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\i = Val("%"+nList()\s)
              Else
                nList()\i = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\l = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\l = Val("%"+nList()\s)
              Else
                nList()\l = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\w = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\w = Val("%"+nList()\s)
              Else
                nList()\w = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\b = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\b = Val("%"+nList()\s)
              Else
                nList()\b = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\u = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\u = Val("%"+nList()\s)
              Else
                nList()\u = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\c = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\c = Val("%"+nList()\s)
              Else
                nList()\c = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\a = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\a = Val("%"+nList()\s)
              Else
                nList()\a = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_STRING
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_POINTER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\p = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\p = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\p = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\q = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\q = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\d = ValD(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\l = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\l = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\f = ValF(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\q = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\q = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\q = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\i = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\i = Val("%"+nList()\s)
              Else
                nList()\i = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\l = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\l = Val("%"+nList()\s)
              Else
                nList()\l = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\w = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\w = Val("%"+nList()\s)
              Else
                nList()\w = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\b = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\b = Val("%"+nList()\s)
              Else
                nList()\b = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\u = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\u = Val("%"+nList()\s)
              Else
                nList()\u = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\c = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\c = Val("%"+nList()\s)
              Else
                nList()\c = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\a = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\a = Val("%"+nList()\s)
              Else
                nList()\a = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_POINTER
          If ConvertPointers
            Select DesiredType
              Case #PNB_TYPE_NAME
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\s = PeekS(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_NAME
              Case #PNB_TYPE_STRING
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\s = PeekS(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_STRING
              Case #PNB_TYPE_DOUBLE
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\d = PeekD(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_DOUBLE
              Case #PNB_TYPE_FLOAT
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\f = PeekF(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_FLOAT
              Case #PNB_TYPE_EPIC
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\q = PeekQ(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_EPIC
              Case #PNB_TYPE_INTEGER
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\i = PeekI(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_INTEGER
              Case #PNB_TYPE_LONG
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\l = PeekL(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_LONG
              Case #PNB_TYPE_WORD
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\w = PeekW(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_WORD
              Case #PNB_TYPE_BYTE
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\b = PeekB(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_BYTE
              Case #PNB_TYPE_UWORD
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\u = PeekU(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_UWORD
              Case #PNB_TYPE_CHARACTER
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\c = PeekC(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_CHARACTER
              Case #PNB_TYPE_UBYTE
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\a = PeekA(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_UBYTE
            EndSelect
          Else
            Select DesiredType
              Case #PNB_TYPE_NAME
                nList()\s = Str(nList()\p)
                nList()\p = 0
                nlist()\Flags = #PNB_TYPE_NAME
              Case #PNB_TYPE_STRING
                nList()\s = Str(nList()\p)
                nList()\p = 0
                nlist()\Flags = #PNB_TYPE_STRING
              Case #PNB_TYPE_DOUBLE
                nList()\d = nList()\p
                nlist()\Flags = #PNB_TYPE_DOUBLE
              Case #PNB_TYPE_FLOAT
                nList()\f = nList()\p
                nlist()\Flags = #PNB_TYPE_FLOAT
              Case #PNB_TYPE_EPIC
                nList()\q = nList()\p
                nlist()\Flags = #PNB_TYPE_EPIC
              Case #PNB_TYPE_INTEGER
                nList()\i = nList()\p
                nlist()\Flags = #PNB_TYPE_INTEGER
              Case #PNB_TYPE_LONG
                nList()\l = nList()\p
                nlist()\Flags = #PNB_TYPE_LONG
              Case #PNB_TYPE_WORD
                nList()\w = nList()\p
                nlist()\Flags = #PNB_TYPE_WORD
              Case #PNB_TYPE_BYTE
                nList()\b = nList()\p
                nlist()\Flags = #PNB_TYPE_BYTE
              Case #PNB_TYPE_UWORD
                nList()\u = nList()\p
                nlist()\Flags = #PNB_TYPE_UWORD
              Case #PNB_TYPE_CHARACTER
                nList()\c = nList()\p
                nlist()\Flags = #PNB_TYPE_CHARACTER
              Case #PNB_TYPE_UBYTE
                nList()\a = nList()\p
                nlist()\Flags = #PNB_TYPE_UBYTE
            EndSelect
          EndIf
        Case #PNB_TYPE_DOUBLE
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = StrD(nList()\d, 19)
              nList()\d = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = StrD(nList()\d, 19)
              nList()\d = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\d
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\d
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\d
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\d
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\d
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\d
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\d
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\d
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\d
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\d
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_FLOAT
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = StrF(nList()\f, 14)
              nList()\f = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = StrF(nList()\f, 14)
              nList()\f = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\f
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\f
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\f
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\f
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\f
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\f
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\f
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\f
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\f
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\f
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_EPIC
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\q)
              nList()\q = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\q)
              nList()\q = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\q
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\q
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\q
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\q
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\q
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\q
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\q
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\q
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\q
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\q
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_INTEGER
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\i)
              nList()\i = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\i)
              nList()\i = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\i
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\i
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\i
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\i
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_LONG
              nList()\l = nList()\i
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\i
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\i
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\i
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\i
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\i
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_LONG
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\l)
              nList()\l = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\l)
              nList()\l = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\l
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\l
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\l
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\l
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\l
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_WORD
              nList()\w = nList()\l
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\l
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\l
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\l
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\l
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_WORD
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\w)
              nList()\w = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\w)
              nList()\w = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\w
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\w
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\w
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\w
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\w
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\w
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\w
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\w
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\w
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\w
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_BYTE
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\b)
              nList()\b = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\b)
              nList()\b = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\b
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\b
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\b
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\b
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\b
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\b
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\b
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\b
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\b
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\b
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_UWORD
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\u)
              nList()\u = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\u)
              nList()\u = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\u
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\u
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\u
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\u
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\u
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\u
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\u
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\u
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\u
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\u
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_CHARACTER
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\c)
              nList()\c = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\c)
              nList()\c = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\c
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\c
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\c
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\c
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\c
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\c
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\c
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\c
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\c
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\c
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_UBYTE
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\a)
              nList()\a = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\a)
              nList()\a = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\a
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\a
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\a
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\a
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\a
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\a
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\a
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\a
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\a
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\a
              nlist()\Flags = #PNB_TYPE_CHARACTER
          EndSelect
      EndSelect
    Next
    PopListPosition(nList())
    ProcedureReturn
  EndProcedure
  
  Procedure.i nListDelete(List nList.nList(), StringToFind.s)
    Protected Ocurrences.i = 0
    Protected a.i
    ForEach nList()
      If ListSize(nList()\nList())
        a = nListDelete(nList()\nList(), StringToFind)
        Ocurrences = Ocurrences + a
      EndIf
      If nList()\Flags & #PNB_TYPE_NAME
        If nList()\s = StringToFind
          Ocurrences = Ocurrences + 1
          DeleteElement(nList())
        EndIf
      EndIf
    Next
    ProcedureReturn Ocurrences
  EndProcedure
  
  Procedure.i nListReplace(List nList.nList(), StringToFind.s, *Element.nList)
    Protected Ocurrences.i = 0
    Protected a.i
    ForEach nList()
      If ListSize(nList()\nList())
        a = nListReplace(nList()\nList(), StringToFind, *Element)
        Ocurrences = Ocurrences + a
        If a > 0
          nList()\Flags | *Element\Flags
        EndIf
      EndIf
      If nList()\Flags & #PNB_TYPE_NAME
        If nList()\s = StringToFind
          nList()\s = ""
          Ocurrences = Ocurrences + 1
          Select nListGetHighestType(*Element\Flags)
            Case #PNB_TYPE_NAME
              nList()\s = *Element\s
            Case #PNB_TYPE_STRING
              nList()\s = *Element\s
            Case #PNB_TYPE_POINTER
              nList()\p = *Element\p
            Case #PNB_TYPE_DOUBLE
              nList()\d = *Element\d
            Case #PNB_TYPE_FLOAT
              nList()\f = *Element\f
            Case #PNB_TYPE_EPIC
              nList()\q = *Element\q
            Case #PNB_TYPE_INTEGER
              nList()\i = *Element\i
            Case #PNB_TYPE_LONG
              nList()\l = *Element\l
            Case #PNB_TYPE_WORD
              nList()\w = *Element\w
            Case #PNB_TYPE_BYTE
              nList()\b = *Element\b
            Case #PNB_TYPE_UWORD
              nList()\u = *Element\u
            Case #PNB_TYPE_CHARACTER
              nList()\c = *Element\c
            Case #PNB_TYPE_UBYTE
              nList()\a = *Element\a
          EndSelect
          nList()\Flags = *Element\Flags
        EndIf
      EndIf
    Next
    ProcedureReturn Ocurrences
  EndProcedure
  
  
  Procedure.i nListClear(List nList.nList(), Type.i = #PB_List_First) ;PB clears list elements automatically.
    Protected a.i
    If Type = #PB_List_First Or Type = #PB_List_Last
      ResetList(nList())
      a = #PB_List_After
    Else
      a = Type
    EndIf
    
    While NextElement(nList())
      If ListSize(nList()\nList())
        nListClear(nList())
      EndIf
      DeleteElement(nList())
    Wend
  EndProcedure
  
  Procedure.i nListCompare(List nList1.nList(), List nList2.nList())
    PushListPosition(nList1())
    PushListPosition(nList2())
    ResetList(nList1())
    ResetList(nList2())
    If ListSize(nList1()) = ListSize(nList2())
      ForEach nList1()
        NextElement(nList2())
        If nListCompare(nList1()\nList(), nList2()\nList())
          If nList1()\Flags <> nList2()\Flags
            PopListPosition(nList1())
            PopListPosition(nList2())
            ProcedureReturn 0
          ElseIf nListGetHighestType(nList1()\Flags) = #PNB_TYPE_STRING Or nListGetHighestType(nList1()\Flags) = #PNB_TYPE_NAME
            If nList1()\s <> nList2()\s
              PopListPosition(nList1())
              PopListPosition(nList2())
              ProcedureReturn 0 
            EndIf
          Else
            Select nListGetHighestType(nList1()\Flags)
              Case #PNB_TYPE_POINTER
                If nList1()\p <> nList2()\p
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_DOUBLE
                If nList1()\d <> nList2()\d
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_FLOAT
                If nList1()\f <> nList2()\f
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_EPIC
                If nList1()\q <> nList2()\q
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_INTEGER
                If nList1()\i <> nList2()\i
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_LONG
                If nList1()\l <> nList2()\l
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_WORD
                If nList1()\w <> nList2()\w
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_BYTE
                If nList1()\b <> nList2()\b
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_UWORD
                If nList1()\u <> nList2()\u
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_CHARACTER
                If nList1()\c <> nList2()\c
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_UBYTE
                If nList1()\a <> nList2()\a
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
            EndSelect
            
          EndIf
          
        Else
          PopListPosition(nList1())
          PopListPosition(nList2())
          ProcedureReturn 0
        EndIf
      Next
      PopListPosition(nList1())
      PopListPosition(nList2())
      ProcedureReturn 1
    Else
      PopListPosition(nList1())
      PopListPosition(nList2())
      ProcedureReturn 0
    EndIf
    
    
  EndProcedure
  
  Procedure.i nListPNBTonList(List nList.nList(), String.s)
    Protected Start.i
    Protected Index.i
    Protected Depth.i
    Protected Amount.i
    
    Start = 1
    Index = 1
    Depth = 0
    Amount = 0
    
    While Index <= Len(String)
      Select Asc(Mid(String, Index, 1))
        Case Asc(";") ;Block comments; will be ignored..
          Start = Index
          Repeat
            Index = Index+1
          Until Asc(Mid(String, Index, 1)) = Asc(";") Or Index > Len(String)
          
        Case Asc("'") ;'Apostrophed expressions' are counted as strings. Brackets will be ignored.
          Start = Index
          Repeat
            Index = Index+1
          Until Asc(Mid(String, Index, 1)) = Asc("'") Or Index > Len(String)
          AddElement(nList())
          nList()\Flags | #PNB_TYPE_STRING
          nList()\s = Mid(String, Start+1, Index-Start-1)
          
        Case 34 ;"Quoted expressions" are counted as strings, too.
          Start = Index
          Repeat
            Index = Index+1
          Until Asc(Mid(String, Index, 1)) = 34 Or Index > Len(String)
          AddElement(nList())
          nList()\Flags | #PNB_TYPE_STRING
          nList()\s = Mid(String, Start+1, Index-Start-1)
          
        Case Asc("[") ;[Hard bracketed expressions] are an alternative to apostrophes and quotes.
          Start = Index
          Depth = Depth+1
          Repeat
            Index+1
            Select Asc(Mid(String, Index, 1))
              Case Asc("[")
                Depth = Depth+1
              Case Asc("]")
                Depth = Depth-1
            EndSelect
          Until Depth = 0 Or Index > Len(String)
          AddElement(nList())
          Amount+1
          nList()\Flags | #PNB_TYPE_STRING
          nList()\s = Mid(String, Start+1, Index-Start-1)
          
        Case Asc("(") ;Find (bracketed expressions), pass them, get the return value, then evaluate again.
          Start = Index
          Depth = Depth+1
          Repeat
            Index = Index+1
            Select Asc(Mid(String, Index, 1))
              Case Asc("(")
                Depth = Depth+1
              Case Asc(")")
                Depth = Depth-1
            EndSelect
          Until Depth = 0 Or Index > Len(String)
          AddElement(nList())
          Amount+nListPNBtonList(nList()\nList(), Mid(String, Start+1, Index-Start-1))
          nList()\Flags | #PNB_TYPE_LIST
          
        Case Asc(" "), 9, 13, 10 ;Ignore spaces, tabs, carriage returns (CR), and line feeds (LF).
          
        Default               ;Anything else, preferably commands.
          Start = Index
          Repeat
            Index = Index+1
          Until Asc(Mid(String, Index, 1)) = Asc(" ") Or Asc(Mid(String, Index, 1)) = 13 Or Asc(Mid(String, Index, 1)) = 10 Or Asc(Mid(String, Index, 1)) = 9 Or Asc(Mid(String, Index, 1)) = Asc("(") Or Asc(Mid(String, Index, 1)) = Asc(")") Or Index > Len(String)
          
          AddElement(nList())
          Amount+1
          nList()\s = Mid(String, Start, Index-Start)
          
          Select Asc(nList()\s)
            Case 48 To 57, 43, 45, 46 ; Numbers, plus, minus, and decimal
              Select Asc(nList()\s)
                Case 43, 45
                  If Len(nList()\s) = 1
                    If ListIndex(nList()) = 0
                      nList()\Flags | #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
                    Else
                      nList()\Flags | #PNB_TYPE_NAME
                    EndIf
                    Continue
                  EndIf
              EndSelect
              If FindString(nList()\s, ".")
                If Len(StringField(nList()\s, 2, ".")) < 15
                  nList()\f = ValF(nList()\s)
                  nList()\Flags | #PNB_TYPE_FLOAT
                  nList()\s = ""
                Else
                  nList()\f = ValD(nList()\s)
                  nList()\Flags | #PNB_TYPE_DOUBLE
                  nList()\s = ""
                EndIf
              Else
                If Mid(nList()\s, 1, 2) = "0x"
                  If Len(nList()\s) < 11
                    nList()\l = Val("$"+Mid(nList()\s, 3))
                    nList()\Flags | #PNB_TYPE_INTEGER
                    nList()\s = ""
                  Else
                    nList()\q = Val("$"+Mid(nList()\s, 3))
                    nList()\Flags | #PNB_TYPE_EPIC
                    nList()\s = ""
                  EndIf
                ElseIf Mid(nList()\s, 1, 2) = "0b"
                  If Len(nList()\s) < 35
                    nList()\l = Val("%"+Mid(nList()\s, 3))
                    nList()\Flags | #PNB_TYPE_INTEGER
                    nList()\s = ""
                  Else
                    nList()\q = Val("%"+Mid(nList()\s, 3))
                    nList()\Flags | #PNB_TYPE_EPIC
                    nList()\s = ""
                  EndIf
                Else
                  If Len(nList()\s) < 12
                    nList()\l = Val(nList()\s)
                    nList()\Flags | #PNB_TYPE_INTEGER
                    nList()\s = ""
                  Else
                    nList()\q = Val(nList()\s)
                    nList()\Flags | #PNB_TYPE_EPIC
                    nList()\s = ""
                  EndIf
                EndIf
              EndIf
            Default
              If ListIndex(nList()) = 0
                nList()\Flags | #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
              Else
                nList()\Flags | #PNB_TYPE_NAME
              EndIf
          EndSelect
          
          Index = Index-1
          
      EndSelect
      Index = Index+1
    Wend
    ProcedureReturn
  EndProcedure
  
  
  Procedure.s nListPNBToString(List nList.nList(), Binary.i = 0)
    Protected String.s
    ForEach nList()
      If ListSize(nList()\nList())
        String + "("+nListPNBToString(nList()\nList(), Binary)+") "
      Else
        Select nListGetHighestType(nList()\Flags)
          Case #PNB_TYPE_UBYTE
            If Binary
              String + "(ForceUByte 0x"+Hex(nList()\a, #PB_Ascii)+") "
            Else
              String + Str(nList()\b)+" "
            EndIf
          Case #PNB_TYPE_BYTE
            If Binary
              String + "(ForceByte 0x"+Hex(nList()\b, #PB_Byte)+") "
            Else
              String + Str(nList()\b)+" "
            EndIf
          Case #PNB_TYPE_CHARACTER
            If Binary
              CompilerIf #PB_Compiler_Unicode
                String + "(ForceCharacter 0x"+Hex(nList()\c, #PB_Unicode)+") "
              CompilerElse
                String + "(ForceCharacter 0x"+Hex(nList()\c, #PB_Ascii)+") "
              CompilerEndIf
            Else
              String + Str(nList()\c)+" "
            EndIf
          Case #PNB_TYPE_DOUBLE
            If Binary
              String + "(ForceDouble 0x"+Hex(nList()\q, #PB_Quad)+") "
            Else
              String + StrD(nList()\d, 19)+" "
            EndIf
          Case #PNB_TYPE_FLOAT
            If Binary
              String + "(ForceFloat 0x"+Hex(nList()\l, #PB_Long)+") "
            Else
              String + StrF(nList()\f, 14)+" "
            EndIf
          Case #PNB_TYPE_INTEGER
            If Binary
              CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
                String + "(ForceInteger 0x"+Hex(nList()\q, #PB_Quad)+") "
              CompilerElse
                String + "(ForceInteger 0x"+Hex(nList()\l, #PB_Long)+") "
              CompilerEndIf
            Else
              String + Str(nList()\i)+" "
            EndIf
          Case #PNB_TYPE_LONG
            If Binary
              String + "(ForceLong 0x"+Hex(nList()\l, #PB_Long)+") "
            Else
              String + Str(nList()\l)+" "
            EndIf
          Case #PNB_TYPE_NAME
            String + nList()\s+" "
          Case #PNB_TYPE_POINTER
            If Binary
              CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
                String + "(ForcePointer 0x"+Hex(nList()\p, #PB_Quad)+") "
              CompilerElse
                String + "(ForcePointer 0x"+Hex(nList()\p, #PB_Long)+") "
              CompilerEndIf
            Else
              String + Str(nList()\p)+" "
            EndIf
          Case #PNB_TYPE_EPIC
            If Binary
              String + "(ForceQuad 0x"+Hex(nList()\q, #PB_Quad)+") "
            Else
              String + Str(nList()\q)+" "
            EndIf
          Case #PNB_TYPE_STRING
            String + "["+nList()\s+"] "
          Case #PNB_TYPE_UWORD
            If Binary
              String + "(ForceUWord 0x"+Hex(nList()\u, #PB_Unicode)+") "
            Else
              String + Str(nList()\u)+" "
            EndIf
          Case #PNB_TYPE_WORD
            If Binary
              String + "(ForceWord 0x"+Hex(nList()\w, #PB_Word)+") "
            Else
              String + Str(nList()\w)+" "
            EndIf
        EndSelect
      EndIf
    Next
    If String
      String = Left(String, Len(String)-1)
    EndIf
    
    ProcedureReturn String
  EndProcedure
  
  Procedure.i nListEval(List nList.nList())
    Static NewMap Lexicon.nList()
    Static NewMap Param.nList()
    Static NewMap ParamDefault.nList()
    Static NewMap Memory.nList()
    Static NewMap *PLIST()
    Protected CAR.s
    Protected a.i
    Protected b.i
    Protected RBOL.i
    Protected RCNT.i
    Protected RINT.i
    Protected RFLT.f
    Protected RSTR.s
    
    Protected RTYP.i
    
    Protected RASC.a
    Protected RBYT.b
    Protected RCHR.c
    Protected RDBL.d
    Protected RLNG.l
    Protected RQUD.q
    Protected RWRD.w
    Protected RUNI.u
    Protected *RPTR
    
    Protected *TPTR.nListThread
    
    Protected NewList cList1.nList()
    Protected NewList cList2.nList()
    Protected NewList cList3.nList()
    Protected NewList cList4.nList()
    
    
    
    ;-Preprocess
    If FirstElement(nList())
      If nList()\Flags & #PNB_TYPE_LIST = 0
        If nList()\Flags & #PNB_TYPE_COMMAND
          Select nList()\s
            Case "If" ;--If
              RCNT = 0
              ForEach nList()
                If nList()\Flags & #PNB_TYPE_NAME
                  Select nList()\s
                    Case "If", "ElseIf"
                      Select nList()\s ;Check for first run to ensure language specification
                        Case "If"
                          If RCNT <> 0
                            ClearList(nList())
                            Break
                          EndIf
                          RCNT = 1
                        Case "ElseIf"
                          If RCNT <> 1
                            ClearList(nList())
                            Break
                          EndIf
                      EndSelect
                      DeleteElement(nList()) ;Delete the If/ElseIf
                      If NextElement(nList())
                        ;We compare here.
                        If nList()\Flags & #PNB_TYPE_LIST
                          nListEval(nList()\nList())
                          MergeLists(nList()\nList(), cList1(), #PB_List_After)
                        Else
                          ClearList(nList())
                          Break
                        EndIf
                        DeleteElement(nList())
                        If NextElement(nList()) ;This is Do
                          If nList()\Flags & #PNB_TYPE_NAME
                            If nList()\s = "Do"
                              DeleteElement(nList())
                              If NextElement(nList()) ;This is the expression.
                                RBOL = Bool(ListSize(cList1()))
                                ForEach cList1()
                                  Select nListGetHighestType(cList1()\Flags)
                                    Case #PNB_TYPE_UBYTE
                                      RBOL = Bool(RBOL And Bool(cList1()\a))
                                    Case #PNB_TYPE_BYTE
                                      RBOL = Bool(RBOL And Bool(cList1()\b))
                                    Case #PNB_TYPE_CHARACTER
                                      RBOL = Bool(RBOL And Bool(cList1()\c))
                                    Case #PNB_TYPE_DOUBLE
                                      RBOL = Bool(RBOL And Bool(cList1()\d))
                                    Case #PNB_TYPE_FLOAT
                                      RBOL = Bool(RBOL And Bool(cList1()\f))
                                    Case #PNB_TYPE_INTEGER
                                      RBOL = Bool(RBOL And Bool(cList1()\i))
                                    Case #PNB_TYPE_LONG
                                      RBOL = Bool(RBOL And Bool(cList1()\l))
                                    Case #PNB_TYPE_NAME
                                      RBOL = Bool(RBOL And Bool(cList1()\s = "True"))
                                    Case #PNB_TYPE_EPIC
                                      RBOL = Bool(RBOL And Bool(cList1()\q))
                                    Case #PNB_TYPE_STRING
                                      RBOL = Bool(RBOL And Bool(cList1()\s = "True"))
                                    Case #PNB_TYPE_UWORD
                                      RBOL = Bool(RBOL And Bool(cList1()\u))
                                    Case #PNB_TYPE_WORD
                                      RBOL = Bool(RBOL And Bool(cList1()\w))
                                  EndSelect
                                Next
                                ClearList(cList1())
                                If RBOL
                                  If nList()\Flags & #PNB_TYPE_LIST
                                    nListEval(nList()\nList())
                                    MergeLists(nList()\nList(), nList(), #PB_List_Before)
                                    DeleteElement(nList())
                                  Else
                                    ClearList(nList())
                                    Break
                                  EndIf
                                  While NextElement(nList())
                                    DeleteElement(nList())
                                  Wend
                                Else
                                  DeleteElement(nList())
                                EndIf
                              Else
                                ClearList(nList())
                                Break
                              EndIf
                            Else
                              ClearList(nList())
                              Break
                            EndIf
                          Else
                            ClearList(nList())
                            Break
                          EndIf
                        Else
                          ClearList(nList())
                          Break
                        EndIf
                      Else
                        ClearList(nList())
                        Break
                      EndIf
                    Case "Else"
                      DeleteElement(nList())
                      If NextElement(nList()) ; Do
                        If nList()\Flags & #PNB_TYPE_NAME
                          If nList()\s = "Do"
                            DeleteElement(nList())
                            If NextElement(nList()) ;Expression
                              If nList()\Flags & #PNB_TYPE_LIST
                                nListEval(nList()\nList())
                                MergeLists(nList()\nList(), nList(), #PB_List_Before)
                                DeleteElement(nList())
                              Else
                                ClearList(nList())
                                Break
                              EndIf
                              While NextElement(nList())
                                DeleteElement(nList())
                              Wend
                            Else
                              ClearList(nList())
                              Break
                            EndIf
                          Else
                            ClearList(nList())
                          EndIf
                        Else
                          ClearList(nList())
                          Break
                        EndIf
                      Else
                        ClearList(nList())
                        Break
                      EndIf
                  EndSelect
                Else
                  ClearList(nList())
                  Break
                EndIf
              Next
              
              
            Case "Select" ;--Select
              DeleteElement(nList()) ;Free the Select
              If NextElement(nList())
                If nList()\Flags & #PNB_TYPE_LIST
                  nListEval(nList()\nList())
                  MergeLists(nList()\nList(), cList1(), #PB_List_After)
                Else
                  ClearList(nList())
                EndIf
                DeleteElement(nList())
                ForEach nList()
                  If nList()\Flags & #PNB_TYPE_NAME
                    Select nList()\s
                      Case "Case"
                        DeleteElement(nList())
                        If NextElement(nList()) ;Expression
                          If nList()\Flags & #PNB_TYPE_LIST
                            nListEval(nList()\nList())
                            MergeLists(nList()\nList(), cList2(), #PB_List_After)
                          Else
                            ClearList(nList())
                            ClearList(cList2())
                            Break
                          EndIf
                          DeleteElement(nList())
                          If NextElement(nList()) ; do
                            If nList()\Flags & #PNB_TYPE_NAME
                              If nList()\s = "Do"
                                DeleteElement(nList())
                                If NextElement(nList())
                                  If nListCompare(cList1(), cList2())
                                    If nList()\Flags & #PNB_TYPE_LIST
                                      nListEval(nList()\nList())
                                      MergeLists(nList()\nList(), nList(), #PB_List_Before)
                                      DeleteElement(nList())
                                    Else
                                      ClearList(nList())
                                      ClearList(cList2())
                                      Break
                                    EndIf
                                    While NextElement(nList())
                                      DeleteElement(nList())
                                    Wend
                                  Else
                                    DeleteElement(nList())
                                  EndIf
                                Else
                                  ClearList(nList())
                                  ClearList(cList2())
                                  Break
                                EndIf
                              Else
                                ClearList(nList())
                                ClearList(cList2())
                                Break
                              EndIf
                            Else
                              ClearList(nList())
                              ClearList(cList2())
                              Break
                            EndIf
                          Else
                            ClearList(nList())
                            ClearList(cList2())
                            Break
                          EndIf
                        Else
                          ClearList(nList())
                          ClearList(cList2())
                          Break
                        EndIf
                        ClearList(cList2())
                      Case "Default"
                        DeleteElement(nList())
                        If NextElement(nList())
                          If nList()\Flags & #PNB_TYPE_NAME
                            If nList()\s = "Do"
                              DeleteElement(nList()) ;do
                              If NextElement(nList())
                                If nList()\Flags & #PNB_TYPE_LIST
                                  nListEval(nList()\nList())
                                  MergeLists(nList()\nList(), nList(), #PB_List_Before)
                                  DeleteElement(nList())
                                Else
                                  ClearList(nList())
                                  ClearList(cList2())
                                  Break
                                EndIf
                                While NextElement(nList())
                                  DeleteElement(nList())
                                Wend
                              Else
                                ClearList(nList())
                                Break
                              EndIf
                            Else
                              ClearList(nList())  
                            EndIf
                          Else
                            ClearList(nList())
                          EndIf
                        Else
                          ClearList(nList())
                          Break
                        EndIf
                    EndSelect
                  Else
                    ClearList(nList())
                    Break
                  EndIf
                Next
              Else
                ClearList(nList())
              EndIf
              ClearList(cList1())
              
              
            Case "While" ;--While
              DeleteElement(nList()) ;Free the While
              If NextElement(nList());condition
                If nList()\Flags & #PNB_TYPE_LIST
                  AddElement(cList1())
                  cList1() = nList()
                  DeleteElement(nList())
                  If NextElement(nList()) ;do
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Do"
                        DeleteElement(nList())
                        If NextElement(nList()) ;expression
                          If nList()\Flags & #PNB_TYPE_LIST
                            AddElement(cList2())
                            cList2() = nList()
                            DeleteElement(nList())
                            Repeat
                              AddElement(cList3())
                              cList3() = cList1()
                              If cList3()\Flags & #PNB_TYPE_LIST
                                nListEval(cList3()\nList())
                                MergeLists(cList3()\nList(), cList3(), #PB_List_After)
                                DeleteElement(cList3())
                              EndIf
                              RBOL = Bool(ListSize(cList3()))
                              ForEach cList3()
                                Select nListGetHighestType(cList3()\Flags)
                                  Case #PNB_TYPE_UBYTE
                                    RBOL = Bool(RBOL And Bool(cList3()\a))
                                  Case #PNB_TYPE_BYTE
                                    RBOL = Bool(RBOL And Bool(cList3()\b))
                                  Case #PNB_TYPE_CHARACTER
                                    RBOL = Bool(RBOL And Bool(cList3()\c))
                                  Case #PNB_TYPE_DOUBLE
                                    RBOL = Bool(RBOL And Bool(cList3()\d))
                                  Case #PNB_TYPE_FLOAT
                                    RBOL = Bool(RBOL And Bool(cList3()\f))
                                  Case #PNB_TYPE_INTEGER
                                    RBOL = Bool(RBOL And Bool(cList3()\i))
                                  Case #PNB_TYPE_LONG
                                    RBOL = Bool(RBOL And Bool(cList3()\l))
                                  Case #PNB_TYPE_NAME
                                    RBOL = Bool(RBOL And Bool(cList3()\s = "True"))
                                  Case #PNB_TYPE_EPIC
                                    RBOL = Bool(RBOL And Bool(cList3()\q))
                                  Case #PNB_TYPE_STRING
                                    RBOL = Bool(RBOL And Bool(cList3()\s = "True"))
                                  Case #PNB_TYPE_UWORD
                                    RBOL = Bool(RBOL And Bool(cList3()\u))
                                  Case #PNB_TYPE_WORD
                                    RBOL = Bool(RBOL And Bool(cList3()\w))
                                EndSelect
                              Next
                              ClearList(cList3())
                              AddElement(cList4())
                              cList4() = cList2()
                              If RBOL
                                If cList4()\Flags & #PNB_TYPE_LIST
                                  nListEval(cList4()\nList())
                                  MergeLists(cList4()\nList(), nList(), #PB_List_Before)
                                EndIf
                              Else
                                While NextElement(nList())
                                  DeleteElement(nList())
                                Wend
                                Break
                              EndIf
                              ClearList(cList4())
                            ForEver
                          Else
                            ClearList(nList())
                            ClearList(cList1())
                          EndIf
                        EndIf
                        ClearList(cList1())
                        ClearList(cList2())
                        ClearList(cList3())
                        ClearList(cList4())
                      Else
                        ClearList(nList())
                        ClearList(cList1())
                      EndIf
                    Else
                      ClearList(nList())
                      ClearList(cList1())
                    EndIf
                  Else
                    ClearList(nList())
                    ClearList(cList1())
                  EndIf
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              
              
            Case "Until" ;--Until
              DeleteElement(nList()) ;Free the Until
              If NextElement(nList());condition
                If nList()\Flags & #PNB_TYPE_LIST
                  AddElement(cList1())
                  cList1() = nList()
                  DeleteElement(nList())
                  If NextElement(nList())
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Do"
                        DeleteElement(nList())
                        If NextElement(nList()) ;expression
                          If nList()\Flags & #PNB_TYPE_LIST
                            AddElement(cList2())
                            cList2() = nList()
                            DeleteElement(nList())
                            Repeat
                              AddElement(cList4())
                              cList4() = cList2()
                              nListEval(cList4()\nList())
                              MergeLists(cList4()\nList(), nList(), #PB_List_Before)
                              AddElement(cList3())
                              cList3() = cList1()
                              nListEval(cList3()\nList())
                              MergeLists(cList3()\nList(), cList3(), #PB_List_After)
                              DeleteElement(cList3())
                              RBOL = Bool(ListSize(cList3()))
                              ForEach cList3()
                                Select nListGetHighestType(cList3()\Flags)
                                  Case #PNB_TYPE_UBYTE
                                    RBOL = Bool(RBOL And Bool(cList3()\a))
                                  Case #PNB_TYPE_BYTE
                                    RBOL = Bool(RBOL And Bool(cList3()\b))
                                  Case #PNB_TYPE_CHARACTER
                                    RBOL = Bool(RBOL And Bool(cList3()\c))
                                  Case #PNB_TYPE_DOUBLE
                                    RBOL = Bool(RBOL And Bool(cList3()\d))
                                  Case #PNB_TYPE_FLOAT
                                    RBOL = Bool(RBOL And Bool(cList3()\f))
                                  Case #PNB_TYPE_INTEGER
                                    RBOL = Bool(RBOL And Bool(cList3()\i))
                                  Case #PNB_TYPE_LONG
                                    RBOL = Bool(RBOL And Bool(cList3()\l))
                                  Case #PNB_TYPE_NAME
                                    RBOL = Bool(RBOL And Bool(cList3()\s = "True"))
                                  Case #PNB_TYPE_EPIC
                                    RBOL = Bool(RBOL And Bool(cList3()\q))
                                  Case #PNB_TYPE_STRING
                                    RBOL = Bool(RBOL And Bool(cList3()\s = "True"))
                                  Case #PNB_TYPE_UWORD
                                    RBOL = Bool(RBOL And Bool(cList3()\u))
                                  Case #PNB_TYPE_WORD
                                    RBOL = Bool(RBOL And Bool(cList3()\w))
                                EndSelect
                              Next
                              ClearList(cList3())
                              If RBOL
                                While NextElement(nList())
                                  DeleteElement(nList())
                                Wend
                                Break
                              EndIf
                            ForEver
                            ClearList(cList1())
                            ClearList(cList2())
                            ClearList(cList3())
                            ClearList(cList4())
                          Else
                            ClearList(nList())
                            ClearList(cList1())
                          EndIf
                        Else
                          ClearList(nList())
                          ClearList(cList1())
                        EndIf
                      Else
                        ClearList(nList())
                        ClearList(cList1())
                      EndIf
                    Else
                      ClearList(nList())
                      ClearList(cList1())
                    EndIf
                  Else
                    ClearList(nList())
                    ClearList(cList1())
                  EndIf
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              
              
            Case "For" ;--For
              DeleteElement(nList()) ;Free the For
              If NextElement(nList());count
                If nList()\Flags & #PNB_TYPE_LIST
                  nListEval(nList()\nList())
                  MergeLists(nList()\nList(), cList1(), #PB_List_After)
                  DeleteElement(nList())
                  RINT = 0
                  ForEach cList1()
                    Select nListGetHighestType(cList1()\Flags)
                      Case #PNB_TYPE_UBYTE
                        RINT = RINT + cList1()\a
                      Case #PNB_TYPE_BYTE
                        RINT = RINT + cList1()\b
                      Case #PNB_TYPE_CHARACTER
                        RINT = RINT + cList1()\c
                      Case #PNB_TYPE_DOUBLE
                        RINT = RINT + cList1()\d
                      Case #PNB_TYPE_FLOAT
                        RINT = RINT + cList1()\f
                      Case #PNB_TYPE_INTEGER
                        RINT = RINT + cList1()\i
                      Case #PNB_TYPE_LONG
                        RINT = RINT + cList1()\l
                      Case #PNB_TYPE_EPIC
                        RINT = RINT + cList1()\q
                      Case #PNB_TYPE_UWORD
                        RINT = RINT + cList1()\u
                      Case #PNB_TYPE_WORD
                        RINT = RINT + cList1()\w
                    EndSelect
                  Next
                  ClearList(cList1())
                  If NextElement(nList()) ;do
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Do"
                        DeleteElement(nList())
                        If NextElement(nList()) ;expression
                          If nList()\Flags & #PNB_TYPE_LIST
                            AddElement(cList2()) 
                            cList2() = nList()
                            DeleteElement(nList())
                            If RINT > 0
                              For RCNT = 1 To RINT
                                AddElement(cList3())
                                cList3() = cList2()
                                nListEval(cList3()\nList())
                                MergeLists(cList3()\nList(), nList(), #PB_List_Before)
                                ClearList(cList3())
                              Next
                            EndIf
                            ClearList(cList1())
                            ClearList(cList2())
                            ClearList(cList3())
                          Else
                            ClearList(nList())
                            ClearList(cList1())
                          EndIf
                        Else
                          ClearList(nList())
                          ClearList(cList1())
                        EndIf
                      Else
                        ClearList(nList())
                        ClearList(cList1())
                      EndIf
                    Else
                      ClearList(nList())
                      ClearList(cList1())
                    EndIf
                  Else
                    ClearList(nList())
                    ClearList(cList1())
                  EndIf
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              
            Case "Function" ;--Function
              DeleteElement(nList()) ;Free the Function
              
              If NextElement(nList())
                If nList()\Flags & #PNB_TYPE_LIST
                  AddElement(cList1()) ;names, aliases
                  cList1() = nList()
                  DeleteElement(nList())
                  If NextElement(nList());do
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Do"
                        DeleteElement(nList())
                        If NextElement(nList())
                          If nList()\Flags & #PNB_TYPE_LIST
                            AddElement(cList2()) ;core function
                            cList2() = nList()
                            DeleteElement(nList())
                            If NextElement(nList())
                              If nList()\Flags & #PNB_TYPE_NAME
                                If nList()\s = "With"
                                  DeleteElement(nList())
                                  If NextElement(nList())
                                    If nList()\Flags & #PNB_TYPE_LIST
                                      AddElement(cList3()) ;core function
                                      cList3() = nList()
                                      DeleteElement(nList())
                                      If NextElement(nList())
                                        If nList()\Flags & #PNB_TYPE_NAME
                                          If nList()\s = "As"
                                            DeleteElement(nList())
                                            If NextElement(nList())
                                              If nList()\Flags & #PNB_TYPE_LIST
                                                AddElement(cList4()) ;default params
                                                cList4() = nList()
                                                DeleteElement(nList())
                                              Else
                                                ClearList(nList())
                                                ClearList(cList1())
                                                ClearList(cList2())
                                                ClearList(cList3())
                                              EndIf
                                            Else
                                              ClearList(nList())
                                              ClearList(cList1())
                                              ClearList(cList2())
                                              ClearList(cList3())
                                            EndIf
                                          Else
                                            ClearList(nList())
                                            ClearList(cList1())
                                            ClearList(cList2())
                                            ClearList(cList3())
                                          EndIf
                                        Else
                                          ClearList(nList())
                                          ClearList(cList1())
                                          ClearList(cList2())
                                          ClearList(cList3())
                                        EndIf
                                      EndIf
                                      ClearList(nList())
                                    Else
                                      ClearList(nList())
                                      ClearList(cList1())
                                      ClearList(cList2())
                                    EndIf
                                  Else
                                    ClearList(nList())
                                    ClearList(cList1())
                                    ClearList(cList2())
                                  EndIf
                                Else
                                  ClearList(nList())
                                  ClearList(cList1())
                                  ClearList(cList2())
                                EndIf
                              Else
                                ClearList(nList())
                                ClearList(cList1())
                                ClearList(cList2())
                              EndIf
                            EndIf
                            
                            ForEach cList1()\nList()
                              If cList1()\nList()\Flags & #PNB_TYPE_NAME
                                If cList1()\nList()\s = "All"
                                  If FirstElement(cList2()\nList())
                                    If cList2()\nList()\Flags & #PNB_TYPE_NAME
                                      If cList2()\nList()\s = "Clear"
                                        CompilerIf #PB_Compiler_Thread = 1
                                          LockMutex(MutexFunMap)
                                        CompilerEndIf
                                        ClearMap(Lexicon())
                                        ClearMap(Param())
                                        ClearMap(ParamDefault())
                                        CompilerIf #PB_Compiler_Thread = 1
                                          UnlockMutex(MutexFunMap)
                                        CompilerEndIf
                                        Break
                                      Else
                                        Break
                                      EndIf
                                    Else
                                      Break
                                    EndIf
                                  Else
                                    Break
                                  EndIf
                                Else ;normal function declaration
                                  CompilerIf #PB_Compiler_Thread = 1
                                    LockMutex(MutexFunMap)
                                  CompilerEndIf
                                  AddMapElement(Lexicon(), cList1()\nList()\s)
                                  AddMapElement(Param(), cList1()\nList()\s)
                                  AddMapElement(ParamDefault(), cList1()\nList()\s)
                                  If FirstElement(cList2()\nList())
                                    If cList2()\nList()\Flags & #PNB_TYPE_NAME
                                      If cList2()\nList()\s = "Clear"
                                        DeleteMapElement(Lexicon())
                                        DeleteMapElement(Param())
                                        DeleteMapElement(ParamDefault())
                                      Else
                                        If ListSize(cList4())
                                          If ListSize(cList3()\nList()) = ListSize(cList4()\nList())
                                            Lexicon() = cList2()
                                            Param() = cList3()
                                            ParamDefault() = cList4()
                                          Else
                                            DeleteMapElement(Lexicon())
                                            DeleteMapElement(Param())
                                            DeleteMapElement(ParamDefault())
                                            Break
                                          EndIf
                                        Else
                                          Lexicon() = cList2()
                                          If ListSize(cList3())
                                            Param() = cList3()
                                          EndIf
                                        EndIf
                                      EndIf
                                    Else
                                      If ListSize(cList4())
                                        If ListSize(cList3()\nList()) = ListSize(cList4()\nList())
                                          Lexicon() = cList2()
                                          Param() = cList3()
                                          ParamDefault() = cList4()
                                        Else
                                          DeleteMapElement(Lexicon())
                                          DeleteMapElement(Param())
                                          DeleteMapElement(ParamDefault())
                                          Break
                                        EndIf
                                      Else
                                        Lexicon() = cList2()
                                        If ListSize(cList3())
                                          Param() = cList3()
                                        EndIf
                                      EndIf
                                    EndIf
                                  Else
                                    DeleteMapElement(Lexicon())
                                    DeleteMapElement(Param())
                                    DeleteMapElement(ParamDefault())
                                  EndIf
                                  CompilerIf #PB_Compiler_Thread = 1
                                    UnlockMutex(MutexFunMap)
                                  CompilerEndIf
                                EndIf
                              EndIf
                            Next
                            ClearList(nList())
                            ClearList(cList1())
                            ClearList(cList2())
                            ClearList(cList3())
                            ClearList(cList4())
                          Else
                            ClearList(nList())
                            ClearList(cList1())
                          EndIf
                        Else
                          ClearList(nList())
                          ClearList(cList1())
                        EndIf
                      Else
                        ClearList(nList())
                        ClearList(cList1())
                      EndIf
                    Else
                      ClearList(nList())
                      ClearList(cList1())
                    EndIf
                  Else
                    ClearList(nList())
                    ClearList(cList1())
                  EndIf
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              
              
            Case "List" ;--List
              DeleteElement(nList())
              ProcedureReturn
              
              
            Case "Fork";--Fork
              DeleteElement(nList())
              ForEach nList()
                If nList()\Flags & #PNB_TYPE_LIST
                *TPTR = AllocateStructure(nListThread)
                CopyList(nList()\nList(), *TPTR\nList())
                  CreateThread(@nListEvalThreadFork(), *TPTR)
                  DeleteElement(nList())
                Else
                  DeleteElement(nList())
                EndIf
              Next
              ProcedureReturn
              
            Case "Fetch";--Fetch
              DeleteElement(nList())
              ForEach nList()
                If nList()\Flags & #PNB_TYPE_LIST
                  AddElement(cList1())
                  cList1()\p = CreateThread(@nListEvalThread(), @nList())
                Else
                  DeleteElement(nList())
                EndIf
              Next
              ForEach cList1()
                WaitThread(cList1()\p)
                DeleteElement(cList1())
              Next
              ForEach nList()
                If ListSize(nList()\nList()) = 0
                  DeleteElement(nList())
                EndIf
              Next
              ProcedureReturn
              
            Case "Command"
              DeleteElement(nList())
              If NextElement(nList()) 
                If nList()\Flags & #PNB_TYPE_LIST
                  nListEval(nList()\nList())
                  MergeLists(nList()\nList(), nList(), #PB_List_After)
                  DeleteElement(nList())
                  If NextElement(nList())
                    nList()\Flags = #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
                  EndIf
                Else
                  nList()\Flags = #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
                EndIf
              EndIf
          EndSelect
        EndIf
      EndIf
    EndIf
    
    
    ;-List split
    ForEach nList()
      If nList()\Flags & #PNB_TYPE_LIST
        If ListSize(nList()\nList())
          nListEval(nList()\nList())
          MergeLists(nList()\nList(), nList(), #PB_List_After)
          DeleteElement(nList())
        Else
          DeleteElement(nList())
        EndIf
      EndIf
    Next
    
    ;-Command eval
    RCNT = 0
    RBOL = 0
    RINT = 0
    RFLT = 0.0
    RSTR = ""
    
    RTYP = 0
    
    RASC = 0
    RBYT = 0
    RCHR = 0
    RDBL = 0.0
    RLNG = 0
    RQUD = 0
    RWRD = 0
    RUNI = 0
    *RPTR = 0
    If FirstElement(nList())
      
      If nList()\Flags & #PNB_TYPE_COMMAND
        CAR = nList()\s
        Select CAR
            ;-Basic Set
            ;-#Basic
            ;---Eval
          Case "Eval"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_STRING
                  nListPNBTonList(cList1(), nList()\s)
                  DeleteElement(nList())
                  nListEval(cList1())
                  MergeLists(cList1(), cList2())
                  ClearList(cList1())
                Default
                  DeleteElement(nList())
              EndSelect
            Next
            ClearList(nList())
            MergeLists(cList2(), nList())
            ClearList(cList2())
            
            ;---Wait
          Case "Wait"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_UBYTE
                  Delay(nList()\a)
                Case #PNB_TYPE_BYTE
                  Delay(nList()\b)
                Case #PNB_TYPE_CHARACTER
                  Delay(nList()\c)
                Case #PNB_TYPE_DOUBLE
                  Delay(nList()\d)
                Case #PNB_TYPE_FLOAT
                  Delay(nList()\f)
                Case #PNB_TYPE_INTEGER
                  Delay(nList()\i)
                Case #PNB_TYPE_LONG
                  Delay(nList()\l)
                Case #PNB_TYPE_EPIC
                  Delay(nList()\q)
                Case #PNB_TYPE_UWORD
                  Delay(nList()\u)
                Case #PNB_TYPE_WORD
                  Delay(nList()\w)
              EndSelect
              DeleteElement(nList())
            Next
            
            ;---Output
          Case "Output"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_UBYTE
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\a)+#CRLF$, Len(Str(nList()\a)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_BYTE
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\b)+#CRLF$, Len(Str(nList()\b)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_CHARACTER
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\c)+#CRLF$, Len(Str(nList()\c)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_DOUBLE
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), StrD(nList()\d, 19)+#CRLF$, Len(StrD(nList()\d, 19)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_FLOAT
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), StrF(nList()\f, 14)+#CRLF$, Len(StrF(nList()\f, 14)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_INTEGER
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\i)+#CRLF$, Len(Str(nList()\i)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_LONG
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\l)+#CRLF$, Len(Str(nList()\l)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_NAME
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), nList()\s+#CRLF$, Len(nList()\s+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_POINTER
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\p)+#CRLF$, Len(Str(nList()\p)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_EPIC
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\q)+#CRLF$, Len(Str(nList()\q)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_STRING
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), nList()\s+#CRLF$, Len(nList()\s+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_UWORD
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\u)+#CRLF$, Len(Str(nList()\u)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_WORD
                  If GetStdHandle_(#STD_OUTPUT_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\w)+#CRLF$, Len(Str(nList()\w)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
              EndSelect
              DeleteElement(nList())
            Next
            
            ;---Error
          Case "Error"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_UBYTE
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\a)+#CRLF$, Len(Str(nList()\a)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_BYTE
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\b)+#CRLF$, Len(Str(nList()\b)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_CHARACTER
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\c)+#CRLF$, Len(Str(nList()\c)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_DOUBLE
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), StrD(nList()\d, 19)+#CRLF$, Len(StrD(nList()\d, 19)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_FLOAT
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), StrF(nList()\f, 14)+#CRLF$, Len(StrF(nList()\f, 14)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_INTEGER
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\i)+#CRLF$, Len(Str(nList()\i)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_LONG
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\l)+#CRLF$, Len(Str(nList()\l)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_NAME
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), nList()\s+#CRLF$, Len(nList()\s+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_POINTER
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\p)+#CRLF$, Len(Str(nList()\p)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_EPIC
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\q)+#CRLF$, Len(Str(nList()\q)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_STRING
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), nList()\s+#CRLF$, Len(nList()\s+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_UWORD
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\u)+#CRLF$, Len(Str(nList()\u)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
                Case #PNB_TYPE_WORD
                  If GetStdHandle_(#STD_ERROR_HANDLE)
                    WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\w)+#CRLF$, Len(Str(nList()\w)+#CRLF$), @RINT, 0)
                    RINT = 0
                  EndIf
              EndSelect
              DeleteElement(nList())
            Next
            
            ;---Debug
          Case "Debug"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_UBYTE
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\a
                  CompilerEndIf
                Case #PNB_TYPE_BYTE
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\b
                  CompilerEndIf
                Case #PNB_TYPE_CHARACTER
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\c
                  CompilerEndIf
                Case #PNB_TYPE_DOUBLE
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\d
                  CompilerEndIf
                Case #PNB_TYPE_FLOAT
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\f
                  CompilerEndIf
                Case #PNB_TYPE_INTEGER
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\i
                  CompilerEndIf
                Case #PNB_TYPE_LONG
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\l
                  CompilerEndIf
                Case #PNB_TYPE_NAME
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\s
                  CompilerEndIf
                Case #PNB_TYPE_POINTER
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\p
                  CompilerEndIf
                Case #PNB_TYPE_EPIC
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\q
                  CompilerEndIf
                Case #PNB_TYPE_STRING
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\s
                  CompilerEndIf
                Case #PNB_TYPE_UWORD
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\u
                  CompilerEndIf
                Case #PNB_TYPE_WORD
                  CompilerIf #PB_Compiler_Debugger
                    Debug nList()\w
                  CompilerEndIf
              EndSelect
              DeleteElement(nList())
            Next
            
            ;-#List Manipilation
            ;---Fork
            ;Case "Fork" is already implemented in a different format in the preprocessing stage.
            ;---Fetch
            ;Case "Fetch" is already implemented in a different format in the preprocessing stage.
            ;---Command
            ;Case "Command" is already implemented in a different format in the preprocessing stage.
            ;---List
            ;Case "List" is already implemented in a different format in the preprocessing stage.
            ;---Element
          Case "Element"
            DeleteElement(nList())
            If NextElement(nList())
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_UBYTE
                  RBOL = 1
                  RINT = nList()\a
                Case #PNB_TYPE_BYTE
                  RBOL = 1
                  RINT = nList()\b
                Case #PNB_TYPE_CHARACTER
                  RBOL = 1
                  RINT = nList()\c
                Case #PNB_TYPE_DOUBLE
                  RBOL = 1
                  RINT = nList()\d
                Case #PNB_TYPE_FLOAT
                  RBOL = 1
                  RINT = nList()\f
                Case #PNB_TYPE_INTEGER
                  RBOL = 1
                  RINT = nList()\i
                Case #PNB_TYPE_LONG
                  RBOL = 1
                  RINT = nList()\l
                Case #PNB_TYPE_EPIC
                  RBOL = 1
                  RINT = nList()\q
                Case #PNB_TYPE_UWORD
                  RBOL = 1
                  RINT = nList()\u
                Case #PNB_TYPE_WORD
                  RBOL = 1
                  RINT = nList()\w
              EndSelect
              DeleteElement(nList())
              If RBOL
                If SelectElement(nList(), RINT)
                  AddElement(cList1())
                  cList1() = nList()
                  ClearList(nList())
                  MergeLists(cList1(), nList())
                  ClearList(cList1())
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              RBOL = 0
              RINT = 0
            Else
              ClearList(nList())
            EndIf
            
            ;---Discard
          Case "Discard"
            ClearList(nList())
            
            ;---Invert
          Case "Invert"
            DeleteElement(nList())
            ForEach nList()
              InsertElement(cList1())
              cList1() = nList()
            Next
            ClearList(nList())
            MergeLists(cList1(), nList())
            
            ;---Size
          Case "Size"
            DeleteElement(nList())
            RINT = ListSize(nList())
            ClearList(nList())
            AddElement(nList())
            nList()\i = RINT
            nList()\Flags | #PNB_TYPE_INTEGER
            RINT = 0
            
            ;---Offset
          Case "Offset"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_POINTER
                  
                Case #PNB_TYPE_STRING
                  RINT+StringByteLength(nList()\s)
                Case #PNB_TYPE_NAME
                  Select nList()\s
                    Case "Double"
                      RINT+SizeOf(Double)
                    Case "Float"
                      RINT+SizeOf(Float)
                    Case "Epic"
                      RINT+SizeOf(Quad)
                    Case "Integer"
                      RINT+SizeOf(Integer)
                    Case "Long"
                      RINT+SizeOf(Long)
                    Case "Word"
                      RINT+SizeOf(Word)
                    Case "Byte"
                      RINT+SizeOf(Byte)
                    Case "UWord"
                      RINT+SizeOf(Unicode)
                    Case "Character"
                      RINT+SizeOf(Character)
                    Case "UByte"
                      RINT+SizeOf(Ascii)
                  EndSelect
              EndSelect
              DeleteElement(nList())
            Next
            AddElement(nList())
            nList()\i = RINT
            nList()\Flags | #PNB_TYPE_INTEGER
            RINT = 0
            
            
            ;-#Type manipulation
            ;---Split
          Case "Split"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  If Len(nList()\s)
                    For RCNT = 1 To Len(nList()\s)
                      AddElement(cList1())
                      cList1()\c = Asc(Mid(nList()\s, RCNT))
                      cList1()\Flags | #PNB_TYPE_CHARACTER
                    Next
                  EndIf
                  DeleteElement(nList())
                Case #PNB_TYPE_STRING
                  If Len(nList()\s)
                    For RCNT = 1 To Len(nList()\s)
                      AddElement(cList1())
                      cList1()\c = Asc(Mid(nList()\s, RCNT))
                      cList1()\Flags | #PNB_TYPE_CHARACTER
                    Next
                  EndIf
                  DeleteElement(nList())
                Default
                  DeleteElement(nList())
              EndSelect
            Next
            MergeLists(cList1(), nList())
            RCNT = 0
            
            ;---Fuse
          Case "Fuse"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_CHARACTER)
            ForEach nList()
              RSTR+Chr(nList()\c)
              DeleteElement(nList())
            Next
            AddElement(nList())
            nList()\s = RSTR
            nList()\Flags | #PNB_TYPE_STRING
            RSTR = ""
            
            ;---Type
          Case "Type"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_LIST
                  RSTR = "List"
                Case #PNB_TYPE_UBYTE
                  RSTR = "UByte"
                Case #PNB_TYPE_BYTE
                  RSTR = "Byte"
                Case #PNB_TYPE_CHARACTER
                  RSTR = "Character"
                Case #PNB_TYPE_DOUBLE
                  RSTR = "Double"
                Case #PNB_TYPE_FLOAT
                  RSTR = "Float"
                Case #PNB_TYPE_INTEGER
                  RSTR = "Integer"
                Case #PNB_TYPE_LONG
                  RSTR = "Long"
                Case #PNB_TYPE_NAME
                  RSTR = "Name"
                Case #PNB_TYPE_POINTER
                  RSTR = "Pointer"
                Case #PNB_TYPE_EPIC
                  RSTR = "Epic"
                Case #PNB_TYPE_STRING
                  RSTR = "String"
                Case #PNB_TYPE_UWORD
                  RSTR = "UWord"
                Case #PNB_TYPE_WORD
                  RSTR = "Word"
              EndSelect
              DeleteElement(nList())
              AddElement(nList())
              nList()\s = RSTR
              nList()\Flags | #PNB_TYPE_NAME
            Next
            RSTR = ""
            
            ;---Name
          Case "Name"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_NAME, 1)
            
            
            ;---String
          Case "String"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_STRING, 1)
            
            
            ;---Pointer
          Case "Pointer"
            DeleteElement(nList())
            ForEach nList()
              CompilerIf #PB_Compiler_Thread = 1
                LockMutex(MutexMemMap)
              CompilerEndIf
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  *RPTR = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
                  PokeS(*RPTR, nList()\s)
                  nList()\s = ""
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_STRING
                  *RPTR = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
                  PokeS(*RPTR, nList()\s)
                  nList()\s = ""
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_DOUBLE
                  *RPTR = AllocateMemory(SizeOf(Double))
                  PokeD(*RPTR, nList()\d)
                  nList()\d = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_FLOAT
                  *RPTR = AllocateMemory(SizeOf(Float))
                  PokeF(*RPTR, nList()\f)
                  nList()\f = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_EPIC
                  *RPTR = AllocateMemory(SizeOf(Quad))
                  PokeQ(*RPTR, nList()\q)
                  nList()\q = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_INTEGER
                  *RPTR = AllocateMemory(SizeOf(Integer))
                  PokeI(*RPTR, nList()\i)
                  nList()\i = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_LONG
                  *RPTR = AllocateMemory(SizeOf(Long))
                  PokeL(*RPTR, nList()\l)
                  nList()\l = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_WORD
                  *RPTR = AllocateMemory(SizeOf(Word))
                  PokeW(*RPTR, nList()\w)
                  nList()\w = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_BYTE
                  *RPTR = AllocateMemory(SizeOf(Byte))
                  PokeB(*RPTR, nList()\b)
                  nList()\b = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_UWORD
                  *RPTR = AllocateMemory(SizeOf(Unicode))
                  PokeU(*RPTR, nList()\u)
                  nList()\u = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_CHARACTER
                  *RPTR = AllocateMemory(SizeOf(Character))
                  PokeC(*RPTR, nList()\c)
                  nList()\c = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
                Case #PNB_TYPE_UBYTE
                  *RPTR = AllocateMemory(SizeOf(Ascii))
                  PokeA(*RPTR, nList()\a)
                  nList()\a = 0
                  nList()\p = *RPTR
                  If Not FindMapElement(*PLIST(), Str(*RPTR))
                    AddMapElement(*PLIST(), Str(*RPTR))
                  Else
                    FreeMemory(*PLIST())
                    AddMapElement(*PLIST(), Str(*RPTR))
                  EndIf
                  *PLIST() = *RPTR
                  *RPTR = 0
                  nList()\Flags = #PNB_TYPE_POINTER
              EndSelect
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexMemMap)
              CompilerEndIf
            Next
            
            
            ;---Double
          Case "Double"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_DOUBLE, 1)
            
            
            ;---Float
          Case "Float"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_FLOAT, 1)
            
            
            ;---Epic
          Case "Epic"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_EPIC, 1)
            
            
            ;---Integer
          Case "Integer"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_INTEGER, 1)
            
            
            ;---Long
          Case "Long"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_LONG, 1)
            
            
            ;---Word
          Case "Word"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_WORD, 1)
            
            
            ;---Byte
          Case "Byte"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_BYTE, 1)
            
            
            ;---UWord
          Case "UWord"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_UWORD, 1)
            
            
            ;---Character
          Case "Character"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_CHARACTER, 1)
            
            
            ;---UByte
          Case "UByte"
            DeleteElement(nList())
            nListConvert(nList(), #PNB_TYPE_UBYTE, 1)
            
            
            ;---ForceName
          Case "ForceName"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_NAME
              nList()\q = 0
            Next
            
            
            ;---ForceString
          Case "ForceString"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_STRING
              nList()\q = 0
            Next
            
            
            ;---ForcePointer
          Case "ForcePointer"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_POINTER
              *RPTR = nList()\p
              nList()\q = 0
              nList()\p = *RPTR
              *RPTR = 0
            Next
            
            
            ;---ForceDouble
          Case "ForceDouble"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_DOUBLE
              RDBL = nList()\d
              nList()\q = 0
              nList()\d = RDBL
              RDBL = 0.0
            Next
            
            
            ;---ForceFloat
          Case "ForceFloat"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_FLOAT
              RFLT = nList()\f
              nList()\q = 0
              nList()\f = RFLT
              RFLT = 0.0
            Next
            
            
            ;---ForceEpic
          Case "ForceEpic"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_EPIC
            Next
            
            
            ;---ForceInteger
          Case "ForceInteger"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_INTEGER
              RINT = nList()\i
              nList()\q = 0
              nList()\i = RINT
              RINT = 0
            Next
            
            
            ;---ForceLong
          Case "ForceLong"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_LONG
              RLNG = nList()\l
              nList()\q = 0
              nList()\l = RLNG
              RLNG = 0
            Next
            
            
            ;---ForceWord
          Case "ForceWord"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_WORD
              RWRD = nList()\w
              nList()\q = 0
              nList()\w = RWRD
              RWRD = 0
            Next
            
            
            ;---ForceByte
          Case "ForceByte"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_BYTE
              RBYT = nList()\b
              nList()\q = 0
              nList()\b = RBYT
              RBYT = 0
            Next
            
            
            ;---ForceUWord
          Case "ForceUWord"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_UWORD
              RUNI = nList()\u
              nList()\q = 0
              nList()\u = RUNI
              RUNI = 0
            Next
            
            
            ;---ForceCharacter
          Case "ForceCharacter"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_CHARACTER
              RCHR = nList()\c
              nList()\q = 0
              nList()\c = RCHR
              RCHR = 0
            Next
            
            
            ;---ForceUByte
          Case "ForceUByte"
            DeleteElement(nList())
            ForEach nList()
              nList()\Flags = #PNB_TYPE_UBYTE
              RASC = nList()\a
              nList()\q = 0
              nList()\a = RASC
              RASC = 0
            Next
            
            
            ;-#Variables
            ;---Set
          Case "Set"
            DeleteElement(nList())
            If NextElement(nList())
              If nList()\Flags & #PNB_TYPE_NAME
                RSTR = nList()\s
                DeleteElement(nList())
                If RSTR = "All"
                  If NextElement(nList())
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Clear"
                        CompilerIf #PB_Compiler_Thread = 1
                          LockMutex(MutexVarMap)
                        CompilerEndIf
                        ClearMap(Memory())
                        ClearList(nList())
                        CompilerIf #PB_Compiler_Thread = 1
                          UnlockMutex(MutexVarMap)
                        CompilerEndIf
                      EndIf
                    EndIf
                  Else
                    CompilerIf #PB_Compiler_Thread = 1
                      LockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearMap(Memory())
                    ClearList(nList())
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                  EndIf
                Else
                  CompilerIf #PB_Compiler_Thread = 1
                    LockMutex(MutexVarMap)
                  CompilerEndIf
                  AddMapElement(Memory(), RSTR)
                  If ListSize(nList())
                    ForEach nList()
                      AddElement(Memory()\nList())
                      Memory()\nList() = nList()
                      DeleteElement(nList())
                    Next
                    
                  Else
                    DeleteMapElement(Memory(), RSTR)
                    ClearList(nList())
                  EndIf
                  CompilerIf #PB_Compiler_Thread = 1
                    UnlockMutex(MutexVarMap)
                  CompilerEndIf
                EndIf
              Else
                ClearList(nList())
              EndIf
            Else
              ClearList(nList())
            EndIf
            RSTR = ""
            
            
            ;---Get
          Case "Get"
            DeleteElement(nList())
            ForEach nList()
              If nList()\Flags & #PNB_TYPE_NAME
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexVarMap)
                CompilerEndIf
                If FindMapElement(Memory(), nList()\s)
                  CopyList(Memory()\nList(), cList1())
                  MergeLists(cList1(), cList2())
                Else
                  ResetMap(Memory())
                EndIf
                DeleteElement(nList())
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
              Else
                ClearList(nList())
              EndIf
            Next
            MergeLists(cList2(), nList())
            
            ;---Take
          Case "Take"
            DeleteElement(nList())
            ForEach nList()
              If nList()\Flags & #PNB_TYPE_NAME
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexVarMap)
                CompilerEndIf
                If FindMapElement(Memory(), nList()\s)
                  MergeLists(Memory()\nList(), cList1())
                  DeleteMapElement(Memory())
                Else
                  ResetMap(Memory())
                EndIf
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                DeleteElement(nList())
              EndIf
            Next
            MergeLists(cList1(), nList())
            
            ;---Remove
          Case "Remove"
            DeleteElement(nList())
            ForEach nList()
              If nList()\Flags & #PNB_TYPE_NAME
                If nList()\s = "All"
                  CompilerIf #PB_Compiler_Thread = 1
                    LockMutex(MutexVarMap)
                  CompilerEndIf
                  ClearMap(Memory())
                  ClearList(nList())
                  CompilerIf #PB_Compiler_Thread = 1
                    UnlockMutex(MutexVarMap)
                  CompilerEndIf
                Else
                  CompilerIf #PB_Compiler_Thread = 1
                    LockMutex(MutexVarMap)
                  CompilerEndIf
                  If FindMapElement(Memory(), nList()\s)
                    DeleteMapElement(Memory())
                  Else
                    ResetMap(Memory())
                  EndIf
                  CompilerIf #PB_Compiler_Thread = 1
                    UnlockMutex(MutexVarMap)
                  CompilerEndIf
                EndIf
                DeleteElement(nList())
              EndIf
            Next
            
            ;---Cycle
          Case "Cycle"
            DeleteElement(nList())
            ForEach nList()
              CompilerIf #PB_Compiler_Thread = 1
                LockMutex(MutexVarMap)
              CompilerEndIf
              If nList()\Flags & #PNB_TYPE_NAME
                If FindMapElement(Memory(), nList()\s)
                  If FirstElement(Memory()\nList())
                    AddElement(cList1())
                    cList1() = Memory()\nList()
                    MoveElement(Memory()\nList(), #PB_List_Last)
                  EndIf
                Else
                  ResetMap(Memory())
                EndIf
              Else
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(nList())
                ClearList(cList1())
                Break
              EndIf
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
              DeleteElement(nList())
            Next
            MergeLists(cList1(), nList())
            
            ;---Bury
          Case "Bury"
            DeleteElement(nList())
            If NextElement(nList())
              If nList()\Flags & #PNB_TYPE_NAME
                AddElement(cList1())
                cList1() = nList()
                DeleteElement(nList())
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexVarMap)
                CompilerEndIf
                If Not FindMapElement(Memory(), cList1()\s)
                  AddMapElement(Memory(), cList1()\s)
                EndIf
                MergeLists(nList(), Memory()\nList())
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(cList1())
              Else
                ClearList(nList())
              EndIf
            Else
              ClearList(nList())
            EndIf
            
            
            ;---Dig
          Case "Dig"
            DeleteElement(nList())
            ForEach nList()
              CompilerIf #PB_Compiler_Thread = 1
                LockMutex(MutexVarMap)
              CompilerEndIf
              If nList()\Flags & #PNB_TYPE_NAME
                If FindMapElement(Memory(), nList()\s)
                  If LastElement(Memory()\nList())
                    AddElement(cList1())
                    cList1() = Memory()\nList()
                    DeleteElement(Memory()\nList())
                    If Not ListSize(Memory()\nList())
                      DeleteMapElement(Memory())
                    EndIf
                  EndIf
                Else
                  ResetMap(Memory())
                EndIf
              Else
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(nList())
                ClearList(cList1())
                Break
              EndIf
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
              DeleteElement(nList())
            Next
            MergeLists(cList1(), nList())
            
            ;---Detect
          Case "Detect"
            DeleteElement(nList())
            ForEach nList()
              CompilerIf #PB_Compiler_Thread = 1
                LockMutex(MutexVarMap)
              CompilerEndIf
              If nList()\Flags & #PNB_TYPE_NAME
                If FindMapElement(Memory(), nList()\s)
                  If LastElement(Memory()\nList())
                    AddElement(cList1())
                    cList1() = Memory()\nList()
                  EndIf
                Else
                  ResetMap(Memory())
                EndIf
              Else
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(nList())
                ClearList(cList1())
                Break
              EndIf
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
              DeleteElement(nList())
            Next
            MergeLists(cList1(), nList())
            
            
            ;---Push
          Case "Push"
            DeleteElement(nList())
            If NextElement(nList())
              If nList()\Flags & #PNB_TYPE_NAME
                AddElement(cList1())
                cList1() = nList()
                DeleteElement(nList())
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexVarMap)
                CompilerEndIf
                If Not FindMapElement(Memory(), cList1()\s)
                  AddMapElement(Memory(), cList1()\s)
                EndIf
                MergeLists(nList(), Memory()\nList(), #PB_List_First)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(cList1())
              Else
                ClearList(nList())
              EndIf
            Else
              ClearList(nList())
            EndIf
            
            
            ;---Pop
          Case "Pop"
            DeleteElement(nList())
            ForEach nList()
              CompilerIf #PB_Compiler_Thread = 1
                LockMutex(MutexVarMap)
              CompilerEndIf
              If nList()\Flags & #PNB_TYPE_NAME
                If FindMapElement(Memory(), nList()\s)
                  If FirstElement(Memory()\nList())
                    AddElement(cList1())
                    cList1() = Memory()\nList()
                    DeleteElement(Memory()\nList())
                    If Not ListSize(Memory()\nList())
                      DeleteMapElement(Memory())
                    EndIf
                  EndIf
                Else
                  ResetMap(Memory())
                EndIf
              Else
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(nList())
                ClearList(cList1())
                Break
              EndIf
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
              DeleteElement(nList())
            Next
            MergeLists(cList1(), nList())
            
            ;---Inspect
          Case "Inspect"
            DeleteElement(nList())
            ForEach nList()
              CompilerIf #PB_Compiler_Thread = 1
                LockMutex(MutexVarMap)
              CompilerEndIf
              If nList()\Flags & #PNB_TYPE_NAME
                If FindMapElement(Memory(), nList()\s)
                  If FirstElement(Memory()\nList())
                    AddElement(cList1())
                    cList1() = Memory()\nList()
                  EndIf
                Else
                  ResetMap(Memory())
                EndIf
              Else
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(nList())
                ClearList(cList1())
                Break
              EndIf
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
              DeleteElement(nList())
            Next
            MergeLists(cList1(), nList())
            
            ;---Reverse
          Case "Reverse"
            DeleteElement(nList())
            ForEach nList()
              CompilerIf #PB_Compiler_Thread = 1
                LockMutex(MutexVarMap)
              CompilerEndIf
              If nList()\Flags & #PNB_TYPE_NAME
                If FindMapElement(Memory(), nList()\s)
                  ForEach Memory()\nList()
                    InsertElement(cList1())
                    cList1() = Memory()\nList()
                  Next
                  ClearList(Memory()\nList())
                  MergeLists(cList1(), Memory()\nList())
                Else
                  ResetMap(Memory())
                EndIf
              Else
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(nList())
                ClearList(cList1())
                Break
              EndIf
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
              DeleteElement(nList())
            Next
            
            
            ;-#Arithmetic
            ;---Add
          Case "+", "Add"
            DeleteElement(nList())
            RTYP = nListTypeFromList(nList())
            nListConvert(nList(), nListGetHighestType(RTYP))
            Select nListGetHighestType(RTYP)
              Case #PNB_TYPE_NAME
                NextElement(nList())
                RSTR = nList()\s
                DeleteElement(nList())
                ForEach nList()
                  RSTR+nList()\s
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\s = RSTR
                nList()\Flags | #PNB_TYPE_NAME
                
                RSTR = ""
              Case #PNB_TYPE_STRING
                NextElement(nList())
                RSTR = nList()\s
                DeleteElement(nList())
                ForEach nList()
                  RSTR+nList()\s
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\s = RSTR
                nList()\Flags | #PNB_TYPE_STRING
                
                RSTR = ""
              Case #PNB_TYPE_POINTER
                NextElement(nList())
                *RPTR = nList()\p
                DeleteElement(nList())
                ForEach nList()
                  *RPTR+nList()\p
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\p = *RPTR
                nList()\Flags | #PNB_TYPE_POINTER
                
                *RPTR = 0
              Case #PNB_TYPE_DOUBLE
                NextElement(nList())
                RDBL = nList()\d
                DeleteElement(nList())
                ForEach nList()
                  RDBL+nList()\d
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\d = RDBL
                nList()\Flags | #PNB_TYPE_DOUBLE
                
                RDBL = 0.0
              Case #PNB_TYPE_FLOAT
                NextElement(nList())
                RFLT = nList()\f
                DeleteElement(nList())
                ForEach nList()
                  RFLT+nList()\f
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\f = RFLT
                nList()\Flags | #PNB_TYPE_FLOAT
                
                RFLT = 0.0
              Case #PNB_TYPE_EPIC
                NextElement(nList())
                RQUD = nList()\q
                DeleteElement(nList())
                ForEach nList()
                  RQUD+nList()\q
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\q = RQUD
                nList()\Flags | #PNB_TYPE_EPIC
                
                RQUD = 0
              Case #PNB_TYPE_INTEGER
                NextElement(nList())
                RINT = nList()\i
                DeleteElement(nList())
                ForEach nList()
                  RINT+nList()\i
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\i = RINT
                nList()\Flags | #PNB_TYPE_INTEGER
                
                RINT = 0
              Case #PNB_TYPE_LONG
                NextElement(nList())
                RLNG = nList()\l
                DeleteElement(nList())
                ForEach nList()
                  RLNG+nList()\l
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\l = RLNG
                nList()\Flags | #PNB_TYPE_LONG
                
                RLNG = 0
              Case #PNB_TYPE_WORD
                NextElement(nList())
                RWRD = nList()\w
                DeleteElement(nList())
                ForEach nList()
                  RWRD+nList()\w
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\w = RWRD
                nList()\Flags | #PNB_TYPE_WORD
                
                RWRD = 0
              Case #PNB_TYPE_BYTE
                NextElement(nList())
                RBYT = nList()\b
                DeleteElement(nList())
                ForEach nList()
                  RBYT+nList()\b
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\b = RBYT
                nList()\Flags | #PNB_TYPE_BYTE
                
                RBYT = 0
              Case #PNB_TYPE_UWORD
                NextElement(nList())
                RUNI = nList()\u
                DeleteElement(nList())
                ForEach nList()
                  RUNI+nList()\u
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\u = RUNI
                nList()\Flags | #PNB_TYPE_UWORD
                
                RUNI = 0
              Case #PNB_TYPE_CHARACTER
                NextElement(nList())
                RCHR = nList()\c
                DeleteElement(nList())
                ForEach nList()
                  RCHR+nList()\c
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\c = RCHR
                nList()\Flags | #PNB_TYPE_CHARACTER
                
                RCHR = 0
              Case #PNB_TYPE_UBYTE
                NextElement(nList())
                RASC = nList()\a
                DeleteElement(nList())
                ForEach nList()
                  RASC+nList()\a
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\a = RASC
                nList()\Flags | #PNB_TYPE_UBYTE
                
                RASC = 0
            EndSelect
            RTYP = 0
            ;---Sub
          Case "-", "Sub"
            DeleteElement(nList())
            RTYP = nListTypeFromList(nList())
            nListConvert(nList(), nListGetHighestType(RTYP))
            Select nListGetHighestType(RTYP)
              Case #PNB_TYPE_NAME
                NextElement(nList())
                RSTR = nList()\s
                DeleteElement(nList())
                ForEach nList()
                  RSTR = RemoveString(RSTR, nList()\s)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\s = RSTR
                nList()\Flags | #PNB_TYPE_NAME
                
                RSTR = ""
              Case #PNB_TYPE_STRING
                NextElement(nList())
                RSTR = nList()\s
                DeleteElement(nList())
                ForEach nList()
                  RSTR = RemoveString(RSTR, nList()\s)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\s = RSTR
                nList()\Flags | #PNB_TYPE_STRING
                
                RSTR = ""
              Case #PNB_TYPE_POINTER
                NextElement(nList())
                *RPTR = nList()\p
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    *RPTR = -*RPTR
                  Default
                    ForEach nList()
                      *RPTR-nList()\p
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\p = *RPTR
                nList()\Flags | #PNB_TYPE_POINTER
                
                *RPTR = 0
              Case #PNB_TYPE_DOUBLE
                NextElement(nList())
                RDBL = nList()\d
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RDBL = -RDBL
                  Default
                    ForEach nList()
                      RDBL-nList()\d
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\d = RDBL
                nList()\Flags | #PNB_TYPE_DOUBLE
                
                RDBL = 0.0
              Case #PNB_TYPE_FLOAT
                NextElement(nList())
                RFLT = nList()\f
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RFLT = -RFLT
                  Default
                    ForEach nList()
                      RFLT-nList()\f
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\f = RFLT
                nList()\Flags | #PNB_TYPE_FLOAT
                
                RFLT = 0.0
              Case #PNB_TYPE_EPIC
                NextElement(nList())
                RQUD = nList()\q
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RQUD = -RQUD
                  Default
                    ForEach nList()
                      RQUD-nList()\q
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\q = RQUD
                nList()\Flags | #PNB_TYPE_EPIC
                
                RQUD = 0
              Case #PNB_TYPE_INTEGER
                NextElement(nList())
                RINT = nList()\i
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RINT = -RINT
                  Default
                    ForEach nList()
                      RINT-nList()\i
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\i = RINT
                nList()\Flags | #PNB_TYPE_INTEGER
                
                RINT = 0
              Case #PNB_TYPE_LONG
                NextElement(nList())
                RLNG = nList()\l
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RLNG = -RLNG
                  Default
                    ForEach nList()
                      RLNG-nList()\l
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\l = RLNG
                nList()\Flags | #PNB_TYPE_LONG
                
                RLNG = 0
              Case #PNB_TYPE_WORD
                NextElement(nList())
                RWRD = nList()\w
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RWRD = -RWRD
                  Default
                    ForEach nList()
                      RWRD-nList()\w
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\w = RWRD
                nList()\Flags | #PNB_TYPE_WORD
                
                RWRD = 0
              Case #PNB_TYPE_BYTE
                NextElement(nList())
                RBYT = nList()\b
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RBYT = -RBYT
                  Default
                    ForEach nList()
                      RBYT-nList()\b
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\b = RBYT
                nList()\Flags | #PNB_TYPE_BYTE
                
                RBYT = 0
              Case #PNB_TYPE_UWORD
                NextElement(nList())
                RUNI = nList()\u
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RUNI = -RUNI
                  Default
                    ForEach nList()
                      RUNI-nList()\u
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\u = RUNI
                nList()\Flags | #PNB_TYPE_UWORD
                
                RUNI = 0
              Case #PNB_TYPE_CHARACTER
                NextElement(nList())
                RCHR = nList()\c
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RCHR = -RCHR
                  Default
                    ForEach nList()
                      RCHR-nList()\c
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\c = RCHR
                nList()\Flags | #PNB_TYPE_CHARACTER
                
                RCHR = 0
              Case #PNB_TYPE_UBYTE
                NextElement(nList())
                RASC = nList()\a
                DeleteElement(nList())
                Select ListSize(nList())
                  Case 0
                    RASC = -RASC
                  Default
                    ForEach nList()
                      RASC-nList()\a
                      DeleteElement(nList())
                    Next
                EndSelect
                AddElement(nList())
                nList()\a = RASC
                nList()\Flags | #PNB_TYPE_UBYTE
                
                RASC = 0
            EndSelect
            RTYP = 0
            ;---Mul
          Case "*", "Mul"
            DeleteElement(nList())
            RTYP = nListTypeFromList(nList())
            nListConvert(nList(), nListGetHighestType(RTYP))
            Select nListGetHighestType(RTYP)
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_POINTER
                NextElement(nList())
                *RPTR = nList()\p
                DeleteElement(nList())
                ForEach nList()
                  *RPTR*nList()\p
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\p = *RPTR
                nList()\Flags | #PNB_TYPE_POINTER
                
                *RPTR = 0
              Case #PNB_TYPE_DOUBLE
                NextElement(nList())
                RDBL = nList()\d
                DeleteElement(nList())
                ForEach nList()
                  RDBL*nList()\d
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\d = RDBL
                nList()\Flags | #PNB_TYPE_DOUBLE
                
                RDBL = 0.0
              Case #PNB_TYPE_FLOAT
                NextElement(nList())
                RFLT = nList()\f
                DeleteElement(nList())
                ForEach nList()
                  RFLT*nList()\f
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\f = RFLT
                nList()\Flags | #PNB_TYPE_FLOAT
                
                RFLT = 0.0
              Case #PNB_TYPE_EPIC
                NextElement(nList())
                RQUD = nList()\q
                DeleteElement(nList())
                ForEach nList()
                  RQUD*nList()\q
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\q = RQUD
                nList()\Flags | #PNB_TYPE_EPIC
                
                RQUD = 0
              Case #PNB_TYPE_INTEGER
                NextElement(nList())
                RINT = nList()\i
                DeleteElement(nList())
                ForEach nList()
                  RINT*nList()\i
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\i = RINT
                nList()\Flags | #PNB_TYPE_INTEGER
                
                RINT = 0
              Case #PNB_TYPE_LONG
                NextElement(nList())
                RLNG = nList()\l
                DeleteElement(nList())
                ForEach nList()
                  RLNG*nList()\l
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\l = RLNG
                nList()\Flags | #PNB_TYPE_LONG
                
                RLNG = 0
              Case #PNB_TYPE_WORD
                NextElement(nList())
                RWRD = nList()\w
                DeleteElement(nList())
                ForEach nList()
                  RWRD*nList()\w
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\w = RWRD
                nList()\Flags | #PNB_TYPE_WORD
                
                RWRD = 0
              Case #PNB_TYPE_BYTE
                NextElement(nList())
                RBYT = nList()\b
                DeleteElement(nList())
                ForEach nList()
                  RBYT*nList()\b
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\b = RBYT
                nList()\Flags | #PNB_TYPE_BYTE
                
                RBYT = 0
              Case #PNB_TYPE_UWORD
                NextElement(nList())
                RUNI = nList()\u
                DeleteElement(nList())
                ForEach nList()
                  RUNI*nList()\u
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\u = RUNI
                nList()\Flags | #PNB_TYPE_UWORD
                
                RUNI = 0
              Case #PNB_TYPE_CHARACTER
                NextElement(nList())
                RCHR = nList()\c
                DeleteElement(nList())
                ForEach nList()
                  RCHR*nList()\c
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\c = RCHR
                nList()\Flags | #PNB_TYPE_CHARACTER
                
                RCHR = 0
              Case #PNB_TYPE_UBYTE
                NextElement(nList())
                RASC = nList()\a
                DeleteElement(nList())
                ForEach nList()
                  RASC*nList()\a
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\a = RASC
                nList()\Flags | #PNB_TYPE_UBYTE
                
                RASC = 0
            EndSelect
            RTYP = 0
            ;---Div
          Case "/", "Div"
            DeleteElement(nList())
            RTYP = nListTypeFromList(nList())
            nListConvert(nList(), nListGetHighestType(RTYP))
            Select nListGetHighestType(RTYP)
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_POINTER
                NextElement(nList())
                *RPTR = nList()\p
                DeleteElement(nList())
                ForEach nList()
                  If nList()\p = 0
                    *RPTR = 0
                    ClearList(nList())
                  Else
                    *RPTR/nList()\p
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\p = *RPTR
                nList()\Flags | #PNB_TYPE_POINTER
                
                *RPTR = 0
              Case #PNB_TYPE_DOUBLE
                NextElement(nList())
                RDBL = nList()\d
                DeleteElement(nList())
                ForEach nList()
                  If nList()\d = 0.0
                    RDBL = 0.0
                    ClearList(nList())
                  Else
                    RDBL/nList()\d
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\d = RDBL
                nList()\Flags | #PNB_TYPE_DOUBLE
                
                RDBL = 0.0
              Case #PNB_TYPE_FLOAT
                NextElement(nList())
                RFLT = nList()\f
                DeleteElement(nList())
                ForEach nList()
                  If nList()\f = 0.0
                    RFLT = 0.0
                    ClearList(nList())
                  Else
                    RFLT/nList()\f
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\f = RFLT
                nList()\Flags | #PNB_TYPE_FLOAT
                
                RFLT = 0.0
              Case #PNB_TYPE_EPIC
                NextElement(nList())
                RQUD = nList()\q
                DeleteElement(nList())
                ForEach nList()
                  If nList()\q = 0
                    RQUD = 0
                    ClearList(nList())
                  Else
                    RQUD/nList()\q
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\q = RQUD
                nList()\Flags | #PNB_TYPE_EPIC
                
                RQUD = 0
              Case #PNB_TYPE_INTEGER
                NextElement(nList())
                RINT = nList()\i
                DeleteElement(nList())
                ForEach nList()
                  If nList()\i = 0
                    RINT = 0
                    ClearList(nList())
                  Else
                    RINT/nList()\i
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\i = RINT
                nList()\Flags | #PNB_TYPE_INTEGER
                
                RINT = 0
              Case #PNB_TYPE_LONG
                NextElement(nList())
                RLNG = nList()\l
                DeleteElement(nList())
                ForEach nList()
                  If nList()\l = 0
                    RLNG = 0
                    ClearList(nList())
                  Else
                    RLNG/nList()\l
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\l = RLNG
                nList()\Flags | #PNB_TYPE_LONG
                
                RLNG = 0
              Case #PNB_TYPE_WORD
                NextElement(nList())
                RWRD = nList()\w
                DeleteElement(nList())
                ForEach nList()
                  If nList()\w = 0
                    RWRD = 0
                    ClearList(nList())
                  Else
                    RWRD/nList()\w
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\w = RWRD
                nList()\Flags | #PNB_TYPE_WORD
                
                RWRD = 0
              Case #PNB_TYPE_BYTE
                NextElement(nList())
                RBYT = nList()\b
                DeleteElement(nList())
                ForEach nList()
                  If nList()\b = 0
                    RBYT = 0
                    ClearList(nList())
                  Else
                    RBYT/nList()\b
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\b = RBYT
                nList()\Flags | #PNB_TYPE_BYTE
                
                RBYT = 0
              Case #PNB_TYPE_UWORD
                NextElement(nList())
                RUNI = nList()\u
                DeleteElement(nList())
                ForEach nList()
                  If nList()\u = 0
                    RUNI = 0
                    ClearList(nList())
                  Else
                    RUNI/nList()\u
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\u = RUNI
                nList()\Flags | #PNB_TYPE_UWORD
                
                RUNI = 0
              Case #PNB_TYPE_CHARACTER
                NextElement(nList())
                RCHR = nList()\c
                DeleteElement(nList())
                ForEach nList()
                  If nList()\c = 0
                    RCHR = 0
                    ClearList(nList())
                  Else
                    RCHR/nList()\c
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\c = RCHR
                nList()\Flags | #PNB_TYPE_CHARACTER
                
                RCHR = 0
              Case #PNB_TYPE_UBYTE
                NextElement(nList())
                RASC = nList()\a
                DeleteElement(nList())
                ForEach nList()
                  If nList()\a = 0
                    RASC = 0
                    ClearList(nList())
                  Else
                    RASC/nList()\a
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\a = RASC
                nList()\Flags | #PNB_TYPE_UBYTE
                
                RASC = 0
            EndSelect
            RTYP = 0
            
            ;---Pow
          Case "^", "Pow"
            DeleteElement(nList())
            RTYP = nListTypeFromList(nList())
            nListConvert(nList(), nListGetHighestType(RTYP))
            Select nListGetHighestType(RTYP)
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_POINTER
                NextElement(nList())
                *RPTR = nList()\p
                DeleteElement(nList())
                ForEach nList()
                  *RPTR = Pow(*RPTR, nList()\p)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\p = *RPTR
                nList()\Flags | #PNB_TYPE_POINTER
                
                *RPTR = 0
              Case #PNB_TYPE_DOUBLE
                NextElement(nList())
                RDBL = nList()\d
                DeleteElement(nList())
                ForEach nList()
                  RDBL = Pow(RDBL, nList()\d)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\d = RDBL
                nList()\Flags | #PNB_TYPE_DOUBLE
                
                RDBL = 0.0
              Case #PNB_TYPE_FLOAT
                NextElement(nList())
                RFLT = nList()\f
                DeleteElement(nList())
                ForEach nList()
                  RFLT = Pow(RFLT, nList()\f)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\f = RFLT
                nList()\Flags | #PNB_TYPE_FLOAT
                
                RFLT = 0.0
              Case #PNB_TYPE_EPIC
                NextElement(nList())
                RQUD = nList()\q
                DeleteElement(nList())
                ForEach nList()
                  RQUD = Pow(RQUD, nList()\q)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\q = RQUD
                nList()\Flags | #PNB_TYPE_EPIC
                
                RQUD = 0
              Case #PNB_TYPE_INTEGER
                NextElement(nList())
                RINT = nList()\i
                DeleteElement(nList())
                ForEach nList()
                  RINT = Pow(RINT, nList()\i)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\i = RINT
                nList()\Flags | #PNB_TYPE_INTEGER
                
                RINT = 0
              Case #PNB_TYPE_LONG
                NextElement(nList())
                RLNG = nList()\l
                DeleteElement(nList())
                ForEach nList()
                  RLNG = Pow(RLNG, nList()\l)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\l = RLNG
                nList()\Flags | #PNB_TYPE_LONG
                
                RLNG = 0
              Case #PNB_TYPE_WORD
                NextElement(nList())
                RWRD = nList()\w
                DeleteElement(nList())
                ForEach nList()
                  RWRD = Pow(RWRD, nList()\w)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\w = RWRD
                nList()\Flags | #PNB_TYPE_WORD
                
                RWRD = 0
              Case #PNB_TYPE_BYTE
                NextElement(nList())
                RBYT = nList()\b
                DeleteElement(nList())
                ForEach nList()
                  RBYT = Pow(RBYT, nList()\b)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\b = RBYT
                nList()\Flags | #PNB_TYPE_BYTE
                
                RBYT = 0
              Case #PNB_TYPE_UWORD
                NextElement(nList())
                RUNI = nList()\u
                DeleteElement(nList())
                ForEach nList()
                  RUNI = Pow(RUNI, nList()\u)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\u = RUNI
                nList()\Flags | #PNB_TYPE_UWORD
                
                RUNI = 0
              Case #PNB_TYPE_CHARACTER
                NextElement(nList())
                RCHR = nList()\c
                DeleteElement(nList())
                ForEach nList()
                  RCHR = Pow(RCHR, nList()\c)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\c = RCHR
                nList()\Flags | #PNB_TYPE_CHARACTER
                
                RCHR = 0
              Case #PNB_TYPE_UBYTE
                NextElement(nList())
                RASC = nList()\a
                DeleteElement(nList())
                ForEach nList()
                  RASC = Pow(RASC, nList()\a)
                  DeleteElement(nList())
                Next
                AddElement(nList())
                nList()\a = RASC
                nList()\Flags | #PNB_TYPE_UBYTE
                
                RASC = 0
            EndSelect
            RTYP = 0
            ;---Mod
          Case "%", "Mod"
            DeleteElement(nList())
            RTYP = nListTypeFromList(nList())
            nListConvert(nList(), nListGetHighestType(RTYP))
            Select nListGetHighestType(RTYP)
              Case #PNB_TYPE_NAME
                ForEach nList()
                  DeleteElement(nList())
                Next
              Case #PNB_TYPE_STRING
                ForEach nList()
                  DeleteElement(nList())
                Next
              Case #PNB_TYPE_POINTER
                NextElement(nList())
                *RPTR = nList()\p
                DeleteElement(nList())
                ForEach nList()
                  If nList()\p = 0
                    *RPTR = 0
                    ClearList(nList())
                  Else
                    *RPTR%nList()\p
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\p = *RPTR
                nList()\Flags | #PNB_TYPE_POINTER
                
                *RPTR = 0
              Case #PNB_TYPE_DOUBLE
                NextElement(nList())
                RDBL = nList()\d
                DeleteElement(nList())
                ForEach nList()
                  If nList()\d = 0.0
                    RDBL = 0.0
                    ClearList(nList())
                  Else
                    RINT = RDBL/nList()\d
                    RDBL-nList()\d*RINT
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\d = RDBL
                nList()\Flags | #PNB_TYPE_DOUBLE
                
                RDBL = 0.0
              Case #PNB_TYPE_FLOAT
                NextElement(nList())
                RFLT = nList()\f
                DeleteElement(nList())
                ForEach nList()
                  If nList()\f = 0.0
                    RFLT = 0.0
                    ClearList(nList())
                  Else
                    RINT = RFLT/nList()\f
                    RFLT-nList()\f*RINT
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\f = RFLT
                nList()\Flags | #PNB_TYPE_FLOAT
                
                RFLT = 0.0
              Case #PNB_TYPE_EPIC
                NextElement(nList())
                RQUD = nList()\q
                DeleteElement(nList())
                ForEach nList()
                  If nList()\q = 0
                    RQUD = 0
                    ClearList(nList())
                  Else
                    RQUD%nList()\q
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\q = RQUD
                nList()\Flags | #PNB_TYPE_EPIC
                
                RQUD = 0
              Case #PNB_TYPE_INTEGER
                NextElement(nList())
                RINT = nList()\i
                DeleteElement(nList())
                ForEach nList()
                  If nList()\i = 0
                    RINT = 0
                    ClearList(nList())
                  Else
                    RINT%nList()\i
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\i = RINT
                nList()\Flags | #PNB_TYPE_INTEGER
                
                RINT = 0
              Case #PNB_TYPE_LONG
                NextElement(nList())
                RLNG = nList()\l
                DeleteElement(nList())
                ForEach nList()
                  If nList()\l = 0
                    RLNG = 0
                    ClearList(nList())
                  Else
                    RLNG%nList()\l
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\l = RLNG
                nList()\Flags | #PNB_TYPE_LONG
                
                RLNG = 0
              Case #PNB_TYPE_WORD
                NextElement(nList())
                RWRD = nList()\w
                DeleteElement(nList())
                ForEach nList()
                  If nList()\w = 0
                    RWRD = 0
                    ClearList(nList())
                  Else
                    RWRD%nList()\w
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\w = RWRD
                nList()\Flags | #PNB_TYPE_WORD
                
                RWRD = 0
              Case #PNB_TYPE_BYTE
                NextElement(nList())
                RBYT = nList()\b
                DeleteElement(nList())
                ForEach nList()
                  If nList()\b = 0
                    RBYT = 0
                    ClearList(nList())
                  Else
                    RBYT%nList()\b
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\b = RBYT
                nList()\Flags | #PNB_TYPE_BYTE
                
                RBYT = 0
              Case #PNB_TYPE_UWORD
                NextElement(nList())
                RUNI = nList()\u
                DeleteElement(nList())
                ForEach nList()
                  If nList()\u = 0
                    RUNI = 0
                    ClearList(nList())
                  Else
                    RUNI%nList()\u
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\u = RUNI
                nList()\Flags | #PNB_TYPE_UWORD
                
                RUNI = 0
              Case #PNB_TYPE_CHARACTER
                NextElement(nList())
                RCHR = nList()\c
                DeleteElement(nList())
                ForEach nList()
                  If nList()\c = 0
                    RCHR = 0
                    ClearList(nList())
                  Else
                    RCHR%nList()\c
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\c = RCHR
                nList()\Flags | #PNB_TYPE_CHARACTER
                
                RCHR = 0
              Case #PNB_TYPE_UBYTE
                NextElement(nList())
                RASC = nList()\a
                DeleteElement(nList())
                ForEach nList()
                  If nList()\a = 0
                    RASC = 0
                    ClearList(nList())
                  Else
                    RASC%nList()\a
                    DeleteElement(nList())
                  EndIf
                Next
                AddElement(nList())
                nList()\a = RASC
                nList()\Flags | #PNB_TYPE_UBYTE
                
                RASC = 0
            EndSelect
            RTYP = 0
            
            ;---Sign
          Case "+-", "-+", "Sign"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                Case #PNB_TYPE_POINTER
                  nList()\p = Sign(nList()\p)
                Case #PNB_TYPE_DOUBLE
                  nList()\d = Sign(nList()\d)
                Case #PNB_TYPE_FLOAT
                  nList()\f = Sign(nList()\p)
                Case #PNB_TYPE_EPIC
                  nList()\q = Sign(nList()\q)
                Case #PNB_TYPE_INTEGER
                  nList()\i = Sign(nList()\i)
                Case #PNB_TYPE_LONG
                  nList()\l = Sign(nList()\l)
                Case #PNB_TYPE_WORD
                  nList()\w = Sign(nList()\w)
                Case #PNB_TYPE_BYTE
                  nList()\b = Sign(nList()\b)
                Case #PNB_TYPE_UWORD
                  nList()\u = Sign(nList()\u)
                Case #PNB_TYPE_CHARACTER
                  nList()\c = Sign(nList()\c)
                Case #PNB_TYPE_UBYTE
                  nList()\a = Sign(nList()\a)
              EndSelect
            Next
            
            ;---Abs
          Case "_", "Abs"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                Case #PNB_TYPE_POINTER
                  nList()\p = (nList()\p)
                Case #PNB_TYPE_DOUBLE
                  nList()\d = Abs(nList()\d)
                Case #PNB_TYPE_FLOAT
                  nList()\f = Abs(nList()\p)
                Case #PNB_TYPE_EPIC
                  If nList()\q > 0
                    nList()\q = nList()\q
                  EndIf
                Case #PNB_TYPE_INTEGER
                  If nList()\i > 0
                    nList()\i = nList()\i
                  EndIf
                Case #PNB_TYPE_LONG
                  If nList()\l > 0
                    nList()\l = nList()\l
                  EndIf
                Case #PNB_TYPE_WORD
                  If nList()\w > 0
                    nList()\w = nList()\w
                  EndIf
                Case #PNB_TYPE_BYTE
                  If nList()\b > 0
                    nList()\b = nList()\b
                  EndIf
              EndSelect
            Next
            
            ;---Asl
          Case "<<", "Asl"
            DeleteElement(nList())
            NextElement(nList())
            RTYP = nListGetHighestType(nList()\Flags)
            Select RTYP
              Case #PNB_TYPE_NAME
                RSTR = nList()\s
                DeleteElement(nList())
              Case #PNB_TYPE_STRING
                RSTR = nList()\s
                DeleteElement(nList())
              Case #PNB_TYPE_POINTER
                *RPTR = nList()\p
                DeleteElement(nList())
              Case #PNB_TYPE_DOUBLE
                RQUD = nList()\q
                DeleteElement(nList())
              Case #PNB_TYPE_FLOAT
                RLNG = nList()\l
                DeleteElement(nList())
              Case #PNB_TYPE_EPIC
                RQUD = nList()\q
                DeleteElement(nList())
              Case #PNB_TYPE_INTEGER
                RINT = nList()\i
                DeleteElement(nList())
              Case #PNB_TYPE_LONG
                RLNG = nList()\l
                DeleteElement(nList())
              Case #PNB_TYPE_WORD
                RWRD = nList()\w
                DeleteElement(nList())
              Case #PNB_TYPE_BYTE
                RBYT = nList()\b
                DeleteElement(nList())
              Case #PNB_TYPE_UWORD
                RUNI = nList()\u
                DeleteElement(nList())
              Case #PNB_TYPE_CHARACTER
                RCHR = nList()\c
                DeleteElement(nList())
              Case #PNB_TYPE_UBYTE
                RASC = nList()\a
                DeleteElement(nList())
            EndSelect
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                  RCNT = 0
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                  RCNT = 0
                Case #PNB_TYPE_POINTER
                  RCNT = nList()\p
                  DeleteElement(nList())
                Case #PNB_TYPE_DOUBLE
                  RCNT = nList()\d
                  DeleteElement(nList())
                Case #PNB_TYPE_FLOAT
                  RCNT = nList()\f
                  DeleteElement(nList())
                Case #PNB_TYPE_EPIC
                  RCNT = nList()\q
                  DeleteElement(nList())
                Case #PNB_TYPE_INTEGER
                  RCNT = nList()\i
                  DeleteElement(nList())
                Case #PNB_TYPE_LONG
                  RCNT = nList()\p
                  DeleteElement(nList())
                Case #PNB_TYPE_WORD
                  RCNT = nList()\w
                  DeleteElement(nList())
                Case #PNB_TYPE_BYTE
                  RCNT = nList()\b
                  DeleteElement(nList())
                Case #PNB_TYPE_UWORD
                  RCNT = nList()\u
                  DeleteElement(nList())
                Case #PNB_TYPE_CHARACTER
                  RCNT = nList()\c
                  DeleteElement(nList())
                Case #PNB_TYPE_UBYTE
                  RCNT = nList()\a
                  DeleteElement(nList())
              EndSelect
              Select RTYP
                Case #PNB_TYPE_NAME
                  If RCNT > 0
                    While RCNT > Len(RSTR)
                      RCNT-Len(RSTR)
                    Wend
                    RSTR = Mid(RSTR, RCNT+1)+Left(RSTR, RCNT)
                  ElseIf RCNT < 0
                    While -RCNT > Len(RSTR)
                      RCNT+Len(RSTR)
                    Wend
                    RSTR = Right(RSTR, -RCNT)+Mid(RSTR, 1, Len(RSTR)+RCNT)
                  EndIf
                Case #PNB_TYPE_STRING
                  If RCNT > 0
                    While RCNT > Len(RSTR)
                      RCNT-Len(RSTR)
                    Wend
                    RSTR = Mid(RSTR, RCNT+1)+Left(RSTR, RCNT)
                  ElseIf RCNT < 0
                    While -RCNT > Len(RSTR)
                      RCNT+Len(RSTR)
                    Wend
                    RSTR = Right(RSTR, -RCNT)+Mid(RSTR, 1, Len(RSTR)+RCNT)
                  EndIf
                Case #PNB_TYPE_POINTER
                  If RCNT > 0
                    *RPTR<<RCNT
                  Else
                    *RPTR>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_DOUBLE
                  If RCNT > 0
                    RQUD<<RCNT
                  Else
                    RQUD>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_FLOAT
                  If RCNT > 0
                    RLNG<<RCNT
                  Else
                    RLNG>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_EPIC
                  If RCNT > 0
                    RQUD<<RCNT
                  Else
                    RQUD>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_INTEGER
                  If RCNT > 0
                    RINT<<RCNT
                  Else
                    RINT>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_LONG
                  If RCNT > 0
                    RLNG<<RCNT
                  Else
                    RLNG>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_WORD
                  If RCNT > 0
                    RWRD<<RCNT
                  Else
                    RWRD>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_BYTE
                  If RCNT > 0
                    RBYT<<RCNT
                  Else
                    RBYT>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_UWORD
                  If RCNT > 0
                    RUNI<<RCNT
                  Else
                    RUNI>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_CHARACTER
                  If RCNT > 0
                    RCHR<<RCNT
                  Else
                    RCHR>>(-RCNT)
                  EndIf
                Case #PNB_TYPE_UBYTE
                  If RCNT > 0
                    RASC<<RCNT
                  Else
                    RASC>>(-RCNT)
                  EndIf
              EndSelect
            Next
            
            AddElement(nList())
            Select RTYP
              Case #PNB_TYPE_NAME
                nList()\s = RSTR
              Case #PNB_TYPE_STRING
                nList()\s = RSTR
              Case #PNB_TYPE_POINTER
                nList()\p = *RPTR
              Case #PNB_TYPE_DOUBLE
                nList()\q = RQUD
              Case #PNB_TYPE_FLOAT
                nList()\l = RLNG
              Case #PNB_TYPE_EPIC
                nList()\q = RQUD
              Case #PNB_TYPE_INTEGER
                nList()\i = RINT
              Case #PNB_TYPE_LONG
                nList()\l = RLNG
              Case #PNB_TYPE_WORD
                nList()\w = RWRD
              Case #PNB_TYPE_BYTE
                nList()\b = RBYT
              Case #PNB_TYPE_UWORD
                nList()\u = RUNI
              Case #PNB_TYPE_CHARACTER
                nList()\c = RCHR
              Case #PNB_TYPE_UBYTE
                nList()\a = RASC
            EndSelect
            nList()\Flags = RTYP
            
            RSTR = ""
            RCNT = 0
            RINT = 0
            RTYP = 0
            RASC = 0
            RBYT = 0
            RCHR = 0
            RLNG = 0
            RQUD = 0
            RWRD = 0
            RUNI = 0
            *RPTR = 0
            
            ;---Asr
          Case ">>", "Asr"
            DeleteElement(nList())
            NextElement(nList())
            RTYP = nListGetHighestType(nList()\Flags)
            Select RTYP
              Case #PNB_TYPE_NAME
                RSTR = nList()\s
                DeleteElement(nList())
              Case #PNB_TYPE_STRING
                RSTR = nList()\s
                DeleteElement(nList())
              Case #PNB_TYPE_POINTER
                *RPTR = nList()\p
                DeleteElement(nList())
              Case #PNB_TYPE_DOUBLE
                RQUD = nList()\q
                DeleteElement(nList())
              Case #PNB_TYPE_FLOAT
                RLNG = nList()\l
                DeleteElement(nList())
              Case #PNB_TYPE_EPIC
                RQUD = nList()\q
                DeleteElement(nList())
              Case #PNB_TYPE_INTEGER
                RINT = nList()\i
                DeleteElement(nList())
              Case #PNB_TYPE_LONG
                RLNG = nList()\l
                DeleteElement(nList())
              Case #PNB_TYPE_WORD
                RWRD = nList()\w
                DeleteElement(nList())
              Case #PNB_TYPE_BYTE
                RBYT = nList()\b
                DeleteElement(nList())
              Case #PNB_TYPE_UWORD
                RUNI = nList()\u
                DeleteElement(nList())
              Case #PNB_TYPE_CHARACTER
                RCHR = nList()\c
                DeleteElement(nList())
              Case #PNB_TYPE_UBYTE
                RASC = nList()\a
                DeleteElement(nList())
            EndSelect
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                  RCNT = 0
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                  RCNT = 0
                Case #PNB_TYPE_POINTER
                  RCNT = nList()\p
                  DeleteElement(nList())
                Case #PNB_TYPE_DOUBLE
                  RCNT = nList()\d
                  DeleteElement(nList())
                Case #PNB_TYPE_FLOAT
                  RCNT = nList()\f
                  DeleteElement(nList())
                Case #PNB_TYPE_EPIC
                  RCNT = nList()\q
                  DeleteElement(nList())
                Case #PNB_TYPE_INTEGER
                  RCNT = nList()\i
                  DeleteElement(nList())
                Case #PNB_TYPE_LONG
                  RCNT = nList()\p
                  DeleteElement(nList())
                Case #PNB_TYPE_WORD
                  RCNT = nList()\w
                  DeleteElement(nList())
                Case #PNB_TYPE_BYTE
                  RCNT = nList()\b
                  DeleteElement(nList())
                Case #PNB_TYPE_UWORD
                  RCNT = nList()\u
                  DeleteElement(nList())
                Case #PNB_TYPE_CHARACTER
                  RCNT = nList()\c
                  DeleteElement(nList())
                Case #PNB_TYPE_UBYTE
                  RCNT = nList()\a
                  DeleteElement(nList())
              EndSelect
              Select RTYP
                Case #PNB_TYPE_NAME
                  If RCNT > 0
                    While RCNT > Len(RSTR)
                      RCNT-Len(RSTR)
                    Wend
                    RSTR = Right(RSTR, RCNT)+Mid(RSTR, 1, Len(RSTR)-RCNT)
                  ElseIf RCNT < 0
                    While -RCNT > Len(RSTR)
                      RCNT+Len(RSTR)
                    Wend
                    RSTR = Mid(RSTR, -RCNT+1)+Left(RSTR, -RCNT)
                  EndIf
                Case #PNB_TYPE_STRING
                  If RCNT > 0
                    While RCNT > Len(RSTR)
                      RCNT-Len(RSTR)
                    Wend
                    RSTR = Right(RSTR, RCNT)+Mid(RSTR, 1, Len(RSTR)-RCNT)
                  ElseIf RCNT < 0
                    While -RCNT > Len(RSTR)
                      RCNT+Len(RSTR)
                    Wend
                    RSTR = Mid(RSTR, -RCNT+1)+Left(RSTR, -RCNT)
                  EndIf
                Case #PNB_TYPE_POINTER
                  If RCNT > 0
                    *RPTR>>RCNT
                  Else
                    *RPTR<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_DOUBLE
                  If RCNT > 0
                    RQUD>>RCNT
                  Else
                    RQUD<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_FLOAT
                  If RCNT > 0
                    RLNG>>RCNT
                  Else
                    RLNG<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_EPIC
                  If RCNT > 0
                    RQUD>>RCNT
                  Else
                    RQUD<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_INTEGER
                  If RCNT > 0
                    RINT>>RCNT
                  Else
                    RINT<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_LONG
                  If RCNT > 0
                    RLNG>>RCNT
                  Else
                    RLNG<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_WORD
                  If RCNT > 0
                    RWRD>>RCNT
                  Else
                    RWRD<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_BYTE
                  If RCNT > 0
                    RBYT>>RCNT
                  Else
                    RBYT<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_UWORD
                  If RCNT > 0
                    RUNI>>RCNT
                  Else
                    RUNI<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_CHARACTER
                  If RCNT > 0
                    RCHR>>RCNT
                  Else
                    RCHR<<(-RCNT)
                  EndIf
                Case #PNB_TYPE_UBYTE
                  If RCNT > 0
                    RASC>>RCNT
                  Else
                    RASC<<(-RCNT)
                  EndIf
              EndSelect
            Next
            
            AddElement(nList())
            Select RTYP
              Case #PNB_TYPE_NAME
                nList()\s = RSTR
              Case #PNB_TYPE_STRING
                nList()\s = RSTR
              Case #PNB_TYPE_POINTER
                nList()\p = *RPTR
              Case #PNB_TYPE_DOUBLE
                nList()\q = RQUD
              Case #PNB_TYPE_FLOAT
                nList()\l = RLNG
              Case #PNB_TYPE_EPIC
                nList()\q = RQUD
              Case #PNB_TYPE_INTEGER
                nList()\i = RINT
              Case #PNB_TYPE_LONG
                nList()\l = RLNG
              Case #PNB_TYPE_WORD
                nList()\w = RWRD
              Case #PNB_TYPE_BYTE
                nList()\b = RBYT
              Case #PNB_TYPE_UWORD
                nList()\u = RUNI
              Case #PNB_TYPE_CHARACTER
                nList()\c = RCHR
              Case #PNB_TYPE_UBYTE
                nList()\a = RASC
            EndSelect
            nList()\Flags = RTYP
            
            RSTR = ""
            RCNT = 0
            RINT = 0
            RTYP = 0
            RASC = 0
            RBYT = 0
            RCHR = 0
            RLNG = 0
            RQUD = 0
            RWRD = 0
            RUNI = 0
            *RPTR = 0
            
            ;---Sin
          Case "Sin"
            DeleteElement(nList())
            Select nListTypeFromList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_DOUBLE
                nListConvert(nList(), #PNB_TYPE_DOUBLE)
                ForEach nList()
                  nList()\d = Sin(Radian(nList()\d))
                Next
              Default
                nListConvert(nList(), #PNB_TYPE_FLOAT)
                ForEach nList()
                  nList()\f = Sin(Radian(nList()\f))
                Next
            EndSelect
            
            ;---ASin
          Case "ASin"
            DeleteElement(nList())
            Select nListTypeFromList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_DOUBLE
                nListConvert(nList(), #PNB_TYPE_DOUBLE)
                ForEach nList()
                  nList()\d = Degree(ASin(nList()\d))
                Next
              Default
                nListConvert(nList(), #PNB_TYPE_FLOAT)
                ForEach nList()
                  nList()\f = Degree(ASin(nList()\f))
                Next
            EndSelect
            
            ;---Cos
          Case "Cos"
            DeleteElement(nList())
            Select nListTypeFromList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_DOUBLE
                nListConvert(nList(), #PNB_TYPE_DOUBLE)
                ForEach nList()
                  nList()\d = Cos(Radian(nList()\d))
                Next
              Default
                nListConvert(nList(), #PNB_TYPE_FLOAT)
                ForEach nList()
                  nList()\f = Cos(Radian(nList()\f))
                Next
            EndSelect
            
            ;---ACos
          Case "ACos"
            DeleteElement(nList())
            Select nListTypeFromList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_DOUBLE
                nListConvert(nList(), #PNB_TYPE_DOUBLE)
                ForEach nList()
                  nList()\d = Degree(ACos(nList()\d))
                Next
              Default
                nListConvert(nList(), #PNB_TYPE_FLOAT)
                ForEach nList()
                  nList()\f = Degree(ACos(nList()\f))
                Next
            EndSelect
            
            ;---Tan
          Case "Tan"
            DeleteElement(nList())
            Select nListTypeFromList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_DOUBLE
                nListConvert(nList(), #PNB_TYPE_DOUBLE)
                ForEach nList()
                  nList()\d = Tan(Radian(nList()\d))
                Next
              Default
                nListConvert(nList(), #PNB_TYPE_FLOAT)
                ForEach nList()
                  nList()\f = Tan(Radian(nList()\f))
                Next
            EndSelect
            
            ;---ATan
          Case "ATan"
            DeleteElement(nList())
            Select nListTypeFromList(nList())
              Case #PNB_TYPE_STRING
                ClearList(nList())
              Case #PNB_TYPE_NAME
                ClearList(nList())
              Case #PNB_TYPE_DOUBLE
                nListConvert(nList(), #PNB_TYPE_DOUBLE)
                ForEach nList()
                  nList()\d = Degree(ATan(nList()\d))
                Next
              Default
                nListConvert(nList(), #PNB_TYPE_FLOAT)
                ForEach nList()
                  nList()\f = Degree(ATan(nList()\f))
                Next
            EndSelect
            
            ;---Up
          Case "Up"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                Case #PNB_TYPE_DOUBLE
                  nList()\d = Round(nList()\d, #PB_Round_Up)
                Case #PNB_TYPE_FLOAT
                  nList()\f = Round(nList()\f, #PB_Round_Up)
              EndSelect
            Next
            
            ;---Down
          Case "Down"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                Case #PNB_TYPE_DOUBLE
                  nList()\d = Round(nList()\d, #PB_Round_Down)
                Case #PNB_TYPE_FLOAT
                  nList()\f = Round(nList()\f, #PB_Round_Down)
              EndSelect
            Next
            
            ;---Round
          Case "Round"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                Case #PNB_TYPE_DOUBLE
                  nList()\d = Round(nList()\d, #PB_Round_Nearest)
                Case #PNB_TYPE_FLOAT
                  nList()\f = Round(nList()\f, #PB_Round_Nearest)
              EndSelect
            Next
            
            ;---Sqr
          Case "Sqr"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                Case #PNB_TYPE_POINTER
                  nList()\p = Sqr(nList()\p)
                Case #PNB_TYPE_DOUBLE
                  nList()\d = Sqr(nList()\d)
                Case #PNB_TYPE_FLOAT
                  nList()\f = Sqr(nList()\f)
                Case #PNB_TYPE_EPIC
                  nList()\q = Sqr(nList()\q)
                Case #PNB_TYPE_INTEGER
                  nList()\i = Sqr(nList()\i)
                Case #PNB_TYPE_LONG
                  nList()\l = Sqr(nList()\l)
                Case #PNB_TYPE_WORD
                  nList()\w = Sqr(nList()\w)
                Case #PNB_TYPE_BYTE
                  nList()\b = Sqr(nList()\b)
                Case #PNB_TYPE_UWORD
                  nList()\u = Sqr(nList()\u)
                Case #PNB_TYPE_CHARACTER
                  nList()\c = Sqr(nList()\c)
                Case #PNB_TYPE_UBYTE
                  nList()\a = Sqr(nList()\a)
              EndSelect
            Next
            ;---Ran
          Case "Ran", "Rand"
            DeleteElement(nList())
            If NextElement(nList())
              nListConvert(nList(), #PNB_TYPE_INTEGER)
              RINT = nList()\i
              DeleteElement(nList())
              If NextElement(nList())
                RCNT = nList()\i
                DeleteElement(nList())
              Else
                RCNT = 0
              EndIf
              If RCNT > RINT
                Swap RCNT, RINT
              EndIf
              RINT-RCNT
              RINT = Random(RINT)
              RINT+RCNT
              AddElement(nList())
              nList()\i = RINT
              nList()\Flags = #PNB_TYPE_INTEGER
            Else
              AddElement(nList())
              nList()\i = Random(#MAXLONG)-#MINLONG>>1
              nList()\Flags = #PNB_TYPE_INTEGER
            EndIf
            RINT = 0
            RCNT = 0
            ;-#Logic
            ;---Bool
          Case "Bool"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  RBOL = Bool(nList()\s = "True")
                Case #PNB_TYPE_STRING
                  RBOL = Bool(nList()\s = "True")
                Case #PNB_TYPE_POINTER
                  RBOL = Bool(nList()\p)
                Case #PNB_TYPE_DOUBLE
                  RBOL = Bool(nList()\d)
                Case #PNB_TYPE_FLOAT
                  RBOL = Bool(nList()\f)
                Case #PNB_TYPE_EPIC
                  RBOL = Bool(nList()\q)
                Case #PNB_TYPE_INTEGER
                  RBOL = Bool(nList()\i)
                Case #PNB_TYPE_LONG
                  RBOL = Bool(nList()\l)
                Case #PNB_TYPE_WORD
                  RBOL = Bool(nList()\w)
                Case #PNB_TYPE_BYTE
                  RBOL = Bool(nList()\b)
                Case #PNB_TYPE_UWORD
                  RBOL = Bool(nList()\u)
                Case #PNB_TYPE_CHARACTER
                  RBOL = Bool(nList()\c)
                Case #PNB_TYPE_UBYTE
                  RBOL = Bool(nList()\a)
              EndSelect
              DeleteElement(nList())
              AddElement(nList())
              nList()\i = RBOL
              nList()\Flags | #PNB_TYPE_INTEGER
              
            Next
            RBOL = 0
            
            ;---Eql
          Case "=", "==", "Eql"
            DeleteElement(nList())
            RBOL = 1
            If NextElement(nList())
              AddElement(cList1())
              cList1() = nList()
              DeleteElement(nList())
              ForEach nList()
                AddElement(cList2())
                cList2() = nList()
                DeleteElement(nList())
                RBOL = RBOL & nListCompare(cList1(), cList2())
                ClearList(cList2())
              Next
              ClearList(cList1())
              AddElement(nList())
              nList()\i = RBOL
              nList()\Flags | #PNB_TYPE_INTEGER
            Else
              AddElement(nList())
              nList()\i = 1
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            RBOL = 0
            
            ;---Neq
          Case "<>", "><", "Neq"
            DeleteElement(nList())
            RBOL = 1
            If NextElement(nList())
              AddElement(cList1())
              cList1() = nList()
              DeleteElement(nList())
              ForEach nList()
                AddElement(cList2())
                cList2() = nList()
                DeleteElement(nList())
                RBOL = RBOL & ~nListCompare(cList1(), cList2())
                ClearList(cList1())
                MergeLists(cList2(), cList1())
              Next
              ClearList(cList1())
              AddElement(nList())
              nList()\i = RBOL
              nList()\Flags | #PNB_TYPE_INTEGER
            Else
              AddElement(nList())
              nList()\i = 0
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            RBOL = 0
            
            ;---Lss
          Case "<", "Lss"
            DeleteElement(nList())
            RBOL = 1
            If NextElement(nList())
              RTYP = nListTypeFromList(nList())
              Select RTYP
                Case #PNB_TYPE_NAME
                  RBOL = 0
                  ClearList(nList())
                Case #PNB_TYPE_STRING
                  RBOL = 0
                  ClearList(nList())
                Default
                  nListConvert(nList(), RTYP)
                  Select RTYP
                    Case #PNB_TYPE_POINTER
                      *RPTR = nList()\p
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(*RPTR < nList()\p))
                        *RPTR = nList()\p
                        DeleteElement(nList())
                      Next
                      *RPTR = 0
                    Case #PNB_TYPE_DOUBLE
                      RDBL = nList()\d
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RDBL < nList()\d))
                        RDBL = nList()\d
                        DeleteElement(nList())
                      Next
                      RDBL = 0.0
                    Case #PNB_TYPE_FLOAT
                      RFLT = nList()\f
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RFLT < nList()\f))
                        RFLT = nList()\d
                        DeleteElement(nList())
                      Next
                      RFLT = 0.0
                    Case #PNB_TYPE_EPIC
                      RQUD = nList()\q
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RQUD < nList()\q))
                        RQUD = nList()\q
                        DeleteElement(nList())
                      Next
                      RQUD = 0
                    Case #PNB_TYPE_INTEGER
                      RINT = nList()\i
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RINT < nList()\i))
                        RINT = nList()\i
                        DeleteElement(nList())
                      Next
                      RINT = 0
                    Case #PNB_TYPE_LONG
                      RLNG = nList()\l
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RLNG < nList()\l))
                        RLNG = nList()\l
                        DeleteElement(nList())
                      Next
                      RLNG = 0
                    Case #PNB_TYPE_WORD
                      RWRD = nList()\w
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RWRD < nList()\w))
                        RWRD = nList()\w
                        DeleteElement(nList())
                      Next
                      RWRD = 0
                    Case #PNB_TYPE_BYTE
                      RBYT = nList()\b
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RBYT < nList()\b))
                        RBYT = nList()\b
                        DeleteElement(nList())
                      Next
                      RBYT = 0
                    Case #PNB_TYPE_UWORD
                      RUNI = nList()\u
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RUNI < nList()\u))
                        RUNI = nList()\u
                        DeleteElement(nList())
                      Next
                      RUNI = 0
                    Case #PNB_TYPE_CHARACTER
                      RCHR = nList()\c
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RCHR < nList()\c))
                        RCHR = nList()\c
                        DeleteElement(nList())
                      Next
                      RCHR = 0
                    Case #PNB_TYPE_UBYTE
                      RASC = nList()\a
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RASC < nList()\a))
                        RASC = nList()\a
                        DeleteElement(nList())
                      Next
                      RASC = 0
                  EndSelect
              EndSelect
              AddElement(nList())
              nList()\i = RBOL
              nList()\Flags | #PNB_TYPE_INTEGER
            Else
              AddElement(nList())
              nList()\i = 0
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            RBOL = 0
            
            ;---Leq
          Case "<=", "=<", "Leq"
            DeleteElement(nList())
            RBOL = 1
            If NextElement(nList())
              RTYP = nListTypeFromList(nList())
              Select RTYP
                Case #PNB_TYPE_NAME
                  RBOL = 0
                  ClearList(nList())
                Case #PNB_TYPE_STRING
                  RBOL = 0
                  ClearList(nList())
                Default
                  nListConvert(nList(), RTYP)
                  Select RTYP
                    Case #PNB_TYPE_POINTER
                      *RPTR = nList()\p
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(*RPTR <= nList()\p))
                        *RPTR = nList()\p
                        DeleteElement(nList())
                      Next
                      *RPTR = 0
                    Case #PNB_TYPE_DOUBLE
                      RDBL = nList()\d
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RDBL <= nList()\d))
                        RDBL = nList()\d
                        DeleteElement(nList())
                      Next
                      RDBL = 0.0
                    Case #PNB_TYPE_FLOAT
                      RFLT = nList()\f
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RFLT <= nList()\f))
                        RFLT = nList()\d
                        DeleteElement(nList())
                      Next
                      RFLT = 0.0
                    Case #PNB_TYPE_EPIC
                      RQUD = nList()\q
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RQUD <= nList()\q))
                        RQUD = nList()\q
                        DeleteElement(nList())
                      Next
                      RQUD = 0
                    Case #PNB_TYPE_INTEGER
                      RINT = nList()\i
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RINT <= nList()\i))
                        RINT = nList()\i
                        DeleteElement(nList())
                      Next
                      RINT = 0
                    Case #PNB_TYPE_LONG
                      RLNG = nList()\l
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RLNG <= nList()\l))
                        RLNG = nList()\l
                        DeleteElement(nList())
                      Next
                      RLNG = 0
                    Case #PNB_TYPE_WORD
                      RWRD = nList()\w
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RWRD <= nList()\w))
                        RWRD = nList()\w
                        DeleteElement(nList())
                      Next
                      RWRD = 0
                    Case #PNB_TYPE_BYTE
                      RBYT = nList()\b
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RBYT <= nList()\b))
                        RBYT = nList()\b
                        DeleteElement(nList())
                      Next
                      RBYT = 0
                    Case #PNB_TYPE_UWORD
                      RUNI = nList()\u
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RUNI <= nList()\u))
                        RUNI = nList()\u
                        DeleteElement(nList())
                      Next
                      RUNI = 0
                    Case #PNB_TYPE_CHARACTER
                      RCHR = nList()\c
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RCHR <= nList()\c))
                        RCHR = nList()\c
                        DeleteElement(nList())
                      Next
                      RCHR = 0
                    Case #PNB_TYPE_UBYTE
                      RASC = nList()\a
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RASC <= nList()\a))
                        RASC = nList()\a
                        DeleteElement(nList())
                      Next
                      RASC = 0
                  EndSelect
              EndSelect
              AddElement(nList())
              nList()\i = RBOL
              nList()\Flags | #PNB_TYPE_INTEGER
            Else
              AddElement(nList())
              nList()\i = 1
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            RBOL = 0
            ;---Gtr
          Case ">", "Gtr"
            DeleteElement(nList())
            RBOL = 1
            If NextElement(nList())
              RTYP = nListTypeFromList(nList())
              Select RTYP
                Case #PNB_TYPE_NAME
                  RBOL = 0
                  ClearList(nList())
                Case #PNB_TYPE_STRING
                  RBOL = 0
                  ClearList(nList())
                Default
                  nListConvert(nList(), RTYP)
                  Select RTYP
                    Case #PNB_TYPE_POINTER
                      *RPTR = nList()\p
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(*RPTR > nList()\p))
                        *RPTR = nList()\p
                        DeleteElement(nList())
                      Next
                      *RPTR = 0
                    Case #PNB_TYPE_DOUBLE
                      RDBL = nList()\d
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RDBL > nList()\d))
                        RDBL = nList()\d
                        DeleteElement(nList())
                      Next
                      RDBL = 0.0
                    Case #PNB_TYPE_FLOAT
                      RFLT = nList()\f
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RFLT > nList()\f))
                        RFLT = nList()\d
                        DeleteElement(nList())
                      Next
                      RFLT = 0.0
                    Case #PNB_TYPE_EPIC
                      RQUD = nList()\q
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RQUD > nList()\q))
                        RQUD = nList()\q
                        DeleteElement(nList())
                      Next
                      RQUD = 0
                    Case #PNB_TYPE_INTEGER
                      RINT = nList()\i
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RINT > nList()\i))
                        RINT = nList()\i
                        DeleteElement(nList())
                      Next
                      RINT = 0
                    Case #PNB_TYPE_LONG
                      RLNG = nList()\l
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RLNG > nList()\l))
                        RLNG = nList()\l
                        DeleteElement(nList())
                      Next
                      RLNG = 0
                    Case #PNB_TYPE_WORD
                      RWRD = nList()\w
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RWRD > nList()\w))
                        RWRD = nList()\w
                        DeleteElement(nList())
                      Next
                      RWRD = 0
                    Case #PNB_TYPE_BYTE
                      RBYT = nList()\b
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RBYT > nList()\b))
                        RBYT = nList()\b
                        DeleteElement(nList())
                      Next
                      RBYT = 0
                    Case #PNB_TYPE_UWORD
                      RUNI = nList()\u
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RUNI > nList()\u))
                        RUNI = nList()\u
                        DeleteElement(nList())
                      Next
                      RUNI = 0
                    Case #PNB_TYPE_CHARACTER
                      RCHR = nList()\c
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RCHR > nList()\c))
                        RCHR = nList()\c
                        DeleteElement(nList())
                      Next
                      RCHR = 0
                    Case #PNB_TYPE_UBYTE
                      RASC = nList()\a
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RASC > nList()\a))
                        RASC = nList()\a
                        DeleteElement(nList())
                      Next
                      RASC = 0
                  EndSelect
              EndSelect
              AddElement(nList())
              nList()\i = RBOL
              nList()\Flags | #PNB_TYPE_INTEGER
            Else
              AddElement(nList())
              nList()\i = 0
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            RBOL = 0
            
            ;---Geq
          Case ">=", "=>", "Geq"
            DeleteElement(nList())
            RBOL = 1
            If NextElement(nList())
              RTYP = nListTypeFromList(nList())
              Select RTYP
                Case #PNB_TYPE_NAME
                  RBOL = 0
                  ClearList(nList())
                Case #PNB_TYPE_STRING
                  RBOL = 0
                  ClearList(nList())
                Default
                  nListConvert(nList(), RTYP)
                  Select RTYP
                    Case #PNB_TYPE_POINTER
                      *RPTR = nList()\p
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(*RPTR >= nList()\p))
                        *RPTR = nList()\p
                        DeleteElement(nList())
                      Next
                      *RPTR = 0
                    Case #PNB_TYPE_DOUBLE
                      RDBL = nList()\d
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RDBL >= nList()\d))
                        RDBL = nList()\d
                        DeleteElement(nList())
                      Next
                      RDBL = 0.0
                    Case #PNB_TYPE_FLOAT
                      RFLT = nList()\f
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RFLT >= nList()\f))
                        RFLT = nList()\d
                        DeleteElement(nList())
                      Next
                      RFLT = 0.0
                    Case #PNB_TYPE_EPIC
                      RQUD = nList()\q
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RQUD >= nList()\q))
                        RQUD = nList()\q
                        DeleteElement(nList())
                      Next
                      RQUD = 0
                    Case #PNB_TYPE_INTEGER
                      RINT = nList()\i
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RINT >= nList()\i))
                        RINT = nList()\i
                        DeleteElement(nList())
                      Next
                      RINT = 0
                    Case #PNB_TYPE_LONG
                      RLNG = nList()\l
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RLNG >= nList()\l))
                        RLNG = nList()\l
                        DeleteElement(nList())
                      Next
                      RLNG = 0
                    Case #PNB_TYPE_WORD
                      RWRD = nList()\w
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RWRD >= nList()\w))
                        RWRD = nList()\w
                        DeleteElement(nList())
                      Next
                      RWRD = 0
                    Case #PNB_TYPE_BYTE
                      RBYT = nList()\b
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RBYT >= nList()\b))
                        RBYT = nList()\b
                        DeleteElement(nList())
                      Next
                      RBYT = 0
                    Case #PNB_TYPE_UWORD
                      RUNI = nList()\u
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RUNI >= nList()\u))
                        RUNI = nList()\u
                        DeleteElement(nList())
                      Next
                      RUNI = 0
                    Case #PNB_TYPE_CHARACTER
                      RCHR = nList()\c
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RCHR >= nList()\c))
                        RCHR = nList()\c
                        DeleteElement(nList())
                      Next
                      RCHR = 0
                    Case #PNB_TYPE_UBYTE
                      RASC = nList()\a
                      DeleteElement(nList())
                      ForEach nList()
                        RBOL = Bool(RBOL & Bool(RASC >= nList()\a))
                        RASC = nList()\a
                        DeleteElement(nList())
                      Next
                      RASC = 0
                  EndSelect
              EndSelect
              AddElement(nList())
              nList()\i = RBOL
              nList()\Flags | #PNB_TYPE_INTEGER
            Else
              AddElement(nList())
              nList()\i = 1
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            RBOL = 0
            
            ;---And
          Case "And", "&"
            DeleteElement(nList())
            RBOL = 1
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  RBOL = Bool(RBOL And Bool(nList()\s = "True"))
                Case #PNB_TYPE_STRING
                  RBOL = Bool(RBOL And Bool(nList()\s = "True"))
                Case #PNB_TYPE_POINTER
                  RBOL = Bool(RBOL And Bool(nList()\p))
                Case #PNB_TYPE_DOUBLE
                  RBOL = Bool(RBOL And Bool(nList()\d))
                Case #PNB_TYPE_FLOAT
                  RBOL = Bool(RBOL And Bool(nList()\f))
                Case #PNB_TYPE_EPIC
                  RBOL = Bool(RBOL And Bool(nList()\q))
                Case #PNB_TYPE_INTEGER
                  RBOL = Bool(RBOL And Bool(nList()\i))
                Case #PNB_TYPE_LONG
                  RBOL = Bool(RBOL And Bool(nList()\l))
                Case #PNB_TYPE_WORD
                  RBOL = Bool(RBOL And Bool(nList()\w))
                Case #PNB_TYPE_BYTE
                  RBOL = Bool(RBOL And Bool(nList()\b))
                Case #PNB_TYPE_UWORD
                  RBOL = Bool(RBOL And Bool(nList()\u))
                Case #PNB_TYPE_CHARACTER
                  RBOL = Bool(RBOL And Bool(nList()\c))
                Case #PNB_TYPE_UBYTE
                  RBOL = Bool(RBOL And Bool(nList()\a))
              EndSelect
              DeleteElement(nList())
            Next
            AddElement(nList())
            nList()\i = RBOL
            nList()\Flags | #PNB_TYPE_INTEGER
            
            RBOL = 0
            
            
            ;---bAnd
          Case "bAnd", "b&"
            DeleteElement(nList())
            If NextElement(nList())
              RTYP = nListGetHighestType(nList()\Flags)
              Select RTYP
                Case #PNB_TYPE_NAME
                  ClearList(nList())
                Case #PNB_TYPE_STRING
                  ClearList(nList())
                Default
                  RQUD = nList()\q
                  DeleteElement(nList())
                  ForEach nList()
                    RQUD&nList()\q
                    DeleteElement(nList())
                  Next
              EndSelect
              AddElement(nList())
              nList()\q = RQUD
              Select RTYP
                Case #PNB_TYPE_POINTER
                  *RPTR = nList()\p
                  nList()\q = 0
                  nList()\p = *RPTR
                  *RPTR = 0
                Case #PNB_TYPE_FLOAT
                  RLNG = nList()\l
                  nList()\q = 0
                  nList()\l = RLNG
                  RLNG = 0
                Case #PNB_TYPE_INTEGER
                  RINT = nList()\i
                  nList()\q = 0
                  nList()\l = RINT
                  RINT = 0
                Case #PNB_TYPE_LONG
                  RLNG = nList()\l
                  nList()\q = 0
                  nList()\l = RLNG
                  RLNG = 0
                Case #PNB_TYPE_WORD
                  RWRD = nList()\w
                  nList()\q = 0
                  nList()\l = RWRD
                  RWRD = 0
                Case #PNB_TYPE_BYTE
                  RBYT = nList()\b
                  nList()\q = 0
                  nList()\b = RBYT
                  RBYT = 0
                Case #PNB_TYPE_UWORD
                  RUNI = nList()\b
                  nList()\q = 0
                  nList()\u = RUNI
                  RUNI = 0
                Case #PNB_TYPE_CHARACTER
                  RCHR = nList()\c
                  nList()\q = 0
                  nList()\c = RCHR
                  RCHR = 0
                Case #PNB_TYPE_UBYTE
                  RASC = nList()\a
                  nList()\q = 0
                  nList()\a = RASC
                  RASC = 0
              EndSelect
              nList()\Flags = RTYP
              RTYP = 0
              RQUD = 0
            Else
              AddElement(nList())
              nList()\i = 0
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            
            ;---Or
          Case "Or", "|"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  RBOL = Bool(RBOL Or Bool(nList()\s = "True"))
                Case #PNB_TYPE_STRING
                  RBOL = Bool(RBOL Or Bool(nList()\s = "True"))
                Case #PNB_TYPE_POINTER
                  RBOL = Bool(RBOL Or Bool(nList()\p))
                Case #PNB_TYPE_DOUBLE
                  RBOL = Bool(RBOL Or Bool(nList()\d))
                Case #PNB_TYPE_FLOAT
                  RBOL = Bool(RBOL Or Bool(nList()\f))
                Case #PNB_TYPE_EPIC
                  RBOL = Bool(RBOL Or Bool(nList()\q))
                Case #PNB_TYPE_INTEGER
                  RBOL = Bool(RBOL Or Bool(nList()\i))
                Case #PNB_TYPE_LONG
                  RBOL = Bool(RBOL Or Bool(nList()\l))
                Case #PNB_TYPE_WORD
                  RBOL = Bool(RBOL Or Bool(nList()\w))
                Case #PNB_TYPE_BYTE
                  RBOL = Bool(RBOL Or Bool(nList()\b))
                Case #PNB_TYPE_UWORD
                  RBOL = Bool(RBOL Or Bool(nList()\u))
                Case #PNB_TYPE_CHARACTER
                  RBOL = Bool(RBOL Or Bool(nList()\c))
                Case #PNB_TYPE_UBYTE
                  RBOL = Bool(RBOL Or Bool(nList()\a))
              EndSelect
              DeleteElement(nList())
            Next
            AddElement(nList())
            nList()\i = RBOL
            nList()\Flags | #PNB_TYPE_INTEGER
            
            RBOL = 0
            
            ;---bOr
          Case "bOr", "b|"
            DeleteElement(nList())
            If NextElement(nList())
              RTYP = nListGetHighestType(nList()\Flags)
              Select RTYP
                Case #PNB_TYPE_NAME
                  ClearList(nList())
                Case #PNB_TYPE_STRING
                  ClearList(nList())
                Default
                  RQUD = nList()\q
                  DeleteElement(nList())
                  ForEach nList()
                    RQUD|nList()\q
                    DeleteElement(nList())
                  Next
              EndSelect
              AddElement(nList())
              nList()\q = RQUD
              Select RTYP
                Case #PNB_TYPE_POINTER
                  *RPTR = nList()\p
                  nList()\q = 0
                  nList()\p = *RPTR
                  *RPTR = 0
                Case #PNB_TYPE_FLOAT
                  RLNG = nList()\l
                  nList()\q = 0
                  nList()\l = RLNG
                  RLNG = 0
                Case #PNB_TYPE_INTEGER
                  RINT = nList()\i
                  nList()\q = 0
                  nList()\l = RINT
                  RINT = 0
                Case #PNB_TYPE_LONG
                  RLNG = nList()\l
                  nList()\q = 0
                  nList()\l = RLNG
                  RLNG = 0
                Case #PNB_TYPE_WORD
                  RWRD = nList()\w
                  nList()\q = 0
                  nList()\l = RWRD
                  RWRD = 0
                Case #PNB_TYPE_BYTE
                  RBYT = nList()\b
                  nList()\q = 0
                  nList()\b = RBYT
                  RBYT = 0
                Case #PNB_TYPE_UWORD
                  RUNI = nList()\b
                  nList()\q = 0
                  nList()\u = RUNI
                  RUNI = 0
                Case #PNB_TYPE_CHARACTER
                  RCHR = nList()\c
                  nList()\q = 0
                  nList()\c = RCHR
                  RCHR = 0
                Case #PNB_TYPE_UBYTE
                  RASC = nList()\a
                  nList()\q = 0
                  nList()\a = RASC
                  RASC = 0
              EndSelect
              nList()\Flags = RTYP
              RTYP = 0
              RQUD = 0
            Else
              AddElement(nList())
              nList()\i = 0
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            
            ;---XOr
          Case "XOr", "!"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  RBOL = Bool(RBOL XOr Bool(nList()\s = "True"))
                Case #PNB_TYPE_STRING
                  RBOL = Bool(RBOL XOr Bool(nList()\s = "True"))
                Case #PNB_TYPE_POINTER
                  RBOL = Bool(RBOL XOr Bool(nList()\p))
                Case #PNB_TYPE_DOUBLE
                  RBOL = Bool(RBOL XOr Bool(nList()\d))
                Case #PNB_TYPE_FLOAT
                  RBOL = Bool(RBOL XOr Bool(nList()\f))
                Case #PNB_TYPE_EPIC
                  RBOL = Bool(RBOL XOr Bool(nList()\q))
                Case #PNB_TYPE_INTEGER
                  RBOL = Bool(RBOL XOr Bool(nList()\i))
                Case #PNB_TYPE_LONG
                  RBOL = Bool(RBOL XOr Bool(nList()\l))
                Case #PNB_TYPE_WORD
                  RBOL = Bool(RBOL XOr Bool(nList()\w))
                Case #PNB_TYPE_BYTE
                  RBOL = Bool(RBOL XOr Bool(nList()\b))
                Case #PNB_TYPE_UWORD
                  RBOL = Bool(RBOL XOr Bool(nList()\u))
                Case #PNB_TYPE_CHARACTER
                  RBOL = Bool(RBOL XOr Bool(nList()\c))
                Case #PNB_TYPE_UBYTE
                  RBOL = Bool(RBOL XOr Bool(nList()\a))
              EndSelect
              DeleteElement(nList())
            Next
            AddElement(nList())
            nList()\i = RBOL
            nList()\Flags | #PNB_TYPE_INTEGER
            
            RBOL = 0
            
            ;---bXOr
          Case "bXOr", "b!"
            DeleteElement(nList())
            If NextElement(nList())
              RTYP = nListGetHighestType(nList()\Flags)
              Select RTYP
                Case #PNB_TYPE_NAME
                  ClearList(nList())
                Case #PNB_TYPE_STRING
                  ClearList(nList())
                Default
                  RQUD = nList()\q
                  DeleteElement(nList())
                  ForEach nList()
                    RQUD!nList()\q
                    DeleteElement(nList())
                  Next
              EndSelect
              AddElement(nList())
              nList()\q = RQUD
              Select RTYP
                Case #PNB_TYPE_POINTER
                  *RPTR = nList()\p
                  nList()\q = 0
                  nList()\p = *RPTR
                  *RPTR = 0
                Case #PNB_TYPE_FLOAT
                  RLNG = nList()\l
                  nList()\q = 0
                  nList()\l = RLNG
                  RLNG = 0
                Case #PNB_TYPE_INTEGER
                  RINT = nList()\i
                  nList()\q = 0
                  nList()\l = RINT
                  RINT = 0
                Case #PNB_TYPE_LONG
                  RLNG = nList()\l
                  nList()\q = 0
                  nList()\l = RLNG
                  RLNG = 0
                Case #PNB_TYPE_WORD
                  RWRD = nList()\w
                  nList()\q = 0
                  nList()\l = RWRD
                  RWRD = 0
                Case #PNB_TYPE_BYTE
                  RBYT = nList()\b
                  nList()\q = 0
                  nList()\b = RBYT
                  RBYT = 0
                Case #PNB_TYPE_UWORD
                  RUNI = nList()\b
                  nList()\q = 0
                  nList()\u = RUNI
                  RUNI = 0
                Case #PNB_TYPE_CHARACTER
                  RCHR = nList()\c
                  nList()\q = 0
                  nList()\c = RCHR
                  RCHR = 0
                Case #PNB_TYPE_UBYTE
                  RASC = nList()\a
                  nList()\q = 0
                  nList()\a = RASC
                  RASC = 0
              EndSelect
              nList()\Flags = RTYP
              RTYP = 0
              RQUD = 0
            Else
              AddElement(nList())
              nList()\i = 0
              nList()\Flags | #PNB_TYPE_INTEGER
            EndIf
            
            ;---Not  
          Case "Not", "~"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  RBOL = Bool(nList()\s = "True")
                Case #PNB_TYPE_STRING
                  RBOL = Bool(nList()\s = "True")
                Case #PNB_TYPE_POINTER
                  RBOL = Bool(nList()\p)
                Case #PNB_TYPE_DOUBLE
                  RBOL = Bool(nList()\d)
                Case #PNB_TYPE_FLOAT
                  RBOL = Bool(nList()\f)
                Case #PNB_TYPE_EPIC
                  RBOL = Bool(nList()\q)
                Case #PNB_TYPE_INTEGER
                  RBOL = Bool(nList()\i)
                Case #PNB_TYPE_LONG
                  RBOL = Bool(nList()\l)
                Case #PNB_TYPE_WORD
                  RBOL = Bool(nList()\w)
                Case #PNB_TYPE_BYTE
                  RBOL = Bool(nList()\b)
                Case #PNB_TYPE_UWORD
                  RBOL = Bool(nList()\u)
                Case #PNB_TYPE_CHARACTER
                  RBOL = Bool(nList()\c)
                Case #PNB_TYPE_UBYTE
                  RBOL = Bool(nList()\a)
              EndSelect
              DeleteElement(nList())
              AddElement(nList())
              nList()\i = Bool(Not RBOL)
              nList()\Flags | #PNB_TYPE_INTEGER
              
            Next
            RBOL = 0
            
            ;---bNot
          Case "bNot", "b~"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                Case #PNB_TYPE_POINTER
                  nList()\p = ~nList()\p
                Case #PNB_TYPE_DOUBLE
                  nList()\q = ~nList()\q
                Case #PNB_TYPE_FLOAT
                  nList()\l = ~nList()\l
                Case #PNB_TYPE_EPIC
                  nList()\q = ~nList()\q
                Case #PNB_TYPE_INTEGER
                  nList()\i = ~nList()\i
                Case #PNB_TYPE_LONG
                  nList()\l = ~nList()\l
                Case #PNB_TYPE_WORD
                  nList()\w = ~nList()\w
                Case #PNB_TYPE_BYTE
                  nList()\b = ~nList()\b
                Case #PNB_TYPE_UWORD
                  nList()\u = ~nList()\u
                Case #PNB_TYPE_CHARACTER
                  nList()\c = ~nList()\c
                Case #PNB_TYPE_UBYTE
                  nList()\a = ~nList()\a
              EndSelect
            Next
            
            ;-#Memory
            ;---Allocate
          Case "Allocate"
            DeleteElement(nList())
            ForEach nList()
              Select nListGetHighestType(nList()\Flags)
                Case #PNB_TYPE_NAME
                  DeleteElement(nList())
                Case #PNB_TYPE_STRING
                  DeleteElement(nList())
                Case #PNB_TYPE_POINTER
                  DeleteElement(nList())
                Case #PNB_TYPE_DOUBLE
                  *RPTR = AllocateMemory(nList()\d)
                  nList()\d = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_FLOAT
                  *RPTR = AllocateMemory(nList()\f)
                  nList()\f = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_EPIC
                  *RPTR = AllocateMemory(nList()\q)
                  nList()\q = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_INTEGER
                  *RPTR = AllocateMemory(nList()\i)
                  nList()\i = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_LONG
                  *RPTR = AllocateMemory(nList()\l)
                  nList()\l = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_WORD
                  *RPTR = AllocateMemory(nList()\w)
                  nList()\w = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_BYTE
                  *RPTR = AllocateMemory(nList()\b)
                  nList()\b = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_UWORD
                  *RPTR = AllocateMemory(nList()\u)
                  nList()\u = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_CHARACTER
                  *RPTR = AllocateMemory(nList()\c)
                  nList()\c = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
                Case #PNB_TYPE_UBYTE
                  *RPTR = AllocateMemory(nList()\a)
                  nList()\a = 0
                  nList()\p = *RPTR
                  nList()\Flags | #PNB_TYPE_POINTER
              EndSelect
              If *RPTR <> 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                If Not FindMapElement(*PLIST(), Str(*RPTR))
                  AddMapElement(*PLIST(), Str(*RPTR))
                Else
                  FreeMemory(*PLIST())
                  AddMapElement(*PLIST(), Str(*RPTR))
                EndIf
                *PLIST() = *RPTR
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
              EndIf
              *RPTR = 0
            Next
            
            ;---Free
          Case "Free"
            DeleteElement(nList())
            ForEach nList()
              If nList()\Flags & #PNB_TYPE_NAME
                If nList()\s = "All"
                  CompilerIf #PB_Compiler_Thread = 1
                    LockMutex(MutexMemMap)
                  CompilerEndIf
                  ForEach *PLIST()
                    FreeMemory(*PLIST())
                    DeleteMapElement(*PLIST())
                  Next
                  CompilerIf #PB_Compiler_Thread = 1
                    UnlockMutex(MutexMemMap)
                  CompilerEndIf
                EndIf
              ElseIf nList()\Flags & #PNB_TYPE_POINTER
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                If FindMapElement(*PLIST(), Str(nList()\p))
                  FreeMemory(nList()\p)
                  DeleteMapElement(*PLIST())
                Else
                  ResetMap(*PLIST())
                EndIf
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
              EndIf
              DeleteElement(nList())
            Next
            
            ;---Assert
          Case "Assert"
            DeleteElement(nList())
            ForEach nList()
              If nList()\Flags & #PNB_TYPE_POINTER
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                AddMapElement(*PLIST(), Str(nList()\p))
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
              EndIf
              DeleteElement(nList())
            Next
            
            ;---Relinquish
          Case "Relinquish"
            DeleteElement(nList())
            ForEach nList()
              If nList()\Flags & #PNB_TYPE_POINTER
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                If FindMapElement(*PLIST(), Str(nList()\p))
                  DeleteMapElement(*PLIST())
                Else
                  ResetMap(*PLIST())
                EndIf
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
              EndIf
              DeleteElement(nList())
            Next
            
            ;---Poke
          Case "Poke"
            DeleteElement(nList())
            If NextElement(nList())
              If nList()\Flags & #PNB_TYPE_POINTER
                *RPTR = nList()\p
                DeleteElement(nList())
                ForEach nList()
                  Select nListGetHighestType(nList()\Flags)
                    Case #PNB_TYPE_NAME
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeS(*RPTR, nList()\s)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+StringByteLength(nList()\s)+SizeOf(Character)
                    Case #PNB_TYPE_STRING
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeS(*RPTR, nList()\s)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+StringByteLength(nList()\s)+SizeOf(Character)
                    Case #PNB_TYPE_POINTER
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      If FindMapElement(*PLIST(), Str(nList()\p))
                        MoveMemory(*PLIST(), *RPTR, MemorySize(*PLIST()))
                        *RPTR+MemorySize(*PLIST())
                      Else
                        ResetMap(*PLIST())
                      EndIf
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                    Case #PNB_TYPE_DOUBLE
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeD(*RPTR, nList()\d)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Double)
                    Case #PNB_TYPE_FLOAT
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeF(*RPTR, nList()\f)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Float)
                    Case #PNB_TYPE_EPIC
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeQ(*RPTR, nList()\q)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Quad)
                    Case #PNB_TYPE_INTEGER
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeI(*RPTR, nList()\i)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Integer)
                    Case #PNB_TYPE_LONG
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeL(*RPTR, nList()\l)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Long)
                    Case #PNB_TYPE_WORD
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeW(*RPTR, nList()\w)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Word)
                    Case #PNB_TYPE_BYTE
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeB(*RPTR, nList()\b)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Byte)
                    Case #PNB_TYPE_UWORD
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeU(*RPTR, nList()\u)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Unicode)
                    Case #PNB_TYPE_CHARACTER
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeC(*RPTR, nList()\c)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Character)
                    Case #PNB_TYPE_UBYTE
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      PokeA(*RPTR, nList()\a)
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                      *RPTR+SizeOf(Ascii)
                  EndSelect
                  DeleteElement(nList())
                Next
              Else
                ClearList(nList())
              EndIf
            EndIf
            *RPTR = 0
            
            ;---Peek
          Case "Peek"
            DeleteElement(nList())
            If NextElement(nList())
              If nList()\Flags & #PNB_TYPE_POINTER
                *RPTR = nList()\p
                DeleteElement(nList())
                ForEach nList()
                  Select nListGetHighestType(nList()\Flags)
                    Case #PNB_TYPE_POINTER
                      CompilerIf #PB_Compiler_Thread = 1
                        LockMutex(MutexMemMap)
                      CompilerEndIf
                      If FindMapElement(*PLIST(), Str(nList()\p))
                        CopyMemory(*RPTR, *PLIST(), MemorySize(*PLIST()))
                        *RPTR+MemorySize(*PLIST())
                      Else
                        ResetMap(*PLIST())
                      EndIf
                      CompilerIf #PB_Compiler_Thread = 1
                        UnlockMutex(MutexMemMap)
                      CompilerEndIf
                    Case #PNB_TYPE_NAME
                      Select nList()\s
                        Case "Name"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\s = PeekS(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+StringByteLength(cList1()\s)+SizeOf(Character)
                          cList1()\Flags | #PNB_TYPE_NAME
                        Case "String"
                          AddElement(cList1())
                          cList1()\s = PeekS(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+StringByteLength(cList1()\s)+SizeOf(Character)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\Flags | #PNB_TYPE_STRING
                        Case "Double"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\d = PeekD(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Double)
                          cList1()\Flags | #PNB_TYPE_DOUBLE
                        Case "Float"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\f = PeekF(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Float)
                          cList1()\Flags | #PNB_TYPE_FLOAT
                        Case "Epic"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\q = PeekQ(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Quad)
                          cList1()\Flags | #PNB_TYPE_EPIC
                        Case "Integer"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\i = PeekI(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Integer)
                          cList1()\Flags | #PNB_TYPE_INTEGER
                        Case "Long"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\l = PeekL(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Long)
                          cList1()\Flags | #PNB_TYPE_LONG
                        Case "Word"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\w = PeekW(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Word)
                          cList1()\Flags | #PNB_TYPE_WORD
                        Case "Byte"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\b = PeekB(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Byte)
                          cList1()\Flags | #PNB_TYPE_BYTE
                        Case "UWord"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\u = PeekU(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Unicode)
                          cList1()\Flags | #PNB_TYPE_UWORD
                        Case "Character"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\c = PeekC(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Character)
                          cList1()\Flags | #PNB_TYPE_CHARACTER
                        Case "UByte"
                          AddElement(cList1())
                          CompilerIf #PB_Compiler_Thread = 1
                            LockMutex(MutexMemMap)
                          CompilerEndIf
                          cList1()\a = PeekA(*RPTR)
                          CompilerIf #PB_Compiler_Thread = 1
                            UnlockMutex(MutexMemMap)
                          CompilerEndIf
                          *RPTR+SizeOf(Ascii)
                          cList1()\Flags | #PNB_TYPE_UBYTE
                      EndSelect
                  EndSelect
                  DeleteElement(nList())
                Next
              Else
                ClearList(nList())
              EndIf
            EndIf
            
            MergeLists(cList1(), nList())
            *RPTR = 0
            
            ;-#Functions
          Default
            CompilerIf #PB_Compiler_Thread = 1
              LockMutex(MutexVarMap)
            CompilerEndIf
            If FindMapElement(Lexicon(), CAR)
              DeleteElement(nList())
              If FindMapElement(Param(), CAR)
                ResetList(Param()\nList())
              Else
                ResetMap(Param())
              EndIf
              If FindMapElement(ParamDefault(), CAR)
                ResetList(ParamDefault()\nList())
              Else
                ResetMap(ParamDefault())
              EndIf
              
              If ListSize(Param()\nList())
                If ListSize(ParamDefault()\nList());plus default param
                  If ListSize(nList()) <= ListSize(Param()\nList())
                    AddElement(cList1())
                    cList1() = Lexicon()
                    ForEach ParamDefault()\nList()
                      NextElement(Param()\nList())
                      If NextElement(nList())
                        nListReplace(cList1(), Param()\nList()\s, nList())
                        DeleteElement(nList())
                      Else
                        nListReplace(cList1(), Param()\nList()\s, ParamDefault()\nList())
                      EndIf
                    Next
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearList(nList())
                    nListEval(cList1()\nList())
                    MergeLists(cList1()\nList(), nList(), #PB_List_After)
                  Else
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearList(nList())
                  EndIf
                Else ;param list
                  If ListSize(Param()\nList()) = ListSize(nList())
                    AddElement(cList1())
                    cList1() = Lexicon()
                    ForEach Param()\nList()
                      NextElement(nList())
                      nListReplace(cList1(), Param()\nList()\s, nList())
                      DeleteElement(nList())
                    Next
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearList(nList())
                    nListEval(cList1()\nList())
                    MergeLists(cList1()\nList(), nList(), #PB_List_After)
                  Else
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearList(nList())
                  EndIf
                EndIf
                
              Else
                AddElement(cList1())
                cList1() = Lexicon()  
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(nList())
                nListEval(cList1()\nList())
                MergeLists(cList1()\nList(), nList(), #PB_List_After)
              EndIf
              
            Else
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
            EndIf
        EndSelect
      Else
      EndIf
    EndIf
    ProcedureReturn
  EndProcedure
  
  Procedure.s nListEvalString(String.s)
    Protected NewList nList.nList()
    Protected ReturnString.s
    nListPNBTonList(nList(), String)
    nListEval(nList())
    ReturnString = nListPNBToString(nList(), EnableBinary)
    nListClear(nList())
    ProcedureReturn ReturnString.s
  EndProcedure
  
  Procedure.i nListEvalThread(*nList.nListThread)
    nListEval(*nList\nList())
  EndProcedure
  
  Procedure.i nListEvalThreadFork(*nList.nListThread)
    nListEval(*nList\nList())
    ClearStructure(*nList, nListThread)
    FreeMemory(*nList)
  EndProcedure
  
EndModule