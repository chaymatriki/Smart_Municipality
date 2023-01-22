const express= require('express')
const app = express()
const mongoose= require('mongoose')
const {MONGOURI} = require('./keys')
//middlewares  : this function is called when we call for /post 

//const sign  = 
//app.use('/posts',posti)



app.get('/',(req,res)=> {
    res.json({message:"HEY YOU"})
    console.log("GET REQUEST")
});



mongoose.connect(MONGOURI,{
    useNewUrlParser:true,
    useUnifiedTopology:true
})
mongoose.connection.on('connected',()=>{
    console.log("connected to mongodb")
})
mongoose.connection.on('error',(err)=>{
    console.log("error connection",err)
})

require('./models/post')
require('./models/user')

app.use(express.json())
app.use(require("./routes/auth"))
app.use(require("./routes/form"))

//how to we start listening to the server

app.listen(3000);

