import Zone exposing (update, view, model)
import StartApp.Simple as StartApp

main =
  StartApp.start { model = model, view = view, update = update }

