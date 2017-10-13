import gab.opencv.*;

class EdgeImage {
  PImage cvImage;
  PImage image;
  
  public EdgeImage(PApplet parent, PImage image) {
    this.image = image;
    
    OpenCV opencv = new OpenCV(parent, image, true);
    opencv.findCannyEdges(25, 75);
    
    cvImage = opencv.getOutput();
  }
  
  public void draw(float x, float y) {
    image(cvImage, x, y);
  }
  
  public void draw(PGraphics pg, float x, float y) {
    pg.image(cvImage, x, y);
  }
}

class ParsedBuoy {
  public PImage fullImage;
  public EdgeImage[] edgeImages;
  int camWidth;
  
  public ParsedBuoy(PApplet parent, PImage buoyImage) {
    fullImage = buoyImage.get(0, 0, buoyImage.width, buoyImage.height - 30); // Caption removed
     
    camWidth = fullImage.width / 6;
    PImage[] camImages = divideImageByColumns(fullImage, 6);
    edgeImages = new EdgeImage[camImages.length]; 
    for (int i = 0; i < camImages.length; i++) {
      PImage camImage = camImages[i];
      edgeImages[i] = new EdgeImage(parent, camImage);
    }
  }
  
  private PImage[] divideImageByColumns(PImage image, int columns) {
     PImage[] images = new PImage[columns];
     int sectionWidth = image.width / columns;
     for (int i = 0; i < columns; i++) {
       images[i] = image.get(i * sectionWidth, 0, sectionWidth, image.height);
     }
     return images;
  }
  
  public void draw(float x, float y) {
    for (int i = 0; i < edgeImages.length; i++) {
      edgeImages[i].draw(x + (i * camWidth), y);
    }
  }
  
  public void draw(PGraphics pg, float x, float y) {
    for (int i = 0; i < edgeImages.length; i++) {
      edgeImages[i].draw(pg, x + (i * camWidth), y);
    }
  }
}