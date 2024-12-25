const express=require('express');
require('dotenv').config();

const app=express();
const PORT=3000;
app.use(express.json());

// get variable env
const Owner=process.env.Owner;
console.log(Owner);

// app.get('/',(req,res)=>{
//     res.sendFile(__dirname + '/index.html');
//   });

app.get('/getvariabla',(req,res)=>{
  res.json({
    owner:Owner,
  })
});


app.listen(PORT,()=>{
    console.log('this start in port ',PORT);
})

