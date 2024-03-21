const express = require('express')
const app = express()
const port = 8000

app.use(express.urlencoded({ extended: false }));

app.use(express.json());


app.post('*', (req, res) => {
  res.json({headers: req.headers,body: req.body})
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})