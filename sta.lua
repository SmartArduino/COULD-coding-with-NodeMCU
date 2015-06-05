--yun coding demo
--Created @ 2015/05/27 by Doit Studio
--Modified: null
--http://www.doit.am/
--http://www.smartarduino.com/
--http://szdoit.taobao.com/
--bbs: bbs.doit.am

print("Ready to Set up wifi mode")
wifi.setmode(wifi.STATION)
local ssid = "Doit"
local psw = "123456789"
print("Conneting to "..ssid)
wifi.sta.config(ssid,psw)--ssid and password
wifi.sta.connect()
local cnt = 0
gpio.mode(0,gpio.OUTPUT);
tmr.alarm(3, 1000, 1, function() 
    if (wifi.sta.getip() == nil) and (cnt < 20) then 
    	print("->")
    	cnt = cnt + 1
		if cnt % 2 ==1 then 
		   gpio.write(0,gpio.HIGH);
		else
		   gpio.write(0,gpio.LOW);
		end
    else 
    	tmr.stop(3)
    	if (cnt < 20) then 
			print("Config done, IP is "..wifi.sta.getip())
			cnt = nil;ssid=nil;psw=nil;
			collectgarbage();
			if file.open("yun.lc") then
				dofile("yun.lc")
			else
				print("yun.lc not exist")
			end
    	else 
			print("Wifi setup time more than 20s, Pls verify\r\nssid:"..ssid.." psw:"..psw.."\r\nThen re-download the file.")
			cnt=cnt+1;
			tmr.alarm(1, 300, 1, function()
				if cnt % 2 ==1 then 
				   gpio.write(0,gpio.HIGH);
				else
				   gpio.write(0,gpio.LOW);
				end
			end)
    	end
		
    end 
	 end)
