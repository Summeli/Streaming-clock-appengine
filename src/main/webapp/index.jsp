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
  </head>
  <title>Send a message </title>
  <body>
    <p>finice time streamer </p>
    <p>webSocketUri = "<%=servletUri.getWebSocketAddress() %>"</p>
    <br><br>
    <h3>Speed climbing client</h3>
    <a href="speed_clock.jsp">Speed climbing client</a>
  </body>
</html>
