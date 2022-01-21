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

#  Version macros for compile-time API version detection
const
  ZMQ_VERSION_MAJOR* = 4
  ZMQ_VERSION_MINOR* = 2
  ZMQ_VERSION_PATCH* = 0

template ZMQ_MAKE_VERSION*(major, minor, patch: untyped): untyped =
  ((major) * 10000 + (minor) * 100 + (patch))

const
  ZMQ_VERSION* = ZMQ_MAKE_VERSION(ZMQ_VERSION_MAJOR, ZMQ_VERSION_MINOR,
                                    ZMQ_VERSION_PATCH)

#  Run-time API version detection
proc version*(major: var cint, minor: var cint, patch: var cint){.cdecl,
  importc: "zmq_version", dynlib: zmqdll.}
