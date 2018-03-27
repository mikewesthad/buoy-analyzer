/**
* A tool for visualizing the history of buoy cam images (see mikewesthad/buoy-cam-scraper on GitHub).
* This takes a single vertical slice from every buoy cam image.
*/

import java.io.FilenameFilter;
import java.util.Arrays;

// Set this to be wherever your buoy cam images are stored on your computer
String imagesDirectory = "E:/Github/buoy-cam-scraper/scraped-images";

// Name of the folder where output will be stored
String runName = "10px-trial";
String outputPath = "slices/" + runName;

int scaleFactor = 1;
int sliceWidth = 10;
int maxNumImages = 100; // Maximum hourly buoy images to process
int[] buoys = {
    41001, 41004, 41008, 41009, 41010, 41013, 41043, 41046, 41047, 41048, 41424, 42001, 42040,
    42056, 42057, 42058, 42059, 45005, 46002, 46005, 46015, 46050, 46053, 46054, 51001
};
int captionHeight = 30;

void setup() {
  // Make the output directory
  new File(sketchPath(outputPath)).mkdirs();
  
   for (int buoyID: buoys) {
     buoyID = 42057;
     String[] imageNames = getBuoyFilenames(buoyID);
     Arrays.sort(imageNames);
     if (imageNames.length > 0) {
       if (imageNames.length > maxNumImages) {
         visualizeBuoy(buoyID, Arrays.copyOfRange(imageNames, 0, maxNumImages - 1));
       } else {
         visualizeBuoy(buoyID, imageNames);
       }
     }
   }
   exit();
}

void visualizeBuoy(int buoyID, String[] imageNames) {
    println(buoyID + ": " + imageNames.length + " images");
    
    PImage firstImage = loadImage(imagesDirectory + "/" + imageNames[0]);
    int pgHeight = (firstImage.height - captionHeight) * scaleFactor;
    int pgWidth = imageNames.length * sliceWidth * scaleFactor;
   
    PGraphics pg = createGraphics(pgWidth, pgHeight);
    
    int numImages = 6;
    int imageWidth = firstImage.width / numImages;
    int selectedImageNum = 1; 
    
    pg.noSmooth();
    pg.beginDraw();
    for (int i = 0; i < imageNames.length; i++) {
      println(imageNames[i]);
      if (i % 30 == 0) println("\t" + i + " / " + imageNames.length + " " + imageNames[i]);
      
      PImage img = loadImage(imagesDirectory + "/" + imageNames[i]);
      
      
      // Pick slice from center of selected camera
      int sliceX = selectedImageNum * imageWidth + (imageWidth / 2) - (sliceWidth / 2);
      PImage slice = img.get(sliceX, 0, sliceWidth, img.height - captionHeight);
      pg.image(slice, i * sliceWidth * scaleFactor, 0, sliceWidth * scaleFactor, pgHeight);
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