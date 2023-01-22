const mongoose=require('mongoose')

const userSchema = new mongoose.Schema({
    lastName:{
        type:String,
        required:true
    },
    firstName:{
        type:String,
        required:true
    },
    email:{
        type:String,
        required:true
    },
    password:{
        type:String,
        required:true
    },
    cin:{
        type:String,
        required:true
    },
    phone:{
        type:String,
        required:true
    },
    type:{
        type:String,
        required:true
    },
    
})

module.exports=mongoose.model("User",userSchema)