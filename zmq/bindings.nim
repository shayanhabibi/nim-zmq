{.deadCodeElim: on.}
when defined(windows):
  const
    zmqdll* = "(lib|)zmq.dll"
elif defined(macosx):
  const
    zmqdll* = "libzmq.dylib"
else:
  const
    zmqdll* = "libzmq.so(.4|.5|)"

import zmq/bindings/version; export version
import zmq/bindings/spec; export spec


# Socket Types
type
  TSocket {.final, pure.} = object
  ZSocket* = ptr TSocket

#****************************************************************************
#  0MQ infrastructure (a.k.a. context) initialisation & termination.
#****************************************************************************
type
  TContext {.final, pure.} = object
  ZContext* = ptr TContext


proc ctx_new*(): ZContext {.
    cdecl, importc: "zmq_ctx_new", dynlib: zmqdll
  .}
  
proc ctx_term*(context: ZContext): cint {.
    cdecl, importc: "zmq_ctx_term", dynlib: zmqdll
  .}

proc ctx_shutdown*(ctx: ZContext): cint {.
    cdecl, importc: "zmq_ctx_shutdown", dynlib: zmqdll
  .}

proc ctx_set*(context: ZContext, option: cint, optval: cint): cint {.
    cdecl, importc: "zmq_ctx_set", dynlib: zmqdll
  .}

proc ctx_get*(context: ZContext, option: cint): cint {.
    cdecl, importc: "zmq_ctx_get", dynlib: zmqdll
  .}

#****************************************************************************
#  0MQ message definition.
#****************************************************************************
type
  ZMsg* {.pure, final.} = object
    priv*: array[64, uint8] # Only using post 64 byte versions so no need
                            # for this to look like shit

  TFreeFn = proc (data, hint: pointer) {.noconv.}

# check that library version (from dynlib/dll/so) matches header version (from zmq.h)
# and that sizeof(zmq_msg_t) matches ZMsg
proc msg_init*(msg: var ZMsg): cint {.
    cdecl, importc: "zmq_msg_init", dynlib: zmqdll
  .}

proc msg_init*(msg: var ZMsg, size: int): cint {.
    cdecl, importc: "zmq_msg_init_size", dynlib: zmqdll
  .}

proc msg_init*(msg: var ZMsg, data: cstring, size: int,
                ffn: TFreeFn, hint: pointer             ): cint {.
    cdecl, importc: "zmq_msg_init_data", dynlib: zmqdll
  .}

proc msg_send*(msg: var ZMsg, s: ZSocket, flags: cint): cint {.
    cdecl, importc: "zmq_msg_send", dynlib: zmqdll
  .}

proc msg_recv*(msg: var ZMsg, s: ZSocket, flags: cint): cint {.
    cdecl, importc: "zmq_msg_recv", dynlib: zmqdll
  .}

proc msg_close*(msg: var ZMsg): cint {.
    cdecl, importc: "zmq_msg_close", dynlib: zmqdll
  .}

proc msg_move*(dest, src: var ZMsg): cint {.
    cdecl, importc: "zmq_msg_move", dynlib: zmqdll
  .}

proc msg_copy*(dest, src: var ZMsg): cint {.
    cdecl, importc: "zmq_msg_copy", dynlib: zmqdll
  .}

proc msg_data*(msg: var ZMsg): pointer {.
    cdecl, importc: "zmq_msg_data", dynlib: zmqdll
  .}

proc msg_size*(msg: var ZMsg): int {.
    cdecl, importc: "zmq_msg_size", dynlib: zmqdll
  .}

proc msg_more*(msg: var ZMsg): cint {.
    cdecl, importc: "zmq_msg_more", dynlib: zmqdll
  .}

proc msg_get*(msg: var ZMsg, option: cint): cint {.
    cdecl, importc: "zmq_msg_get", dynlib: zmqdll
  .}

proc msg_set*(msg: var ZMsg, option: cint, optval: cint): cint {.
    cdecl, importc: "zmq_msg_set", dynlib: zmqdll
  .}

#  Socket event data
type
  zmq_event_t* {.pure, final.} = object
    event*: uint16 # id of the event as bitfield
    value*: int32  # value is either error code, fd or reconnect interval

proc socket*(context: ZContext, theType: cint): ZSocket {.
    cdecl, importc: "zmq_socket", dynlib: zmqdll
  .}

proc close*(s: ZSocket): cint{.
    cdecl, importc: "zmq_close", dynlib: zmqdll
  .}

proc setsockopt*(s: ZSocket, option: ZSockOptions, optval: pointer,
                       optvallen: int): cint {.
    cdecl, importc: "zmq_setsockopt", dynlib: zmqdll
  .}

proc getsockopt*(s: ZSocket, option: ZSockOptions, optval: pointer,
                   optvallen: ptr int): cint {.
    cdecl, importc: "zmq_getsockopt", dynlib: zmqdll
  .}

proc bindAddr*(s: ZSocket, address: cstring): cint {.
    cdecl, importc: "zmq_bind", dynlib: zmqdll
  .}

proc connect*(s: ZSocket, address: cstring): cint {.
    cdecl, importc: "zmq_connect", dynlib: zmqdll
  .}

proc unbind*(s: ZSocket, address: cstring): cint {.
    cdecl, importc: "zmq_unbind", dynlib: zmqdll
  .}

proc disconnect*(s: ZSocket, address: cstring): cint {.
    cdecl, importc: "zmq_disconnect", dynlib: zmqdll
  .}

proc send*(s: ZSocket, buf: pointer, len: int, flags: cint): cint {.
    cdecl, importc: "zmq_send", dynlib: zmqdll
  .}

proc send_const*(s: ZSocket, buf: pointer, len: int, flags: cint): cint {.
    cdecl, importc: "zmq_send_const", dynlib: zmqdll
  .}

proc recv*(s: ZSocket, buf: pointer, len: int, flags: cint): cint {.
    cdecl, importc: "zmq_recv", dynlib: zmqdll
  .}

proc socket_monitor*(s: ZSocket, address: pointer, events: cint): cint {.
    cdecl, importc: "zmq_socket_monitor", dynlib: zmqdll
  .}

proc sendmsg*(s: ZSocket, msg: var ZMsg, flags: cint): cint {.
    cdecl, importc: "zmq_sendmsg", dynlib: zmqdll
  .}

proc recvmsg*(s: ZSocket, msg: var ZMsg, flags: cint): cint {.
    cdecl, importc: "zmq_recvmsg", dynlib: zmqdll
  .}


#****************************************************************************
#  I/O multiplexing.
#****************************************************************************

type
  ZPollItem*{.pure, final.} = object
    socket*: ZSocket
    fd*: cint
    events*: cshort
    revents*: cshort

const
  ZMQ_POLLITEMS_DFLT* = 16

proc poll*(items: ptr UncheckedArray[ZPollItem], nitems: cint, timeout: clong): cint {.
    cdecl, importc: "zmq_poll", dynlib: zmqdll
  .}

#  Built-in message proxy (3-way)
proc proxy*(frontend: ZSocket, backend: ZSocket, capture: ZSocket): cint {.
    cdecl, importc: "zmq_proxy", dynlib: zmqdll
  .}

proc proxy_steerable*(frontend: ZSocket, backend: ZSocket, capture: ZSocket,
            control: ZSocket): cint {.
    cdecl, importc: "zmq_proxy_steerable", dynlib: zmqdll
  .}

#  Encode a binary key as printable text using ZMQ RFC 32
proc z85_encode*(dest: cstring, data: ptr uint8, size: int): cstring {.
    cdecl, importc: "zmq_z85_encode", dynlib: zmqdll
  .}

#  Encode a binary key from printable text per ZMQ RFC 32
proc z85_decode*(dest: ptr uint8, string: cstring): ptr uint8 {.
    cdecl, importc: "zmq_z85_decode", dynlib: zmqdll
  .}

proc sanity_check_libzmq(): void =
  var actual_lib_major, actual_lib_minor, actual_lib_patch: cint
  version(actual_lib_major, actual_lib_minor, actual_lib_patch)

  let
    expected_lib_version {.used.} = make_dotted_version(ZMQ_VERSION_MAJOR,
        ZMQ_VERSION_MINOR, ZMQ_VERSION_PATCH)
    actual_lib_version = make_dotted_version(actual_lib_major, actual_lib_minor, actual_lib_patch)

  # This gives more flexibility wrt to versions, but set of API calls may differ
  if zmq_msg_t_size(actual_lib_version) != sizeof(ZMsg):
    raise newException(LibraryError, "expecting ZMsg size of " & $sizeof(ZMsg) &
        " but found " & $zmq_msg_t_size(actual_lib_version) & " from libzmq-" & actual_lib_version)

sanity_check_libzmq()
