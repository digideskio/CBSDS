var bodyParser 	= require('body-parser')
,	express 	= require('express')
,	app 		= express()
,	server 		= require('http').createServer(app)
,	io 			= require('socket.io').listen(server);

server.listen(4583);

io.sockets.on('connection', function (socket) {
	var id = ((new Date).getTime()  % 9999);
	socket.emit('id',{'id':id});
	socket.join(id);
	console.log("connection");
	socket.on('newid', function (oldid) {
		var id = ((new Date).getTime()  % 9999);
		socket.emit('id',{'id':id});
		socket.leave(oldid);
		socket.join(id);
	});
	socket.on('togglespray',function(){
		io.socket.emit('toggledspray');
	});
});

app.use(bodyParser());
app.use(express.static(__dirname + '/static'));
// { red:127, green: 127, blue: 127, special: 0, time: 10000, misc:"hello" }
app.post("/spray",function(req,res){
	io.sockets.in(req.body.id).emit('spray',req.body.spray);
	res.json("ok");
});
app.post("/togglespray",function(req,res){
	io.sockets.in(req.body.id).emit('togglespray');
	res.json("ok");
});