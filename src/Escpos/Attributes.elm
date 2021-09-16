module Escpos.Attributes exposing (..)

import Escpos.Internal.Model as Internal exposing (Alignment, Attribute, CharacterSizing)



--


align : Alignment -> Attribute
align =
    Internal.AlignmentAttribute



--


underline : Attribute
underline =
    Internal.TextAttribute Internal.Underline


bold : Attribute
bold =
    Internal.TextAttribute Internal.Bold


characterSize : CharacterSizing -> Attribute
characterSize =
    Internal.CharacterSize >> Internal.TextAttribute
