# lightsaber = require('lightsaber')
# d = lightsaber.d
# log = lightsaber.log
# json = lightsaber.json
# pjson = lightsaber.pjson
#
# client = require('core-network-client')
# Scene = client.core.Scene
# WallLayout = client.layouts.WallLayout
# TableLayout = client.layouts.TableLayout
# SphereLayout = client.layouts.SphereLayout
#
# sphere = require('nodesphere')
# GoogleSpreadsheet = sphere.adaptor.GoogleSpreadsheet
#
# SPREADSHEET_ID = '19S6kIq9-kv1pZBsICr9uzdoxga0tatlVBWqMEwFYuNU'
# SPREADSHEET_ORIENTATION = 'rows'
#
# GoogleSpreadsheet.create({
#   id: SPREADSHEET_ID,
#   gsheet_orientation: SPREADSHEET_ORIENTATION
# }).then(function(gsheet) {
#   return gsheet.fetch()
# }).then(function(sphere) {
#   sphere.should.deep.eq {
#   }
# })
