module Escpos.Internal.Ascii exposing (Ascii(..), allAscii, toInt)


type Ascii
    = Null
    | StartOfHeading
    | StartOfText
    | EndOfText
    | EndOfTransmission
    | Enquiry
    | Acknowledgement
    | Bell
    | Backspace
    | HorizontalTab
    | LineFeed
    | VerticalTab
    | FormFeed
    | CarriageReturn
    | ShiftOut
    | ShiftIn
    | DataLinkEscape
    | DeviceControl1
    | DeviceControl2
    | DeviceControl3
    | DeviceControl4
    | NegativeAcknowledgement
    | SynchronousIdle
    | EndOfTransmissionBlock
    | Cancel
    | EndOfMedium
    | Substitute
    | Escape
    | FileSeparator
    | GroupSeparator
    | RecordSeparator
    | UnitSeparator
    | Space
    | Bang
    | DoubleQuote
    | Hashtag
    | Dollar
    | Percent
    | Ampersand
    | SingleQuote
    | LeftParenthesis
    | RightParenthesis
    | Asterisk
    | Plus
    | Comma
    | Hyphen
    | Dot
    | SlashTR
    | Number_0
    | Number_1
    | Number_2
    | Number_3
    | Number_4
    | Number_5
    | Number_6
    | Number_7
    | Number_8
    | Number_9
    | Colon
    | SemiColon
    | Less
    | Equal
    | Greater
    | Question
    | At
    | Letter_A
    | Letter_B
    | Letter_C
    | Letter_D
    | Letter_E
    | Letter_F
    | Letter_G
    | Letter_H
    | Letter_I
    | Letter_J
    | Letter_K
    | Letter_L
    | Letter_M
    | Letter_N
    | Letter_O
    | Letter_P
    | Letter_Q
    | Letter_R
    | Letter_S
    | Letter_T
    | Letter_U
    | Letter_V
    | Letter_W
    | Letter_X
    | Letter_Y
    | Letter_Z
    | LeftBracket
    | SlashTL
    | RightBracket
    | Power
    | Underscore
    | Backtick
    | Letter_a
    | Letter_b
    | Letter_c
    | Letter_d
    | Letter_e
    | Letter_f
    | Letter_g
    | Letter_h
    | Letter_i
    | Letter_j
    | Letter_k
    | Letter_l
    | Letter_m
    | Letter_n
    | Letter_o
    | Letter_p
    | Letter_q
    | Letter_r
    | Letter_s
    | Letter_t
    | Letter_u
    | Letter_v
    | Letter_w
    | Letter_x
    | Letter_y
    | Letter_z
    | LeftKey
    | Pipe
    | RightKey
    | Tilde
    | Delete


allAscii : List Ascii
allAscii =
    [ Null
    , StartOfHeading
    , StartOfText
    , EndOfText
    , EndOfTransmission
    , Enquiry
    , Acknowledgement
    , Bell
    , Backspace
    , HorizontalTab
    , LineFeed
    , VerticalTab
    , FormFeed
    , CarriageReturn
    , ShiftOut
    , ShiftIn
    , DataLinkEscape
    , DeviceControl1
    , DeviceControl2
    , DeviceControl3
    , DeviceControl4
    , NegativeAcknowledgement
    , SynchronousIdle
    , EndOfTransmissionBlock
    , Cancel
    , EndOfMedium
    , Substitute
    , Escape
    , FileSeparator
    , GroupSeparator
    , RecordSeparator
    , UnitSeparator
    , Space
    , Bang
    , DoubleQuote
    , Hashtag
    , Dollar
    , Percent
    , Ampersand
    , SingleQuote
    , LeftParenthesis
    , RightParenthesis
    , Asterisk
    , Plus
    , Comma
    , Hyphen
    , Dot
    , SlashTR
    , Number_0
    , Number_1
    , Number_2
    , Number_3
    , Number_4
    , Number_5
    , Number_6
    , Number_7
    , Number_8
    , Number_9
    , Colon
    , SemiColon
    , Less
    , Equal
    , Greater
    , Question
    , At
    , Letter_A
    , Letter_B
    , Letter_C
    , Letter_D
    , Letter_E
    , Letter_F
    , Letter_G
    , Letter_H
    , Letter_I
    , Letter_J
    , Letter_K
    , Letter_L
    , Letter_M
    , Letter_N
    , Letter_O
    , Letter_P
    , Letter_Q
    , Letter_R
    , Letter_S
    , Letter_T
    , Letter_U
    , Letter_V
    , Letter_W
    , Letter_X
    , Letter_Y
    , Letter_Z
    , LeftBracket
    , SlashTL
    , RightBracket
    , Power
    , Underscore
    , Backtick
    , Letter_a
    , Letter_b
    , Letter_c
    , Letter_d
    , Letter_e
    , Letter_f
    , Letter_g
    , Letter_h
    , Letter_i
    , Letter_j
    , Letter_k
    , Letter_l
    , Letter_m
    , Letter_n
    , Letter_o
    , Letter_p
    , Letter_q
    , Letter_r
    , Letter_s
    , Letter_t
    , Letter_u
    , Letter_v
    , Letter_w
    , Letter_x
    , Letter_y
    , Letter_z
    , LeftKey
    , Pipe
    , RightKey
    , Tilde
    , Delete
    ]


toInt : Ascii -> Int
toInt ascii =
    case ascii of
        Null ->
            0

        StartOfHeading ->
            1

        StartOfText ->
            2

        EndOfText ->
            3

        EndOfTransmission ->
            4

        Enquiry ->
            5

        Acknowledgement ->
            6

        Bell ->
            7

        Backspace ->
            8

        HorizontalTab ->
            9

        LineFeed ->
            10

        VerticalTab ->
            11

        FormFeed ->
            12

        CarriageReturn ->
            13

        ShiftOut ->
            14

        ShiftIn ->
            15

        DataLinkEscape ->
            16

        DeviceControl1 ->
            17

        DeviceControl2 ->
            18

        DeviceControl3 ->
            19

        DeviceControl4 ->
            20

        NegativeAcknowledgement ->
            21

        SynchronousIdle ->
            22

        EndOfTransmissionBlock ->
            23

        Cancel ->
            24

        EndOfMedium ->
            25

        Substitute ->
            26

        Escape ->
            27

        FileSeparator ->
            28

        GroupSeparator ->
            29

        RecordSeparator ->
            30

        UnitSeparator ->
            31

        Space ->
            32

        Bang ->
            33

        DoubleQuote ->
            34

        Hashtag ->
            35

        Dollar ->
            36

        Percent ->
            37

        Ampersand ->
            38

        SingleQuote ->
            39

        LeftParenthesis ->
            40

        RightParenthesis ->
            41

        Asterisk ->
            42

        Plus ->
            43

        Comma ->
            44

        Hyphen ->
            45

        Dot ->
            46

        SlashTR ->
            47

        Number_0 ->
            48

        Number_1 ->
            49

        Number_2 ->
            50

        Number_3 ->
            51

        Number_4 ->
            52

        Number_5 ->
            53

        Number_6 ->
            54

        Number_7 ->
            55

        Number_8 ->
            56

        Number_9 ->
            57

        Colon ->
            58

        SemiColon ->
            59

        Less ->
            60

        Equal ->
            61

        Greater ->
            62

        Question ->
            63

        At ->
            64

        Letter_A ->
            65

        Letter_B ->
            66

        Letter_C ->
            67

        Letter_D ->
            68

        Letter_E ->
            69

        Letter_F ->
            70

        Letter_G ->
            71

        Letter_H ->
            72

        Letter_I ->
            73

        Letter_J ->
            74

        Letter_K ->
            75

        Letter_L ->
            76

        Letter_M ->
            77

        Letter_N ->
            78

        Letter_O ->
            79

        Letter_P ->
            80

        Letter_Q ->
            81

        Letter_R ->
            82

        Letter_S ->
            83

        Letter_T ->
            84

        Letter_U ->
            85

        Letter_V ->
            86

        Letter_W ->
            87

        Letter_X ->
            88

        Letter_Y ->
            89

        Letter_Z ->
            90

        LeftBracket ->
            91

        SlashTL ->
            92

        RightBracket ->
            93

        Power ->
            94

        Underscore ->
            95

        Backtick ->
            96

        Letter_a ->
            97

        Letter_b ->
            98

        Letter_c ->
            99

        Letter_d ->
            100

        Letter_e ->
            101

        Letter_f ->
            102

        Letter_g ->
            103

        Letter_h ->
            104

        Letter_i ->
            105

        Letter_j ->
            106

        Letter_k ->
            107

        Letter_l ->
            108

        Letter_m ->
            109

        Letter_n ->
            110

        Letter_o ->
            111

        Letter_p ->
            112

        Letter_q ->
            113

        Letter_r ->
            114

        Letter_s ->
            115

        Letter_t ->
            116

        Letter_u ->
            117

        Letter_v ->
            118

        Letter_w ->
            119

        Letter_x ->
            120

        Letter_y ->
            121

        Letter_z ->
            122

        LeftKey ->
            123

        Pipe ->
            124

        RightKey ->
            125

        Tilde ->
            126

        Delete ->
            127
