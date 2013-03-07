_ = require 'underscore'
fs = require 'yi-fs'
path = require 'path'
iconv = require 'iconv-lite'
csv = require 'yi-csv'
convert = {}
###*
 * json对象数组转换为csv文件
###
class json2csv
    constructor : (jsonArr)->
        self = @
        self.jsonArr = jsonArr||[]
        self.csvText = ''
        self
    fields : (map)->
        self = @
        self.map = map
        self
    toCSVText : ()->
        self = @
        text = []
        if !_.isArray self.jsonArr
            throw new Exception "the json input must be an array."
        self.jsonArr.forEach (json)->
            if self.map
                if _.isFunction self.map
                    item = self.map json
                else
                    if _.isObject self.map
                        item = {}
                        _.each json,(v,k,obj)->
                            if self.map[k]
                                item[self.map[k]] = v
                            else
                                item[k] = v
                    else
                        item = json
            else
                item = json
            if !self.headers
                self.headers = _.keys item
                self.headers = self.headers.map (header)->
                    header.replace /,/g,' '
                text.push self.headers.toString()
            text.push ((_.values item).map (val)->
                if val?
                    val.toString().replace /,/g,' ' 
                else
                    ''
                ).toString()
        text.join '\n'
    toCSVFile : (target,options,callback)->
        self = @
        if !callback&&_.isFunction options
            callback = options
            options = {}
            options.encode = 'utf8'
            options.mode = '0777'
        content = self.toCSVText()
        buf = iconv.encode content,options.encode?='utf8'
        filedir = path.dirname target
        fs.mkdirp filedir,options.mode?='0777',(err)->
            if err
                callback err,content if callback
            else
                fs.writeFile target,buf,(err)->
                    console.log  "write json to file success."
                    callback err,content if callback
convert.json2csv = json2csv
###*
 * csv转换为json对象数组
###
class csv2json
    constructor : (csvfile)->
        if !fs.existsSync csvfile
            console.error csvfile
            throw "please input the valid csvfile param."
        @csvfile = csvfile
        @
    fields : (map)->
        if _.isArray map
            @keys = map
        else
            @headers = _.keys map
            @keys = _.values map
            @map = map
        @
    toJSON : (options,callback)->
        self = @
        if !callback&&_.isFunction options
            callback = options
            options = {}
        readCsv = new csv(self.csvfile).parse options
        jsonArr = []
        readCsv.on 'error', (err) ->
            callback err,jsonArr
        #读取完毕则获取每一行数据
        readCsv.on 'end', (rows) ->
            rows.forEach (row)->
                if _.isArray row
                    if self.keys
                        jsonArr.push _.object self.keys,row
                    else
                        jsonArr.push row
                else
                    if !self.keys
                        jsonArr.push row
                    else
                        if !self.map
                            jsonArr.push _.object self.keys,_.values row
                        else
                            newO = {}
                            _.each row,(v,k,obj)->
                                if self.map[k]
                                    newO[self.map[k]] = v
                                else
                                    newO[k] = v
                            jsonArr.push newO
            callback null,jsonArr
convert.csv2json = csv2json
###*
 * schema验证和规格化
###
class schema 
    constructor : (fields_validation={})->
        self = @
        self.fields_validation = fields_validation
        self
    _SchemaTypes : 
        'String':String
        'Number':Number
        'Date':Date
        'Buffer':Buffer
        'Boolean':Boolean
        'Mixed':Object
        'ObjectId':require('mongodb').ObjectID
        'Array':Array
    validate : (obj)->
    _format : (val,format)->
        if format == 'String'||format == String
            if typeof val == 'string'
                return val
            if typeof val == 'number'
                return String val
            if val instanceof Date
                dateutil = require 'date-utils'
                return val.toFormat 'YYYY-MM-DD HH24:MI:SS'
            if Buffer.isBuffer val
                return val.toString()
            if _.isBoolean val
                return val.toString()
            if val instanceof Array
                return val.toString()
            if val instanceof require('mongodb').ObjectID
                return val.toString()
            if typeof val == 'object'
                return JSON.stringify val
        if format == 'Number'||format == Number
            if typeof val == 'number'|| (typeof val == 'string'&&(!isNaN Number val))
                return Number val
            else
                throw "#{val} can not parse into a Number type"
        if format == 'Date'||format == Date
            if val instanceof Date||(new Date(val) instanceof Date)
                return new Date val
            else
                throw "#{val} can not parse into a Date type"
        if format == 'Buffer'||format == Buffer
            if Buffer.isBuffer val
                return val
            else
                if _.isString val
                    return new Buffer val
                else
                    throw "#{val} can not parse into a Buffer type"
        if format == 'Boolean'||format == Boolean
            if val == true||val == 'true'
                return true
            else
                if val == false||val == 'false'
                    return false
                else
                    throw "#{val} can not parse into a Boolean type"
        if format == 'Array'||format == Array
            if val instanceof Array
                return val
            else
                if _.isString val
                    return val.split ','
                else
                    throw "#{val} can not parse into a Array type"
        if format == 'ObjectId'||format == require('mongodb').ObjectID
            if val instanceof require('mongodb').ObjectID
                return val
            else
                _id = new require('mongodb').ObjectID val
        if format == 'Mixed'||format == Object
            return val
    format : (obj,allow_field_null)->
        if !obj || !_.isObject obj
            return
        error = null
        self = @
        _.each self.fields_validation,(config,field)->
            try
                if _.include (_.keys self._SchemaTypes).concat(_.values self._SchemaTypes),config
                    if allow_field_null
                        obj[field] = self._format obj[field],config if obj[field]?
                    else
                        if obj[field]?
                            obj[field] = self._format obj[field],config
                        else
                            throw "#{field} must not be null"
                else
                    if (_.isObject config)&&!_.isArray config
                        if (!obj[field]?)&&config.default?
                            obj[field] = config.default
                        if config.required&&!obj[field]?
                            throw "#{field} must be required"
                        if config.type
                            obj[field] = self._format obj[field],config.type if obj[field]?

            catch e
                error = e
        if error
            console.error error
            return
        else
            return obj
convert.schema = schema
module.exports = convert