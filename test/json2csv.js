// Generated by CoffeeScript 1.4.0
(function() {
  var async, json2csv;

  json2csv = require('../index').json2csv;

  async = require('async');

  async.parallel({
    'no fields transform': function(callback) {
      var jsonArr;
      jsonArr = new json2csv([
        {
          uid: '123456',
          name: 'avicha',
          age: 23,
          sex: 'boy'
        }, {
          uid: '654321',
          name: 'yi',
          age: '19',
          sex: 'girl'
        }
      ]);
      console.log(jsonArr.toCSVText());
      return callback(null);
    },
    'has fields transform': function(callback) {
      var jsonArr;
      jsonArr = new json2csv([
        {
          uid: '123456',
          name: 'avicha',
          age: 23,
          sex: 'boy'
        }, {
          uid: '654321',
          name: 'yi',
          age: '19',
          sex: 'girl'
        }
      ]);
      return jsonArr.fields({
        'uid': '用户Id',
        'name': '名字',
        'age': '年龄',
        'sex': '性别'
      }).toCSVFile('../csv/user1.csv', {
        encode: 'gbk'
      }, function(err, csvtext) {
        if (!err && csvtext) {
          console.log(csvtext);
        }
        return callback(err);
      });
    },
    'another fields transform': function(callback) {
      var jsonArr;
      jsonArr = new json2csv([
        {
          uid: '123456',
          name: 'avicha',
          age: 23,
          sex: 'boy'
        }, {
          uid: '654321',
          name: 'yi',
          age: '19',
          sex: 'girl'
        }
      ]);
      return jsonArr.fields(function(json) {
        return {
          '用户Id': json.uid,
          '名字': json.name,
          '年龄': json.age,
          '性别': (function() {
            if (json.sex === 'boy') {
              return '男';
            } else {
              if (json.sex === 'girl') {
                return '女';
              } else {
                return '未知';
              }
            }
          })()
        };
      }).toCSVFile('../csv/user2.csv', {
        encode: 'utf8'
      }, function(err, csvtext) {
        if (!err && csvtext) {
          console.log(csvtext);
        }
        return callback(err);
      });
    }
  }, function(err, results) {
    if (err) {
      return console.error(err);
    } else {
      return console.log("test end.");
    }
  });

}).call(this);
