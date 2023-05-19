const mongoose=require('mongoose');

const playerSchema=new mongoose.Schema({
    nickname:{
        type:String
    },
    currentWordIndex:{
        type:Number,
        default:0
    },
    wordPerMin:{
        type:Number,
        default:-1
    },
    socketID:{
        type:String
    },
    isLeader:{
        type:Boolean,
        default:false
    }
});

module.exports=playerSchema;