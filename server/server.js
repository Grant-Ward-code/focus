const express = require('express');
const StreamChat = require('stream-chat').StreamChat; 

const app = express(); 
const client = new StreamChat('g5peb9r9v99p','uuhxe28canqr7wrq25yt3qjnayvuphqerga74dmzkqrfcsba279um9wc2jzf24q6', {timeout: 6000 });

app.use(express.json()); 

app.post("/token",(req, res)=>{ 
	const { input } = req.body; 
	console.log(input); 
	if (input){ 
	  const token = client.createToken(input); 
	  return res.json({ token }) 
	} else { 
	  return res.json("Could not generate token"); 
	}
 })

app.listen(3002,()=>{ 
	console.log('Server is running on port 3002'); 
});



