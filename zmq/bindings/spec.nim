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

#****************************************************************************
#  0MQ socket definition.
#****************************************************************************

type
  ZSocketType* = enum
    PAIR = 0,
    PUB = 1,
    SUB = 2,
    REQ = 3,
    REP = 4,
    DEALER = 5,
    ROUTER = 6,
    PULL = 7,
    PUSH = 8,
    XPUB = 9,
    XSUB = 10,
    STREAM = 11
    SERVER = 12
    CLIENT = 13

type ZSockOptions* = enum
  AFFINITY = 4
  IDENTITY = 5
  SUBSCRIBE = 6
  UNSUBSCRIBE = 7
  RATE = 8
  RECOVERY_IVL = 9
  SNDBUF = 11
  RCVBUF = 12
  RCVMORE = 13
  FD = 14
  EVENTS = 15
  TYPE = 16
  LINGER = 17
  RECONNECT_IVL = 18
  BACKLOG = 19
  RECONNECT_IVL_MAX = 21
  MAXMSGSIZE = 22
  SNDHWM = 23
  RCVHWM = 24
  MULTICAST_HOPS = 25
  RCVTIMEO = 27
  SNDTIMEO = 28
  LAST_ENDPOINT = 32
  ROUTER_MANDATORY = 33
  TCP_KEEPALIVE = 34
  TCP_KEEPALIVE_CNT = 35
  TCP_KEEPALIVE_IDLE = 36
  TCP_KEEPALIVE_INTVL = 37
  TCP_ACCEPT_FILTER = 38
  IMMEDIATE = 39
  XPUB_VERBOSE = 40
  ROUTER_RAW = 41
  IPV6 = 42
  MECHANISM = 43
  PLAIN_SERVER = 44
  PLAIN_USERNAME = 45
  PLAIN_PASSWORD = 46
  CURVE_SERVER = 47
  CURVE_PUBLICKEY = 48
  CURVE_SECRETKEY = 49
  CURVE_SERVERKEY = 50
  PROBE_ROUTER = 51
  REQ_CORRELATE = 52
  REQ_RELAXED = 53
  CONFLATE = 54
  ZAP_DOMAIN = 55
  ROUTER_HANDOVER = 56
  TOS = 57
  CONNECT_RID = 61
  GSSAPI_SERVER = 62
  GSSAPI_PRINCIPAL = 63
  GSSAPI_SERVICE_PRINCIPAL = 64
  GSSAPI_PLAINTEXT = 65
  HANDSHAKE_IVL = 66
  SOCKS_PROXY = 68
  XPUB_NODROP = 69
  # BLOCKY = 70 # Used primarily in CTX options so changed to ZContextOptions
  XPUB_MANUAL = 71
  XPUB_WELCOME_MSG = 72
  STREAM_NOTIFY = 73
  INVERT_MATCHING = 74
  HEARTBEAT_IVL = 75
  HEARTBEAT_TTL = 76
  HEARTBEAT_TIMEOUT = 77
  XPUB_VERBOSE_UNSUBSCRIBE = 78
  CONNECT_TIMEOUT = 79
  TCP_RETRANSMIT_TIMEOUT = 80
  THREAD_SAFE = 81

#  Message options
type ZMsgOptions* = enum
  MORE = 1
  SRCFD = 2
  SHARED = 3

#  Send/recv options.
#  Added NOFLAGS option for default argument in send / receive function
type ZSendRecvOptions* = enum
  NOFLAGS = 0
  DONTWAIT = 1
  SNDMORE = 2

#  Security mechanisms
const
  ZMQ_NULL* = 0
  ZMQ_PLAIN* = 1
  ZMQ_CURVE* = 2
  ZMQ_GSSAPI* = 3

type
  ZSecurityOptions* = enum
    NULL = 0
    PLAIN = 1
    CURVE = 2
    GSSAPI = 3

#****************************************************************************
#  0MQ socket events and monitoring
#****************************************************************************
#  Socket transport events (tcp and ipc only)
const
  ZMQ_EVENT_CONNECTED* = 1
  ZMQ_EVENT_CONNECT_DELAYED* = 2
  ZMQ_EVENT_CONNECT_RETRIED* = 4
  ZMQ_EVENT_LISTENING* = 8
  ZMQ_EVENT_BIND_FAILED* = 16
  ZMQ_EVENT_ACCEPTED* = 32
  ZMQ_EVENT_ACCEPT_FAILED* = 64
  ZMQ_EVENT_CLOSED* = 128
  ZMQ_EVENT_CLOSE_FAILED* = 256
  ZMQ_EVENT_DISCONNECTED* = 512
  ZMQ_EVENT_MONITOR_STOPPED* = 1024
  ZMQ_EVENT_ALL* = (ZMQ_EVENT_CONNECTED or ZMQ_EVENT_CONNECT_DELAYED or
      ZMQ_EVENT_CONNECT_RETRIED or ZMQ_EVENT_LISTENING or
      ZMQ_EVENT_BIND_FAILED or ZMQ_EVENT_ACCEPTED or ZMQ_EVENT_ACCEPT_FAILED or
      ZMQ_EVENT_CLOSED or ZMQ_EVENT_CLOSE_FAILED or ZMQ_EVENT_DISCONNECTED or
      ZMQ_EVENT_MONITOR_STOPPED)

type
  ZSockEvent* = enum
    CONNECTED = 1
    CONNECT_DELAYED = 2
    CONNECT_RETRIED = 4
    LISTENING = 8
    BIND_FAILED = 16
    ACCEPTED = 32
    ACCEPT_FAILED = 64
    CLOSED = 128
    CLOSE_FAILED = 256
    DISCONNECTED = 512
    MONITOR_STOPPED = 1024
    ALL = (1 or 2 or 4 or 8 or 16 or 32 or 64 or 128 or 256 or 512 or 1024)

#****************************************************************************
#  0MQ errors.
#****************************************************************************
#  A number random enough not to collide with different errno ranges on
#  different OSes. The assumption is that error_t is at least 32-bit type.
const
  ZMQ_HAUSNUMERO* = 156384712
#  On Windows platform some of the standard POSIX errnos are not defined.
when not(defined(ENOTSUP)):
  const
    ENOTSUP* = (ZMQ_HAUSNUMERO + 1)
    EPROTONOSUPPORT* = (ZMQ_HAUSNUMERO + 2)
    ENOBUFS* = (ZMQ_HAUSNUMERO + 3)
    ENETDOWN* = (ZMQ_HAUSNUMERO + 4)
    EADDRINUSE* = (ZMQ_HAUSNUMERO + 5)
    EADDRNOTAVAIL* = (ZMQ_HAUSNUMERO + 6)
    ECONNREFUSED* = (ZMQ_HAUSNUMERO + 7)
    EINPROGRESS* = (ZMQ_HAUSNUMERO + 8)
    ENOTSOCK* = (ZMQ_HAUSNUMERO + 9)
    EMSGSIZE* = (ZMQ_HAUSNUMERO + 10)
    EAFNOSUPPORT* = (ZMQ_HAUSNUMERO + 11)
    ENETUNREACH* = (ZMQ_HAUSNUMERO + 12)
    ECONNABORTED* = (ZMQ_HAUSNUMERO + 13)
    ECONNRESET* = (ZMQ_HAUSNUMERO + 14)
    ENOTCONN* = (ZMQ_HAUSNUMERO + 15)
    ETIMEDOUT* = (ZMQ_HAUSNUMERO + 16)
    EHOSTUNREACH* = (ZMQ_HAUSNUMERO + 17)
    ENETRESET* = (ZMQ_HAUSNUMERO + 18)

#  Native 0MQ error codes.
const
  EFSM* = (ZMQ_HAUSNUMERO + 51)
  ENOCOMPATPROTO* = (ZMQ_HAUSNUMERO + 52)
  ETERM* = (ZMQ_HAUSNUMERO + 53)
  EMTHREAD* = (ZMQ_HAUSNUMERO + 54)

#  This function retrieves the errno as it is known to 0MQ library. The goal
#  of this function is to make the code 100% portable, including where 0MQ
#  compiled with certain CRT library (on Windows) is linked to an
#  application that uses different CRT library.
let ZMQ_EAGAIN* {.importc: "EAGAIN", header: "errno.h".}: cint
proc errno*(): cint{.cdecl, importc: "zmq_errno", dynlib: zmqdll.}

#  Resolves system errors and 0MQ errors to human-readable string.
proc strerror*(errnum: cint): cstring {.cdecl, importc: "zmq_strerror",
  dynlib: zmqdll.}

# Context Options
const
  ZMQ_IO_THREADS* = 1
  ZMQ_MAX_SOCKETS* = 2
  ZMQ_SOCKET_LIMIT* = 3
  ZMQ_THREAD_PRIORITY* = 3
  ZMQ_THREAD_SCHED_POLICY* = 4
  ZMQ_MAX_MSGZ* = 5
  ZMQ_MSG_T_SIZE* = 6
  ZMQ_THREAD_AFFINITY_CPU_ADD* = 7
  ZMQ_THREAD_AFFINITY_CPU_REMOVE* = 8
  ZMQ_THREAD_NAME_PREFIX* = 9
  ZMQ_BLOCKY* = 70

type ZContextOptions* = enum
  IO_THREADS = 1
  MAX_SOCKETS = 2
  SOCKET_LIMIT = 3
  # THREAD_PRIORITY = 3
  THREAD_SCHED_POLICY = 4
  MAX_MSGZ = 5
  MSG_T_SIZE = 6
  THREAD_AFFINITY_CPU_ADD = 7
  THREAD_AFFINITY_CPU_REMOVE = 8
  THREAD_NAME_PREFIX = 9
  ZMQ_IPV6 = 42
  BLOCKY = 70 # 4.2.0 + # NOTE - is a SOCKOPTION in def but is used in ctxs
#  Default for new contexts
const
  ZMQ_IO_THREADS_DFLT* = 1
  ZMQ_MAX_SOCKETS_DFLT* = 1023
  ZMQ_THREAD_PRIORITY_DFLT* = - 1
  ZMQ_THREAD_SCHED_POLICY_DFLT* = - 1

#****************************************************************************
#  I/O multiplexing.
#****************************************************************************
const
  ZMQ_POLLIN* = 1
  ZMQ_POLLOUT* = 2
  ZMQ_POLLERR* = 4
  ZMQ_POLLPRI* = 8
const
  ZMQ_POLLITEMS_DFLT* = 16
type
  ZPollFlag* = enum
    POLLIN = 1
    POLLOUT = 2
    POLLERR = 4
    POLLPRI = 8

template make_dotted_version*(major, minor, patch: untyped): string =
  $major & "." & $minor & "." & $patch

proc zmq_msg_t_size*(dotted_version: string): int =
  # From the zeromq repository and versions,
  # cos there isn't an ffi way to get it direct from libzmq,
  # and anyway ffi doesn't work at compile time.
  case dotted_version
  of "4.2.0":
    64
  of "4.1.5", "4.1.4", "4.1.3", "4.1.2", "4.1.1":
    64
  of "4.1.0":
    48
  of "4.0.8", "4.0.7", "4.0.6", "4.0.5", "4.0.4", "4.0.3", "4.0.2", "4.0.1", "4.0.0":
    32
  of "3.2.5", "3.2.4", "3.2.3", "3.2.2", "3.2.1", "3.1.0":
    32
  else:
    # assuming this is for newer versions.
    # It will probably stay at 64 for a while https://github.com/zeromq/libzmq/issues/1295
    64

# #  Socket types.
# const
#   ZMQ_PAIR* = 0
#   ZMQ_PUB* = 1
#   ZMQ_SUB* = 2
#   ZMQ_REQ* = 3
#   ZMQ_REP* = 4
#   ZMQ_DEALER* = 5
#   ZMQ_ROUTER* = 6
#   ZMQ_PULL* = 7
#   ZMQ_PUSH* = 8
#   ZMQ_XPUB* = 9
#   ZMQ_XSUB* = 10
#   ZMQ_STREAM* = 11
#   ZMQ_SERVER* = 12
#   ZMQ_CLIENT* = 13

# #  Deprecated aliases
# const
#   ZMQ_XREQ* = ZMQ_DEALER
#   ZMQ_XREP* = ZMQ_ROUTER

# #  Socket options.
# const
#   ZMQ_AFFINITY* = 4
#   ZMQ_IDENTITY* = 5
#   ZMQ_SUBSCRIBE* = 6
#   ZMQ_UNSUBSCRIBE* = 7
#   ZMQ_RATE* = 8
#   ZMQ_RECOVERY_IVL* = 9
#   ZMQ_SNDBUF* = 11
#   ZMQ_RCVBUF* = 12
#   ZMQ_RCVMORE* = 13
#   ZMQ_FD* = 14
#   ZMQ_EVENTS* = 15
#   ZMQ_TYPE* = 16
#   ZMQ_LINGER* = 17
#   ZMQ_RECONNECT_IVL* = 18
#   ZMQ_BACKLOG* = 19
#   ZMQ_RECONNECT_IVL_MAX* = 21
#   ZMQ_MAXMSGSIZE* = 22
#   ZMQ_SNDHWM* = 23
#   ZMQ_RCVHWM* = 24
#   ZMQ_MULTICAST_HOPS* = 25
#   ZMQ_RCVTIMEO* = 27
#   ZMQ_SNDTIMEO* = 28
#   ZMQ_LAST_ENDPOINT* = 32
#   ZMQ_ROUTER_MANDATORY* = 33
#   ZMQ_TCP_KEEPALIVE* = 34
#   ZMQ_TCP_KEEPALIVE_CNT* = 35
#   ZMQ_TCP_KEEPALIVE_IDLE* = 36
#   ZMQ_TCP_KEEPALIVE_INTVL* = 37
#   #ZMQ_TCP_ACCEPT_FILTER* = 38
#   ZMQ_IMMEDIATE* = 39
#   ZMQ_XPUB_VERBOSE* = 40
#   ZMQ_ROUTER_RAW* = 41
#   #ZMQ_IPV6* = 42
#   ZMQ_MECHANISM* = 43
#   ZMQ_PLAIN_SERVER* = 44
#   ZMQ_PLAIN_USERNAME* = 45
#   ZMQ_PLAIN_PASSWORD* = 46
#   ZMQ_CURVE_SERVER* = 47
#   ZMQ_CURVE_PUBLICKEY* = 48
#   ZMQ_CURVE_SECRETKEY* = 49
#   ZMQ_CURVE_SERVERKEY* = 50
#   ZMQ_PROBE_ROUTER* = 51
#   ZMQ_REQ_CORRELATE* = 52
#   ZMQ_REQ_RELAXED* = 53
#   ZMQ_CONFLATE* = 54
#   ZMQ_ZAP_DOMAIN* = 55
#   ZMQ_ROUTER_HANDOVER* = 56
#   ZMQ_TOS* = 57
#   #ZMQ_IPC_FILTER_PID* = 58
#   #ZMQ_IPC_FILTER_UID* = 59
#   #ZMQ_IPC_FILTER_GID* = 60
#   ZMQ_CONNECT_RID* = 61
#   ZMQ_GSSAPI_SERVER* = 62
#   ZMQ_GSSAPI_PRINCIPAL* = 63
#   ZMQ_GSSAPI_SERVICE_PRINCIPAL* = 64
#   ZMQ_GSSAPI_PLAINTEXT* = 65
#   ZMQ_HANDSHAKE_IVL* = 66
#   ZMQ_SOCKS_PROXY* = 68
#   ZMQ_XPUB_NODROP* = 69
#   ZMQ_BLOCKY* = 70
#   ZMQ_XPUB_MANUAL* = 71
#   ZMQ_XPUB_WELCOME_MSG* = 72
#   ZMQ_STREAM_NOTIFY* = 73
#   ZMQ_INVERT_MATCHING* = 74
#   ZMQ_HEARTBEAT_IVL* = 75
#   ZMQ_HEARTBEAT_TTL* = 76
#   ZMQ_HEARTBEAT_TIMEOUT* = 77
#   ZMQ_XPUB_VERBOSE_UNSUBSCRIBE* = 78
#   ZMQ_CONNECT_TIMEOUT* = 79
#   ZMQ_TCP_RETRANSMIT_TIMEOUT* = 80
#   ZMQ_THREAD_SAFE* = 81

# #  Message options
# const
#   ZMQ_MORE* = 1
#   ZMQ_SRCFD* = 2
#   ZMQ_SHARED* = 3

# const
#   ZMQ_DONTWAIT* = 1
#   ZMQ_SNDMORE* = 2
