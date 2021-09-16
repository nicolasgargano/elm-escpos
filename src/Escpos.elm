module Escpos exposing (batch, cut, encodeToBytes, initialize, newline, raw, write, writeLine)

import Array exposing (Array)
import Bytes exposing (Bytes)
import Bytes.Decode
import Escpos.Internal.Model as Internal exposing (Attribute, Command)
import Json.Encode as Encode



-- COMMANDS


batch : List Attribute -> List Command -> Command
batch =
    Internal.Batch


raw : List Int -> Command
raw =
    Internal.Raw


none : Command
none =
    raw []


write : String -> Command
write =
    Internal.Write


newline : Command
newline =
    Internal.Newline


writeLine : String -> Command
writeLine =
    Internal.WriteLine


initialize : Command
initialize =
    Internal.Initialize


cut : Command
cut =
    Internal.Cut



-- ENCODING


encodeToBytes : Command -> Bytes
encodeToBytes command =
    Internal.toBytes (Internal.applyTextAttribute (Array.repeat 8 0) []) [] command


encondeToJson : Command -> Encode.Value
encondeToJson command =
    command
        |> encodeToBytes
        |> bytesToInts
        |> Maybe.withDefault []
        |> Encode.list Encode.int



-- HELPERS


decodeBytes : Int -> Bytes.Decode.Decoder a -> Bytes.Decode.Decoder (List a)
decodeBytes len decoder =
    Bytes.Decode.loop ( len, [] ) (listStep decoder)


listStep : Bytes.Decode.Decoder a -> ( Int, List a ) -> Bytes.Decode.Decoder (Bytes.Decode.Step ( Int, List a ) (List a))
listStep decoder ( n, xs ) =
    if n <= 0 then
        Bytes.Decode.succeed (Bytes.Decode.Done xs)

    else
        Bytes.Decode.map (\x -> Bytes.Decode.Loop ( n - 1, x :: xs )) decoder


bytesToInts : Bytes -> Maybe (List Int)
bytesToInts bytes_ =
    bytes_
        |> Bytes.Decode.decode (decodeBytes (Bytes.width bytes_) Bytes.Decode.unsignedInt8)
        |> Maybe.map List.reverse
