module Escpos.Attributes exposing
    ( bold
    , underline
    , alignLeft
    , alignCenter
    , alignRight
    , normalSize
    , normalDoubleWidth
    , normalDoubleHeight
    , normalDouble
    , smallSize
    , smallDoubleWidth
    , smallDoubleHeight
    , smallDouble
    )

{-|


# Style

@docs bold
@docs underline


# Alignment

Keep in mind these commands will align at least the whole line where it's used.

@docs alignLeft
@docs alignCenter
@docs alignRight


# Sizing

@docs normalSize
@docs normalDoubleWidth
@docs normalDoubleHeight
@docs normalDouble

@docs smallSize
@docs smallDoubleWidth
@docs smallDoubleHeight
@docs smallDouble

-}

import Escpos.Internal as Internal exposing (Alignment, Attribute, CharacterSizing)



-- ALIGNMENT


{-| Align text to the left.

This is the default.

-}
alignLeft : Attribute
alignLeft =
    Internal.AlignmentAttribute Internal.Left


{-| Center the text.
-}
alignCenter : Attribute
alignCenter =
    Internal.AlignmentAttribute Internal.Center


{-| Align to the right.
-}
alignRight : Attribute
alignRight =
    Internal.AlignmentAttribute Internal.Right



-- STYLE


{-| Underline.
-}
underline : Attribute
underline =
    Internal.TextAttribute Internal.Underline


{-| Bold.
-}
bold : Attribute
bold =
    Internal.TextAttribute Internal.Bold



-- SIZING


{-| Default size.
-}
normalSize : Attribute
normalSize =
    Internal.TextAttribute (Internal.CharacterSize Internal.Normal)


{-| Makes the font double the width of normal size.
-}
normalDoubleWidth : Attribute
normalDoubleWidth =
    Internal.TextAttribute (Internal.CharacterSize Internal.NormalDoubleWidth)


{-| Makes the font double the height of normal size.
-}
normalDoubleHeight : Attribute
normalDoubleHeight =
    Internal.TextAttribute (Internal.CharacterSize Internal.NormalDoubleHeight)


{-| Makes the font double the width and height of normal size.
-}
normalDouble : Attribute
normalDouble =
    Internal.TextAttribute (Internal.CharacterSize Internal.NormalDouble)


{-| Makes the font smaller than normal size.
-}
smallSize : Attribute
smallSize =
    Internal.TextAttribute (Internal.CharacterSize Internal.Small)


{-| Makes the font double the width of the small size.
-}
smallDoubleWidth : Attribute
smallDoubleWidth =
    Internal.TextAttribute (Internal.CharacterSize Internal.SmallDoubleWidth)


{-| Makes the font double the height of the small size.
-}
smallDoubleHeight : Attribute
smallDoubleHeight =
    Internal.TextAttribute (Internal.CharacterSize Internal.SmallDoubleHeight)


{-| Makes the font double the width and height of the small size.
-}
smallDouble : Attribute
smallDouble =
    Internal.TextAttribute (Internal.CharacterSize Internal.SmallDouble)
