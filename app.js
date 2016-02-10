var express = require('express')
var app = express()
app.use(express.static('.'))
var listener = app.listen(process.env.PORT || 3000, function () {
  console.log('Server listening on port ' + listener.address().port)
})