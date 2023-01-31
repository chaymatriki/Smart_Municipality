const express = require ('express')
const router = express.Router()
const mongoose = require("mongoose")
const User = mongoose.model("User")
const bcrypt = require('bcryptjs');
const jwt =require("jsonwebtoken")
const {JWT_SECRET} = require('../keys')
const requireLogin = require('../middleware/requireLogin')

router.post('/signup',(req,res)=>{
    const {lastName,firstName,email,password,cin,phone,type} =req.body
    if(!email||!password||!cin){ // not process further avec return 
       return  res.status(422).json({error:"please add fields"})
    }
  User.findOne({email:email})
    .then((SavedUser) => {
      if(SavedUser) {
        return  res.status(422).json({error:"user already exists with that email "})
      }
      else {
      bcrypt.hash(password,12)
      .then((hashedpassword)=>{
        const user = new User({
          lastName,
          firstName,
          email,
          password:hashedpassword,
          cin,
          phone,
          type
        })
        user.save()
      .then(
        user => {
        	const token = jwt.sign({_id:user._id},JWT_SECRET)
            res.json({token,userType:user.type})
            console.log("done")
        })
        .catch(err=>{
          console.log(err)
        })
      
      })
      .catch(err=>{
        console.log(err)
      })
      }
    })
    })

    router.post('/signin',(req,res)=>{
      console.log("signing in")
        const {email,password} = req.body
        if (!email||!password) {
          return  res.status(422).json({error:"please add two fields "})
        }
      
        User.findOne({email:email})
        .then((SavedUser) => {
          if(!SavedUser) {
            return  res.status(422).json({error:" email invalid" })
          }
      
          bcrypt.compare(password,SavedUser.password)
          .then((doMatch) =>  {
            if(doMatch) {
             const token = jwt.sign({_id:SavedUser._id},JWT_SECRET)
               res.json({token,userType:SavedUser.type})
              
            }
            else{
              return  res.status(422).json({error:"  password invalid" })
            }
          })
          .catch(err=>{
            console.log(err)
          })
        })
        .catch(err=>{
          console.log(err)
        })
      })

module.exports= router