module Habit where

import Date exposing (Date)
import Zone exposing (update, view, Color(..))
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import StartApp.Simple exposing (start)

type alias Model = {
  label: String,
  zones: List (Date, Maybe Color)
}

type Action = Rotate Date

model : Model
model = {
    label = "Meditation",
    zones = [
      (constDate "2016-02-10 00:00:00", Nothing),
      (constDate "2016-02-10 00:00:00", Nothing),
      (constDate "2016-02-10 00:00:00", Just Red),
      (constDate "2016-02-10 00:00:00", Just Red),
      (constDate "2016-02-10 00:00:00", Just Yellow),
      (constDate "2016-02-10 00:00:00", Just Yellow),
      (constDate "2016-02-10 00:00:00", Just Green),
      (constDate "2016-02-10 00:00:00", Just Green),
      (constDate "2016-02-10 00:00:00", Just Green),
      (constDate "2016-02-10 00:00:00", Just Yellow),
      (constDate "2016-02-10 00:00:00", Just Red)
    ]
  }

view : Signal.Address Action -> Model -> Html
view address { label, zones } =
  div [] [
    span [ labelStyle ] [ text label ],
    span [] <| List.map (viewZone address) zones
  ]

viewZone : Signal.Address Action -> (Date, Maybe Color) -> Html
viewZone address (date, colorOrNot) =
  Zone.view (Signal.forwardTo address <| always <| Rotate date) colorOrNot

update : Action -> Model -> Model
update action model = model

main : Signal Html
main =
  start { model = model, update = update, view = view }

labelStyle : Attribute
labelStyle = style [
    ("font-family", "Helvetica Neue"),
    ("font-weight", "400"),
    ("font-size", "14px"),
    ("width", "120px"),
    ("display", "inline-block"),
    ("vertical-align", "top"),
    ("margin-right", "25px"),
    ("text-align", "right"),
    ("line-height", "22px"),
    ("text-transform", "uppercase")
  ]

constDate : String -> Date
constDate str =
  Result.withDefault (Date.fromTime 0) (Date.fromString str)

