shb = require './lib/shb'
meilishuo = require './lib/meilishuo'
_ = require 'underscore'

module.exports =
  shb : shb
  meilishuo : meilishuo
# shb.get 'all', [1], (err, itemInfos) ->
#   console.dir itemInfos