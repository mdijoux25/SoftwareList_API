/*
 * Copyright (c) 2021 Mathieu Dijoux ALL RIGHTS RESERVED
 */

// external requirements
const express = require('express')
const router = express.Router()

// paramters
const apps = require('./SoftwareParserService')

// APIs
router.get('/', rootPath)
router.post('/list', listSoft)

// API functions
function rootPath(req, res, next) {
    res.status(200).send("Successfull connection.")
  }

 function listSoft(req, res, next) {
    apps
      .parseListing(req.body)
      .then(parsed => (parsed ? res.json(parsed) : res.sendStatus(404)))
      .catch(err => next(err))
  }

  module.exports = router