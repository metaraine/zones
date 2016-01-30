import Habit exposing (update, view, model)
import StartApp.Simple as StartApp

main = StartApp.start { model = model, view = view, update = update }
