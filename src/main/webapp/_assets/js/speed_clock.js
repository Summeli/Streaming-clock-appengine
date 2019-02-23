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

var loopinterval = 25;
var time = 0;
var delay = 0;
var ping_ctrl = 0;
var ping_interval = 60000;
var stopped_l = 0;
var totaltime_l = 0;
var running_l = 0;
var stopped_r = 0;
var totaltime_r = 0;
var running_r = 0;
var bib_r = 0;
var bib_l = 0;
var results_output = $('#ehco-results');
$(function () {

  /* Helper to keep an activity log on the page. */
  function log(text) {
	console.log(text);
  }

  /* Establish the WebSocket connection and register event handlers. */
  var websocket = new WebSocket(webSocketUri);

  websocket.onopen = function () {
	log('Connected : ' + webSocketUri);
	/*register to listen clock events*/
	websocket.send("REGISTER");
  };

  websocket.onclose = function () {
	log('Closed');
  };

  websocket.onmessage = function (e) {
	log('Message received');
	var msg = e.data;
	console.log("message is:" + msg)
	var cmd = msg.substring(0, 3);
	/*protocol srs=start and reset
			   sbrxxx / sblxxx = update bibnumber
			   ssr, ssl = stop right / left clock*/
	if (cmd === 'srs') {
	  time = 0;
	  running_l = 1;
	  running_r = 1;
	  stopped_l = 0;
	  stopped_r= 0;
	} else if (cmd === 'sbr') {
	  bib_r = msg.substring(3, msg.lenght);
	  resetRightClock();
	  $("#bib_right").html(bib_r);
	} else if (cmd === 'sbl') {
	  bib_l = msg.substring(3, msg.lenght);
	  resetLeftClock();
	  $("#bib_left").html(bib_l);
	}else if( cmd === 'srf'){
        console.log("false start right");
        results_output.prepend($('<li>').text("bib:"+bib_r +" false start"));
	}else if(cmd === 'slf'){
	    results_output.prepend($('<li>').text("bib:"+bib_l +" false start"));
	    console.log("false start left");
	}else if (cmd === 'ssr') {
	  var b = msg.indexOf('b');
	  var ls = msg.substring(3, b);
	  bib_r = msg.substring(b+1,msg.lenght);
	  printResult(bib_r,ls);
	  stopped_r = ls;
	} else if (cmd === 'ssl') {
	  var b = msg.indexOf('b');
	  var ls = msg.substring(3, b);
	  bib_l = msg.substring(b+1,msg.lenght);
	  printResult(bib_l,ls);
	  stopped_l = ls;
	}
  };

  websocket.onerror = function (e) {
	log('Error (see console)');
	console.log(e);
  };

  setInterval(function () {
	//keep connection alive
	ping_ctrl = ping_ctrl+loopinterval;
	if (ping_ctrl > ping_interval) {
	  websocket.send("PING");
	  ping_ctrl = 0;
	}

	//increase timer
	time = time +loopinterval; 
	
	//update LEFT CLOCK
	updateLeftClock();
	updateRightClock();

  }, loopinterval);

});

function printResult(bib,result){
	console.log("result: "+result);
	var fractions = Math.floor(result / 10) % 100;
	var sec = Math.floor(result / 1000);
	var min = Math.floor(sec / 60);
	var printout = 'Bib: '+bib+" time: "+pad(min)+':'+pad(sec % 60)+':'+pad(fractions);
	console.log(printout);
	results_output.prepend($('<li>').text(printout));
}

function pad(val) { 
  return val > 9 ? val : "0" + val; 
  }
function resetRightClock(){
    running_r = 0;
	$("#seconds_right").html("00");
	$("#minutes_right").html("00");
	$("#fractions_right").html("00");
}
function resetLeftClock(){
    running_l = 0;
	$("#seconds_left").html("00");
	$("#minutes_left").html("00");
	$("#fractions_left").html("00");
}
function updateRightClock() {
  if (running_r == 0)
	return;
  var fractions = 0;
  var sec = 0;
  var min = 0;
  if (stopped_r != 0 && stopped_r < totaltime_r) {
	fractions = Math.floor(stopped_r / 10) % 100;
	sec = Math.floor(stopped_r / 1000);
	min = Math.floor(sec / 60);
	$("#fractions_right").html(pad(fractions));
	$("#seconds_right").html(pad(sec % 60));
	$("#minutes_right").html(pad(min));
	return;
  }
  totaltime_r = time - delay;
  if (totaltime_r < 0) {
	$("#seconds_right").html("00");
	$("#minutes_right").html("00");
	$("#fractions_right").html("00");
	return;
  } else if (stopped_r > 0 && totaltime_r > stopped_r) {
	totaltime_r = stopped_r;
  }
  //display time
  fractions = Math.floor(totaltime_r / 10) % 100;
  sec = Math.floor(totaltime_r / 1000);
  min = Math.floor(sec / 60);
  $("#fractions_right").html(pad(fractions));
  $("#seconds_right").html(pad(sec % 60));
  $("#minutes_right").html(pad(min));
};

function updateLeftClock() {
  if (running_l == 0)
	return;
  var fractions = 0;
  var sec = 0;
  var min = 0;
  if (stopped_l != 0 && stopped_l < totaltime_l) {
	fractions = Math.floor(stopped_l / 10) % 100;
	sec = Math.floor(stopped_l / 1000);
	min = Math.floor(sec / 60);
	$("#fractions_left").html(pad(fractions));
	$("#seconds_left").html(pad(sec %60));
	$("#minutes_left").html(pad(min));
	return;
  }
  totaltime_l = time - delay;
  if (totaltime_l < 0) {
	$("#seconds_left").html("00");
	$("#minutes_left").html("00");
	$("#fractions_left").html("00");
	return;
  } else if (stopped_l > 0 && totaltime_l > stopped_l) {
	totaltime_l = stopped_l;
  }
  //display time
  fractions = Math.floor(totaltime_l / 10) % 100;
  sec = Math.floor(totaltime_l / 1000);
  min = Math.floor(sec / 60);
  $("#fractions_left").html(pad(fractions));
  $("#seconds_left").html(pad(sec % 60));
  $("#minutes_left").html(pad(min));
};

window.onload = function init() {
  $("#seconds_left").html("00");
  $("#minutes_left").html("00");
  $("#fractions_left").html("00");
  $("#minutes_right").html("00");
  $("#seconds_right").html("00");
  $("#fractions_right").html("00");
  $("#delay").attr("value", 0);
  var input = document.getElementById("delay");
  input.addEventListener("change", delayUpdated, false);
}

function delayUpdated(event) {
  var input = Number(event.target.value);
  console.log(input);
  delay = input * 1000;
}