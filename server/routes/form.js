const express = require ('express')
const router = express.Router()
const mongoose = require("mongoose")
const Post = mongoose.model("Post")
const multer = require('multer')
const requiredLogin = require('../middleware/requireLogin')


var fs = require('fs');
var upload = multer({ dest: 'uploads/' })

/*const fileFilter=(req,file,cb) =>{
    if(file.mimetype === 'image/jpeg' || file.mimetype === 'image/jpg' || file.mimetype ==='image/png'){
        cb(null,true)
    } else {
        cb(null,false)
    }
}
/*
const storage=multer.diskStorage({
    destination:function(req,file,cb) {
       cb(null,'./uploads/')
    },
    filename:function(req,file,cb) {
       cb(null,   file.originalname)
       //new Date().toISOString()+
    }
})


const upload=multer({ storage: storage , 
    limits:{
    fileSize:1024 * 1024 *5
    },
    fileFilter:fileFilter

}
)*/

/*router.get('/allforms',requiredLogin,(req,res)=>{
    // rit fil populate itharali ligne mta3 id haka fi table mere 
   // w fi deuxieme champ  inti  tiktib chnouwa t7ib ta5ou 
   Post.find().populate("postedBy","_id name")

 .then(posts=>{
      
       res.json({posts})

   }).catch(err=>{
       res.json(err)   
   })
})*/
router.get('/allforms',(req,res)=>{
    // rit fil populate itharali ligne mta3 id haka fi table mere 
   // w fi deuxieme champ  inti  tiktib chnouwa t7ib ta5ou 
   Post.find().populate("postedBy","_id firstName lastName")

 .then(posts=>{
      
       res.json(posts)

   }).catch(err=>{
       res.json(err)   
   })
})

/*router.post('/fillinform', requiredLogin,upload.single('photo'),(req,res)=>{
  //  console.log(req.file)
   const {title,body} = req.body //ba3thha  le client 
   req.file 
   if(!title||!body) {
     return res.status(422).json({error:'body and title are required'})
    }
    req.user.password=undefined
   const post = new Post({
       title,
       body,
       photo:req.file.path,
       postedBy:req.user
   })
   console.log(req.file.path)
   post.save().then(result=>{
       res.json({post:result})
       console.log()
       //console.log(req.body)
   }).catch(err=>
    console.log(err)
    )

})*/

/*router.post('/fillinform', requiredLogin,upload.single('photo'),(req,res)=>{
  console.log("POSTING")
  console.log(req.file)
   const title = req.body.title
   const body = req.body.body
   const location = req.body.location
   req.file
   if(!title||!body) {
     return res.status(422).json({error:'body and title are required'})
    }
    req.user.password=undefined
   const post = new Post({
       title,
       body,
       location:req.body.location,
       photo:req.file.path,
       postedBy:req.user
   })
   //console.log(req.file.path)
   post.save().then(result=>{
       res.json({post:result})
   }).catch(err=>
    console.log(err)
    )

})*/

router.get('/uploads/:fileName', function (req, res) {
  console.log("get")
    //const filePath = // find out the filePath based on given fileName
    console.log(req.params.fileName)
    const filePath = 'C:/Users/uber/Desktop/sig_fraud_app/server/uploads/' + req.params.fileName
    res.sendFile(filePath);
});



router.post('/fillinform', requiredLogin, upload.single("picture"), function (req,res) {
  console.log("Received file" + req.file.originalname);
  const title = req.body.title
  const body = req.body.body
  const location = req.body.location
  var src = fs.createReadStream(req.file.path);
  var dest = fs.createWriteStream('uploads/' + req.file.originalname);
  src.pipe(dest);
  src.on('end', function() {
    fs.unlinkSync(req.file.path);
    //res.json('OK: received ' + req.file.originalname);
  });
  src.on('error', function(err) { res.json({error:'Something went wrong!'}); });

  if(!title||!body) {
     return res.status(422).json({error:'body and title are required'})
    }
    req.user.password=undefined
   const post = new Post({
       title,
       body,
       location:req.body.location,
       //photo: "server\\" + req.file.path,
       //photo: "server/uploads/" + req.file.originalname,
       photo: req.file.originalname,
       postedBy:req.user
   })

   post.save().then(result=>{
       res.json({post:result})
   }).catch(err=>
    console.log(err)
    )

})



module.exports = router
