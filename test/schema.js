// Generated by CoffeeScript 1.4.0
(function() {
  var Goods, Schema, goods1, goods2;

  Schema = require('../index').schema;

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

  goods1 = Goods.format({
    itemId: 123456,
    itemPrice: '12.35',
    data: {
      score: 100
    }
  });

  if (goods1) {
    console.log(goods1);
  }

  goods2 = Goods.format({
    itemId: '654321',
    data: {
      score: 50
    }
  });

  if (goods2) {
    console.log(goods2);
  }

}).call(this);