module Habit where

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (style, class)
import Html.Events exposing (onClick)
import StartApp.Simple exposing (start)
import DateUtil exposing (..)
import Zone exposing (update, view, Color(..))

type alias Model = {
  label: String,
  zones: List (Date, Maybe Color)
}

type Action = Rotate Date Zone.Action

model : Model
model = {
    label = "Meditation",
    zones = [
      (constDate "2016-01-31 00:00:00", Nothing),
      (constDate "2016-02-01 00:00:00", Nothing),
      (constDate "2016-02-02 00:00:00", Just Red),
      (constDate "2016-02-03 00:00:00", Just Red),
      (constDate "2016-02-04 00:00:00", Just Yellow),
      (constDate "2016-02-05 00:00:00", Just Yellow),
      (constDate "2016-02-06 00:00:00", Just Green),
      (constDate "2016-02-07 00:00:00", Just Green),
      (constDate "2016-02-08 00:00:00", Just Green),
      (constDate "2016-02-09 00:00:00", Just Yellow),
      (constDate "2016-02-10 00:00:00", Just Red)
    ]
  }

view : Signal.Address Action -> Model -> Html
view address { label, zones } =
  div [] [
    span [ class "habit-label", labelStyle ] [ text label ],
    span [] <| List.map (viewZone address) zones
  ]

viewZone : Signal.Address Action -> (Date, Maybe Color) -> Html
viewZone address (date, colorOrNot) =
  Zone.view (Signal.forwardTo address <| Rotate date) colorOrNot

update : Action -> Model -> Model
update (Rotate date zoneAction) { label, zones } =
  let
    updateZone : (Date, Maybe Color) -> (Date, Maybe Color)
    updateZone (zoneDate, colorOrNot) =
      (zoneDate,
        if dateEquals zoneDate date
        then Zone.update zoneAction colorOrNot
        else colorOrNot
      )
  in
    {
      label = label,
      zones = List.map updateZone zones
    }

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
