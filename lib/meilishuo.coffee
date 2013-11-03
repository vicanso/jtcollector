myUtil = require './util'
cheerio = require 'cheerio'
async = require 'async'
request = require 'request'
_ = require 'underscore'

meilishuo =
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
  _getUrls : (query, page = 1) ->
    page--
    category = query.category
    tag = query.tag
    urls = []
    urls = _.map [0...8], (frame) ->
      if category == '衣服' && tag == '秋装'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2255"
      else if category == '衣服' && tag == '毛衣'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2613"
      else if category == '衣服' && tag == '外套'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2023"
      else if category == '衣服' && tag == '西装'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2257"
      else if category == '衣服' && tag == '牛仔外套'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2031"
      else if category == '衣服' && tag == '大衣'
        url = "http://www.meilishuo.com/aj/getGoods/attr?frame=#{frame}&page=#{page}&view=1&word=34370&section=hot&hi=&price=all"
      else if category == '衣服' && tag == '卫衣'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2033"
      else if category == '衣服' && tag == '衬衫'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2045"
      else if category == '衣服' && tag == '连衣裙'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2055"
      else if category == '衣服' && tag == '长裙'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2053"
      else if category == '衣服' && tag == '半身裙'
        url = "http://www.meilishuo.com/aj/getGoods/attr?frame=#{frame}&page=#{page}&view=1&word=36861&section=hot&hi=&price=all"
      else if category == '衣服' && tag == '伞裙'
        url = "http://www.meilishuo.com/aj/getGoods/attr?frame=#{frame}&page=#{page}&view=1&word=39403&section=hot&hi=&price=all"
      else if category == '衣服' && tag == '背心裙'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2063"
      else if category == '衣服' && tag == '百褶裙'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2067"
      else if category == '衣服' && tag == '牛仔裤'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2097"
      else if category == '衣服' && tag == '小脚裤'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2091"
      else if category == '衣服' && tag == '打底裤'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2089"
      else if category == '衣服' && tag == '铅笔裤'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2103"
      else if category == '衣服' && tag == '哈伦裤'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2087"
      else if category == '衣服' && tag == '九分裤'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2085"
      else if category == '衣服' && tag == '内裤'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2115"
      else if category == '衣服' && tag == '文胸'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=2000000000000&section=hot&price=all&nid=2113"
      else if category == '鞋子' && tag == '平底鞋'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=6000000000000&section=hot&price=all&nid=2135"
      else if category == '鞋子' && tag == '帆布鞋'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=6000000000000&section=hot&price=all&nid=2127"
      else if category == '鞋子' && tag == '厚底鞋'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=6000000000000&section=hot&price=all&nid=2131"
      else if category == '鞋子' && tag == '粗跟鞋'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=6000000000000&section=hot&price=all&nid=2145"
      else if category == '鞋子' && tag == '靴子'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=6000000000000&section=hot&price=all&nid=2151"
      else if category == '鞋子' && tag == '高帮鞋'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=6000000000000&section=hot&price=all&nid=2149"
      else if category == '鞋子' && tag == '雪地靴'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=6000000000000&section=hot&price=all&nid=2757"
      else if category == '鞋子' && tag == '高跟鞋'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=6000000000000&section=hot&price=all&nid=2573"
      else if category == '鞋子' && tag == '短靴'
        url = "http://www.meilishuo.com/aj/getGoods/attr?frame=#{frame}&page=#{page}&view=1&word=34516&section=hot&hi=&price=all"
      else if category == '鞋子' && tag == '长靴'
        url = "http://www.meilishuo.com/aj/getGoods/attr?frame=#{frame}&page=#{page}&view=1&word=34515&section=hot&hi=&price=all"
      else if category == '包包' && tag == '单肩包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2213"
      else if category == '包包' && tag == '斜拷包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2215"
      else if category == '包包' && tag == '手提包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2217"
      else if category == '包包' && tag == '手拿包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2219"
      else if category == '包包' && tag == '钱包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2221"
      else if category == '包包' && tag == '晚宴包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2227"
      else if category == '包包' && tag == '链条包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2229"
      else if category == '包包' && tag == '信封包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2231"
      else if category == '包包' && tag == '贝壳包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2237"
      else if category == '包包' && tag == '复古包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2243"
      else if category == '包包' && tag == '编织包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2247"
      else if category == '包包' && tag == '大包'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=5000000000000&section=hot&price=all&nid=2225"
      else if category == '家居' && tag == 'zakka'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=1333"
      else if category == '家居' && tag == '抱枕'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=1335"
      else if category == '家居' && tag == '音乐盒'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2551"
      else if category == '家居' && tag == '马克杯'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2481"
      else if category == '家居' && tag == '相架'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2485"
      else if category == '家居' && tag == '笔记本'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2491"
      else if category == '家居' && tag == '韩国文具'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2495"
      else if category == '家居' && tag == '贴纸'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2497"
      else if category == '家居' && tag == '坐垫'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2507"
      else if category == '家居' && tag == '床上用品'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2511"
      else if category == '家居' && tag == '时钟'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2513"
      else if category == '家居' && tag == '灯具'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=2517"
      else if category == '家居' && tag == '置物架'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=1289"
      else if category == '家居' && tag == '盘碟'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=1303"
      else if category == '家居' && tag == '烘焙'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=1293"
      else if category == '家居' && tag == '勺筷'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=1295"
      else if category == '家居' && tag == '咖啡杯'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=1305"
      else if category == '家居' && tag == '盆栽'
        url = "http://www.meilishuo.com/aj/getGoods/catalog?frame=#{frame}&page=#{page}&view=1&word=0&cata_id=9000000000000&section=hot&price=all&nid=1351"
      url



  _getOnePage : (query, page, cbf) ->
    urls = @_getUrls query, page
    async.waterfall [
      (cbf) ->
        funcs = _.map urls, (url) ->
          (cbf) ->
            cbf = _.once cbf
            _.delay ->
              cbf null
            , 120 * 1000
            myUtil.request url, (err, html) ->
              if err
                cbf err
                return
              func = new Function "var data = #{html.toString()};return data.tInfo;"
              cbf null, func()
        async.parallelLimit funcs, 2, cbf
      (result, cbf) =>
        result = _.flatten result, true
        itemInfos = []
        async.eachLimit result, 5, (item, cbf) =>
          @_getItemInfo item, (err, itemInfo) ->
            if itemInfo
              _.extend itemInfo, query
              itemInfos.push itemInfo
            cbf null
        , ->
          cbf null, itemInfos
    ], cbf

  _getItemInfo : (item, cbf) ->
    async.waterfall [
      (cbf) =>
        @_getItemId item.url, cbf
      (id, cbf) ->
        if id
          cbf null, {
            id : id
            img : item.show_pic.replace 'http://imgtest.meiliworks.com', 'http://imgtest.meiliworks.com'
          }
        else
          cbf null
    ], cbf

  _getItemId : (url, cbf) ->
    async.waterfall [
      (cbf) ->
        myUtil.request "http://www.meilishuo.com#{url}", cbf
      (html, cbf) ->
        $ = cheerio.load html
        cbf null, $('.pic_view a').first().attr 'href'
      (url, cbf) ->
        myUtil.request url, cbf
      (html, cbf) ->
        $ = cheerio.load html
        try
          str = GLOBAL.decodeURIComponent $('script').last().html()
        catch e
          console.error url
          console.dir '.....'
          str = $('script').last().html()
        reg = /[\?\&]id=([\d]*)/
        result = reg.exec str
        if !result?[1]
          console.dir url
        cbf null, result?[1]
    ], cbf


module.exports = meilishuo