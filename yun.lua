--yun coding demo
--Created @ 2015/05/27 by Doit Studio
--Modified: null
--http://www.doit.am/
--http://www.smartarduino.com/
--http://szdoit.taobao.com/
--bbs: bbs.doit.am

print("Start yun")

gpio.mode(0,gpio.OUTPUT);--LED Light on
gpio.write(0,gpio.LOW);

local deviceID = "doitCar"
local timeTickCnt = 0
local fileName = "yunRemote"
local conn;
local flagClientTcpConnected=false;
print("Start TCP Client");
tmr.alarm(3, 5000, 1, function()
	if flagClientTcpConnected==true then
		timeTickCnt = timeTickCnt + 1;
		if timeTickCnt>=60 then --every 300 seconds send "cmd=keep\r\n" to server
			timeTickCnt = 0;
			conn:send("cmd=keep\r\n");
		end		
	elseif flagClientTcpConnected==false then
	print("Try connect Server");
	conn=net.createConnection(net.TCP, false) 
	conn:connect(7500,"182.92.178.210");--182.92.178.210  --198.199.94.16
		conn:on("connection",function(c)
			print("TCPClient:conneted to server");
			conn:send("cmd=subscribe&topic="..deviceID.."\r\n");
			flagClientTcpConnected = true;timeTickCnt = 0;
			end) --connection
		conn:on("disconnection",function(c) 
			flagClientTcpConnected = false;
			conn=nil;collectgarbage();
			end) --disconnection
		conn:on("receive", function(conn, m) 
			if string.sub(m,1,5)=="__B__" then
				file.remove(fileName..".lua")
				file.open(fileName..".lua", "w" )				
				conn:send("cmd=next\r\n");--start fetching prog file
			elseif string.sub(m,1,5)=="__E__" then --finish fetching
				file.close()
				collectgarbage();
				node.compile(fileName..".lua");
				file.remove(fileName..".lua");
				dofile(fileName..".lc")
			else --the file context
				print("Recieve:"..m)
				file.writeline(m);
				conn:send("cmd=next\r\n");--continue fetching
			end
			collectgarbage();
			end)--receive
	end 
end)

