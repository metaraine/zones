--module HabitChart where

import Time exposing (Time)
import Date exposing (Date, Month, fromTime, year, month, day, dayOfWeek, hour, minute, second)
import Date.Period as Period
import Date.Compare as Compare exposing (Compare2 (..), is)
import String exposing (left)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import DateUtil exposing (..)
import Zone exposing (update, view, Color(..))
import Habit exposing (update, view)
import HabitList exposing (update, view)

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

type Action =
  NoOp
  | Rotate HabitList.Action
  | UpdateLabel String
  | Tick Date

-- Needed for foldp but not used (http://stackoverflow.com/a/34095298/480608)
startModel = {
    habitRecords = [
      {
        label = "Sleep",
        decayRate = 2,
        checkins = [{
          date = constDate "2016-03-15 00:00:00",
          color = Green
        },{
          date = constDate "2016-03-16 00:00:00",
          color = Green
        },{
          date = constDate "2016-03-17 00:00:00",
          color = Green
        }]
      }
    ],
    date = fromTime 0,
    daysToShow = 14
  }

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

model : Signal Model
model =
  Signal.foldp update startModel (Signal.mergeMany [actions.signal, clock, labelActions])

clock : Signal Action
clock = Signal.map (Tick << fromTime) (Time.every Time.second)

labelActions : Signal Action
labelActions =
  Signal.map UpdateLabel label

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
      HabitList.view (Signal.forwardTo address Rotate) (toHabitList dates habitRecords)
    ]

toHabitList : List Date -> List HabitRecord -> List Habit.Model
toHabitList dates habitRecords =
  let
    firstDate = Maybe.withDefault (fromTime 0) <| List.head dates

    findZone : List Checkin -> Int -> Int -> Date -> Maybe Color
    findZone checkins decayRate decay date =
      let
        searchCheckin = List.head <| List.filter (dateEquals date << .date) checkins
      in
        case searchCheckin of
          Just { color } -> Just color
          Nothing -> if is Compare.SameOrAfter date firstDate
            then
              let
                nextDecay = (decay + 1) % (if decayRate == 0 then 1 else decayRate)
                zone = findZone checkins decayRate nextDecay <| Period.add Period.Day -1 date
              in
                Maybe.map (decayZone decayRate (decay+1)) zone
            else Nothing

    toHabit : HabitRecord -> Habit.Model
    toHabit { label, decayRate, checkins } = {
        label = label,
        zones = List.map (\date -> (date, findZone checkins decayRate 0 date)) dates
      }
  in
    List.map toHabit habitRecords

decayZone : Int -> Int -> Color -> Color
decayZone decayRate decay color =
  if decayRate == 0 then Red
  else if decay < decayRate then color
  else decayStep color

decayStep : Color -> Color
decayStep color =
  case color of
    Green -> Yellow
    _ -> Red

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
    Rotate (HabitList.Rotate label (Habit.Rotate zoneDate zoneAction)) ->
      { model |
        habitRecords = List.map (updateRecord label zoneDate) model.habitRecords
      }
    UpdateLabel label ->
      { model |
        habitRecords = List.map (updateRecordLabel label) model.habitRecords
      }
    Tick date -> { model | date = date }

updateRecord : String -> Date -> HabitRecord -> HabitRecord
updateRecord label date habitRecord =
  let
    updateCheckin : Checkin -> Checkin
    updateCheckin checkin =
      if dateEquals date checkin.date
      then {
        date = checkin.date,
        color = Zone.rotateColor checkin.color
      }
      else checkin

    findCheckin : List Checkin -> Date -> Maybe Checkin
    findCheckin checkins date =
      List.head <| List.filter (dateEquals date << .date) checkins
  in
    { habitRecord |
      checkins =
        case findCheckin habitRecord.checkins date of
          Just _ -> List.map updateCheckin habitRecord.checkins
          Nothing -> { date = date , color = Green } :: habitRecord.checkins
    }

updateRecordLabel : String -> HabitRecord -> HabitRecord
updateRecordLabel label habitRecord =
  { habitRecord |
    label = label
  }

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

main : Signal Html
main =
  Signal.map (view actions.address) model

port label : Signal String
