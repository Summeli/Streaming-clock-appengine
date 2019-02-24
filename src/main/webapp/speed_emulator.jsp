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
<%@ page import="com.finice.servletUri" %>
<head>
  <link rel="icon" type="image/png" href="_assets/img/favicon.png" />
  <script src="_assets/lib/jquery.min.js"></script>
  <title>Finice clock synchronization client</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>
  <p>Clock Synchronization demo server</p>
  <br>
  <span id="minutes"></span>:<span id="seconds"></span>:<span id="fractions">:</span>
  <br>
  <input id="start" type="submit" name="button" value="start" />
  <input id="stopl" type="submit" name="button" value="stop left" />
  <input id="stopr" type="submit" name="button" value="stop right" />
  <br>
  <div>
  <label for="bib_left">Left BIB (1-999):</label>
  <input type="number" id="bib_left" name="bib_left" min="1" max="999">
  <label for="bib_left">Right BIB (1-999):</label>
  <input type="number" id="bib_right" name="bib_right" min="1" max="999">
  </div>
  <div>
    <p>Messages:</p>
    <ul id="echo-response"></ul>
  </div>

  <div>
    <p>Status:</p>
    <ul id="echo-status"></ul>
  </div>
  <script type='text/javascript'>
	 var webSocketUri =  "<%=servletUri.getWebSocketAddress() %>";
  </script>
   <script type='text/javascript' src="_assets/js/speed_emulator.js"></script>
</body>
</html>