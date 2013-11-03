(function() {
  var async, cheerio, myUtil, request, shb, _;

  myUtil = require('./util');

  cheerio = require('cheerio');

  async = require('async');

  request = require('request');

  _ = require('underscore');

  shb = {
    get: function(queries, pages, cbf) {
      var result,
        _this = this;
      result = [];
      if (!_.isArray(queries)) {
        queries = [queries];
      }
      return async.eachLimit(queries, 1, function(query, cbf) {
        return async.eachLimit(pages, 5, function(page, cbf) {
          return _this._getOnePage(query, page, function(err, itemInfos) {
            if (itemInfos) {
              result.push(itemInfos);
            }
            return cbf(null);
          });
        }, function() {
          return cbf(null);
        });
      }, function() {
        return cbf(null, _.flatten(result, true));
      });
    },
    _getUrl: function(query, page) {
      var category, tag, url;
      if (page == null) {
        page = 1;
      }
      category = query.category;
      tag = query.tag;
      if (category === '衣服' && tag === '卫衣') {
        url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E5%8D%AB%E8%A1%A3&page=" + page;
      } else if (category === '衣服' && tag === '连衣裙') {
        url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E8%BF%9E%E8%A1%A3%E8%A3%99&page=" + page;
      } else if (category === '衣服' && tag === '牛仔裤') {
        url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E7%89%9B%E4%BB%94%E8%A3%A4&page=" + page;
      } else if (category === '衣服' && tag === '衬衫') {
        url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E8%A1%AC%E8%A1%AB&page=" + page;
      } else if (category === '衣服' && tag === '小脚裤') {
        url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E9%93%85%E7%AC%94%E8%A3%A4&page=" + page;
      }
      return url;
    },
    _getOnePage: function(query, page, cbf) {
      var url;
      url = this._getUrl(query, page);
      return async.waterfall([
        function(cbf) {
          return myUtil.request(url, function(err, html) {
            var $, items;
            if (err) {
              return cbf(err);
            } else {
              $ = cheerio.load(html);
              items = $('#matchSetListContainer .imgContainer a');
              return cbf(null, _.compact(_.map(items, function(item) {
                var imgSrc;
                item = $(item);
                url = item.attr('href');
                if (~url.indexOf('taobao.com')) {
                  imgSrc = item.find('img').attr('src').replace('_310x310.jpg', '');
                  return {
                    url: url,
                    img: imgSrc
                  };
                } else {
                  return null;
                }
              })));
            }
          });
        }, function(itemInfos, cbf) {
          url = require('url');
          return async.eachLimit(itemInfos, 5, function(itemInfo, cbf) {
            return myUtil.getItemUrlFromTaoke(itemInfo.url, function(err, itemUrl) {
              var urlInfo, _ref;
              if (itemUrl) {
                itemInfo.url = itemUrl;
                urlInfo = url.parse(itemUrl, true);
                itemInfo.id = (_ref = urlInfo.query) != null ? _ref.id : void 0;
                _.extend(itemInfo, query);
              }
              return cbf(null);
            });
          }, function() {
            return cbf(null, itemInfos);
          });
        }
      ], cbf);
    }
  };

  module.exports = shb;

}).call(this);
