module HabitList where

import Habit exposing (update, view)
import Zone exposing (update, view)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type alias Model = List Habit.Model

model : Model
model = [
    {
      label = "Sleep",
      zones = [
        Zone.Empty,
        Zone.Active Zone.Red,
        Zone.Active Zone.Yellow,
        Zone.Active Zone.Green,
        Zone.Active Zone.Green,
        Zone.Decaying Zone.Green
      ]
    },
    {
      label = "Diet",
      zones = [
        Zone.Active Zone.Red,
        Zone.Active Zone.Red,
        Zone.Active Zone.Yellow,
        Zone.Active Zone.Yellow,
        Zone.Active Zone.Green,
        Zone.Decaying Zone.Yellow
      ]
    },
    {
      label = "Meditation",
      zones = [
        Zone.Empty,
        Zone.Active Zone.Red,
        Zone.Active Zone.Yellow,
        Zone.Active Zone.Green,
        Zone.Active Zone.Green,
        Zone.Decaying Zone.Yellow
      ]
    },
    {
      label = "Exercise",
      zones = [
        Zone.Active Zone.Green,
        Zone.Active Zone.Green,
        Zone.Active Zone.Green,
        Zone.Active Zone.Yellow,
        Zone.Active Zone.Yellow,
        Zone.Decaying Zone.Red
      ]
    }
  ]

view : Signal.Address Zone.Action -> Model -> Html
view address model =
  div [] (List.map (Habit.view address) model)

update : Zone.Action -> Model -> Model
update action model = model
