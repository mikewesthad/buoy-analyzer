/**
* A tool for visualizing the history of buoy cam images (see mikewesthad/buoy-cam-scraper on GitHub).
* This takes a single vertical slice from every buoy cam image.
*/

import java.io.FilenameFilter;
import java.util.Arrays;

// Set this to be wherever your buoy cam images are stored on your computer
String imagesDirectory = "E:/Github/buoy-cam-scraper/scraped-images/";
String outputPath = "./slices";

int captionHeight = 30;
int scaleFactor = 4;
int[] buoys = {
    41001, 41004, 41008, 41009, 41010, 41013, 41043, 41046, 41047, 41048, 41424, 42001, 42040,
    42056, 42057, 42058, 42059, 45005, 46002, 46005, 46015, 46050, 46053, 46054, 51001
};

void setup() {
   for (int buoyID: buoys) {
     String[] imageNames = getBuoyFilenames(buoyID);
     Arrays.sort(imageNames);
     if (imageNames.length > 0) visualizeBuoy(buoyID, imageNames);
   }
   exit();
}

void visualizeBuoy(int buoyID, String[] imageNames) {
    println(buoyID + ": " + imageNames.length + " images");
    
    PImage firstImage = loadImage(imagesDirectory + "/" + imageNames[0]);
    int pgHeight = (firstImage.height - captionHeight) * scaleFactor;
    int pgWidth = imageNames.length * scaleFactor;
   
    PGraphics pg = createGraphics(pgWidth, pgHeight);
     
    pg.noSmooth();
    pg.beginDraw();
    for (int i = 0; i < imageNames.length; i++) {
      if (i % 30 == 0) println("\t" + i + " / " + imageNames.length + " " + imageNames[i]);
      
      PImage img = loadImage(imagesDirectory + "/" + imageNames[i]);
      
      // Pick a random, vertical slice from the image
      PImage slice = img.get(floor(random(0, img.width)), 0, 1, img.height - captionHeight);
      pg.image(slice, i * scaleFactor, 0, scaleFactor, pgHeight);
    }
    pg.endDraw();
    pg.save(outputPath + "/" + buoyID + ".png");
}

String[] getBuoyFilenames(final int buoyID){
  File directory = new File(imagesDirectory);
  FilenameFilter buoyNameFilter = new FilenameFilter() {
    public boolean accept(File dir, String name) {
      int pos = name.lastIndexOf(".");
      if (pos > 0) name = name.substring(0, pos);
      String buoy = name.split("-")[2];
      return Integer.parseInt(buoy) == buoyID;
    }
  };
  return directory.list(buoyNameFilter);
}