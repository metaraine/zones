import Signal
import Html exposing (..)
import Html.Events exposing (..)
import Time exposing (Time)
import Date exposing (Date, Month, fromTime, year, month, day, hour, minute, second)

import HabitList
import Zone
import StartApp.Simple as StartApp

-- not used by foldp (http://stackoverflow.com/a/34095298/480608)
startTime = 0

type Action =
  NoOp
  | Update Time

type alias Model = {
  habitList: HabitList.Model,
  time: Time
}

showDate : Date -> String
showDate date = toString (month date) ++ " " ++
  toString (day date) ++ ", " ++
  toString (year date) ++ "  " ++
  toString (hour date) ++ ":" ++
  toString (minute date) ++ ":" ++
  toString (second date)

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    Update time -> { model | time = time }

model : Signal Model
model =
  Signal.foldp update { habitList = HabitList.model, time = startTime } (Signal.merge actions.signal clock )

clock : Signal Action
clock = Signal.map Update (Time.every Time.second)

main : Signal Html
main =
  Signal.map (view actions.address) model

view : Signal.Address Action -> Model -> Html
view address model =
  div [] [
    text <| showDate <| fromTime model.time,
    HabitList.view (Signal.forwardTo address <| always NoOp) model.habitList
  ]
