/*
 * Copyright (c) 2021 Mathieu Dijoux ALL RIGHTS RESERVED
 */
 
const fs = require('fs')
const path = require('path')

const regStructValues = ['Hostname', 'OS', 'Username', 'Domain', 'List of Software', 'Count of Software']
const dataDir = path.join(__dirname, 'data')
const dataFile = path.join(dataDir, 'Software-Listing.log')
const errorFile = path.join(dataDir, 'Software-Listing_error.log')
const finalCSV = path.join(dataDir, 'Software-Listing_final.csv')

// create data directories and files
fs.existsSync(dataDir) || fs.mkdirSync(dataDir)
fs.existsSync(dataFile) || fs.open(dataFile, 'w', (err) => { if (err) throw err })
fs.existsSync(errorFile) || fs.open(errorFile, 'w', (err) => { if (err) throw err })
fs.existsSync(errorFile) || fs.writeFileSync(finalCSV, `"Timestamp",${regStructValues.map(value => { return '"' + value + '"' })}\n`)

async function parseListing(softwarelist){
// timestamp
softwarelist['Timestamp'] = new Date().toISOString(Date.now())

// verify the host has not been entered already
var exists = false
fs.readFileSync(dataFile).toString().split('\n').map(line => {
    if (line != '') {
      if (softwarelist['Hostname'] == JSON.parse(line)['Hostname'])
        exists = true
    }
  })

  if (!exists) {
    // log successful registration
    fs.appendFileSync(dataFile, JSON.stringify(softwarelist) + '\n', (err) => {
      if (err) throw err
    })

        // create CSV entry for M$ Autopilot
        fs.appendFileSync(finalCSV, `"${softwarelist.Timestamp}",${regStructValues.map(value => { return softwarelist[value] })}\n`, (err) => {
            if (err) throw err
          })
          console.log(softwarelist['Timestamp'] + " : " + "Successful.")
          return { "response": "success" }
        }
        else {
          return { "response": "Listing already made" }
        }
}

module.exports = {
    parseListing
  }