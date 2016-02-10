module HabitList where

import Habit exposing (update, view)
import Zone exposing (update, view, Model, Color(..), Action(..))
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type alias Model = List Habit.Model

model : Model
model = [
    {
      label = "Sleep",
      zones = [
        Nothing,
        Just Red,
        Just Yellow,
        Just Green,
        Just Green,
        Just Green
      ]
    },
    {
      label = "Diet",
      zones = [
        Just Red,
        Just Red,
        Just Yellow,
        Just Yellow,
        Just Green,
        Just Yellow
      ]
    },
    {
      label = "Meditation",
      zones = [
        Nothing,
        Just Red,
        Just Yellow,
        Just Green,
        Just Green,
        Just Yellow
      ]
    },
    {
      label = "Exercise",
      zones = [
        Just Green,
        Just Green,
        Just Green,
        Just Yellow,
        Just Yellow,
        Just Red
      ]
    }
  ]

view : Signal.Address Action -> Model -> Html
view address model =
  div [] <| List.map (Habit.view address) model

update : Action -> Model -> Model
update action model = model
