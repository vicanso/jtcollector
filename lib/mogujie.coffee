request = require './request'
cheerio = require 'cheerio'
async = require 'async'
_ = require 'underscore'


mogujie =
  get : (url, cbf) ->
    request url, (err, html) =>
      $ = cheerio.load html
      getMoguProfile = new Function "return #{$('script').eq(1).html().trim()}"
      moguProfile = getMoguProfile()
      items = $('#imagewall_container .i_w_f .pic a')
      console.dir moguProfile
      @_getAjaxHtml moguProfile
      @_getDetailUrl items, $



  _getAjaxHtml : (moguProfile) ->
    moguProfile.page = 0
    urls = []
    async.doWhilst (cbf) =>
      request {
        url : 'http://www.mogujie.com/book/ajax'
        method : 'POST'
        json : 
          lastTweetId : moguProfile.lastTweetId
          book : moguProfile.book
          totalCol : 4
          page : moguProfile.page
          total : moguProfile.totalCnt
        headers : 
          'Referer' : 'http://www.mogujie.com/shopping/'
      }, (err, res) =>
        if err
          cbf err
        else
          html = res?.result?.html?.book
          if html
            $ = cheerio.load html
            urls = urls.concat @_getDetailUrl $('.i_w_f .pic a'), $
            # console.dir _.uniq urls
          data = res?.result?.data
          console.dir data
          if data
            moguProfile.lastTweetId = data.lastTweetId
            moguProfile.lastTweetId = null if data.is_end
          else
            moguProfile.lastTweetId = null
          cbf null
    , ->
      moguProfile.page++
      moguProfile.page < 2
      # moguProfile.lastTweetId
    , (err) ->
      # console.dir err
      # console.dir urls
  _getDetailUrl : (items, $) ->
    _.map items, (item) ->
      item = $ item
      url = item.attr 'href'

module.exports = mogujie