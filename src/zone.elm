module Zone where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type Color = Red | Yellow | Green

type alias Model = { color: Color, decaying: Bool }

type Action = Rotate

model : Model
model = { color = Yellow, decaying = False }

nextZone : Model -> Model
nextZone model =
  { color =
    case model.color of
      Red -> Yellow
      Yellow -> Green
      Green -> Red
  , decaying = model.decaying
  }

colorToHex : Color -> String
colorToHex color =
  case color of
    Red -> "#E67C73"
    Yellow -> "#FFD666"
    Green -> "#57BB8A"

zoneStyle : Model -> Attribute
zoneStyle model =
  style
    [ ("background-color", colorToHex model.color)
    , ("display", "inline-block")
    , ("width", "20px")
    , ("height", "20px")
    , ("opacity", if model.decaying then "0.5" else "1")
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  span [ onClick address Rotate, zoneStyle model ] []

update : Action -> Model -> Model
update action model = nextZone model
