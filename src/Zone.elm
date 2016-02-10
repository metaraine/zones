module Zone where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import StartApp.Simple exposing (start)

type Color = Red | Yellow | Green

type Action = Rotate

model : Maybe Color
model = Just Green

colorToHex : Color -> String
colorToHex color =
  case color of
    Red -> "#E67C73"
    Yellow -> "#FFD666"
    Green -> "#57BB8A"

zoneStyle : Maybe Color -> Attribute
zoneStyle colorOrNot =
  style
    [ ("background-color", case colorOrNot of
      Just color -> colorToHex color
      Nothing -> "transparent")
    , ("display", "inline-block")
    , ("width", "20px")
    , ("height", "20px")
    ]

view : Signal.Address Action -> Maybe Color -> Html
view address model =
  span [ onClick address Rotate, zoneStyle model ] []

update : Action -> Maybe Color -> Maybe Color
update action =
  Maybe.map rotateColor

main : Signal Html
main =
  start { model = model, update = update, view = view }

rotateColor : Color -> Color
rotateColor color =
  case color of
    Green -> Red
    Yellow -> Green
    Red -> Yellow
