(function() {
  var async, defaultHeaders, loopGetUrl, request, util, zlib, _;

  _ = require('underscore');

  request = require('request');

  zlib = require('zlib');

  async = require('async');

  request = request.defaults({
    jar: true
  });

  defaultHeaders = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Encoding': 'gzip,deflate,sdch',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36'
  };

  util = {
    request: function(url, retryTimes, cbf) {
      var options, timeout,
        _this = this;
      if (_.isFunction(retryTimes)) {
        cbf = retryTimes;
        retryTimes = 2;
      }
      timeout = 60 * 1000;
      if (_.isObject(url)) {
        options = url;
        if (options.timeout == null) {
          options.timeout = timeout;
        }
        options.encoding = null;
      } else {
        options = {
          url: url,
          timeout: timeout,
          encoding: null
        };
      }
      if (options.headers == null) {
        options.headers = {};
      }
      options.headers = _.defaults(options.headers, defaultHeaders);
      return request(options, function(err, res, body) {
        var _ref;
        if (err) {
          if (retryTimes > 0) {
            return _this.request(url, --retryTimes, cbf);
          } else {
            return cbf(err);
          }
        } else if ((res != null ? (_ref = res.headers) != null ? _ref['content-encoding'] : void 0 : void 0) === 'gzip') {
          return zlib.gunzip(body, cbf);
        } else {
          return cbf(null, body);
        }
      });
    },
    getItemUrlFromTaoke: function(taokeUrl, cbf) {
      var options, url;
      url = require('url');
      options = {
        url: taokeUrl,
        followRedirect: false,
        timeout: 60 * 1000
      };
      return async.waterfall([
        function(cbf) {
          return request(options, function(err, res) {
            var location, _ref;
            location = res != null ? (_ref = res.headers) != null ? _ref.location : void 0 : void 0;
            if (location) {
              location = url.parse(location, true).query.tu;
            }
            return cbf(err, location);
          });
        }, function(taokeUrl, cbf) {
          options.url = taokeUrl;
          options.headers = {
            'Referer': "http://s.click.taobao.com/t_js?tu=" + (GLOBAL.encodeURIComponent(taokeUrl))
          };
          return request(options, function(err, res) {
            var itemId, location, urlInfo, _ref;
            location = res != null ? (_ref = res.headers) != null ? _ref.location : void 0 : void 0;
            itemId = null;
            if (location) {
              urlInfo = url.parse(location, true);
              itemId = urlInfo.query.id;
            }
            if (itemId) {
              return cbf(err, "http://" + urlInfo.host + urlInfo.pathname + "?id=" + itemId);
            } else {
              return loopGetUrl(location, options.url, cbf);
            }
          });
        }
      ], cbf);
    }
  };

  loopGetUrl = function(taokeUrl, currentUrl, cbf) {
    var itemId, options, url, urlInfo;
    url = require('url');
    itemId = null;
    urlInfo = null;
    options = {
      url: taokeUrl,
      followRedirect: false,
      timeout: 60 * 1000,
      headers: {
        'Referer': currentUrl
      }
    };
    return async.doWhilst(function(cbf) {
      return request(options, function(err, res) {
        var location, _ref;
        if (err) {
          cbf(err);
          return;
        }
        location = res != null ? (_ref = res.headers) != null ? _ref.location : void 0 : void 0;
        if (location) {
          urlInfo = url.parse(location, true);
          itemId = urlInfo.query.id;
          options.headers.Referer = options.url;
          options.url = location;
        } else {
          options = null;
        }
        return cbf(null);
      });
    }, function() {
      return options && !itemId;
    }, function(err) {
      if (itemId && urlInfo) {
        return cbf(err, "http://" + urlInfo.host + urlInfo.pathname + "?id=" + itemId);
      } else {
        return cbf(null);
      }
    });
  };

  module.exports = util;

}).call(this);
