# LOK-Scripts
# **Table of contents**

* [Prerequisites](#prerequisites)
	* [OS](#os)
	* [Powershell](#powershell)
* [Script setup](#script-setup)
* [Things to keep in mind](#things-to-keep-in-mind)
	* [What to do](#what-to-do)
	* [What not to do](#what-not-to-do)
* [Upcoming Features - Coming Soon](#upcoming-features---coming-soon)
<!--te-->


<br/>

# **Prerequisites**
### **OS**
1. For this script to work we will use WINDOWS os as we have powershell available in Windows as default.
2. The scipt might work on other OS as well but then it needs to be tested.

### **Powershell**
1. For this script to work we need POWERSHELL installed on your PC/Laptop(You can search for powershell in your PC/Laptop).
2. If powershell is available it's well and good else you can download and install it from official microsoft website. (https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3)

# **Script setup**
1. First download the script (.ps1 extension file) from the github repo (Script URL: https://github.com/ankitpro/LOK-Scripts/blob/main/get%20alliance%20information.ps1).
2. Next right click on the script and select "Run with powershell".
3. The moment the script is started it'll ask you to enter the access token.
4. To get access token follow the below steps.
	1. Login to your game and then press F12 to open developer tools.
	2. Once you press F12 you'll see developer tools opened at the bottom of your screen.
	3. Click on Network at the bottom and then click on alliance on the game to find the access token.
	4. Now when you click on Alliance you'll see a network traffic with the name "my".
	5. Click on "my" and then in the headers section beside "my" scroll to the bottom of the page.
	6. You'll see something called "x-access-token".
	7. Copy the access token completely and then paste that token in your powershell.
	8. Eureka your setup is done.
	Example: x-access-token: eyJhbGci54848OiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzljNzcyOTRiNDQ1NzE1ZjA5YWFkZTEiLCJraW5nZG9tSWQiOiI2MzljNzcyOTRiNDQ1NzE1ZjA5YWFkZTIiLCJ3b3JsZElkIjo1NCwidmVyc2lvbiI6MTU4OSwiYnVpbGQiOjAsInBsYXRmb3JtIjoid2ViIiwidGltZSI6MTY3NzQ5MTMxMTE4MywiY2xpZW50WG9yIjoiMCIsImlhdCI6MTY3NzQ5MTMxMSwiZXhwIjoxNjc4MDk2MTExLCJpc3MiOiJub2RnYW1lcy5jb20iLCJzdWIiOiJ1c2VySW5mbyJ9.VOjUR_oZAl_P64LQOaKfE74dohXnD7-difZFGU
	You'll see access token as above copy from "eyJh" to "difZFGU" as below:
	eyJhbGci54848OiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzljNzcyOTRiNDQ1NzE1ZjA5YWFkZTEiLCJraW5nZG9tSWQiOiI2MzljNzcyOTRiNDQ1NzE1ZjA5YWFkZTIiLCJ3b3JsZElkIjo1NCwidmVyc2lvbiI6MTU4OSwiYnVpbGQiOjAsInBsYXRmb3JtIjoid2ViIiwidGltZSI6MTY3NzQ5MTMxMTE4MywiY2xpZW50WG9yIjoiMCIsImlhdCI6MTY3NzQ5MTMxMSwiZXhwIjoxNjc4MDk2MTExLCJpc3MiOiJub2RnYW1lcy5jb20iLCJzdWIiOiJ1c2VySW5mbyJ9.VOjUR_oZAl_P64LQOaKfE74dohXnD7-difZFGU
	
# **Things to keep in mind**
### **What to do**
1. Make sure your game is open on browser.

### **What not to do**
1. Do not close the game session in the browser as that might make the developer know that a script is running and your access token might change.

# **Upcoming Features - Coming Soon**
1. Adding logging to check things done by the script.
2. Multiple account handling feature with reference name as input for the EU.
3. Enable or disable notifications.
4. Providing a link of each game after its status so that EU's can open the link and know the status of that specific game.
