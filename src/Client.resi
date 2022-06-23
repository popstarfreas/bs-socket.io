module Make: (Messages: Messages.S) =>
{
  type t

  /* ** Socket.io docs: https://socket.io/docs/client-api/#io-url-options */
  let create: unit => t

  let createWithUrl: string => t

  let emit: /* ** Same as the server-side `emit`, doesn't take a message name.
   The recommended payload type to send is a variant wSocket.io docs: https://socket.io/docs/client-api/#socket-emit-eventname-args-ack */
  (t, Messages.clientToServer) => unit

  let on: (t, Messages.serverToClientDecodeResult => unit) => unit

  @send external onConnectError: (t, @as("connect_error") _, Js.Exn.t => unit) => unit = "on"
  @send external onConnect: (t, @as("connect") _, unit => unit) => unit = "on"
  @send external onDisconnect: (t, @as("disconnect") _, unit => unit) => unit = "on"
}
