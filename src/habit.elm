module Habit where

import Zone exposing (update, view)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type alias Model = { label: String, zones: List Zone.Model }

type Action = Something

model : Model
model = { label = "Meditation", zones = [
    { color = Zone.Green, decaying = False },
    { color = Zone.Green, decaying = False },
    { color = Zone.Yellow, decaying = False },
    { color = Zone.Red, decaying = False }
  ]}

view : Signal.Address Zone.Action -> Model -> Html
view address model =
  div [ (style [
      ("margin-top", "25px"),
      ("margin-left", "25px")
    ]) ] [
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
    ("vertical-align", "top"),
    ("line-height", "25px"),
    ("margin-right", "20px"),
    ("text-transform", "uppercase")
  ]
