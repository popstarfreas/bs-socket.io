module Make = (Messages: Messages.S) => {
  type t
  @module("socket.io-client") @new external create: unit => t = "io"
  @module("socket.io-client") @new external createWithUrl: string => t = "io"
  @send external _emit: (t, string, 'a) => unit = "emit"
  let emit = (socket, obj: Messages.clientToServer) =>
    _emit(socket, "message", Messages.clientToServerEncode(obj))
  @send external _on: (t, string, Js.Json.t => unit) => unit = "on"
  let on = (socket, func: Messages.serverToClientDecodeResult => unit) =>
    _on(socket, "message", obj => func(Messages.serverToClientDecode(obj)))
}
