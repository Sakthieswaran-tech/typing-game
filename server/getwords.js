const axios=require('axios');

const getWords=async()=>{
    const response=await axios.get('https://api.quotable.io/quotes/random');
    return response.data[0].content.split(' ');
}

module.exports=getWords;