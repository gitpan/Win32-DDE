/*

#   DDE.xs

#   This file is to provide a direct interface to the ddeml.dll
#   provided with windows 3.1.

#   This file is an xs file wich means it will get (pre-)compiled
#   with the XSUB compiler provided with the current perl package.
#   before it gets compiled with the C compiler.

*/

#ifdef __cplusplus
extern "C" {
#endif
#include <windows.h>
#include <ddeml.h>
#include "wtypes.h"
#include "EXTERN.h"  
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#define RCS_STRING "$Id: dde.xs,v 1.2 1997/10/06 17:06:06 wegscd Exp wegscd $"


static int Debug=0;
static int Count=0;

/* static  CALLBACK *     pCb; */
static  FARPROC         fpProc;
static  SV *            PerlSub;


HANDLE  Module;

HDDEDATA CALLBACK
DDEML_Function(UINT wType, UINT wFmt, HCONV hConv, HSZ hsz1, HSZ hsz2,
	       HDDEDATA hData, DWORD dwData1, DWORD dwData2);


HDDEDATA CALLBACK
DDEML_Function(wType, wFmt, hConv, hsz1, hsz2, hData, dwData1, dwData2)
UINT wType;
UINT wFmt;
HCONV hConv;
HSZ hsz1;
HSZ hsz2;
HDDEDATA hData;
DWORD dwData1;
DWORD dwData2;
{
  
  HDDEDATA retval;
  int count;

  dSP;    /* Get a local copy of perls stack pointer */
  
  /* Create a boundry for any tempory variables */
  ENTER;
  SAVETMPS;
  PUSHMARK(sp);
  
  /* Push the variables onto the stack for the Perl sub. */
/*  XPUSHs(this); */
  XPUSHs(sv_2mortal(newSViv(wType)));
  XPUSHs(sv_2mortal(newSViv(wFmt)));
  XPUSHs(sv_2mortal(newSViv((IV)hConv)));
  XPUSHs(sv_2mortal(newSViv((IV)hsz1)));
  XPUSHs(sv_2mortal(newSViv((IV)hsz2)));
  XPUSHs(sv_2mortal(newSViv((IV)hData)));
  XPUSHs(sv_2mortal(newSViv(dwData1)));
  XPUSHs(sv_2mortal(newSViv(dwData2)));

  PUTBACK;
  
  /* Call the Perl sub */
  count = perl_call_sv(PerlSub, G_SCALAR);

  /* Check to make sure the number of returns is what we want */
  if (count != 1)
    croak("Wrong number of return vars from %s ", PerlSub);


  /* Refresh the local copy of the stack pointer, *
   * perl_call_sv could have realloced the space. */
  SPAGAIN;

/*
   ret = SvPV((SV *)POPs, len); 
   retval = DdeCreateDataHandle( ddeInstance, ret, len, 0, hszItem, wFmt, 0);
 */

  retval = (HDDEDATA)SvIV((SV *) POPs);

  /* Clean up the stack space from the Temporary boundry *
   * created earlier to the present position.            *
 */
         
  FREETMPS;
  LEAVE;
  
  return((HDDEDATA) retval);
}

static int not_here(char *s)
{
 croak("%s not implemented on this architecture", s);
 return -1;
}

static double
constant(name, arg)
char *name;
int arg;
{
    errno = 0;
    switch (*name) {
    case 'A':
	break;
    case 'B':
	break;
    case 'C':
	break;
    case 'D':
	if (strEQ(name, "DMLERR_ADVACKTIMEOUT"))
#ifdef DMLERR_ADVACKTIMEOUT
	    return DMLERR_ADVACKTIMEOUT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_BUSY"))
#ifdef DMLERR_BUSY
	    return DMLERR_BUSY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_DATAACKTIMEOUT"))
#ifdef DMLERR_DATAACKTIMEOUT
	    return DMLERR_DATAACKTIMEOUT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_DLL_NOT_INITIALIZED"))
#ifdef DMLERR_DLL_NOT_INITIALIZED
	    return DMLERR_DLL_NOT_INITIALIZED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_DLL_USAGE"))
#ifdef DMLERR_DLL_USAGE
	    return DMLERR_DLL_USAGE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_EXECACKTIMEOUT"))
#ifdef DMLERR_EXECACKTIMEOUT
	    return DMLERR_EXECACKTIMEOUT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_FIRST"))
#ifdef DMLERR_FIRST
	    return DMLERR_FIRST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_INVALIDPARAMETER"))
#ifdef DMLERR_INVALIDPARAMETER
	    return DMLERR_INVALIDPARAMETER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_LAST"))
#ifdef DMLERR_LAST
	    return DMLERR_LAST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_LOW_MEMORY"))
#ifdef DMLERR_LOW_MEMORY
	    return DMLERR_LOW_MEMORY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_MEMORY_ERROR"))
#ifdef DMLERR_MEMORY_ERROR
	    return DMLERR_MEMORY_ERROR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_NOTPROCESSED"))
#ifdef DMLERR_NOTPROCESSED
	    return DMLERR_NOTPROCESSED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_NO_CONV_ESTABLISHED"))
#ifdef DMLERR_NO_CONV_ESTABLISHED
	    return DMLERR_NO_CONV_ESTABLISHED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_NO_ERROR"))
#ifdef DMLERR_NO_ERROR
	    return DMLERR_NO_ERROR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_POKEACKTIMEOUT"))
#ifdef DMLERR_POKEACKTIMEOUT
	    return DMLERR_POKEACKTIMEOUT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_POSTMSG_FAILED"))
#ifdef DMLERR_POSTMSG_FAILED
	    return DMLERR_POSTMSG_FAILED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_REENTRANCY"))
#ifdef DMLERR_REENTRANCY
	    return DMLERR_REENTRANCY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_SERVER_DIED"))
#ifdef DMLERR_SERVER_DIED
	    return DMLERR_SERVER_DIED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_SYS_ERROR"))
#ifdef DMLERR_SYS_ERROR
	    return DMLERR_SYS_ERROR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_UNADVACKTIMEOUT"))
#ifdef DMLERR_UNADVACKTIMEOUT
	    return DMLERR_UNADVACKTIMEOUT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DMLERR_UNFOUND_QUEUE_ID"))
#ifdef DMLERR_UNFOUND_QUEUE_ID
	    return DMLERR_UNFOUND_QUEUE_ID;
#else
	    goto not_there;
#endif
	break;
    case 'E':
	break;
    case 'F':
	break;
    case 'G':
	break;
    case 'H':
	break;
    case 'I':
	break;
    case 'J':
	break;
    case 'K':
	break;
    case 'L':
	break;
    case 'M':
	break;
    case 'N':
	break;
    case 'O':
	break;
    case 'P':
	break;
    case 'Q':
	break;
    case 'R':
	break;
    case 'S':
	break;
    case 'T':
	break;
    case 'U':
	break;
    case 'V':
	break;
    case 'W':
	break;
    case 'X':
	if (strEQ(name, "XCLASS_BOOL"))
#ifdef XCLASS_BOOL
	    return XCLASS_BOOL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XCLASS_DATA"))
#ifdef XCLASS_DATA
	    return XCLASS_DATA;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XCLASS_FLAGS"))
#ifdef XCLASS_FLAGS
	    return XCLASS_FLAGS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XCLASS_MASK"))
#ifdef XCLASS_MASK
	    return XCLASS_MASK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XCLASS_NOTIFICATION"))
#ifdef XCLASS_NOTIFICATION
	    return XCLASS_NOTIFICATION;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_ADVACKRCVD"))
#ifdef XST_ADVACKRCVD
	    return XST_ADVACKRCVD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_ADVDATAACKRCVD"))
#ifdef XST_ADVDATAACKRCVD
	    return XST_ADVDATAACKRCVD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_ADVDATASENT"))
#ifdef XST_ADVDATASENT
	    return XST_ADVDATASENT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_ADVSENT"))
#ifdef XST_ADVSENT
	    return XST_ADVSENT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_CONNECTED"))
#ifdef XST_CONNECTED
	    return XST_CONNECTED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_DATARCVD"))
#ifdef XST_DATARCVD
	    return XST_DATARCVD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_EXECACKRCVD"))
#ifdef XST_EXECACKRCVD
	    return XST_EXECACKRCVD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_EXECSENT"))
#ifdef XST_EXECSENT
	    return XST_EXECSENT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_INCOMPLETE"))
#ifdef XST_INCOMPLETE
	    return XST_INCOMPLETE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_INIT1"))
#ifdef XST_INIT1
	    return XST_INIT1;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_INIT2"))
#ifdef XST_INIT2
	    return XST_INIT2;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_NULL"))
#ifdef XST_NULL
	    return XST_NULL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_POKEACKRCVD"))
#ifdef XST_POKEACKRCVD
	    return XST_POKEACKRCVD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_POKESENT"))
#ifdef XST_POKESENT
	    return XST_POKESENT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_REQSENT"))
#ifdef XST_REQSENT
	    return XST_REQSENT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_UNADVACKRCVD"))
#ifdef XST_UNADVACKRCVD
	    return XST_UNADVACKRCVD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XST_UNADVSENT"))
#ifdef XST_UNADVSENT
	    return XST_UNADVSENT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYPF_ACKREQ"))
#ifdef XTYPF_ACKREQ
	    return XTYPF_ACKREQ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYPF_NOBLOCK"))
#ifdef XTYPF_NOBLOCK
	    return XTYPF_NOBLOCK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYPF_NODATA"))
#ifdef XTYPF_NODATA
	    return XTYPF_NODATA;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_ADVDATA"))
#ifdef XTYP_ADVDATA
	    return XTYP_ADVDATA;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_ADVREQ"))
#ifdef XTYP_ADVREQ
	    return XTYP_ADVREQ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_ADVSTART"))
#ifdef XTYP_ADVSTART
	    return XTYP_ADVSTART;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_ADVSTOP"))
#ifdef XTYP_ADVSTOP
	    return XTYP_ADVSTOP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_CONNECT"))
#ifdef XTYP_CONNECT
	    return XTYP_CONNECT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_CONNECT_CONFIRM"))
#ifdef XTYP_CONNECT_CONFIRM
	    return XTYP_CONNECT_CONFIRM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_DISCONNECT"))
#ifdef XTYP_DISCONNECT
	    return XTYP_DISCONNECT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_ERROR"))
#ifdef XTYP_ERROR
	    return XTYP_ERROR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_EXECUTE"))
#ifdef XTYP_EXECUTE
	    return XTYP_EXECUTE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_MASK"))
#ifdef XTYP_MASK
	    return XTYP_MASK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_MONITOR"))
#ifdef XTYP_MONITOR
	    return XTYP_MONITOR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_POKE"))
#ifdef XTYP_POKE
	    return XTYP_POKE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_REGISTER"))
#ifdef XTYP_REGISTER
	    return XTYP_REGISTER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_REQUEST"))
#ifdef XTYP_REQUEST
	    return XTYP_REQUEST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_SHIFT"))
#ifdef XTYP_SHIFT
	    return XTYP_SHIFT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_UNREGISTER"))
#ifdef XTYP_UNREGISTER
	    return XTYP_UNREGISTER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_WILDCONNECT"))
#ifdef XTYP_WILDCONNECT
	    return XTYP_WILDCONNECT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "XTYP_XACT_COMPLETE"))
#ifdef XTYP_XACT_COMPLETE
	    return XTYP_XACT_COMPLETE;
#else
	    goto not_there;
#endif
	break;
    case 'Y':
	break;
    case 'Z':
	break;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}




MODULE = Win32::DDE		PACKAGE = Win32::DDE	PREFIX = w32_

PROTOTYPES: DISABLE

double
constant(name,arg)
	char *		name
	int		arg


IV
w32_DdeAbandonTransaction(idInst,hConv,idTrans)
    DWORD idInst
    HCONV hConv
    DWORD idTrans
CODE:
    RETVAL = DdeAbandonTransaction(idInst, hConv, idTrans);
OUTPUT:
    RETVAL

char *
w32_DdeAccessData(hData,cbData)
    HDDEDATA hData
    DWORD cbData
CODE:
    RETVAL = DdeAccessData(hData, &cbData);
    sv_setpvn((SV*)ST(0), RETVAL, cbData);
OUTPUT:
    cbData	if (RETVAL) { sv_setiv(ST(1), (U32)cbData); }
    RETVAL

HDDEDATA
w32_DdeAddData(hData,lpvSrcBuf,cbAddData,offObj)
    HDDEDATA hData
    char *lpvSrcBuf
    DWORD cbAddData
    DWORD offObj
CODE:
    RETVAL = DdeAddData(hData, lpvSrcBuf, cbAddData, offObj);
OUTPUT:
    RETVAL


HDDEDATA
w32_DdeClientTransaction(lpvData, cbData, hConv, hszItem, uFmt, uType, uTimeout, lpuResult)
    char *lpvData
    DWORD cbData
    HCONV hConv
    HSZ hszItem
    UINT uFmt
    UINT uType
    DWORD uTimeout
    LPDWORD lpuResult
CODE:
    if (cbData == 0)
	lpvData = (char *)NULL;
    RETVAL = DdeClientTransaction((char *) lpvData,
                                        (DWORD)cbData,
                                        (HCONV)hConv,
                                        (HSZ)hszItem,
                                        (UINT)uFmt,
                                        (UINT)uType,
                                        (DWORD)uTimeout, (DWORD FAR *)NULL);
OUTPUT:
    RETVAL

IV
w32_DdeCmpStringHandles(hsz1,hsz2)
    HSZ hsz1
    HSZ hsz2
CODE:
    RETVAL = DdeCmpStringHandles(hsz1, hsz2);
OUTPUT:
    RETVAL


HCONV
w32_DdeConnect(idInst, hszService, hszTopic)
    DWORD idInst
    HSZ hszService
    HSZ hszTopic
CODE:
    RETVAL = DdeConnect(idInst, hszService, hszTopic, NULL);
OUTPUT:
    RETVAL


HCONVLIST
w32_DdeConnectList(idInst, hszService, hszTopic, hConvList)
    DWORD idInst
    HSZ hszService
    HSZ hszTopic
    HCONVLIST hConvList
CODE:
    RETVAL = DdeConnectList(idInst, hszService, hszTopic, hConvList, NULL);
OUTPUT:
    RETVAL

HDDEDATA
w32_DdeCreateDataHandle(idInst, lpvSrcBuf, cbInitData, offSrcBuf, hszItem, uFmt, afCmd)
    DWORD idInst
    char *lpvSrcBuf
    DWORD cbInitData
    DWORD offSrcBuf
    HSZ hszItem
    UINT uFmt
    UINT afCmd
CODE:
    RETVAL = DdeCreateDataHandle(
		     idInst, lpvSrcBuf, cbInitData, offSrcBuf,
		     hszItem, uFmt, afCmd);
OUTPUT:
    RETVAL

HSZ
w32_DdeCreateStringHandle(idInst, lpszString, codepage)
    DWORD idInst
    char *lpszString
    int codepage
CODE:
    RETVAL = DdeCreateStringHandle(idInst, lpszString, codepage);
OUTPUT:
    RETVAL

IV
w32_DdeDisconnect(hConv)
    HCONV hConv
CODE:
    RETVAL = DdeDisconnect(hConv);
OUTPUT:
    RETVAL

IV
w32_DdeDisconnectList(hConvList)
    HCONVLIST hConvList
CODE:
    RETVAL = DdeDisconnectList(hConvList);
OUTPUT:
    RETVAL

IV
w32_DdeEnableCallback(idInst, hConv, uCmd)
    DWORD idInst
    HCONV hConv
    UINT uCmd
CODE:
    RETVAL = DdeEnableCallback(idInst, hConv, uCmd);
OUTPUT:
    RETVAL

IV
w32_DdeFreeDataHandle(hData)
    HDDEDATA hData
CODE:
    RETVAL = DdeFreeDataHandle(hData);
OUTPUT:
    RETVAL

IV
w32_DdeFreeStringHandle(idInst, hsz)
    DWORD idInst
    HSZ hsz
CODE:
    RETVAL = DdeFreeStringHandle(idInst, hsz);
OUTPUT:
    RETVAL

IV
w32_DdeGetData(hData, pDest, cbMax, offSrc)
    HDDEDATA hData
    char *pDest = NO_INIT
    DWORD cbMax
    DWORD offSrc
CODE:
    /* if size spec is 0 then user wants to get size of buffer */
    /* getdata needs pDest to be zero to give the size */
    if (cbMax == 0)
	pDest = NULL;
    else
	pDest = malloc((size_t) cbMax + 1);
    RETVAL = DdeGetData(hData, pDest, cbMax, offSrc);

    /* if pDest == 0 then we are looking for size only */
    /* changed to cbMax because pDest is a pointer to a string containing 0 */
    if(cbMax != 0)
	sv_setpvn(ST(1), pDest, cbMax);
    free(pDest);
OUTPUT:
    RETVAL

IV
w32_DdeGetLastError(idInst)
    DWORD idInst
CODE:
    RETVAL = DdeGetLastError(idInst);
OUTPUT:
    RETVAL

IV
w32_DdeInitialize(lpidInst, pfnCallback, afCmd, uRes)
    DWORD lpidInst
    SV *pfnCallback
    DWORD afCmd
    DWORD uRes
CODE:
    if (Count) {
	Count++;
	RETVAL = 0;
    }
    else {
	fpProc = MakeProcInstance((FARPROC)DDEML_Function, ghInstance);
	if (fpProc == 0)
	    RETVAL = DMLERR_MEMORY_ERROR;
	else {
	    PerlSub = pfnCallback;
	    RETVAL = DdeInitialize(&lpidInst, (PFNCALLBACK)fpProc,afCmd,uRes);
	}
    }
OUTPUT:
    lpidInst	sv_setiv(ST(0), (U32)lpidInst);              
    RETVAL

IV
w32_DdeKeepStringHandle(idInst, hsz)
    DWORD idInst
    HSZ hsz
CODE:
    RETVAL = DdeKeepStringHandle(idInst, hsz);
OUTPUT:
    RETVAL

HDDEDATA
w32_DdeNameService(idInst, hsz1, hszRes, afCmd)
    DWORD idInst
    HSZ hsz1
    HSZ hszRes
    UINT afCmd
CODE:
    RETVAL = DdeNameService(idInst, hsz1, hszRes, afCmd);
OUTPUT:
    RETVAL

IV
w32_DdePostAdvise(idInst, hszTopic, hszItem)
    DWORD idInst
    HSZ hszTopic
    HSZ hszItem
CODE:
    RETVAL = DdePostAdvise(idInst, hszTopic, hszItem);
OUTPUT:
    RETVAL

IV
w32_DdeQueryConvInfo(hConv, idTransaction, lpConvInfo)
    HCONV hConv
    DWORD idTransaction
    char *lpConvInfo
CODE:
    RETVAL = DdeQueryConvInfo(hConv, idTransaction, (CONVINFO FAR *)lpConvInfo);
OUTPUT:
    RETVAL

HCONV
w32_DdeQueryNextServer(hConvList, hConvPrev)
    HCONVLIST hConvList
    HCONV hConvPrev
CODE:
    RETVAL = DdeQueryNextServer(hConvList, hConvPrev);
OUTPUT:
    RETVAL

IV
w32_DdeQueryString(idInst, hsz, lpsz, cchMax, codepage)
    DWORD idInst
    HSZ hsz
    char *lpsz
    DWORD cchMax
    int codepage
CODE:
    RETVAL = DdeQueryString(idInst, hsz, lpsz, cchMax, codepage);
OUTPUT:
    lpsz	if (RETVAL) sv_setpvn(ST(2), lpsz, cchMax);
    RETVAL

HCONV
w32_DdeReconnect(hConv)
    HCONV hConv
CODE:
    RETVAL = DdeReconnect(hConv);
OUTPUT:
    RETVAL

IV
w32_DdeSetUserHandle(hConv,id, hUser)
    HCONV hConv
    DWORD id
    DWORD hUser
CODE:
    RETVAL = DdeSetUserHandle(hConv, id, hUser);
OUTPUT:
    RETVAL

IV
w32_DdeUnaccessData(hData)
    HDDEDATA hData
CODE:
    RETVAL = DdeUnaccessData(hData);
OUTPUT:
    RETVAL

IV
w32_DdeUninitialize(idInst)
    DWORD idInst
CODE:
    if (Count > 1) { 
	Count--;
	RETVAL = 1;
    }
    else {
	if (Count == 1) {
	    RETVAL = DdeUninitialize(idInst);
	    if (RETVAL != 0) {
		FreeProcInstance( fpProc );
		Count--;
		RETVAL = 1; /* ensure we can use neg nubers for next error */
	    }
	    /* if retval is 0 then the 0 will fall through */
	    /* => 1 = success, 0 = dde fail, -1 = user stupidity */
	}
	else
	    RETVAL = -1; /* errors, uninitialize before initialize. */
    }
OUTPUT:
    RETVAL

char *
w32_Dde_XS_rcs_string()
#--------------------
CODE:
 RETVAL = RCS_STRING;
#--------------------
OUTPUT:
 RETVAL

char *
w32_Dde_XS_compile_date()
#--------------------
CODE:
 RETVAL = __DATE__ " " __TIME__;
#--------------------
OUTPUT:
 RETVAL
