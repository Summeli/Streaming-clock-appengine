<!DOCTYPE html>
<!--
  Copyright 2019 Antti Pohjola

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<html>
<%@ page import="com.finice.SendServlet" %>
  <head>
    <script src="lib/jquery.min.js"></script>
  	<link rel="stylesheet" href="timer.css">

    <title>Finice streaming clock</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  </head>
  <body>
	<div id="clock">
		<div id="c_text">Time remaining:</div>
		<div id="timebox">
			<div class="timetext"><span id="minutes"></span>:<span id="seconds"></span></div>
		</div>
	</div>
	<br><br><br><br>
	<div class="tech_stuff>
        <label for="delay">Stream delay in seconds (1-60):</label>
        <input type="number" id="delay" name="delay"
               min="0" max="60">
        <br>
        <div>
          <p>Messages:</p>
          <ul id="echo-response"></ul>
        </div>

        <div>
          <p>Status:</p>
          <ul id="echo-status"></ul>
        </div>
    </div>
  <script>
    var sec = 0;
    var stopped = 0;
    var delay = 0;
    var total_sec = 0;
    var running = 0;
	var ping_ctrl = 0;
	var ping_interval = 60;
    $(function() {

     var webSocketUri =  "<%=SendServlet.getWebSocketAddress() %>";

     /* Get elements from the page */
     var form = $('#echo-form');
     var textarea = $('#echo-text');
     var output = $('#echo-response');
     var status = $('#echo-status');

     /* Helper to keep an activity log on the page. */
     function log(text){
       status.append($('<li>').text(text))
     }

     /* Establish the WebSocket connection and register event handlers. */
     var websocket = new WebSocket(webSocketUri);

     websocket.onopen = function() {
       log('Connected : ' + webSocketUri);
       /*register to listen clock events*/
       websocket.send("REGISTER");
     };

     websocket.onclose = function() {
       log('Closed');
     };

     websocket.onmessage = function(e) {
       log('Message received');
       var msg=e.data;
       /*protocol s=start
                  p = pause
                  r = reset*/
       if(msg.charAt(0) === 'r'){
           running = 0;
           sec = 0;
           $("#seconds").html(0);
           $("#minutes").html(0);
       }else if(msg.charAt(0) === 's'){
           running = 1;
           stopped = 0;
       }else if(msg.charAt(0) === 'p'){
           stopped = msg.substring(1) / 1000;
           console.log("stopped at: "+stopped);
       }
       output.append($('<li>').text(e.data));
     };

     websocket.onerror = function(e) {
       log('Error (see console)');
       console.log(e);
     };

     function pad ( val ) { return val > 9 ? val : "0" + val; }
     setInterval( function(){
	  //keep connection alive
	  ping_ctrl++;
	  if(ping_ctrl > ping_interval){
	    websocket.send("PING");
		ping_ctrl = 0;
	  }
         if(running == 0)
           return;
         if(stopped != 0 && stopped < total_sec){
            $("#seconds").html(pad(stopped%60));
            $("#minutes").html(pad(parseInt(stopped/60,10)));
            return;
         }
         sec++; //incread seconds
         total_sec = sec - delay;
         if(total_sec < 0){
           $("#seconds").html(0);
           $("#minutes").html(0);
           return;
         }else if(stopped > 0 && total_sec > stopped){
           total_sec = stopped;
         }
         $("#seconds").html(pad(total_sec%60));
         $("#minutes").html(pad(parseInt(total_sec/60,10)));
     }, 1000);

   });

   window.onload = function init() {
    $("#seconds").html(0);
    $("#minutes").html(0);
   var input = document.getElementById("delay");
   input.addEventListener("change", delayUpdated, false);
   }

   function delayUpdated(event)
   {
     var input = Number(event.target.value);
     console.log(input);
     delay = input;
   }

   </script>
  </body>
</html>
