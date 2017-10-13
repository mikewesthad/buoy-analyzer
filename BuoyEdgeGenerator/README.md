# Buoy Edge Generator

This Processing sketch generates edge detection images from a set of source imagery. It is used to process a database of images scrapped from buoys around the US with live image feeds.

## Running

Make sure you have the opencv Processing library installed. Set up the input and output paths for your machine. imagesDirectory should point to the directory of buoy images.

```java
String imagesDirectory = "E:/Github/buoy-cam-scraper/scraped-images";
String outputDirectory = "./frames";
```