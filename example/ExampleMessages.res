type clientToServer = string
type clientToServerDecodeResult = option<clientToServer>

// Decode/Encode are kept simple and do nothing
let clientToServerDecode = Js.Json.decodeString
let clientToServerEncode = (message: clientToServer) => Obj.magic(message)

type serverToClient = string
type serverToClientDecodeResult = option<serverToClient>

// Decode/Encode are kept simple and do nothing
let serverToClientDecode = Js.Json.decodeString
let serverToClientEncode = (message: serverToClient) => Obj.magic(message)
