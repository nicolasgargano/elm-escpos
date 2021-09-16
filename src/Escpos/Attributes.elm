module Escpos.Attributes exposing (alignCenter, alignLeft, alignRight, bold, normalDouble, normalDoubleHeight, normalDoubleWidth, normalSize, smallDouble, smallDouleHeight, smallDouleWidth, smallSize, underline)

import Escpos.Internal.Model as Internal exposing (Alignment, Attribute, CharacterSizing)



-- ALIGNMENT


alignLeft : Attribute
alignLeft =
    Internal.AlignmentAttribute Internal.Left


alignCenter : Attribute
alignCenter =
    Internal.AlignmentAttribute Internal.Center


alignRight : Attribute
alignRight =
    Internal.AlignmentAttribute Internal.Left



-- STYLE


underline : Attribute
underline =
    Internal.TextAttribute Internal.Underline


bold : Attribute
bold =
    Internal.TextAttribute Internal.Bold



-- SIZING


normalSize : Attribute
normalSize =
    Internal.TextAttribute (Internal.CharacterSize Internal.Normal)


normalDoubleWidth : Attribute
normalDoubleWidth =
    Internal.TextAttribute (Internal.CharacterSize Internal.NormalDoubleWidth)


normalDoubleHeight : Attribute
normalDoubleHeight =
    Internal.TextAttribute (Internal.CharacterSize Internal.NormalDoubleHeight)


normalDouble : Attribute
normalDouble =
    Internal.TextAttribute (Internal.CharacterSize Internal.NormalDouble)


smallSize : Attribute
smallSize =
    Internal.TextAttribute (Internal.CharacterSize Internal.Small)


smallDouleWidth : Attribute
smallDouleWidth =
    Internal.TextAttribute (Internal.CharacterSize Internal.SmallDoubleWidth)


smallDouleHeight : Attribute
smallDouleHeight =
    Internal.TextAttribute (Internal.CharacterSize Internal.SmallDoubleHeight)


smallDouble : Attribute
smallDouble =
    Internal.TextAttribute (Internal.CharacterSize Internal.SmallDouble)
