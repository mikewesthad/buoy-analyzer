/** 
 * Sketch to prepare files for After Effects animation. It generates slice imagery as well as
 * long strips of camera frames. 
 **/

import java.io.FilenameFilter;
import java.util.Arrays;

// Set this to be wherever your buoy cam images are stored on your computer
String imagesDirectory = "E:/Github/buoy-cam-scraper/scraped-images/";

int selectedCameraIndex = 3;
String startingTimestamp = "1510225800000";
int buoyID = 41047;
int numHours = 24 * 5;
int sliceWidth = 30;
int numHoursPerImage = 24;
int captionHeight = 30;

// Name of the folder where output will be stored
String outputPath = "extracted/" +
  "StartingTimestamp-" + startingTimestamp 
  + "_CamIndex-" + selectedCameraIndex 
  + "_NumHours-" + numHours 
  + "_SliceWidth-" + sliceWidth;


void setup() {
  // Make the output directory
  new File(sketchPath(outputPath)).mkdirs();
  
  String[] imageNames = getBuoyFilenames(buoyID);
  Arrays.sort(imageNames);
  
  int startIndex = -1;
  for (int i = 0; i < imageNames.length; i++) {
    if (imageNames[i].startsWith(startingTimestamp)) {
      startIndex = i;
      break;
    }
  }
  
  if (startIndex == -1) {
    println("No image found that starts with the specified timestamp " + startingTimestamp);
  } else {
    int endIndex = min(startIndex + numHours - 1, imageNames.length - 1);
    String[] selectedImageNames = Arrays.copyOfRange(imageNames, startIndex, endIndex + 1);
    
    println("Generating slices...");
    generateSlices(selectedImageNames);
    
    println("Generating cam images...");
    generateCamImages(selectedImageNames);
  }
    
  exit();
}

void generateSlices(String[] imageNames) {
  PImage firstImage = loadImage(imagesDirectory + "/" + imageNames[0]);
  int pgHeight = (firstImage.height - captionHeight);
  int pgWidth = imageNames.length * sliceWidth;
  PGraphics pg = createGraphics(pgWidth, pgHeight);
  int imageWidth = firstImage.width / 6;
  
  pg.noSmooth();
  pg.beginDraw();
  for (int i = 0; i < imageNames.length; i++) {
    if (i % 30 == 0) println("\t" + (float(i) / imageNames.length * 100) + " % ");
    PImage img = loadImage(imagesDirectory + "/" + imageNames[i]);
    
    // Slice from end of the selected camera
    int sliceX = (selectedCameraIndex + 1) * imageWidth - (sliceWidth + 1);
    
    PImage slice = img.get(sliceX, 0, sliceWidth, img.height - captionHeight);
    pg.image(slice, i * sliceWidth, 0, sliceWidth, pgHeight);
  }
  pg.endDraw();

  pg.save(outputPath + "/" 
    + "Buoy-" + buoyID 
    + "_CamIndex-" + selectedCameraIndex 
    + "_SliceWidth-" + sliceWidth 
    + ".png");
}

void generateCamImages(String[] imageNames) {
  PImage firstImage = loadImage(imagesDirectory + "/" + imageNames[0]);
  int camWidth = firstImage.width / 6;
  int camHeight = firstImage.height - captionHeight;

  for (int startIndex = 0; startIndex < imageNames.length; startIndex += numHoursPerImage) {
    println("\t" + (float(startIndex) / imageNames.length * 100) + " % ");
    int numHours = min(imageNames.length - startIndex, numHoursPerImage);
    PGraphics pg = createGraphics(camWidth * numHours, camHeight);
    
    pg.beginDraw();
    for (int i = 0; i < numHours; i++) {
      PImage img = loadImage(imagesDirectory + "/" + imageNames[i + startIndex]);
      PImage slice = img.get(selectedCameraIndex * camWidth, 0, camWidth, camHeight);
      pg.image(slice, i * camWidth, 0, camWidth, camHeight);
    }
    pg.endDraw();
     
    String startTime = imageNames[startIndex].split("-")[0];
    int partNum = startIndex / numHoursPerImage;

    pg.save(outputPath + "/" 
      + "Buoy-" + buoyID 
      + "_CamIndex-" + selectedCameraIndex 
      + "_Part-" + partNum 
      + "_StartingTime-" + startTime 
      + ".png");
  }
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