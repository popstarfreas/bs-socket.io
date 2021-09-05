type serverT

type socketT

type room = string

module Make = (Messages: Messages.S) => {
  @module external create: unit => serverT = "socket.io"
  @module external createWithHttp: 'a => serverT = "socket.io"

  type createOptionsT /* **
   * makeOptions is a simple way to get around the fact that ocaml won't allow you to declare
   * partially defined records (and row polymorphism + ad hoc polymorphism is tricky in ocaml)
   * This allows you to create a JS object with any of the defined properties, allowing to omit
   * any number of them.
   */
  @obj
  external makeOptions: (
    ~pingTimeout: int=?,
    ~pingInterval: int=?,
    ~maxHttpBufferSize: int=?,
    ~transports: list<string>=?,
    ~allowUpgrades: bool=?,
    ~perMessageDeflate: int=?,
    ~httpCompression: int=?,
    ~cookie: string=?,
    ~cookiePath: string=?,
    ~wsEngine: string=?,
    unit,
  ) => createOptionsT = ""
  @module
  external createWithOptions: createOptionsT => serverT = "socket.io"
  @module
  external createWithHttpAndOption: ('a, createOptionsT) => serverT = "socket.io"
  @module
  external createWithPort: (int, createOptionsT) => serverT = "socket.io"

  @send external serveClient: (serverT, bool) => serverT = "serveClient"

  @send external path: (serverT, string) => serverT = "path"

  @send external adapter: (serverT, 'a) => serverT = "adapter"

  @send external origins: (serverT, string) => serverT = "origins"
  @send
  external originsWithFunc: (serverT, ('a, bool) => unit) => serverT = "origins"

  @send external close: serverT => unit = "close"
  /* ** */

  @send
  external attach: (serverT, 'a, createOptionsT) => serverT = "attach"
  @send
  external attachWithPort: (serverT, int, createOptionsT) => serverT = "attach"

  @send external _emit: ('a, string, 'b) => unit = "emit"
  /* ** */

  module Socket = {
    @get external getId: socketT => room = "id"
    @get external getRooms: socketT => 'a = "rooms"
    @get external getHandshake: socketT => 'a = "handshake"

    @send
    external _on: (socketT, string, Js.Json.t => unit) => unit = "on"
    let on = (socket, func) => _on(socket, "message", obj => func(Messages.clientToServerDecode(obj)))

    let emit = (socket: socketT, obj: Messages.serverToClient) =>
      _emit(socket /* ** */, "message", Messages.serverToClientEncode(obj))

    type broadcastT
    @get
    external _unsafeGetBroadcast: socketT => broadcastT = "broadcast"
    let broadcast = (socket, data: Messages.serverToClient) =>
      _emit(_unsafeGetBroadcast(socket), "message", Messages.serverToClientEncode(data))

    @send external join: (socketT, string) => unit = "join"
    @send
    external leave: (
      socketT,
      string,
    ) => socketT = "leave"
    @send external to_: (socketT, string) => socketT = "to"
    @send external compress: (socketT, bool) => socketT = "compress"
    @send external disconnect: (socketT, bool) => socketT = "disconnect"
    @send
    external use: (socketT, ('a, ~next: unit => unit) => unit) => unit = "use"

    @send
    external _once: (socketT, string, Js.Json.t => unit) => unit = "once"
    let once = (socket, func) => _once(socket, "message", obj => func(Messages.clientToServerDecode(obj)))

    type volatileT
    @get external getVolatile: socketT => volatileT = "volatile"
    @send
    external /* ** Volatile */

    _volatileEmit: (volatileT, string, 'a) => unit = "emit"
    let volatileEmit = (server: socketT, obj: Messages.serverToClient): unit =>
      _volatileEmit(getVolatile(server), "message", Messages.serverToClientEncode(obj))
    let onDisconnect = (socket, cb) => _on(socket, "disconnect", _ => cb())
  }
  @send
  external _unsafeOnConnect: (serverT, string, socketT => unit) => unit = "on"
  let onConnect = (io, cb) => _unsafeOnConnect(io, "connection", cb)
}
