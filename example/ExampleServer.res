/* Created a bunch of modules to keep things clean. This is just for demo purposes. */
module Path = {
  type pathT
  @module("path") @variadic
  external join: array<string> => string = "join"
}

module Express = {
  type expressT
  @module external express: unit => expressT = "express"
  @send external use: (expressT, string) => unit = "use"
  @module("express") external static: string => string = "static"
  type responseT
  @send external sendFile: (responseT, string, 'a) => unit = "sendFile"
  @send
  external get: (expressT, string, ('a, responseT) => unit) => unit = "get"
}

module Http = {
  type http
  @module("http") external create: Express.expressT => http = "Server"
  @send external listen: (http, int, unit => unit) => unit = "listen"
}

let app = Express.express()

let http = Http.create(app)

@val external __dirname: string = "__dirname"

Express.use(app, Express.static(Path.join([__dirname, ".."])))

Express.get(app, "/", (_, res) => Express.sendFile(res, "index.html", {"root": __dirname}))

module MyServer = BsSocket.Server.Make(ExampleMessages)

let io = MyServer.createWithHttp(http)

MyServer.onConnect(io, socket => {
  open MyServer
  print_endline("Got a connection!")
  Socket.join(socket, "someRoom")

  Socket.on(socket, x =>
    switch x {
    | Some(message) =>
      Socket.broadcast(socket, message)
      Socket.emit(socket, message)
    | None => Socket.broadcast(socket, "Failed to decode message.")
    }
  )
})

Http.listen(http, 3000, () => print_endline("listening on *:3000"))
