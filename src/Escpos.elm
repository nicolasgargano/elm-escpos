module Escpos exposing (..)

import Array exposing (Array)
import Bytes exposing (Bytes)
import Escpos.Internal.LowLevel as LowLevel
import Escpos.Internal.Model as Internal exposing (Attribute, Command)



--


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


horizontalTab : Command
horizontalTab =
    Internal.HorizontalTab


verticalTab : Command
verticalTab =
    Internal.VerticalTab


initialize : Command
initialize =
    Internal.Initialize


cut : Command
cut =
    Internal.Cut



-- HELPERS


toBytes : Command -> Bytes
toBytes command =
    Internal.toBytes (Internal.applyTextAttribute (Array.repeat 8 0) []) [] command


encode : Command -> Bytes
encode command =
    toBytes command


encodeWithInitAndCut : Command -> Bytes
encodeWithInitAndCut command =
    LowLevel.sequence
        [ LowLevel.initialize
        , toBytes command
        , LowLevel.cut
        ]
