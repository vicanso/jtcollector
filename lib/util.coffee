_ = require 'underscore'
request = require 'request'
zlib = require 'zlib'
async = require 'async'
request = request.defaults {jar: true}

defaultHeaders = 
  'Accept' : 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
  'Accept-Encoding' : 'gzip,deflate,sdch'
  'User-Agent' : 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36'
util =
  request :  (url,  retryTimes, cbf) ->
    if _.isFunction retryTimes
      cbf = retryTimes
      retryTimes = 2
    timeout = 60 * 1000
    if _.isObject url
      options = url
      options.timeout ?= timeout
      options.encoding = null
    else
      options = 
        url : url
        timeout : timeout
        encoding : null
    options.headers ?= {}
    options.headers = _.defaults options.headers, defaultHeaders
    # console.dir options.headers
    request options, (err, res, body) =>
      if err
        if retryTimes > 0
          @request url, --retryTimes, cbf
        else
          cbf err
      else if res?.headers?['content-encoding'] == 'gzip'
        zlib.gunzip body, cbf
      else
        cbf null, body
  getItemUrlFromTaoke : (taokeUrl, cbf) ->
    url = require 'url'
    options = 
      url : taokeUrl
      followRedirect : false
      timeout : 60 * 1000
    async.waterfall [
      (cbf) ->
        request options, (err, res) ->
          location = res?.headers?.location
          if location
            location = url.parse(location, true).query.tu
          cbf err, location
      (taokeUrl, cbf) ->
        options.url = taokeUrl
        # options.followRedirect = true
        options.headers = 
          'Referer' : "http://s.click.taobao.com/t_js?tu=#{GLOBAL.encodeURIComponent(taokeUrl)}"
        request options, (err, res) ->
          location = res?.headers?.location
          itemId = null
          if location
            urlInfo = url.parse location, true
            itemId = urlInfo.query.id
          if itemId
            cbf err, "http://#{urlInfo.host}#{urlInfo.pathname}?id=#{itemId}"
          else
            loopGetUrl location, options.url, cbf
    ], cbf


loopGetUrl = (taokeUrl, currentUrl, cbf) ->
  url = require 'url'
  itemId = null
  urlInfo = null
  options = 
    url : taokeUrl
    followRedirect : false
    timeout : 60 * 1000
    headers : 
      'Referer' : currentUrl
  async.doWhilst (cbf) ->
    request options, (err, res) ->
      if err
        cbf err
        return
      location = res?.headers?.location
      if location
        urlInfo = url.parse location, true
        itemId = urlInfo.query.id
        options.headers.Referer = options.url
        options.url = location
      else
        options = null
      cbf null
  , ->
    options && !itemId
  , (err)->
    if itemId && urlInfo
      cbf err, "http://#{urlInfo.host}#{urlInfo.pathname}?id=#{itemId}"
    else
      cbf null


module.exports = util