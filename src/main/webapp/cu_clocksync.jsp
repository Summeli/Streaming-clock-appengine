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
    <title>Finice clock synchronization client</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  </head>
  <body>
    <p>Clock Synchronization demo server</p>
    <br>
    <span id="minutes"></span>:<span id="seconds"></span>
    <br>
    <input id="start" type="submit" name="button" value="start"/>
    <input id="stop" type="submit" name="button" value="stop"/>
    <input id="reset" type="submit" name="button" value="reset"/>
    <br>
    <form id="echo-form">
      <textarea id="echo-text" placeholder="Enter some text..."></textarea>
      <button type="submit">Send</button>
    </form>

    <div>
      <p>Messages:</p>
      <ul id="echo-response"></ul>
    </div>

    <div>
      <p>Status:</p>
      <ul id="echo-status"></ul>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <script>
    var milliseconds = 0;
    var running = 0;
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
      };

      websocket.onclose = function() {
        log('Closed');
      };

      websocket.onmessage = function(e) {
        log('Message received');
        output.append($('<li>').text(e.data));
      };

      websocket.onerror = function(e) {
        log('Error (see console)');
        console.log(e);
      };

      /* Handle form submission and send a message to the websocket. */
      form.submit(function(e) {
        e.preventDefault();
        var data = textarea.val();
        websocket.send(data);
      });

      document.getElementById('start').onclick = function() {
        websocket.send('s');
        console.log("start");
        running = 1;
      };
      document.getElementById('stop').onclick = function() {
        websocket.send('p'+milliseconds);
        console.log("pause");
        running = 0;
      };
      document.getElementById('reset').onclick = function() {
         websocket.send('r');
         milliseconds = 0;
         console.log("reset");
         $("#seconds").html(0);
         $("#minutes").html(0);
      };
      function pad ( val ) { return val > 9 ? val : "0" + val; }
       setInterval( function(){
        if(running == 0){
           return;
        }
        milliseconds = milliseconds + 1000;
        var sec = milliseconds / 1000;
        $("#seconds").html(pad(sec%60));
        $("#minutes").html(pad(parseInt(sec/60,10)));
        if(sec%60 == 0){
            websocket.send("PING");
        }
      }, 1000);
    });
    </script>
  </body>
</html>
