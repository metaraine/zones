module Zone where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type Color = Red | Yellow | Green

type Action = Rotate

type alias Model = Maybe {
  color: Color,
  faded: Bool
}

model : Model
model = Just {
    color = Green,
    faded = False
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
    [ ("background-color", case model of
      Just { color } -> colorToHex color
      Nothing -> "transparent")
    , ("display", "inline-block")
    , ("width", "20px")
    , ("height", "20px")
    , ("opacity", case model of
      Just { faded } -> if faded then "0.3" else "1.0"
      Nothing -> "1.0")
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  span [ onClick address Rotate, zoneStyle model ] []

update : Action -> Model -> Model
update action model = model
