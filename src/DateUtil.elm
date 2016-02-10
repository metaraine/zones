module DateUtil where

import Date exposing (Date, Month, fromTime, year, month, day, dayOfWeek, hour, minute, second)
import Date.Period as Period
import Date.Compare as Compare exposing (Compare2 (..), is)

-- Elm date equality does not work in v0.16
dateEquals : Date -> Date -> Bool
dateEquals date1 date2 =
  year date1 == year date2 &&
  month date1 == month date2 &&
  day date1 == day date2

constDate : String -> Date
constDate str =
  Result.withDefault (Date.fromTime 0) (Date.fromString str)

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

-- Gets a list of n days up to the given date
listOfDates : Date -> Int -> List Date
listOfDates date days =
  List.map (\n -> (Period.add Period.Day -n date)) (List.reverse [0 .. days - 1])

