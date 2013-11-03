myUtil = require './util'
cheerio = require 'cheerio'
async = require 'async'
request = require 'request'
_ = require 'underscore'

shb = 
  get : (queries, pages, cbf) ->
    result = []
    queries = [queries] if !_.isArray queries
    async.eachLimit queries, 1, (query, cbf) =>
      async.eachLimit pages, 5, (page, cbf) =>
        @_getOnePage query, page, (err, itemInfos) ->
          result.push itemInfos if itemInfos
          cbf null
      , ->
        cbf null
    , ->
      cbf null,  _.flatten result, true


  _getUrl : (query, page = 1) ->
    category = query.category
    tag = query.tag

    if category == '衣服' && tag == '卫衣'
      url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E5%8D%AB%E8%A1%A3&page=#{page}"
    else if category == '衣服' && tag == '连衣裙'
      url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E8%BF%9E%E8%A1%A3%E8%A3%99&page=#{page}"
    else if category == '衣服' && tag == '牛仔裤'
      url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E7%89%9B%E4%BB%94%E8%A3%A4&page=#{page}"
    else if category == '衣服' && tag == '衬衫'
      url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E8%A1%AC%E8%A1%AB&page=#{page}"
    else if category == '衣服' && tag == '小脚裤'
      url = "http://www.chaobaida.com/qz/shb/items/?category=%E8%A1%A3%E6%9C%8D&style=%E5%85%A8%E9%83%A8&keyword=%E9%93%85%E7%AC%94%E8%A3%A4&page=#{page}"
    url
  _getOnePage : (query, page, cbf) ->
    url = @_getUrl query, page
    async.waterfall [
      (cbf) ->
        myUtil.request url, (err, html) ->
          if err
            cbf err
          else
            $ = cheerio.load html
            items = $ '#matchSetListContainer .imgContainer a'
            cbf null, _.compact _.map items, (item) ->
              item = $ item
              url = item.attr 'href'
              if ~url.indexOf 'taobao.com'
                imgSrc = item.find('img').attr('src').replace '_310x310.jpg', ''
                {
                  url : url
                  img : imgSrc
                }
              else
                null
      (itemInfos, cbf) ->
        url = require 'url'
        async.eachLimit itemInfos, 5, (itemInfo, cbf) ->
          myUtil.getItemUrlFromTaoke itemInfo.url, (err, itemUrl) ->
            if itemUrl
              itemInfo.url = itemUrl
              urlInfo = url.parse itemUrl, true
              itemInfo.id = urlInfo.query?.id
              _.extend itemInfo, query
            # delete itemInfo.url
            cbf null
        , ->
          cbf null, itemInfos
    ], cbf
module.exports = shb