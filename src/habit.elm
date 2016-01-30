module Habit where

import Zone exposing (update, view)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type alias Model = { label: String, zones: List Zone.Model }

type Action = Something

model : Model
model = { label = "Meditation", zones = [
    Zone.Empty,
    Zone.Empty,
    Zone.Decaying Zone.Red,
    Zone.Decaying Zone.Red,
    Zone.Decaying Zone.Yellow,
    Zone.Decaying Zone.Yellow,
    Zone.Decaying Zone.Green,
    Zone.Active Zone.Green,
    Zone.Active Zone.Green,
    Zone.Active Zone.Yellow,
    Zone.Active Zone.Red
  ]}

view : Signal.Address Zone.Action -> Model -> Html
view address model =
  div [] [
    span [ labelStyle ] [ text model.label ],
    span [] (List.map (Zone.view address) model.zones)
  ]

--viewZone : Signal.Address Action -> Zone.Model -> Html
--viewZone address zoneModel =
--  Zone.view address zoneModel

update : Zone.Action -> Model -> Model
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
