fs = require 'fs'
Snockets = require 'snockets'

NAME = 'main'
OUTPUTNAME = 'all'
INPUT_FILE = "src/#{NAME}.coffee"
OUTPUT_FILE = "lib/#{OUTPUTNAME}.js"

task 'build', 'Build lib/ from src/', ->
  snockets = new Snockets()
  js = snockets.getConcatenation INPUT_FILE, async: false, minify: false
  fs.writeFileSync OUTPUT_FILE, js

task 'clean', "remove #{OUTPUT_FILE}", ->
  fs.unlinkSync OUTPUT_FILE