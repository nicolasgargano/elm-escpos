module Escpos.Internal exposing
    ( Command(..)
    , Attribute(..)
    , TextAttribute(..)
    , CharacterSizing(..)
    , Alignment(..)
    , toBytes
    )

{-| _Note: you only need this module if you are writing a custom interpreter for Command._


# Custom Types

@docs Command
@docs Attribute
@docs TextAttribute
@docs CharacterSizing
@docs Alignment


# Convert

@docs toBytes

-}

import Array exposing (Array)
import Bytes exposing (Bytes)
import Bytes.Encode
import Escpos.Internal.LowLevel as LowLevel
import RadixInt


{-| The basic building block.
-}
type Command
    = Batch (List Attribute) (List Command)
    | Raw (List Int)
    | Write String
    | Newline
    | WriteLine String
    | HorizontalTab
    | VerticalTab
    | Initialize
    | Cut


{-| Attributes.
-}
type Attribute
    = TextAttribute TextAttribute
    | AlignmentAttribute Alignment
    | WhiteOverBlack


{-| Attributes that can be applied to text.
-}
type TextAttribute
    = Underline
    | Bold
    | CharacterSize CharacterSizing


{-| Size of the characters.
-}
type CharacterSizing
    = Small
    | SmallDoubleWidth
    | SmallDoubleHeight
    | SmallDouble
    | Normal
    | NormalDoubleWidth
    | NormalDoubleHeight
    | NormalDouble


{-| How text should align. Note that you cannot have multiple alignments within the same line.
-}
type Alignment
    = Left
    | Center
    | Right



-- HELPERS


{-| Convert a command to a series of bytes.
-}
toBytes : Command -> Bytes
toBytes command =
    toBytesHelper (applyTextAttribute (Array.repeat 8 0) []) [] command


toBytesHelper : Array Int -> List Attribute -> Command -> Bytes
toBytesHelper outsideTextStyleBits outsideAttributes command =
    case command of
        Batch attrs commands ->
            let
                insideTextStyle =
                    applyTextAttribute outsideTextStyleBits (extractTextAttributes attrs)

                insideOtherAttributesBytes =
                    List.map toBytesWithoutTextStyling attrs

                outsideAttributes_ =
                    if List.isEmpty outsideAttributes then
                        [ AlignmentAttribute Left ]

                    else
                        outsideAttributes

                outsideOtherAttributesBytes =
                    if List.isEmpty outsideAttributes then
                        List.map toBytesWithoutTextStyling [ AlignmentAttribute Left ]

                    else
                        List.map toBytesWithoutTextStyling outsideAttributes
            in
            LowLevel.sequence
                [ LowLevel.style (bitListToBytes insideTextStyle)
                , LowLevel.sequence insideOtherAttributesBytes
                , commands
                    |> List.map (toBytesHelper insideTextStyle (outsideAttributes_ ++ attrs))
                    |> LowLevel.sequence
                , LowLevel.style (bitListToBytes outsideTextStyleBits)
                , LowLevel.sequence outsideOtherAttributesBytes
                ]

        Raw ints ->
            ints
                |> List.map Bytes.Encode.unsignedInt8
                |> Bytes.Encode.sequence
                |> Bytes.Encode.encode

        Write string ->
            LowLevel.text string

        Newline ->
            LowLevel.newline

        WriteLine string ->
            LowLevel.sequence
                [ LowLevel.text string
                , LowLevel.newline
                ]

        HorizontalTab ->
            LowLevel.horizontalTab

        VerticalTab ->
            LowLevel.verticalTab

        Initialize ->
            LowLevel.sequence
                [ LowLevel.initialize
                ]

        Cut ->
            LowLevel.cut


toBytesWithoutTextStyling : Attribute -> Bytes
toBytesWithoutTextStyling attribute =
    case attribute of
        TextAttribute _ ->
            Bytes.Encode.sequence [] |> Bytes.Encode.encode

        AlignmentAttribute alignment ->
            let
                alignmentHex =
                    case alignment of
                        Left ->
                            0x00

                        Center ->
                            0x01

                        Right ->
                            0x02
            in
            alignmentHex |> Bytes.Encode.unsignedInt8 |> Bytes.Encode.encode |> LowLevel.alignment

        WhiteOverBlack ->
            LowLevel.whiteOverBlack True


extractTextAttributes : List Attribute -> List TextAttribute
extractTextAttributes attributes =
    List.foldl
        (\curr acc ->
            case curr of
                TextAttribute ta ->
                    ta :: acc

                _ ->
                    acc
        )
        []
        attributes


bitListToBytes arr =
    arr
        |> Array.toList
        |> RadixInt.fromList (RadixInt.Base 2)
        |> Maybe.map RadixInt.toInt
        |> Maybe.withDefault 0
        |> Bytes.Encode.unsignedInt8
        |> Bytes.Encode.encode


applyTextAttribute : Array Int -> List TextAttribute -> Array Int
applyTextAttribute arr attributes =
    let
        modFn : TextAttribute -> Array Int -> Array Int
        modFn attribute =
            case attribute of
                Underline ->
                    Array.set 7 1

                Bold ->
                    Array.set 3 1

                CharacterSize characterSizing ->
                    case characterSizing of
                        Small ->
                            Array.set 0 1

                        SmallDoubleWidth ->
                            Array.set 0 1 >> Array.set 5 1

                        SmallDoubleHeight ->
                            Array.set 0 1 >> Array.set 4 1

                        SmallDouble ->
                            Array.set 0 1 >> Array.set 5 1 >> Array.set 4 1

                        Normal ->
                            identity

                        NormalDoubleWidth ->
                            Array.set 5 1

                        NormalDoubleHeight ->
                            Array.set 4 1

                        NormalDouble ->
                            Array.set 5 1 >> Array.set 4 1
    in
    case attributes of
        [] ->
            arr

        attrs ->
            List.foldl modFn arr attrs
