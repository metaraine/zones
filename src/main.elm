import Signal
import Html exposing (..)
import Html.Events exposing (..)

import HabitChart
import StartApp.Simple as StartApp

type Action = NoOp

model : Signal HabitChart.Model
model = HabitChart.model

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

main : Signal Html
main =
  Signal.map (view actions.address) model

view : Signal.Address Action -> HabitChart.Model -> Html
view address model =
  HabitChart.view (Signal.forwardTo address <| always NoOp) model
  --div [] [
  --  text <| showDate <| fromTime model.time,
  --]
