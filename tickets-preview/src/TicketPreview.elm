port module TicketPreview exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Base64.Encode
import Basics.Extra exposing (flip)
import Browser
import Css exposing (focus, hover)
import Css.Global
import Dict exposing (Dict)
import Escpos exposing (batch, cut, initialize, newline)
import Html
import Html.Parser exposing (Node)
import Html.Parser.Util
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)
import Http
import List.Extra
import LoadingData exposing (LoadingData(..))
import Svg.Styled exposing (svg)
import Svg.Styled.Attributes
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Tickets exposing (TicketDemo, allTickets)
import Time



-- MAIN


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = mainView
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Flags =
    { ticketRendererEndpoint : String
    }


type alias Model =
    { ticketRendererEndpoint : String
    , ticketsHtml : Dict String (LoadingData ( Escpos.Command, Html Msg ))
    , maybeSelectedTicket : Maybe String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        dict =
            allTickets
                |> List.map (\{ id, escposCommand } -> ( id, Loading ))
                |> Dict.fromList

        maybeSelectedTicket =
            if Dict.member "Capabilities" dict then
                Just "Capabilities"

            else
                Nothing
    in
    ( Model flags.ticketRendererEndpoint dict maybeSelectedTicket
    , Cmd.none
    )



-- PORTS


port connectAndPrint : List Int -> Cmd msg



-- UPDATE


type Msg
    = GotTicketDemo String (Maybe ( Escpos.Command, Html Msg ))
    | RequestTicketDemo TicketDemo
    | ConnectAndPrint Escpos.Command
    | SelectTicket String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTicketDemo id maybeData ->
            ( { model
                | ticketsHtml =
                    model.ticketsHtml
                        |> Dict.insert id
                            (maybeData
                                |> Maybe.map Success
                                |> Maybe.withDefault Error
                            )
              }
            , Cmd.none
            )

        RequestTicketDemo ticketDemo ->
            ( model
            , ticketDemoCmd model.ticketRendererEndpoint ticketDemo
            )

        ConnectAndPrint escposCommand ->
            let
                printCommand =
                    batch []
                        (List.concat
                            [ [ initialize ]
                            , [ escposCommand ]

                            -- These two newlines add some padding so content is not cut in half
                            , [ newline, newline ]
                            , [ cut ]
                            ]
                        )
            in
            ( model
            , connectAndPrint (Escpos.encodeToInts printCommand)
            )

        SelectTicket id ->
            ( { model
                | maybeSelectedTicket = Just id
                , ticketsHtml = Dict.insert id Loading model.ticketsHtml
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        maybeTicketDemo =
            model.maybeSelectedTicket
                |> Maybe.andThen (\id -> List.Extra.find (\td -> td.id == id) allTickets)
    in
    case maybeTicketDemo of
        Just ticketDemo ->
            Time.every 1000 (\_ -> RequestTicketDemo ticketDemo)

        Nothing ->
            Sub.none



-- VIEW


mainView : Model -> Browser.Document Msg
mainView model =
    { title = "Tickets Preview"
    , body =
        [ Html.Styled.toUnstyled <|
            div []
                [ Css.Global.global Tw.globalStyles
                , view model
                ]
        ]
    }


view : Model -> Html Msg
view model =
    let
        sidebar =
            section [ css [ Tw.px_8, Tw.min_w_min ] ]
                [ div [ css [ Tw.py_4, Tw.px_2, Tw.text_lg, Tw.font_semibold, Tw.tracking_widest, Tw.text_gray_900, Tw.uppercase, Tw.rounded_lg ] ]
                    [ text "Tickets" ]
                , nav [ css [ Tw.flex, Tw.flex_col, Tw.w_full, Tw.col_span_1, Tw.bg_white, Tw.space_y_2 ] ]
                    (allTickets
                        |> List.map
                            (\{ id } ->
                                let
                                    selectedAttr =
                                        if model.maybeSelectedTicket |> Maybe.withDefault "" |> (==) id then
                                            Tw.bg_gray_200

                                        else
                                            Tw.bg_white
                                in
                                a [ onClick (SelectTicket id), css [ Tw.transition_all, Tw.duration_200, Tw.py_2, Tw.px_2, Tw.text_gray_900, Tw.text_sm, Tw.font_semibold, Tw.cursor_pointer, Tw.rounded_lg, selectedAttr, hover [ Tw.bg_gray_200 ], focus [ Tw.bg_blue_900 ] ] ]
                                    [ text id ]
                            )
                    )
                ]

        ticketSection =
            let
                ticketContent =
                    case model.maybeSelectedTicket |> Maybe.andThen (flip Dict.get model.ticketsHtml) of
                        Nothing ->
                            text "Select a ticket"

                        Just loadingData ->
                            case loadingData of
                                Loading ->
                                    div [ css [ Tw.place_self_center, Tw.animate_spin, Tw.ease_linear, Tw.rounded_full, Tw.border_t_8, Tw.border_gray_300, Tw.h_10, Tw.w_10 ] ] []

                                Error ->
                                    text "Woops!"

                                Success ( escposCommand, ticketHtml ) ->
                                    let
                                        showPhoto =
                                            model.maybeSelectedTicket |> Maybe.withDefault "" |> (==) "Capabilities"

                                        capabilitiesPhoto =
                                            if showPhoto then
                                                [ img [ css [ Tw.col_span_1, Tw.py_14 ], src "https://user-images.githubusercontent.com/8648893/129381755-81baa7c4-016b-47bb-8867-ed0bbd54313e.png" ] [] ]

                                            else
                                                []

                                        ticketColSpan =
                                            if showPhoto then
                                                Tw.col_span_1

                                            else
                                                Tw.col_span_2
                                    in
                                    div
                                        [ css [ Tw.grid, Tw.grid_cols_1, Bp.lg [ Tw.grid_cols_2 ] ] ]
                                        (div [ css [ ticketColSpan, Tw.space_y_5, Tw.flex, Tw.flex_col, Tw.items_center ] ]
                                            [ button [ css [ Tw.space_x_1, Tw.shadow, Tw.bg_white, hover [ Tw.bg_gray_300 ], Tw.text_gray_900, Tw.font_bold, Tw.py_2, Tw.px_4, Tw.rounded, Tw.inline_flex, Tw.items_center ], onClick (ConnectAndPrint escposCommand) ]
                                                [ printerIcon
                                                , span [] [ text "Print" ]
                                                ]
                                            , div [ css [ Tw.bg_white, Tw.w_min, Tw.shadow_2xl ] ] [ ticketHtml ]
                                            ]
                                            :: capabilitiesPhoto
                                        )
            in
            section [ css [ Tw.px_6, Tw.py_6, Tw.col_span_4, Tw.bg_gray_200 ] ]
                [ div [ css [ Tw.flex, Tw.h_full, Tw.max_w_full, Tw.w_full, Tw.justify_center ] ]
                    [ ticketContent
                    ]
                ]
    in
    main_ [ css [ Tw.h_screen, Tw.grid, Tw.grid_cols_5 ] ]
        [ sidebar
        , ticketSection
        ]



-- HELPERS


parseHtml : String -> Maybe (Html msg)
parseHtml =
    Html.Parser.runDocument
        >> Result.toMaybe
        >> Maybe.map (.document >> Tuple.second)
        >> Maybe.map Html.Parser.Util.toVirtualDom
        >> Maybe.map (Html.div [])
        >> Maybe.map fromUnstyled


ticketDemoCmd : String -> TicketDemo -> Cmd Msg
ticketDemoCmd rendererEndpoint ticketDemo =
    let
        base64 =
            ticketDemo.escposCommand
                |> Escpos.encodeToBytes
                |> Base64.Encode.bytes
                |> Base64.Encode.encode

        body =
            Http.stringBody "multipart/form-data;boundary=boundary"
                (String.join "\n"
                    [ "--boundary"
                    , "Content-Disposition: form-data; name=\"receipt\""
                    , ""
                    , base64
                    , "--boundary--"
                    ]
                )
    in
    Http.post
        { url = rendererEndpoint
        , body = body
        , expect =
            Http.expectString
                (Result.toMaybe
                    >> Maybe.andThen parseHtml
                    >> Maybe.map (Tuple.pair ticketDemo.escposCommand)
                    >> GotTicketDemo ticketDemo.id
                )
        }


printerIcon =
    svg
        [ Svg.Styled.Attributes.css
            [ Tw.h_6
            , Tw.w_6
            ]
        , Svg.Styled.Attributes.fill "none"
        , Svg.Styled.Attributes.viewBox "0 0 24 24"
        , Svg.Styled.Attributes.stroke "currentColor"
        ]
        [ Svg.Styled.path
            [ Svg.Styled.Attributes.strokeLinecap "round"
            , Svg.Styled.Attributes.strokeLinejoin "round"
            , Svg.Styled.Attributes.strokeWidth "2"
            , Svg.Styled.Attributes.d "M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"
            ]
            []
        ]
