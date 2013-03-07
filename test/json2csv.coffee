json2csv = require('../index').json2csv
async = require 'async'
async.parallel
    'no fields transform':(callback)->
        jsonArr = new json2csv [{uid:'123456',name:'avicha',age:23,sex:'boy'},{uid:'654321',name:'yi',age:'19',sex:'girl'}]
        console.log jsonArr.toCSVText()
        callback null
    'has fields transform':(callback)->
        jsonArr = new json2csv [{uid:'123456',name:'avicha',age:23,sex:'boy'},{uid:'654321',name:'yi',age:'19',sex:'girl'}]
        jsonArr.fields({'uid':'用户Id','name':'名字','age':'年龄','sex':'性别'}).toCSVFile '../csv/user1.csv',encode:'gbk',(err,csvtext)->
            console.log csvtext if !err&&csvtext
            callback err
    'another fields transform':(callback)->
        jsonArr = new json2csv [{uid:'123456',name:'avicha',age:23,sex:'boy'},{uid:'654321',name:'yi',age:'19',sex:'girl'}]
        jsonArr.fields (json)->
            {
                '用户Id':json.uid
                '名字':json.name
                '年龄':json.age
                '性别':do ()->
                    if json.sex == 'boy'
                        '男'
                    else
                        if json.sex == 'girl'
                            '女'
                        else
                            '未知'
            }
        .toCSVFile '../csv/user2.csv',encode:'utf8',(err,csvtext)->
            console.log csvtext if !err&&csvtext
            callback err
,(err,results)->
    if err
        console.error err
    else
        console.log "test end."