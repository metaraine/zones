module Zone where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type Color = Red | Yellow | Green

type Model = Empty
  | Active Color
  | Decaying Color

type Action = Rotate

model : Model
model = Active Red

colorToHex : Color -> String
colorToHex color =
  case color of
    Red -> "#E67C73"
    Yellow -> "#FFD666"
    Green -> "#57BB8A"

zoneStyle : Model -> Attribute
zoneStyle model =
  style
    [ ("background-color", case model of
        Empty -> "white"
        Active color -> colorToHex color
        Decaying color -> colorToHex color
      )
    , ("display", "inline-block")
    , ("width", "20px")
    , ("height", "20px")
    , ("opacity", case model of
      Decaying _ -> "0.2"
      _ -> "1.0"
    )]

view : Signal.Address Action -> Model -> Html
view address model =
  span [ onClick address Rotate, zoneStyle model ] []

update : Action -> Model -> Model
update action model = model
