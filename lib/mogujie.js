(function() {
  var async, cheerio, mogujie, request, _;

  request = require('./request');

  cheerio = require('cheerio');

  async = require('async');

  _ = require('underscore');

  mogujie = {
    get: function(url, cbf) {
      var _this = this;
      return request(url, function(err, html) {
        var $, getMoguProfile, items, moguProfile;
        $ = cheerio.load(html);
        getMoguProfile = new Function("return " + ($('script').eq(1).html().trim()));
        moguProfile = getMoguProfile();
        items = $('#imagewall_container .i_w_f .pic a');
        console.dir(moguProfile);
        _this._getAjaxHtml(moguProfile);
        return _this._getDetailUrl(items, $);
      });
    },
    _getAjaxHtml: function(moguProfile) {
      var urls,
        _this = this;
      moguProfile.page = 0;
      urls = [];
      return async.doWhilst(function(cbf) {
        return request({
          url: 'http://www.mogujie.com/book/ajax',
          method: 'POST',
          json: {
            lastTweetId: moguProfile.lastTweetId,
            book: moguProfile.book,
            totalCol: 4,
            page: moguProfile.page,
            total: moguProfile.totalCnt
          },
          headers: {
            'Referer': 'http://www.mogujie.com/shopping/'
          }
        }, function(err, res) {
          var $, data, html, _ref, _ref1, _ref2;
          if (err) {
            return cbf(err);
          } else {
            html = res != null ? (_ref = res.result) != null ? (_ref1 = _ref.html) != null ? _ref1.book : void 0 : void 0 : void 0;
            if (html) {
              $ = cheerio.load(html);
              urls = urls.concat(_this._getDetailUrl($('.i_w_f .pic a'), $));
            }
            data = res != null ? (_ref2 = res.result) != null ? _ref2.data : void 0 : void 0;
            console.dir(data);
            if (data) {
              moguProfile.lastTweetId = data.lastTweetId;
              if (data.is_end) {
                moguProfile.lastTweetId = null;
              }
            } else {
              moguProfile.lastTweetId = null;
            }
            return cbf(null);
          }
        });
      }, function() {
        moguProfile.page++;
        return moguProfile.page < 2;
      }, function(err) {});
    },
    _getDetailUrl: function(items, $) {
      return _.map(items, function(item) {
        var url;
        item = $(item);
        return url = item.attr('href');
      });
    }
  };

  module.exports = mogujie;

}).call(this);
