module Make: (Messages: Messages.S) =>
{
  type t

  /* ** Socket.io docs: https://socket.io/docs/server-api/#namespace-name */
  let getName: t => string

  let /* ** Socket.io docs: https://socket.io/docs/server-api/#namespace-adapter */
  getAdapter: t => 'a

  let getConnected: /* ** Socket.io docs: https://socket.io/docs/server-api/#namespace-connected */
  t => 'a

  let clients: /* ** Socket.io docs: https://socket.io/docs/server-api/#namespace-clients-callback */
  (t, ('a, list<string>) => unit) => unit

  let use: (t, (Server.socketT, unit => unit) => unit) => unit

  let default: Server.serverT => t

  let of_: (Server.serverT, string) => t

  let to_: (t, string) => t

  let emit: (t, Messages.serverToClient) => unit

  type volatileT /* ** Socket.io docs: https://socket.io/docs/server-api/#flag-volatile */
  let getVolatile: t => volatileT
  let volatileEmit: (t, Messages.serverToClient) => unit

  type localT /* ** Socket.io docs: https://socket.io/docs/server-api/#flag-local */
  let getLocal: t => localT
  let localEmit: (t, Messages.serverToClient) => unit
}
