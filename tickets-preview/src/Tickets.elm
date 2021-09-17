module Tickets exposing (..)

import Escpos exposing (batch, newline, write, writeLine)
import Escpos.Attributes exposing (..)
import TicketExample


type alias TicketDemo =
    { id : String
    , escposCommand : Escpos.Command
    }


{-| Add your own tickets here to see them in the sidebar
-}
allTickets =
    [ helloWorld
    , attributes
    , readmeExample
    , capabilities
    ]



-- SAMPLE TICKETS


helloWorld : TicketDemo
helloWorld =
    TicketDemo "Hello World" <|
        writeLine "Hello world!"


attributes : TicketDemo
attributes =
    TicketDemo "Attributes" <|
        batch [ bold ] [ writeLine "I am bold" ]


readmeExample : TicketDemo
readmeExample =
    TicketDemo "README example" <|
        TicketExample.ticketContents


capabilities : TicketDemo
capabilities =
    TicketDemo "Capabilities" <|
        let
            testBlock title commands =
                batch []
                    [ batch [ alignCenter ]
                        [ write "=-=-= =-=-= "
                        , write title
                        , write " =-=-= =-=-="
                        , newline
                        , newline
                        , newline
                        ]
                    , batch [] commands
                    , newline
                    , newline
                    ]
        in
        batch []
            [ testBlock "Alignment"
                [ batch [ alignLeft ] [ writeLine "Left" ]
                , batch [ alignCenter ] [ writeLine "Center" ]
                , batch [ alignRight ] [ writeLine "Right" ]
                ]
            , testBlock "Style"
                [ batch [ bold ] [ writeLine "Bold" ]
                , batch [ underline ] [ writeLine "Underline" ]
                , batch [ normalSize ] [ writeLine "Normal" ]
                , batch [ normalDoubleWidth ] [ writeLine "NormalDoubleWidth" ]
                , batch [ normalDoubleHeight ] [ writeLine "NormalDoubleHeight" ]
                , batch [ normalDouble ] [ writeLine "NormalDouble" ]
                , batch [ smallSize ] [ writeLine "Small" ]
                , batch [ smallDoubleWidth ] [ writeLine "SmallDoubleWidth" ]
                , batch [ smallDoubleHeight ] [ writeLine "SmallDoubleHeight" ]
                , batch [ smallDouble ] [ writeLine "SmallDouble" ]
                ]
            , testBlock "Combinations"
                [ batch [ bold, underline, alignCenter ] [ writeLine "Center-Bold-Underline" ]
                , batch [ smallSize, alignRight, underline, bold ] [ writeLine "Small-Right-Undrln-Bld" ]
                , batch [ normalDouble, alignCenter, bold ] [ writeLine "Dbl-Cntr-Bold" ]
                ]
            , testBlock "Nesting"
                [ batch [ bold ]
                    [ writeLine "Nested 1 - Bold"
                    , batch [ underline ]
                        [ writeLine "Nested 2 - Underline (N1 Bold)"
                        , batch [ alignCenter ]
                            [ writeLine "Nested 3 - Center (N1 Bold, N2 Underline)"
                            ]
                        , writeLine "Nested 2 - Underline (N1 Bold)"
                        ]
                    ]
                ]
            ]
