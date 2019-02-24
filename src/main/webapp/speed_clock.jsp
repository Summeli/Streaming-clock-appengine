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
  <link rel="stylesheet" href="_assets/css/timer.css">

  <title>Finice streaming clock</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>
  <div class="timers">
    <div class="left">
      <div class="clock">
        <div class="c_text" id="c_text_left"><span id="bib_left"></span> TIME:</div>
        <div class="timebox">
          <div class="timetext"><span id="minutes_left"></span>:<span id="seconds_left"></span>:<span id="fractions_left"></span></div>
        </div>
      </div>
    </div>
    <div class="right">
      <div class="clock">
        <div class="c_text" id="c_text_right"><span id="bib_right"></span> TIME:</div>
        <div class="timebox">
          <div class="timetext"><span id="minutes_right"></span>:<span id="seconds_right"></span>:<span id="fractions_right"></span></div>
        </div>
      </div>
    </div>
  </div>
  <br><br><br><br>
  <div class="tech_stuff>
    <label for="delay">Stream delay in timeonds (1-60):</label>
    <input type="number" id="delay" name="delay" min="0" max="60">
    <br>
	<div>
      <h3>Results:</h3>
      <ul id="ehco-results"></ul>
    </div>
  </div>
  <script type='text/javascript'>
	 var webSocketUri =  "<%=servletUri.getWebSocketAddress() %>";
  </script>
  <script type='text/javascript' src="_assets/js/speed_clock.js"></script>
</body>
</html>