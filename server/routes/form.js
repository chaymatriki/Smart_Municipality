const express = require ('express')
const router = express.Router()
const mongoose = require("mongoose")
const Post = mongoose.model("Post")
const multer = require('multer')
const requiredLogin = require('../middleware/requireLogin')
const path = require("path")


var fs = require('fs');
var upload = multer({ dest: 'uploads/' })


router.get('/parent',(req,res)=>{
	var name = __dirname;
	let match = name.match(/(.*)\\(.*)$/);
	let newString = match[1] + "\\";
  res.send(newString)
})

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

router.get('/uploads/:fileName', function (req, res) {
  console.log("get")
    //const filePath = // find out the filePath based on given fileName
    var dirname = __dirname;
	let match = dirname.match(/(.*)\\(.*)$/);
	let dirpath = match[1] + "\\";
    //console.log(req.params.fileName)
    const filePath = dirpath + 'uploads\\' + req.params.fileName
    console.log(filePath)
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
