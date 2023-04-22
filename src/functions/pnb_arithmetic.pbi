Procedure PNB_Add(List nList.nList())
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
      
  EndSelect
  
EndProcedure

Procedure PNB_Sub(List nList.nList())
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
      
  EndSelect
  
EndProcedure

Procedure PNB_Mul(List nList.nList())
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
      
  EndSelect
  
EndProcedure

Procedure PNB_Div(List nList.nList())
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
      
  EndSelect
  
EndProcedure

Procedure PNB_Pow(List nList.nList())
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
      
  EndSelect
  
EndProcedure

Procedure PNB_Mod(List nList.nList())
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
          *RPTR%nList()\p
          DeleteElement(nList())
        EndIf
      Next
      AddElement(nList())
      nList()\p = *RPTR
      nList()\Flags | #PNB_TYPE_POINTER
      
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
      
  EndSelect
  
EndProcedure

Procedure PNB_Sign(List nList.nList())
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
        nList()\f = Sign(nList()\f)
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
EndProcedure

Procedure PNB_Abs(List nList.nList())
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
        nList()\f = Abs(nList()\f)
      Case #PNB_TYPE_EPIC
        If nList()\q < 0
          nList()\q = -nList()\q
        EndIf
      Case #PNB_TYPE_INTEGER
        If nList()\i < 0
          nList()\i = -nList()\i
        EndIf
      Case #PNB_TYPE_LONG
        If nList()\l < 0
          nList()\l = -nList()\l
        EndIf
      Case #PNB_TYPE_WORD
        If nList()\w < 0
          nList()\w = -nList()\w
        EndIf
      Case #PNB_TYPE_BYTE
        If nList()\b < 0
          nList()\b = -nList()\b
        EndIf
    EndSelect
  Next
  
EndProcedure

Procedure PNB_ASL(List nList.nList())
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
  
EndProcedure

Procedure PNB_ASR(List nList.nList())
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
  
EndProcedure

Procedure PNB_Sin(List nList.nList())
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
  
EndProcedure

Procedure PNB_ASin(List nList.nList())
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
  
EndProcedure

Procedure PNB_Cos(List nList.nList())
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
  
EndProcedure

Procedure PNB_ACos(List nList.nList())
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
  
EndProcedure

Procedure PNB_Tan(List nList.nList())
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
  
EndProcedure

Procedure PNB_ATan(List nList.nList())
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
  
EndProcedure

Procedure PNB_RoundUp(List nList.nList())
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
  
EndProcedure

Procedure PNB_RoundDown(List nList.nList())
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
  
EndProcedure

Procedure PNB_RoundNearest(List nList.nList())
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
  
EndProcedure

Procedure PNB_Square(List nList.nList())
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
  
EndProcedure

Procedure PNB_Random(List nList.nList())
  Protected RINT.i
  Protected RCNT.i
  
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
  
EndProcedure
