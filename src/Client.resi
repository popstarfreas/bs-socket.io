module Make: (Messages: Messages.S) =>
{
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

  /* ** Socket.io docs: https://socket.io/docs/client-api/#io-url-options */
  @module("socket.io-client") @new external create: unit => t = "io"
  @module("socket.io-client") @new external createWithUrl: string => t = "io"
  @module("socket.io-client") @new external createWithUrlAndOptions: (string, options) => t = "io"

  let emit: /* ** Same as the server-side `emit`, doesn't take a message name.
   The recommended payload type to send is a variant wSocket.io docs: https://socket.io/docs/client-api/#socket-emit-eventname-args-ack */
  (t, Messages.clientToServer) => unit

  let on: (t, Messages.serverToClientDecodeResult => unit) => unit

  @send external onConnectError: (t, @as("connect_error") _, Js.Exn.t => unit) => unit = "on"
  @send external onConnect: (t, @as("connect") _, unit => unit) => unit = "on"
  @send external onDisconnect: (t, @as("disconnect") _, unit => unit) => unit = "on"
}
