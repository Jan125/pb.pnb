Procedure PNB_Element(List nList.nList())
  Protected RBOL.i
  Protected RINT.i
  Protected RSTR.s
  
  Protected NewList cList1.nList()
  
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
      Case #PNB_TYPE_NAME
        RBOL = 1
        RSTR = nList()\s
    EndSelect
    DeleteElement(nList())
    If RBOL
      If RSTR = "All"
        
      ElseIf RINT-1 >= 0 And RINT-1 <= ListSize(nList())
        If SelectElement(nList(), RINT-1)
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
    Else
      ClearList(nList())
    EndIf
  Else
    ClearList(nList())
  EndIf
  
EndProcedure

Procedure PNB_Discard(List nList.nList())
  ClearList(nList())
  
EndProcedure


Procedure PNB_Invert(List nList.nList())
  Protected NewList cList1.nList()
  
  ForEach nList()
    InsertElement(cList1())
    cList1() = nList()
  Next
  ClearList(nList())
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Size(List nList.nList())
  Protected RINT.i
  
  RINT = ListSize(nList())
  ClearList(nList())
  AddElement(nList())
  nList()\i = RINT
  nList()\Flags | #PNB_TYPE_INTEGER
  
EndProcedure

Procedure PNB_Offset(List nList.nList())
  Protected RINT.i
  
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_POINTER
        
      Case #PNB_TYPE_STRING
        RINT+StringByteLength(nList()\s)
      Case #PNB_TYPE_BYTE
        RINT+SizeOf(Byte)
      Case #PNB_TYPE_UBYTE
        RINT+SizeOf(Ascii)
      Case #PNB_TYPE_CHARACTER
        RINT+SizeOf(Character)
      Case #PNB_TYPE_WORD
        RINT+SizeOf(Word)
      Case #PNB_TYPE_UWORD
        RINT+SizeOf(Unicode)
      Case #PNB_TYPE_Long
        RINT+SizeOf(Long)
      Case #PNB_TYPE_INTEGER
        RINT+SizeOf(Integer)
      Case #PNB_TYPE_EPIC
        RINT+SizeOf(Quad)
      Case #PNB_TYPE_FLOAT
        RINT+SizeOf(Float)
      Case #PNB_TYPE_DOUBLE
        RINT+SizeOf(Double)
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
  
EndProcedure


