module WsClient = BsSocket.Client.Make(ExampleMessages)

let socket = WsClient.createWithUrl("ws://localhost:3000")

WsClient.on(socket, x =>
  switch x {
  | Some(s) => Js.log(`Echo(${s})`)
  | None => Js.log(`Failed to decode message.`)
  }
)

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
})
->Readline.on(#line, line => socket->WsClient.emit(line))