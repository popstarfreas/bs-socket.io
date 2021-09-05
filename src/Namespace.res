module Make = (Messages: Messages.S) => {
  type t

  /* ** Getters */
  @get external getName: t => string = "name"
  @get external getAdapter: t => 'a = "adapter"

  @get
  external /* Returns a JS object with socket IDs as keys. */
  getConnected: t => 'a = "connected"
  @send
  external clients: (t, ('a, list<string>) => unit) => unit = "clients"

  @send
  external /* ** */

  use: (t, (Server.socketT, unit => unit) => unit) => unit = "use"

  @send
  external /* ** */
  default: Server.serverT => t = "sockets"

  @send
  external /* ** This is "of" in socket.io. */
  of_: (Server.serverT, string) => t = "of"

  @send
  external /* ** This is "to" in socket.io or the "in" (they're synonyms apparently) */
  to_: (t, string) => t = "to"

  @send
  external _emit: /* ** */
  (t, string, 'a) => unit = "emit"
  let emit = (server: t, obj: Messages.serverToClient): unit =>
    _emit(server, "message", Json.toValidJson(obj))

  type volatileT /* ** Volatile */
  @get external getVolatile: t => volatileT = "volatile"
  @send external _volatileEmit: (volatileT, string, 'a) => unit = "emit"
  let volatileEmit = (server: t, obj: Messages.serverToClient): unit =>
    _volatileEmit(getVolatile(server), "message", Json.toValidJson(obj))

  type localT
  @get
  external /* ** Local */

  getLocal: t => localT = "local"
  @send external _localEmit: (localT, string, 'a) => unit = "emit"
  let localEmit = (server: t, obj: Messages.serverToClient): unit =>
    _localEmit(getLocal(server), "message", Json.toValidJson(obj))
}
