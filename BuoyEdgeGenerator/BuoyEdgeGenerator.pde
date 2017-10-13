import java.util.Comparator;
import java.io.FilenameFilter;
import java.util.Arrays;

String imagesDirectory = "E:/Github/buoy-cam-scraper/scraped-images";
String outputDirectory = "./frames";
int[] buoys = {
    41001, 41004, 41008, 41009, 41010, 41013, 41043, 41046, 41047, 41048, 41424, 42001, 42040,
    42056, 42057, 42058, 42059, 45005, 46002, 46005, 46015, 46050, 46053, 46054, 51001
};

void setup() {
  for (int buoyID: buoys) {
    String[] files = getBuoyFilenames(buoyID);
    Arrays.sort(files);
    if (files.length > 0) processBuoyImagesToEdgeImage(files, buoyID);
  }

  exit();
}

void printlnFormat(String s, Object... args) {
  println(String.format(s, args));
}

void processBuoyImagesToEdgeImage(String[] files, int buoyID) {
  PImage firstImage = loadImage(imagesDirectory + "/" + files[0]);
  ParsedBuoy firstBuoy = new ParsedBuoy(this, firstImage);
  PGraphics pg = createGraphics(firstBuoy.fullImage.width, firstBuoy.fullImage.height);
  
  for (int i = 0; i < files.length; i++) {
    printlnFormat("%s = %s / %s", buoyID, i, files.length);
    
    pg.beginDraw();
    pg.clear();
    
    PImage image = loadImage(imagesDirectory + "/" + files[i]);
    image.loadPixels();
    ParsedBuoy buoy = new ParsedBuoy(this, image);
    buoy.draw(pg, 0, 0);
    
    int pos = files[i].lastIndexOf(".");
    String name = files[i].substring(0, pos);
    String outPath = String.format("%s/%s.png", outputDirectory, name);
    pg.save(outPath);
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