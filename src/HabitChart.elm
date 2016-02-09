module HabitChart where

import Zone exposing (update, view, Color(..))
import Habit exposing (update, view)
import HabitList exposing (update, view)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Time exposing (Time)
import Date exposing (Date, Month, fromTime, year, month, day, dayOfWeek, hour, minute, second)
import Date.Period as Period
import Date.Compare as Compare exposing (Compare2 (..), is)
import String exposing (left)

type alias Model = {
  habitRecords: List HabitRecord,
  date: Date,
  daysToShow: Int
}

type alias HabitRecord = {
  label: String,
  decayRate: Int,
  checkins: List Checkin
}

type alias Checkin = {
  date: Date,
  color: Color
}

type Action = NoOp | Update Date

-- Needed for foldp but not used (http://stackoverflow.com/a/34095298/480608)
startModel = {
    habitRecords = [
      {
        label = "Sleep",
        decayRate = 2,
        checkins = [{
          date = constDate "2016-02-01 00:00:00",
          color = Yellow
        },{
          date = constDate "2016-02-04 00:00:00",
          color = Green
        },{
          date = constDate "2016-02-09 00:00:00",
          color = Green
        }]
      }
    ],
    date = fromTime 0,
    daysToShow = 10
  }

constDate : String -> Date
constDate str =
  Result.withDefault (Date.fromTime 0) (Date.fromString str)

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

model : Signal Model
model =
  Signal.foldp update startModel (Signal.merge actions.signal clock)

clock : Signal Action
clock = Signal.map (Update << fromTime) (Time.every Time.second)

view : Signal.Address Action -> Model -> Html
view address { date, daysToShow, habitRecords } =
  let
    dates = listOfDates date daysToShow
  in
    div [ (style [
        ("margin-top", "25px"),
        ("margin-left", "25px")
      ]) ] [
      --viewHeaderRow model.date model.daysToShow viewHeaderMonthCell,
      viewHeaderRow dates viewHeaderDayCell,
      viewHeaderRow dates viewHeaderCell,
      HabitList.view (Signal.forwardTo address <| always NoOp) (toHabitList dates habitRecords)
    ]

-- Elm date equality does not work in v0.16
dateEquals : Date -> Date -> Bool
dateEquals date1 date2 =
  year date1 == year date2 &&
  month date1 == month date2 &&
  day date1 == day date2

toHabitList : List Date -> List HabitRecord -> List Habit.Model
toHabitList dates habitRecords =
  let
    firstDate = case List.head dates of
      Just date -> date
      Nothing -> fromTime 0

    findZone : List Checkin -> Int -> Int -> Date -> Zone.Model
    findZone checkins decayRate decay date =
      let
        searchCheckin = List.head <| List.filter (dateEquals date << .date) checkins
      in
        case searchCheckin of
          Just { color } -> Zone.Active color
          Nothing -> if is Compare.SameOrAfter date firstDate
            -- TODO: Why does this pass Empty to decayZone on the second recursive call?
            then case findZone checkins decayRate (decay + 1) (Period.add Period.Day -1 date) of
              Zone.Active color -> decayZone decayRate decay color
              Zone.Decaying color -> decayZone decayRate decay color
              Zone.Empty -> Zone.Empty
            else Zone.Empty

    toHabit : HabitRecord -> Habit.Model
    toHabit { label, decayRate, checkins } = {
        label = label,
        zones = List.map (findZone checkins decayRate 0) dates
      }
  in
    List.map toHabit habitRecords

decayZone : Int -> Int -> Color -> Zone.Model
decayZone decayRate decay color =
  case color of
    Green -> if decay < decayRate then Zone.Active Green else Zone.Active Yellow
    Yellow -> if decay < decayRate then Zone.Active Yellow else Zone.Active Red
    Red -> Zone.Active Red

-- Gets a list of n days up to the given date
listOfDates : Date -> Int -> List Date
listOfDates date days =
  (List.map (\n -> (Period.add Period.Day -n date)) (List.reverse [0 .. days - 1]))

viewHeaderRow : List Date -> (Date -> Html) -> Html
viewHeaderRow dates viewCell =
  div [] [
    span [ labelStyle ] [],
    span [] <| List.map viewCell dates
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
