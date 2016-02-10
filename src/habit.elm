module Habit where

import Zone exposing (update, view, Color(..))
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type alias Model = {
  label: String,
  zones: List (Maybe Color)
}

type Action = Something

model : Model
model = {
    label = "Meditation",
    zones = [
      Nothing,
      Nothing,
      Just Red,
      Just Red,
      Just Yellow,
      Just Yellow,
      Just Green,
      Just Green,
      Just Green,
      Just Yellow,
      Just Red
    ]
  }

view : Signal.Address Zone.Action -> Model -> Html
view address { label, zones } =
  div [] [
    span [ labelStyle ] [ text label ],
    span [] <| List.map (Zone.view address << toZone) zones
  ]

toZone : Maybe Color -> Zone.Model
toZone =
  Maybe.map (\c -> { color = c, faded = False } )

update : Action -> Model -> Model
update action model = model

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
