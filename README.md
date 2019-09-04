streaming-clock
============================

Streaming clock for finice 2019 ice climbing competition
Written with / for Google appengine

## The protocol
This project uses websockets to start / stop timer  

### Lead Climbing
In lead climbing there is only one climber on the route, so we should have separete controls for two different clocks    

reset clock to x minutes
`rcrx` or `rclx`

start clock 
`scr` or `scl`

pause clock
`pcrxxx` or `pclxxx` where xxxx is time in seconds
  
### Speed  
reset clock to 0 and start it   
`srs`  
  
false start right / left  
`srf` or `slf`  
  
update bib-number right / left clock  
`sbrxxxxxx` or `sblxxxxxx` where xxx is the bib number    
  
stop right / left clock  
`ssrxxxxbyyy` or `sslxxxxbyyy` where xxxx is time in milliseconds and yyy is the bib number  

## Requirements

* [Java 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven](https://maven.apache.org/download.cgi) (at least 3.3.9)
* [Gradle](https://gradle.org/gradle-download/) (optional)
* [Google Cloud SDK](https://cloud.google.com/sdk/) (aka gcloud)

Initialize the Google Cloud SDK using:

    gcloud init

This application is ready to run.

## Maven

### Run Locally

    mvn jetty:run

### Deploy

    mvn appengine:deploy

### Test Only

    mvn verify

## Updating to latest Artifacts

An easy way to keep your projects up to date is to use the maven [Versions plugin][versions-plugin].

    mvn versions:display-plugin-updates
    mvn versions:display-dependency-updates
    mvn versions:use-latest-versions

Our usual process is to test, update the versions, then test again before committing back.

[plugin]: http://www.mojohaus.org/versions-maven-plugin/
