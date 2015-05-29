# COULD-coding-with-NodeMCU
COULD-coding-with-NodeMCU
Principle:
Lua source code edited on the cloud is transferred to the node and runned on the node.
The node communicates with server via TCP protocal(Server IP: 198.199.94.16@port:7500）

Here is protocal:

Code:
1, Define your node's name  (such as "doitCar")
cmd=subscribe&topic=doitCar\r\n

Code:
2, When a lua file is edited and needed to be downloaded at the node:
     2.1 Server sends "__B__" to the node. the node open a file,and send "cmd=next\r\n" to server as responce string. Once the node recievs "__B__", it should know that a new source code file is prepared to be transferred. 
     2.2 Server will send the source code in sevaral package. The node recieves and store the package one by one, and sends "cmd=next\r\n" to the server every package.
     2.3 Server send "__E__" when the transfering is finished. The node recieves the finishing string, saves the source code, closes the opened file. compiles the file,and dofile it.


Code:
3, Send  "cmd=keep\r\n" every 3 minitus to keep the tcp link alive.


The CLOUD coding website:http://cloud.doit.am

A tutorial was posted at here:http://bbs.smartarduino.com/showthread.php?tid=3&pid=3#pid3     
that's really simple and easy!
Have fun!

A chinese protocal can be found here:
http://bbs.doit.am/forum.php?mod=viewthread&tid=44&extra=page%3D1
