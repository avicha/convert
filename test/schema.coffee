Schema = require('../index').schema
Goods = new Schema 
    itemId:{type:String,required:true}
    itemPrice:{type:Number,required:true}
    buyNumber:{type:Number,default:0}
    data:Object
goods1 = Goods.format 
    itemId:123456
    itemPrice:'12.35'
    data:
        score:100
console.log goods1 if goods1
goods2 = Goods.format
    itemId:'654321'
    data:
        score:50
console.log goods2 if goods2