module Escpos exposing (batch, cut, encodeToBytes, horizontalTab, initialize, newline, raw, verticalTab, write, writeLine)

import Array exposing (Array)
import Bytes exposing (Bytes)
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


encodeToBytes : Command -> Bytes
encodeToBytes command =
    Internal.toBytes (Internal.applyTextAttribute (Array.repeat 8 0) []) [] command
