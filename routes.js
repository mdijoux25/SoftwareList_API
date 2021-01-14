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

// API functions
function rootPath(req, res, next) {
    res.status(200).send("Successfull connection.")
  }


  module.exports = router