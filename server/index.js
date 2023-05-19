require('dotenv').config();
const express = require('express');
const http = require('http');
const mongoose = require('mongoose');
const morgan = require('morgan');
const cors = require('cors');
const bodyParser = require('body-parser');
const Game = require('./models/Game');
const getWords = require('./getwords');

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);
const io = require('socket.io')(server);

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.json());

app.use(cors());
app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header(
        "Access-Control-Allow-Headers",
        "Origin, X-Requested-With, Content-Type, Accept, Authorization"
    );
    if (req.method === "OPTIONS") {
        res.header("Access-Control-Allow-Methods", "PUT, POST, PATCH, DELETE, GET");
        return res.status(200).json({});
    }
    next();
});

const db = process.env.MONGO_URL;
mongoose.connect(db).then(() => {
    console.log('Connection successful');
}).catch(e => {
    console.log(e);
});

io.on('connection', (socket) => {
    socket.on("create-game", async ({ nickname }) => {
        try {
            let game = new Game();
            const words = await getWords();
            game.words = words;
            let player = {
                socketID: socket.id,
                nickname,
                isLeader: true,
            }
            game.players.push(player);
            game = await game.save();
            let gameID = game._id.toString();
            socket.join(gameID);
            io.to(gameID).emit('updateGame', game);
        } catch (error) {
            console.log(error);
        }
    });

    socket.on("join-game", async ({ gameID, nickname }) => {
        console.log("nickname ", nickname);
        try {
            if (!gameID.match(/^[0-9a-fA-F]{24}$/)) {
                socket.emit('not-a-game', 'Please enter a valid game ID');
                return;
            }
            let game = await Game.findById(gameID);
            if (game.isJoin) {
                let player = {
                    socketID: socket.id,
                    nickname,
                    isLeader: false,
                }
                game.players.push(player);
                game = await game.save();
                let gameID = game._id.toString();
                socket.join(gameID);
                io.to(gameID).emit('updateGame', game);
            } else {
                socket.emit('not-a-game', 'Game is going on. Please try again later');
            }
        } catch (error) {
            console.log(error);
        }
    })

    socket.on("start-time", async ({ playerID, gameID }) => {
        let counter = 5;
        let game = await Game.findById(gameID);
        let player = game.players.id(playerID);

        if (player.isLeader) {
            let intervalID = setInterval(async () => {
                if (counter >= 0) {
                    io.to(gameID).emit("timer-update", ({
                        count: counter,
                        message: 'Game is starting soon'
                    }));
                    console.log(counter)
                    counter--;
                } else {
                    game.isJoin = false;
                    game = await game.save();
                    io.to(gameID).emit("updateGame", game);
                    startGame(gameID);
                    clearInterval(intervalID);
                }
            }, 1000)
        }
    });

    socket.on("submit-word",async({value,gameID})=>{
        let game=await Game.findById(gameID);
        if(!game.isJoin && !game.isOver){
            let player;
            for(let i in game.players){
                if(game.players[i].socketID===socket.id){
                    player=game.players[i];
                }
            }
            if(game.words[player.currentWordIndex]===value.trim()){
                player.currentWordIndex++;
                if(player.currentWordIndex!==game.words.length){
                    game=await game.save();
                    io.to(gameID).emit("updateGame",game);
                }else{
                    let endTime=new Date().getTime();
                    let {startTime}=game;
                    player.wordPerMin=calculateWords(startTime,endTime,player);
                    game=await game.save();
                    socket.emit("game-over");
                    io.to(gameID).emit("updateGame",game);
                }
            }
        }
    })
});

function calculateWords(startTime,endTime,player){
    const timeTakenInSeconds=(endTime-startTime)/1000;
    const timeTakenInMin=timeTakenInSeconds/60;
    let wordsTyped=player.currentWordIndex;
    return Math.floor(wordsTyped/timeTakenInMin);
}

async function startGame(gameID) {
    let game = await Game.findById(gameID);
    game.startTime = new Date().getTime();
    game = await game.save();

    let time = 240;
    let intervalID = setInterval(async()=>{
        if (time >= 0) {
            let timeFormat = calculateTimeFormat(time);
            io.to(gameID).emit("timer-update", ({
                count:timeFormat,
                message: "Time Remaining"
            }));
            time--;
        }else{
            let endTime=new Date().getTime();
            let game=await Game.findById(gameID);
            game.players.forEach((player,index)=>{
                if(player.wordPerMin===-1){
                    game.players[index].wordPerMin=calculateWords(game.startTime,endTime,player);
                }
            })
            game.isOver=true;
            game=await game.save();
            io.to(gameID).emit("updateGame",game);
            clearInterval(intervalID);
        }
    }, 1000);
}

function calculateTimeFormat(time) {
    let min = Math.floor(time / 60);
    let sec = time % 60;

    return `${min}:${sec >= 10 ? sec : '0' + sec}`;
}


server.listen(port, () => {
    console.log(`Server running in port ${port}`);
})