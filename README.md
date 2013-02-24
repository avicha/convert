convert
=======

这是一个用于各种格式转换的模块，暂时提供了把json对象写成csv文件和把csv读出成为json两个方法，同时提供了schema格式化数据的方法，以后将会提供更多转换方法。
##安装
<pre>
    npm install yi-convert
</pre>
##CLASS
* json2csv，把json对象转换成csv文件。

引入json2csv类

```javascript
var json2csv = require('yi-convert').json2csv;
```

初始化json对象数组

```javascript
var jsonArr = new json2csv([
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
```

指定从json转换为csv文件的表头

```javascript
jsonArr.fields({
        'uid': '用户Id',
        'name': '名字',
        'age': '年龄',
        'sex': '性别'
      });
```

使用gbk编码写成csv文件

```javascript
jsonArr.toCSVFile('user.csv', {encode: 'gbk'}, function(err, csvtext) {
        if (!err && csvtext) {
          console.log(csvtext);
        }
        else{
          console.error(err);
        }
    });
```
* csv2json，把csv文件转换成json对象。

引入csv2json类

```javascript
var csv2json = require('yi-convert').csv2json;
```

初始化指定csv文件路径

```javascript
var goodscsv = new csv2json('../csv/goods.csv');
```

指定从csv转换为json对象的字段

```javascript
goodscsv.fields({
        '商品Id': 'itemId',
        '名称': 'title',
        '链接': 'link',
        '销量': 'sold',
        '价格': 'price',
        '图片地址': 'picUrl',
        '分类': 'cat'
      });
```

使用gbk解码csv文件，把结果返回。

```javascript
goodscsv.toJSON({
        headers: true,
        decode: 'gbk'
      }, function(err, jsonArr) {
        if (!err && jsonArr) {
          console.log(jsonArr);
        }
        else {
          console.error(err);
        }
      });
```
* schema，根据schema的定义，规范化json的数据，通常在数据库插入数据前进行此规范化。

引入schema类

```javascript
Schema = require('yi-convert').schema;
```

初始化Schema结构

```javascript
Goods = new Schema({
    itemId: {
      type: String,
      required: true
    },
    itemPrice: {
      type: Number,
      required: true
    },
    buyNumber: {
      type: Number,
      "default": 0
    },
    data: Object
  });
```

运行Schema的format方法规范化json对象

```javascript
goods = Goods.format({
    itemId: 123456,
    itemPrice: '12.35',
    data: {
      score: 100
    }
  });
if (goods) {
    console.log(goods1);
  }
```
