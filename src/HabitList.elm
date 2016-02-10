module HabitList where

import Date exposing (Date)
import Habit exposing (update, view)
import Zone exposing (update, view, Color(..))
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import StartApp.Simple exposing (start)

type Action = Rotate String Habit.Action

model : List Habit.Model
model = [
    {
      label = "Sleep",
      zones = [
        (constDate "2016-02-10 00:00:00", Nothing),
        (constDate "2016-02-10 00:00:00", Just Red),
        (constDate "2016-02-10 00:00:00", Just Yellow),
        (constDate "2016-02-10 00:00:00", Just Green),
        (constDate "2016-02-10 00:00:00", Just Green),
        (constDate "2016-02-10 00:00:00", Just Green)
      ]
    },
    {
      label = "Diet",
      zones = [
        (constDate "2016-02-10 00:00:00", Just Red),
        (constDate "2016-02-10 00:00:00", Just Red),
        (constDate "2016-02-10 00:00:00", Just Yellow),
        (constDate "2016-02-10 00:00:00", Just Yellow),
        (constDate "2016-02-10 00:00:00", Just Green),
        (constDate "2016-02-10 00:00:00", Just Yellow)
      ]
    },
    {
      label = "Meditation",
      zones = [
        (constDate "2016-02-10 00:00:00", Nothing),
        (constDate "2016-02-10 00:00:00", Just Red),
        (constDate "2016-02-10 00:00:00", Just Yellow),
        (constDate "2016-02-10 00:00:00", Just Green),
        (constDate "2016-02-10 00:00:00", Just Green),
        (constDate "2016-02-10 00:00:00", Just Yellow)
      ]
    },
    {
      label = "Exercise",
      zones = [
        (constDate "2016-02-10 00:00:00", Just Green),
        (constDate "2016-02-10 00:00:00", Just Green),
        (constDate "2016-02-10 00:00:00", Just Green),
        (constDate "2016-02-10 00:00:00", Just Yellow),
        (constDate "2016-02-10 00:00:00", Just Yellow),
        (constDate "2016-02-10 00:00:00", Just Red)
      ]
    }
  ]

view : Signal.Address Action -> List Habit.Model -> Html
view address habits =
  div [] <| List.map (viewHabit address) habits

viewHabit : Signal.Address Action -> Habit.Model -> Html
viewHabit address model =
  Habit.view (Signal.forwardTo address <| Rotate model.label) model

update : Action -> List Habit.Model -> List Habit.Model
update action habits = habits

main : Signal Html
main =
  start { model = model, update = update, view = view }

constDate : String -> Date
constDate str =
  Result.withDefault (Date.fromTime 0) (Date.fromString str)
