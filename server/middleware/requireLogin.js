const mongoose = require("mongoose")
const jwt = require('jsonwebtoken')
const {JWT_SECRET} = require('../keys')
const User =mongoose.model("User")
module.exports= (req,res,next) =>{
    const {authorization} =req.headers
   //authorization === Bearer token    
    if(!authorization) {
        res.status(401).json({error:" mafamach token asl donc  ma3amlt log in   "})
    }
    // to accces to token 
    const token = authorization.replace("Bearer ","")
    jwt.verify(token,JWT_SECRET,(err,payload)=>{
        if(err){
         return    res.status(401).json({error:" token ali  mawjoud ne correspond pas li  token mta3ik "})
        }
        const {_id} = payload
        User.findById(_id).then(userdata=>{
            req.user= userdata
            next()
        })
        
    })
}