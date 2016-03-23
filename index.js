$(function () {

  FastClick.attach(document.body)

  $('.habit-label').editable(function(value, settings) {
    app.ports.label.send(value)
    return value
  })

})
