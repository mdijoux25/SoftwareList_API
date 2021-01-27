/*
 * Copyright (c) 2021 Mathieu Dijoux ALL RIGHTS RESERVED
 */
 
const { json } = require('body-parser')
const fs = require('fs')
const path = require('path')
const converter = require ('json-2-csv')

const dataDir = path.join(__dirname, 'data')
const jsonDir = path.join(dataDir, 'JSON')
const dataFile = path.join(dataDir, 'Software-Listing.log')


// create data directories and files
fs.existsSync(dataDir) || fs.mkdirSync(dataDir)
fs.existsSync(jsonDir) || fs.mkdirSync(jsonDir)
fs.existsSync(dataFile) || fs.open(dataFile, 'w', (err) => { if (err) throw err })



async function parseListing(softwarelist){
// timestamp variable
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
    fs.appendFileSync(dataFile, JSON.stringify(softwarelist, ['Timestamp','Hostname', 'Username']) + '\n', (err) => {
      if (err) throw err
    })
      
      const jsonFile = path.join(jsonDir, softwarelist['Hostname']+'.json')
      fs.existsSync(jsonFile) || fs.writeFileSync(jsonFile, JSON.stringify(softwarelist))
      const finalCSV = path.join(dataDir, softwarelist['Hostname']+'.csv')

        // create CSV entry for M$ Autopilot
        let options = {
          expandArrayObjects : true,
          unwindArrays : true,
          excelBOM : true,
          keys : ['Hostname','OS','Username','Domain','BiosVersion','Model','Serial','Processor','RamCount','RamSize','Monitor.type','Monitor.Ecran 1.Marque','Monitor.Ecran 1.Modele','Monitor.Ecran 1.Serial','Monitor.Ecran 2.Marque','Monitor.Ecran 2.Modele','Monitor.Ecran 2.Serial','Monitor.Ecran 3.Marque','Monitor.Ecran 3.Modele','Monitor.Ecran 3.Serial','Monitor.Disk1','Monitor.Disk1.Size','Monitor.Disk1.FreeSpace','Monitor.Disk2','Monitor.Disk2.Size','Monitor.Disk2.FreeSpace','Monitor.Disk3','Monitor.Disk3.Size','Monitor.Disk3.FreeSpace','Software.DisplayName','Software.DisplayVersion','Software.Publisher','Software.InstallDate']
        }
        converter.json2csv(softwarelist,(err, csv) => {
          if (err) {
            throw err;
          }
          fs.writeFileSync(finalCSV, csv)
        }, options)
       
          console.log(softwarelist['Timestamp']+" " + softwarelist['Hostname'] + " : " + "Successful.")
          return { "response": "success" }
        }
        else {
          console.log(softwarelist['Hostname'] + " : " + "already made.")
          return { "response": "Listing already made" }
        }
}

module.exports = {
    parseListing
  }