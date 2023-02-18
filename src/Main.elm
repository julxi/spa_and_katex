port module Main exposing (..)

import Browser exposing (Document, application)
import Element exposing (Attribute, Element)
import Element.Font
import Html
import Html.Attributes
import Html.Events
import Json.Decode as D
import Katex
import Url
import Url.Parser


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Route
    = Home
    | Other


init : String -> ( Route, Cmd Msg )
init url =
    ( locationHrefToRoute url, Cmd.none )


type Msg
    = PushUrl Route
    | UrlChanged String


update : Msg -> Route -> ( Route, Cmd Msg )
update msg route =
    case msg of
        PushUrl newRoute ->
            ( route, pushUrl (stringFromRoute newRoute) )

        UrlChanged url ->
            ( locationHrefToRoute url, renderMath () )


stringFromRoute : Route -> String
stringFromRoute route =
    case route of
        Home ->
            "/"

        Other ->
            "/other"


locationHrefToRoute : String -> Route
locationHrefToRoute locationHref =
    case Url.fromString locationHref of
        Nothing ->
            Home

        Just url ->
            Maybe.withDefault Home (Url.Parser.parse routeParser url)


routeParser : Url.Parser.Parser (Route -> a) a
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map Home Url.Parser.top
        , Url.Parser.map Other (Url.Parser.s "other")
        ]


view : Route -> Document Msg
view route =
    { title = "SPA and Katex"
    , body =
        [ Element.layout
            [ Element.Font.color (Element.rgb 1 1 1)
            ]
            (Element.el
                [ Element.centerX, Element.centerY ]
                (viewPage route)
            )
        ]
    }


viewPage : Route -> Element Msg
viewPage route =
    case route of
        Home ->
            Element.column [ Element.spacing 20 ]
                [ link Other "Link to Other"
                , Element.text "some text"
                , "\\mathrm{home} =  6.2 \\times 10^{-34}"
                    |> Katex.inline
                    |> Katex.print
                    |> Element.text
                ]

        Other ->
            Element.column [ Element.spacing 20 ]
                [ link Home "Link to Home"
                , "\\mathrm{other} = 1.3 \\times 10^{-6}"
                    |> Katex.inline
                    |> Katex.print
                    |> Element.text
                , Element.text "other text"
                ]


linkBehaviour : Route -> Attribute Msg
linkBehaviour route =
    Element.htmlAttribute
        (Html.Events.preventDefaultOn "click"
            (D.succeed
                ( PushUrl route, True )
            )
        )


link : Route -> String -> Element Msg
link route labelText =
    Element.link
        [ linkBehaviour route
        , Element.Font.color (Element.rgb255 119 35 177)
        , Element.Font.underline
        ]
        { url = stringFromRoute route
        , label = Element.text labelText
        }


subscriptions : Route -> Sub Msg
subscriptions route =
    Sub.batch
        [ onUrlChange UrlChanged
        ]


port onUrlChange : (String -> msg) -> Sub msg


port pushUrl : String -> Cmd msg


port renderMath : () -> Cmd msg
