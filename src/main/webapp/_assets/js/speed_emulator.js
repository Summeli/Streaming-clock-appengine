/*******************************************************************
  *
  * Copyright 2019 Antti Pohjola
  * 
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  * 
  *  http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  *
**********************************************************************/


var milliseconds = 0;
var running = 0;
var pingsent = 0;
var oneminute = 60000;
var bib_l = 22;
var bib_r = 42;
var websocket = new WebSocket(webSocketUri);

$(function () {

  /* Get elements from the page */
  var textarea = $('#echo-text');
  var output = $('#echo-response');
  var status = $('#echo-status');

  /* Helper to keep an activity log on the page. */
  function log(text) {
	status.append($('<li>').text(text))
  }

  /* Establish the WebSocket connection and register event handlers. */
  websocket.onopen = function () {
	log('Connected : ' + webSocketUri);
  };

  websocket.onclose = function () {
	log('Closed');
  };

  websocket.onmessage = function (e) {
	log('Message received');
	output.append($('<li>').text(e.data));
  };

  websocket.onerror = function (e) {
	log('Error (see console)');
	console.log(e);
  };

  document.getElementById('start').onclick = function () {
	milliseconds = 0;
	console.log("reset");
	$("#seconds").html(0);
	$("#minutes").html(0);
	$("#fractions").html(0);
	websocket.send('sbr'+bib_r);
	websocket.send('sbl'+bib_l);
	websocket.send('srs');
	console.log("start");
	running = 1;
	pingsent = 0;
  };
  document.getElementById('stopl').onclick = function () {
	websocket.send('ssl' + milliseconds+'b'+bib_l);
	console.log("pause");
  };
  document.getElementById('stopr').onclick = function () {
	websocket.send('ssr' + milliseconds+'b'+bib_r);
	console.log("pause");
  };

  function pad(val) { return val > 9 ? val : "0" + val; }

  setInterval(function () {
	if (running == 0) {
	  return;
	}
	milliseconds = milliseconds + 10;
	var fractions = (milliseconds / 10) % 100;
	var sec = Math.floor(milliseconds / 1000);
	$("#fractions").html(Math.floor(fractions));
	$("#seconds").html(pad(sec % 60));
	$("#minutes").html(pad(Math.floor(sec / 60)));
	if (sec % 60 == 0 && milliseconds > pingsent + oneminute) {
	  pingsent = milliseconds;
	  websocket.send("PING");
	}
  }, 10);

});

window.onload = function init() {
	$("#seconds").html(0);
	$("#minutes").html(0);
	$("#fractions").html(0);
	$("#bib_left").attr("value", bib_l);
	$("#bib_right").attr("value", bib_r);
    var input_bl = document.getElementById("bib_left");
    input_bl.addEventListener("change", BibLUpdated, false);
	var input_br = document.getElementById("bib_right");
    input_br.addEventListener("change", BibRUpdated, false);
}

  function BibLUpdated(event) {
     var input = Number(event.target.value);
     console.log(input);
     bib_l = input;
     websocket.send('sbl'+bib_l);
   }
   function BibRUpdated(event) {
     var input = Number(event.target.value);
     console.log(input);
     bib_r = input;
     websocket.send('sbr'+bib_r);
   }

