const mongoose=require('mongoose')
const{ObjectId} = mongoose.Schema.Types
const PostSchema = new mongoose.Schema({
    title:{
        type:String,
        required:true
    },
    body:{
        type:String,
        required:true
    },
    location:{
        type:Object,
        default:{
            type:"Point",
            address:String,
            latitude:Number,
            longitudetype:Number
        }
    },
    photo:{
        type:String,
    },
    postedBy:{
         type:ObjectId,
         ref:"User"

    },
    date:{
        type:String,
        default :Date.now,
    }
})

module.exports=mongoose.model("Post",PostSchema)