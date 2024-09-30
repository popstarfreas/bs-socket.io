type clientToServer = string
type clientToServerDecodeResult = option<clientToServer>

// Decode/Encode are kept simple and do nothing
let clientToServerDecode = json => Js.Json.decodeString(json)
let clientToServerEncode = (message: clientToServer) => Obj.magic(message)

type serverToClient = string
type serverToClientDecodeResult = option<serverToClient>

// Decode/Encode are kept simple and do nothing
let serverToClientDecode = json => Js.Json.decodeString(json)
let serverToClientEncode = (message: serverToClient) => Obj.magic(message)
