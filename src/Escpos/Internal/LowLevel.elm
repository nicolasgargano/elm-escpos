module Escpos.Internal.LowLevel exposing (..)

import Bytes exposing (Bytes)
import Bytes.Encode
import Escpos.Internal.Ascii as Ascii exposing (Ascii(..))


type Command
    = Command Bytes


make : List Ascii -> Bytes
make asciis =
    asciis
        |> List.map Ascii.toInt
        |> List.map Bytes.Encode.unsignedInt8
        |> Bytes.Encode.sequence
        |> Bytes.Encode.encode



-- COMBINATORS


sequence : List Bytes -> Bytes
sequence bytes =
    bytes
        |> List.map Bytes.Encode.bytes
        |> Bytes.Encode.sequence
        |> Bytes.Encode.encode



-- PRIMITIVES


text : String -> Bytes
text string =
    Bytes.Encode.encode <| Bytes.Encode.string string


newline =
    make [ LineFeed, CarriageReturn ]



-- CONTROL


initialize =
    make [ Escape, At ]


cut =
    make [ GroupSeparator, Letter_V, Null ]


horizontalTab =
    make [ HorizontalTab ]


verticalTab =
    make [ VerticalTab ]



-- -------
-- STYLING
-- -------


style bytes =
    Bytes.Encode.sequence
        [ Bytes.Encode.unsignedInt8 0x1B
        , Bytes.Encode.unsignedInt8 0x21
        , Bytes.Encode.bytes bytes
        ]
        |> Bytes.Encode.encode


defaultStyle =
    0x00
        |> Bytes.Encode.unsignedInt8
        |> Bytes.Encode.encode
        |> style



-- ALIGNMENT a for alignment


alignment : Bytes -> Bytes
alignment bytes =
    Bytes.Encode.sequence
        [ Bytes.Encode.bytes <| make [ Escape, Letter_a ]
        , Bytes.Encode.bytes bytes
        ]
        |> Bytes.Encode.encode


setHorizontalTabPositions : List Int -> Bytes
setHorizontalTabPositions positions =
    Bytes.Encode.sequence
        (List.concat
            [ [ Bytes.Encode.bytes <| make [ Escape, Letter_D ] ]
            , positions |> List.map Bytes.Encode.unsignedInt8
            , [ Bytes.Encode.bytes <| make [ Null ] ]
            ]
        )
        |> Bytes.Encode.encode


whiteOverBlack : Bool -> Bytes
whiteOverBlack bool =
    Bytes.Encode.sequence
        [ Bytes.Encode.bytes <| make [ GroupSeparator, Letter_B ]
        , Bytes.Encode.bytes <|
            make
                [ if bool then
                    Number_0

                  else
                    Number_1
                ]
        ]
        |> Bytes.Encode.encode



-- UNDERLINE: - for line


underline_off =
    make [ Escape, Hyphen, Null ]


underline_1 =
    make [ Escape, Hyphen, Number_1 ]


underline_2 =
    make [ Escape, Hyphen, Number_2 ]



-- BOLD: E for emphasis


bold_off =
    make [ Escape, Letter_E, Number_0 ]


bold_on =
    make [ Escape, Letter_E, Number_1 ]



-- SIZE


{-| 0 to 7 for each

        -110-010
        \__/\__/
          |    |
      height  width

-}
characterSize : Bytes -> Bytes
characterSize bytes =
    Bytes.Encode.sequence
        [ Bytes.Encode.bytes <| make [ Escape, Bang ]
        , Bytes.Encode.bytes bytes
        ]
        |> Bytes.Encode.encode
