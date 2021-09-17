port module TicketExample exposing (..)

import Escpos exposing (batch, cut, initialize, newline, writeLine)
import Escpos.Attributes exposing (alignCenter, normalDouble)


ticketContents : Escpos.Command
ticketContents =
    batch []
        [ batch [ normalDouble, alignCenter ]
            [ writeLine "elm-escpos" ]
        , newline
        , writeLine "Write ESCPOS commands like html."
        , writeLine "Preview tickets with hot reloading."
        ]


port print : List Int -> Cmd msg


printTicket : Escpos.Command -> Cmd msg
printTicket contents =
    let
        printCommand =
            batch []
                [ initialize
                , contents

                -- These empty lines are necessary to avoid the cut going through the contents.
                -- I is not built-in because I'm not sure if it depends on the printer model.
                , batch [] (List.repeat 5 newline)
                , cut
                ]
    in
    printCommand
        |> Escpos.encodeToInts
        |> print
