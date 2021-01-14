/*
 * Copyright (c) 2021 Mathieu Dijoux ALL RIGHTS RESERVED
 */

// external requirements
const bodyParser = require ('body-parser');
const express = require ('express')
const package = require('./package.json')
//const fs = require('fs')
//const path = require('path')

// program parameters
const app = express()
const port = process.env.PORT || 8000


// using bodyParser to parse JSON bodies into JS objects
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json());

// setup API routes
app.use("/", require('./routes'))


// start server
app.listen(port, () => {
  console.log(`Program:\t${package.name}`)
  console.log(`Version:\t${package.version}`)
  console.log(`Author:\t\t${package.author}`)
  console.log(`\n-----------------------------------------`)
  console.log(`Starting server --> listening on port ${port}`)
  });