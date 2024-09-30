type serverT

type socketT

type room = string

module /* This is a really thin wrapper around socket.io. I recommend checking their docs for explanation
 of how this works. */
Make: (Messages: Messages.S) =>
{
  let createWithHttp: /* ** These functions takes an instance of `http` from NodeJS stdlib, which you can get by simply
         doing `require('http')`.

         Socket.io docs: https://socket.io/docs/server-api/#server */
  'httpServer => serverT
  type cors = {
    origin?: array<string>,
    allowedHeaders?: array<string>,
    exposedHeaders?: array<string>,
    credentials?: bool,
    maxAge?: int,
    preflightContinue?: bool,
    optionsSuccessStatus?: int,
  }
  type createOptionsT = {
    pingTimeout?: int,
    pingInterval?: int,
    maxHttpBufferSize?: int,
    transports?: list<string>,
    allowUpgrades?: bool,
    perMessageDeflate?: int,
    httpCompression?: int,
    cookie?: string,
    cookiePath?: string,
    wsEngine?: string,
    cors?: cors,
  }
  let createWithHttpAndOptions: ('httpServer, createOptionsT) => serverT

  let create: unit => serverT
  let createWithOptions: createOptionsT => serverT
  let createWithPort: (int, createOptionsT) => serverT

  let serveClient: (serverT, bool) => serverT

  let path: (serverT, string) => serverT

  let adapter: (serverT, 'a) => serverT

  let origins: (serverT, string) => serverT

  let originsWithFunc: (serverT, ('a, bool) => unit) => serverT

  let close: serverT => unit

  let attach: (serverT, 'a, createOptionsT) => serverT

  let attachWithPort: (serverT, int, createOptionsT) => serverT

  module Socket: {
    /* ** Socket.io docs: https://socket.io/docs/server-api/#socket */

    let getId: socketT => room

    let getRooms: socketT => room

    let getHandshake: socketT => 'a

    let on: (socketT, Messages.clientToServerDecodeResult => unit) => unit

    let emit: (socketT, Messages.serverToClient) => unit

    type broadcastT /* ** Socket.io docs: https://socket.io/docs/server-api/#flag-broadcast */
    let broadcast: (socketT, Messages.serverToClient) => unit

    @send external join: (socketT, room) => unit = "join"

    let leave: (socketT, room) => socketT

    let to_: (socketT, room) => socketT

    let compress: (socketT, bool) => socketT

    let disconnect: (socketT, bool) => socketT

    let use: (socketT, ('packet, ~next: unit => unit) => unit) => unit

    let once: (socketT, Messages.clientToServerDecodeResult => unit) => unit

    type volatileT
    let getVolatile: socketT => volatileT
    let volatileEmit: (socketT, Messages.serverToClient) => unit

    let onDisconnect: (socketT, unit => unit) => unit
  }

  let onConnect: (serverT, socketT => unit) => unit
}
