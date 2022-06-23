module WsClient = SocketIo.Client.Make(ExampleMessages)

let socket = WsClient.createWithUrlAndOptions(
  "ws://localhost:3000",
  WsClient.options(~transports=[#websocket], ()),
)

socket->WsClient.on(x =>
  switch x {
  | Some(s) => Js.log(`Echo(${s})`)
  | None => Js.log(`Failed to decode message.`)
  }
)

socket->WsClient.onConnectError(err => Js.log2("Websocket Error.", err))
socket->WsClient.onConnect(() => Js.log("Connected."))
socket->WsClient.onDisconnect(() => Js.log("Disconnected."))

type stdin
type stdout

module Process = {
  @val external stdin: stdin = "process.stdin"
  @val external stdout: stdout = "process.stdout"
}

module Readline = {
  type t
  type options = {
    input: stdin,
    output: stdout,
    terminal: bool,
  }

  @module("readline") external createInterface: options => t = "createInterface"
  @send external on: (t, [#line], string => unit) => unit = "on"
}

Readline.createInterface({
  input: Process.stdin,
  output: Process.stdout,
  terminal: false,
})->Readline.on(#line, line => socket->WsClient.emit(line))
