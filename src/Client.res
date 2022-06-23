module Make = (Messages: Messages.S) => {
  type t
  type options
  @obj
  external options: (
    ~transports: array<[#polling | #websocket]>=?,
    ~upgrade: bool=?,
    ~rememberUpgrade: bool=?,
    ~path: string=?,
    ~query: {..}=?,
    ~extraHeaders: {..}=?,
    ~withCredentials: bool=?,
    ~forceBase64: bool=?,
    ~timestampRequests: bool=?,
    ~timestampParam: string=?,
    ~closeOnBeforeunload: bool=?,
    ~protocols: array<string>=?,
    ~autoUnref: bool=?,
    /* Missing other node.js specific options here */
    ~rejectUnauthorized: bool=?,
    unit,
  ) => options = ""

  @module("socket.io-client") @new external create: unit => t = "io"
  @module("socket.io-client") @new external createWithUrl: string => t = "io"
  @module("socket.io-client") @new external createWithUrlAndOptions: (string, options) => t = "io"

  @send external _emit: (t, string, 'a) => unit = "emit"
  let emit = (socket, obj: Messages.clientToServer) =>
    _emit(socket, "message", Messages.clientToServerEncode(obj))

  @send external _on: (t, string, Js.Json.t => unit) => unit = "on"
  let on = (socket, func: Messages.serverToClientDecodeResult => unit) =>
    _on(socket, "message", obj => func(Messages.serverToClientDecode(obj)))

  @send external onConnectError: (t, @as("connect_error") _, Js.Exn.t => unit) => unit = "on"
  @send external onConnect: (t, @as("connect") _, unit => unit) => unit = "on"
  @send external onDisconnect: (t, @as("disconnect") _, unit => unit) => unit = "on"
}
