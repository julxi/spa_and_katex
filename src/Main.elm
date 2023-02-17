module Main exposing (..)

import Browser exposing (Document, application)
import Html
import Html.Attributes
import Html.Events
import Url.Parser


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Model
    = Page1
    | Page2


init : Model
init =
    Page1



--:Model


link : msg -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
link href attrs children =
    Html.a
        (Html.Events.preventDefaultOn "click"
            (D.succeed ( href, True ))
            :: attrs
        )
        children


view : Model -> Document Msg
view model =
    { title = "Happy No-Mask-Day"
    , body =
        [ Element.layoutWith
            { options =
                [ Element.focusStyle
                    { borderColor = Nothing
                    , backgroundColor = Nothing
                    , shadow = Nothing
                    }
                ]
            }
            []
            (pageView model)
        ]
    }


pageView : Model -> Element Msg
pageView model =
    case model.route of
        Just Home ->
            Pages.Home.pageView

        Just DefinitonOfNoMaskDay ->
            Pages.WhatIsNoMaskDay.view

        Just LowPoints ->
            Pages.LowPoints.view

        Nothing ->
            [ text "route=nothing" ]
                |> PageLayouts.homePageLayout Element.none "bla"



-- Ui-Elements
