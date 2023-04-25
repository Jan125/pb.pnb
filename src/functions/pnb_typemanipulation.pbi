Procedure PNB_Split(List nList.nList())
  Protected RCNT.i
  
  Protected NewList cList1.nList()
  
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
  
EndProcedure

Procedure PNB_Fuse(List nList.nList())
  Protected RSTR.s
  
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME
        RSTR+nList()\s
      Case #PNB_TYPE_STRING
        RSTR+nList()\s
      Case #PNB_TYPE_POINTER
        RSTR+Chr(nList()\p)
      Case #PNB_TYPE_DOUBLE
        RSTR+Chr(nList()\d)
      Case #PNB_TYPE_FLOAT
        RSTR+Chr(nList()\f)
      Case #PNB_TYPE_EPIC
        RSTR+Chr(nList()\q)
      Case #PNB_TYPE_INTEGER
        RSTR+Chr(nList()\i)
      Case #PNB_TYPE_LONG
        RSTR+Chr(nList()\l)
      Case #PNB_TYPE_WORD
        RSTR+Chr(nList()\w)
      Case #PNB_TYPE_BYTE
        RSTR+Chr(nList()\b)
      Case #PNB_TYPE_UWORD
        RSTR+Chr(nList()\u)
      Case #PNB_TYPE_CHARACTER
        RSTR+Chr(nList()\c)
      Case #PNB_TYPE_UBYTE
        RSTR+Chr(nList()\a)
    EndSelect
    DeleteElement(nList())
  Next
  AddElement(nList())
  nList()\s = RSTR
  nList()\Flags | #PNB_TYPE_STRING
  
EndProcedure

Procedure PNB_Type(List nList.nList())
  Protected RSTR.s
  
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
  
EndProcedure

Procedure PNB_Name(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_NAME, 1)
  
EndProcedure

Procedure PNB_String(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_STRING, 1)
  
EndProcedure

Procedure PNB_Pointer(List nList.nList())
  Protected *RPTR
  
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
  
EndProcedure

Procedure PNB_Double(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_DOUBLE, 1)
  
EndProcedure

Procedure PNB_Float(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_FLOAT, 1)
  
EndProcedure

Procedure PNB_Epic(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_EPIC, 1)
  
EndProcedure

Procedure PNB_Integer(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_INTEGER, 1)
  
EndProcedure

Procedure PNB_Long(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_LONG, 1)
  
EndProcedure

Procedure PNB_Word(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_WORD, 1)
  
EndProcedure

Procedure PNB_Byte(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_BYTE, 1)
  
EndProcedure

Procedure PNB_UWord(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_UWORD, 1)
  
EndProcedure

Procedure PNB_Character(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_CHARACTER, 1)
  
EndProcedure

Procedure PNB_UByte(List nList.nList())
  nListConvert(nList(), #PNB_TYPE_UBYTE, 1)
  
EndProcedure

Procedure PNB_ForceName(List nList.nList())
  ForEach nList()
    nList()\Flags = #PNB_TYPE_NAME
    nList()\q = 0
  Next
  
EndProcedure

Procedure PNB_ForceString(List nList.nList())
  ForEach nList()
    nList()\Flags = #PNB_TYPE_STRING
    nList()\q = 0
  Next
  
EndProcedure

Procedure PNB_ForcePointer(List nList.nList())
  Protected *RPTR
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_POINTER
    *RPTR = nList()\p
    nList()\q = 0
    nList()\p = *RPTR
  Next
  
EndProcedure

Procedure PNB_ForceDouble(List nList.nList())
  Protected RDBL.d
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_DOUBLE
    RDBL = nList()\d
    nList()\q = 0
    nList()\d = RDBL
  Next
  
EndProcedure

Procedure PNB_ForceFloat(List nList.nList())
  Protected RFLT.f
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_FLOAT
    RFLT = nList()\f
    nList()\q = 0
    nList()\f = RFLT
  Next
  
EndProcedure

Procedure PNB_ForceEpic(List nList.nList())
  ForEach nList()
    nList()\Flags = #PNB_TYPE_EPIC
  Next
  
EndProcedure

Procedure PNB_ForceInteger(List nList.nList())
  Protected RINT.i
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_INTEGER
    RINT = nList()\i
    nList()\q = 0
    nList()\i = RINT
  Next
  
EndProcedure

Procedure PNB_ForceLong(List nList.nList())
  Protected RLNG.l
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_LONG
    RLNG = nList()\l
    nList()\q = 0
    nList()\l = RLNG
  Next
  
EndProcedure

Procedure PNB_ForceWord(List nList.nList())
  Protected RWRD.w
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_WORD
    RWRD = nList()\w
    nList()\q = 0
    nList()\w = RWRD
  Next
  
EndProcedure

Procedure PNB_ForceByte(List nList.nList())
  Protected RBYT.b
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_BYTE
    RBYT = nList()\b
    nList()\q = 0
    nList()\b = RBYT
  Next
  
EndProcedure

Procedure PNB_ForceUWord(List nList.nList())
  Protected RUNI.u
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_UWORD
    RUNI = nList()\u
    nList()\q = 0
    nList()\u = RUNI
  Next
  
EndProcedure

Procedure PNB_ForceCharacter(List nList.nList())
  Protected RCHR.c
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_CHARACTER
    RCHR = nList()\c
    nList()\q = 0
    nList()\c = RCHR
  Next
  
EndProcedure

Procedure PNB_ForceUByte(List nList.nList())
  Protected RASC.a
  
  ForEach nList()
    nList()\Flags = #PNB_TYPE_UBYTE
    RASC = nList()\a
    nList()\q = 0
    nList()\a = RASC
  Next
  
EndProcedure
