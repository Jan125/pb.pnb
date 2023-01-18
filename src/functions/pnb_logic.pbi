Procedure PNB_Bool(List nList.nList())
  Protected RBOL.i
  
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
  
EndProcedure

Procedure PNB_Eql(List nList.nList())
  Protected RBOL.i
  Protected NewList cList1.nList()
  Protected NewList cList2.nList()
  
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
      ClearList(cList1())
      MergeLists(cList2(), cList1())
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
  
EndProcedure

Procedure PNB_Neq(List nList.nList())
  Protected RBOL.i
  
  Protected NewList cList1.nList()
  Protected NewList cList2.nList()
  
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
  
EndProcedure

Procedure PNB_Lss(List nList.nList())
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
              RFLT = nList()\f
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
  
EndProcedure

Procedure PNB_Leq(List nList.nList())
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
              RFLT = nList()\f
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
  
EndProcedure


Procedure PNB_Gtr(List nList.nList())
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
              RFLT = nList()\f
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
  
EndProcedure

Procedure PNB_Geq(List nList.nList())
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
              RFLT = nList()\f
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
  
EndProcedure

Procedure PNB_And(List nList.nList())
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
  
EndProcedure

Procedure PNB_bAnd(List nList.nList())
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
  
EndProcedure


Procedure PNB_Or(List nList.nList())
  Protected RBOL.i
  
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
  
EndProcedure

Procedure PNB_bOr(List nList.nList())
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
  
EndProcedure

Procedure PNB_XOr(List nList.nList())
  Protected RBOL.i
  
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
  
EndProcedure

Procedure PNB_bXOr(List nList.nList())
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
  
EndProcedure

Procedure PNB_Not(List nList.nList())
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
  
EndProcedure

Procedure PNB_bNot(List nList.nList())
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
  
EndProcedure
