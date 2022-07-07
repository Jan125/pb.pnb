Procedure PNB_Allocate(List nList.nList())
  Protected *RPTR
  
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
  
EndProcedure

Procedure PNB_Free(List nList.nList())
  Protected *RPTR
  
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
  
EndProcedure

Procedure PNB_Assert(List nList.nList())
  ForEach nList()
    If nList()\Flags & #PNB_TYPE_POINTER
      CompilerIf #PB_Compiler_Thread = 1
        LockMutex(MutexMemMap)
      CompilerEndIf
      AddMapElement(*PLIST(), Str(nList()\p))
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexMemMap)
      CompilerEndIf
    EndIf
    DeleteElement(nList())
  Next
  
EndProcedure

Procedure PNB_Relinquish(List nList.nList())
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
        UnlockMutex(MutexMemMap)
      CompilerEndIf
    EndIf
    DeleteElement(nList())
  Next
  
EndProcedure

Procedure PNB_Poke(List nList.nList())
  Protected *RPTR
  
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
  
EndProcedure

Procedure PNB_Peek(List nList.nList())
  Protected *RPTR
  
  Protected NewList cList1.nList()
  
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
  
EndProcedure
