@send
external /* **
 * All credit goes to Cheng Lou. It was just too hard to figure out jengaboot + bucklescript for now.
 * Copy pasted from https://github.com/chenglou/reason-js
 * */
toString: 'a => string = "toString"

module Event = {
  type eventT
  let isEnterKey: eventT => bool = %raw(`
    function (e) {
      return e.which === 13;
    }
  `)
}

module Element = /* Created a bunch of modules to keep things clean. This is just for demo purposes. */
{
  type elementT
  @set external setInnerHTML: (elementT, string) => unit = "innerHTML"
  @get external getInnerHTML: elementT => string = "innerHTML"
  @set external setValue: (elementT, string) => unit = "value"
  @get external getValue: elementT => string = "value"
  @send
  external addEventListener: (elementT, string, Event.eventT => unit) => unit = "addEventListener"
}

module Document = {
  @val
  external getElementById: string => Element.elementT = "document.getElementById"
  @val
  external addEventListener: (string, Event.eventT => unit) => unit = "document.addEventListener"
}

module Window = {
  type intervalIdT
  @val
  external setInterval: (unit => unit, int) => intervalIdT = "window.setInterval"
  @val
  external clearInterval: intervalIdT => unit = "window.clearInterval"
}

module WsClient = SocketIo.Client.Make(ExampleMessages)

let socket = WsClient.create()

socket->WsClient.onConnectError(err => Js.log2("Websocket Error.", err))
socket->WsClient.onConnect(() => Js.log("Connected."))
socket->WsClient.onDisconnect(() => Js.log("Disconnected."))

let chatarea = Document.getElementById("chatarea")

WsClient.on(socket, x =>
  switch x {
  | Some(s) =>
    let innerHTML = Element.getInnerHTML(chatarea)
    Element.setInnerHTML(
      chatarea,
      innerHTML ++ ("<div><span style='color:red'>Message</span>: " ++ (s ++ "</div>")),
    )
  | None => Js.log("Failed to decode.")
  }
)

let sendbutton = Document.getElementById("sendbutton")

let chatinput = Document.getElementById("chatinput")

Element.addEventListener(sendbutton, "click", _ =>
  WsClient.emit(socket, Element.getValue(chatinput))
)

Document.addEventListener("keyup", e =>
  if Event.isEnterKey(e) {
    WsClient.emit(socket, Element.getValue(chatinput))
    Element.setValue(chatinput, "")
  }
)
