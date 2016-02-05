module HabitChart where

import HabitList exposing (update, view)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Time exposing (Time)
import Date exposing (Date, Month, fromTime, year, month, day, dayOfWeek, hour, minute, second)
import Date.Period as Period
import String exposing (left)

type alias Model = {
  habitList: HabitList.Model,
  date: Date,
  daysToShow: Int
}

type Action = NoOp | Update Date

-- Needed for foldp but not used (http://stackoverflow.com/a/34095298/480608)
startModel = {
    habitList = HabitList.model,
    date = fromTime 0,
    daysToShow = 6
  }

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

model : Signal Model
model =
  Signal.foldp update startModel (Signal.merge actions.signal clock)

clock : Signal Action
clock = Signal.map (Update << fromTime) (Time.every Time.second)

view : Signal.Address Action -> Model -> Html
view address model =
  div [ (style [
      ("margin-top", "25px"),
      ("margin-left", "25px")
    ]) ] [
    --viewHeaderRow model.date model.daysToShow viewHeaderMonthCell,
    viewHeaderRow model.date model.daysToShow viewHeaderDayCell,
    viewHeaderRow model.date model.daysToShow viewHeaderCell,
    HabitList.view (Signal.forwardTo address <| always NoOp) model.habitList
  ]

-- Gets a list of n days up to the given date
listOfDates : Date -> Int -> List Date
listOfDates date days =
  (List.map (\n -> (Period.add Period.Day -n date)) (List.reverse [0 .. days - 1]))

viewHeaderRow : Date -> Int -> (Date -> Html) -> Html
viewHeaderRow date days viewCell =
  div [] [
    span [ labelStyle ] [],
    span [] (List.map viewCell <| listOfDates date days)
  ]

viewHeaderMonthCell : Date -> Html
viewHeaderMonthCell date =
  span [ headerCellStyle ] [ text <| if day date == 1 then showFullMonth date else "" ]

viewHeaderDayCell : Date -> Html
viewHeaderDayCell date =
  span [ headerCellLightStyle ] [ text <| left 2 <| toString <| dayOfWeek date ]

viewHeaderCell : Date -> Html
viewHeaderCell date =
  span [ headerCellStyle ] [ text <| toString <| day date ]

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    Update date -> { model | date = date }

showDate : Date -> String
showDate date =
  toString (month date) ++ " " ++
  toString (day date) ++ ", " ++
  toString (year date) ++ "  " ++
  toString (hour date) ++ ":" ++
  toString (minute date) ++ ":" ++
  toString (second date)

showFullMonth : Date -> String
showFullMonth date =
  case month date of
    Date.Jan -> "January"
    Date.Feb -> "February"
    Date.Mar -> "March"
    Date.Apr -> "April"
    Date.May -> "May"
    Date.Jun -> "June"
    Date.Jul -> "July"
    Date.Aug -> "August"
    Date.Sep -> "September"
    Date.Oct -> "October"
    Date.Nov -> "November"
    Date.Dec -> "December"

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

headerCellStyle : Attribute
headerCellStyle = style [
    ("font-family", "Helvetica Neue"),
    ("font-weight", "400"),
    ("font-size", "12px"),
    ("display", "inline-block"),
    ("width", "20px"),
    ("height", "20px"),
    ("text-align", "center")
  ]

headerCellLightStyle : Attribute
headerCellLightStyle = style [
    ("font-family", "Helvetica Neue"),
    ("font-weight", "400"),
    ("font-size", "12px"),
    ("display", "inline-block"),
    ("width", "20px"),
    ("height", "20px"),
    ("text-align", "center"),
    ("color", "hsl(0, 0%, 80%)")
  ]
