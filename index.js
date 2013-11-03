(function() {
  var meilishuo, shb, _;

  shb = require('./lib/shb');

  meilishuo = require('./lib/meilishuo');

  _ = require('underscore');

  module.exports = {
    shb: shb,
    meilishuo: meilishuo
  };

}).call(this);
