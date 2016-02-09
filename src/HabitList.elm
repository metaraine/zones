module HabitList where

import Habit exposing (update, view)
import Zone exposing (update, view, Model(..), Color(..), Action(..))
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type alias Model = List Habit.Model

model : Model
model = [
    {
      label = "Sleep",
      zones = [
        Empty,
        Active Red,
        Active Yellow,
        Active Green,
        Active Green,
        Decaying Green
      ]
    },
    {
      label = "Diet",
      zones = [
        Active Red,
        Active Red,
        Active Yellow,
        Active Yellow,
        Active Green,
        Decaying Yellow
      ]
    },
    {
      label = "Meditation",
      zones = [
        Empty,
        Active Red,
        Active Yellow,
        Active Green,
        Active Green,
        Decaying Yellow
      ]
    },
    {
      label = "Exercise",
      zones = [
        Active Green,
        Active Green,
        Active Green,
        Active Yellow,
        Active Yellow,
        Decaying Red
      ]
    }
  ]

view : Signal.Address Action -> Model -> Html
view address model =
  div [] (List.map (Habit.view address) model)

update : Action -> Model -> Model
update action model = model
