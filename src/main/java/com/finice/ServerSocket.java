/*
 * Copyright 2019 Antti Pohjola
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.finice;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.WebSocketAdapter;

/*
 * Server-side WebSocket : echoes received message back to client.
 */
public class ServerSocket extends WebSocketAdapter {
  private Logger logger = Logger.getLogger(servletUri.class.getName());
  private final static List<ServerSocket> registeredSockets = new ArrayList();

  @Override
  public void onWebSocketConnect(Session session) {
    super.onWebSocketConnect(session);
    logger.fine("Socket Connected: " + session);
  }

  @Override
  public void onWebSocketText(String message) {
    super.onWebSocketText(message);
    logger.fine("Received message: " + message);
    if(message.equals("PING")){
      try {
        super.getRemote().sendString("PONG");
      }catch (IOException e) {
          logger.severe("Error at responding to PING");
        }
      return;
    }else if(message.equals("REGISTER")){
      logger.info("RESGISTERED CLIENT LISTENER");
      registeredSockets.add(this);
    }
    try {
      for (ServerSocket socket : registeredSockets)
        socket.getRemote().sendString(message);

      // echo message back to client
    //  getRemote().sendString(message);
    } catch (IOException e) {
      logger.severe("Error echoing message: " + e.getMessage());
    }
  }

  @Override
  public void onWebSocketClose(int statusCode, String reason) {
    super.onWebSocketClose(statusCode, reason);
    registeredSockets.remove(this);
    logger.fine("Socket Closed: [" + statusCode + "] " + reason);
  }

  @Override
  public void onWebSocketError(Throwable cause) {
    super.onWebSocketError(cause);
    logger.severe("Websocket error : " + cause.getMessage());
  }
}
