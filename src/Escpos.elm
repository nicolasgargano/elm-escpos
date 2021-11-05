module Escpos exposing
    ( Command
    , batch
    , writeLine
    , none
    , write
    , newline
    , initialize
    , cut
    , encodeToBytes
    , encodeToInts
    , encodeToJson
    , encodeToBase64
    , raw
    )

{-|


# Commands

@docs Command
@docs batch
@docs writeLine
@docs none
@docs write
@docs newline


# Control

@docs initialize
@docs cut


# Encoding

@docs encodeToBytes
@docs encodeToInts
@docs encodeToJson
@docs encodeToBase64


# Custom

@docs raw

-}

import Array exposing (Array)
import Base64.Encode
import Bytes exposing (Bytes)
import Bytes.Decode
import Escpos.Internal as Internal exposing (Attribute, Command)
import Json.Encode as Encode



-- COMMANDS


{-| The basic building block.
-}
type alias Command =
    Internal.Command


{-| This let's you group multiple commands and add attributes to them.

You can think of it as a `div` in html.

    batch []
        [ writeLine "Hello!"
        , batch [ bold ] [ writeLine "I am bold!" ]
        ]

-}
batch : List Attribute -> List Command -> Command
batch =
    Internal.Batch


{-| This function lets you implement your own custom command.
This is useful if you want to add a command not included in this library.

---

For example, the [initialize](https://www.epson-biz.com/modules/ref_escpos/index.php?content_id=192)
command is defined as:



    {-
         ASCII : ESC @
           HEX : 1B  40
       DECIMAL : 27  64
    -}

So you could implement using hex it by writing:

    raw [ 0x1B, 0x40 ]

or using decimal:

    raw [ 27, 64 ]

_Note: For a list of ESCPOS commands you should check your printer documentation._

-}
raw : List Int -> Command
raw =
    Internal.Raw


{-| Do nothing.
-}
none : Command
none =
    raw []


{-| Write the given text.
-}
write : String -> Command
write =
    Internal.Write


{-| Insert a newline.
-}
newline : Command
newline =
    Internal.Newline


{-| Write the given string and insert a newline.
-}
writeLine : String -> Command
writeLine =
    Internal.WriteLine


{-| Prepare to print.

You should always include this as your first command for a ticket.

-}
initialize : Command
initialize =
    Internal.Initialize


{-| Cut the paper.
-}
cut : Command
cut =
    Internal.Cut



-- ENCODING


{-| Return the command as bytes.

This is probably what you need to send to the printer.

-}
encodeToBytes : Command -> Bytes
encodeToBytes command =
    Internal.toBytes command


{-| Return the command a list of ints, one for each byte.

This is useful to send through a port.

-}
encodeToInts : Command -> List Int
encodeToInts command =
    encodeToBytes command
        |> bytesToInts
        |> Maybe.withDefault []


{-| Return the command as json. It will be an array of numbers, one for each byte.

This is useful to send through a port.

-}
encodeToJson : Command -> Encode.Value
encodeToJson command =
    encodeToInts command
        |> Encode.list Encode.int


{-| Return the command as a base64 encoded string.
-}
encodeToBase64 : Command -> String
encodeToBase64 command =
    encodeToBytes command
        |> Base64.Encode.bytes
        |> Base64.Encode.encode



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
