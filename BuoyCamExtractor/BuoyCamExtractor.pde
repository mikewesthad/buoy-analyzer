/**
 * This sketch takes the buoy images stored in "imagesDirectory" and jams them into one big image, where 
 * each row of the image is a single buoy cam over time.
**/

import java.io.FilenameFilter;
import java.util.Arrays;

// Set this to be wherever your buoy cam images are stored on your computer
String imagesDirectory = "E:/Github/buoy-cam-scraper/scraped-images/";

// Name of the folder where output will be stored
String runName = "trial-run";
int maxSlices = 100;
String outputPath = "extracted/" + runName;

int captionHeight = 30;
int[] buoys = {
    41001, 41004, 41008, 41009, 41010, 41013, 41043, 41046, 41047, 41048, 41424, 42001, 42040,
    42056, 42057, 42058, 42059, 45005, 46002, 46005, 46015, 46050, 46053, 46054, 51001
};

void setup() {
  // Make the output directory
  new File(sketchPath(outputPath)).mkdirs();
  
  for (int buoyID: buoys) {
    String[] imageNames = getBuoyFilenames(buoyID);
    Arrays.sort(imageNames);
    
    if (imageNames.length > 0) {
      int startingIndex = max(0, imageNames.length - maxSlices);
      String[] recentImages = Arrays.copyOfRange(imageNames, startingIndex, imageNames.length - 1);
      
      String savePath = outputPath + "/" + buoyID + ".png";
      visualizeBuoy(buoyID, recentImages, savePath);
    }
  }
   exit();
}

void visualizeBuoy(int buoyID, String[] imageNames, String savePath) {
    println(buoyID + ": " + imageNames.length + " images");
    
    PImage firstImage = loadImage(imagesDirectory + "/" + imageNames[0]);
    int camWidth = firstImage.width / 6;
    int camHeight = firstImage.height - captionHeight;
    int pgHeight = camHeight * 6;
    int pgWidth = camWidth * imageNames.length;
   
    PGraphics pg = createGraphics(pgWidth, pgHeight);
       
    pg.noSmooth();
    pg.beginDraw();
    for (int i = 0; i < imageNames.length; i++) {
      if (i % 30 == 0) println("\t" + i + " / " + imageNames.length);
      
      PImage img = loadImage(imagesDirectory + "/" + imageNames[i]);

      for (int c = 0; c < 6; c++) {
        PImage slice = img.get(c * camWidth, 0, camWidth, camHeight);
        int x = i * camWidth; 
        pg.image(slice, x, c * camHeight, camWidth, camHeight);
      }
    }
    pg.endDraw();
    pg.save(savePath);
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