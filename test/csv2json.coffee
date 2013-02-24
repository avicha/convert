csv2json = require('../index').csv2json
async = require 'async'
logger = require('log4js').getLogger __filename
async.parallel
    'no fields transform':(callback)->
        goodscsv = new csv2json('../csv/goods.csv')
        #不加fields即把表头当做json的key来处理
        goodscsv.toJSON decode:'gbk',(err,jsonArr)->
            console.log jsonArr if !err&&jsonArr
            callback err
    'has fields transform':(callback)->
        goodscsv = new csv2json('../csv/goods.csv')
        goodscsv.fields({'商品Id':'itemId','名称':'title','链接':'link','销量':'sold','价格':'price','图片地址':'picUrl','分类':'cat'}).toJSON headers:true,decode:'gbk',(err,jsonArr)->
            console.log jsonArr if !err&&jsonArr
            callback err
    'another fields transform':(callback)->
        goodscsv = new csv2json('../csv/goods.csv')
        #这里故意不加headers=true，结果是把表头也当做一条记录
        goodscsv.fields(['itemId','title','link','sold','price','picUrl','cat']).toJSON decode:'gbk',(err,jsonArr)->
            console.log jsonArr if !err&&jsonArr
            callback err
,(err,results)->
    if err
        logger.error err
    else
        logger.info "test end."