PImage ourImage, ourImage2;
PGraphics pg;
PFont font;


int n = 50;
color c;
color c1 = #df3c8f;
color c2 = #3aa1c6;
color c3 = #96c79a;
color c4 = #f0aecf;
color c5 = #1c4999;
  

color[] colors = {c1, c2, c3, c4, c5};


int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()


int pic = 1;



void setup() {
  ourImage = loadImage("data/cats_bw1.jpg");
  ourImage2 = loadImage("data/bg2.jpg");
  font = createFont("RobotoMono-Regular.ttf", 600);
  pg = createGraphics(1080, 720, P2D);
  size(1080, 720, P2D);
  ourImage.resize(width, height);
  ourImage2.resize(width, height);
  

}


void draw() {
  
  
  //background(#fdf001);
  
  tint(0, 153, 204, 3);  // Display at half opacity
  image(ourImage2, 0, 0);
  //fill(#bb63a2,10);
  noStroke();
  //rect(0,0, width, height);
  
  
  
//cat image
  int img_sx = mouseX;
  int img_sy = mouseY;
  int img_sw = 400;
  int img_sh = 400;
  
  int img_dx = width/2 - 200;
  int img_dy = height/2 -200;
  int img_dw = 400;
  int img_dh = 400;

  if(img_sx > width-400){
     img_sx = width-400;
  }
  if(img_sy > height-400){
    img_sy = height-400;
  }
  
  copy(ourImage, img_sx, img_sy, img_sw, img_sh, img_dx, img_dy, img_dw, img_dh);
  
  
// bg grid  
int tilePX = 20;
int tilePY = 20;
int tilePW = (int)(width/tilePX);
int tilePH = (int)(height/tilePY);

for(int gridX = 0; gridX < tilePX; gridX++){
  for(int gridY = 0; gridY < tilePY; gridY++){
    //fill(0);
    //stroke(255);
    //rect(gridX*tilePW, gridY*tilePH, tilePW, tilePH);
    if(((gridX+1)*tilePW > mouseX && mouseX>gridX*tilePW) && ((gridY+1)*tilePH > mouseY && mouseY>gridY*tilePH)){
      int nowGridX = gridX;
      int nowGridY = gridY;
      fill(colors[(int)random(colors.length)]);
      rect(nowGridX*tilePW, nowGridY*tilePH, tilePW, tilePH);
 
    }
    
  }
}

  
  
  
   //PGraphics kinetic typogrpahy
  
  pg.beginDraw();
  pg.background(0,0,0,0); 
  pg.noStroke();
  if(pic == 1){
    pg.fill(#fdf001);
    pg.textFont(font);
    pg.textSize(800);
    pg.pushMatrix();
    pg.translate(width/2, height/2- 130);
    pg.textAlign(CENTER, CENTER);
    pg.text("3", 0, 0);
    pg.popMatrix();
  }else{
    pg.fill(#fdf001);
    pg.textFont(font);
    pg.textSize(200);
    pg.pushMatrix();
    pg.translate(width/2, height/2- 150);
    pg.textAlign(CENTER, CENTER);
    pg.text("RUIQI", 0, 0);
    pg.popMatrix();
    pg.translate(width/2, height/2 + 90);
    pg.textAlign(CENTER, CENTER);
    pg.text("WANG", 0, 0);
  }
  
  pg.endDraw();
  
  int tileX = 16;
  int tileY = 16;
  
  int tileW = int(width/tileX);
  int tileH = int(height/tileY);
  
  
  
  for(int y = 0; y< tileY; y++){
    for(int x = 0; x < tileX; x++){
      
      int waveX = int(sin(frameCount * 0.03 + (x*y) * 0.07) * 100);
      //int waveY = int(cos(frameCount * 0.03 + (x*y) * 0.07) * 100);
      
      int sx = tileW * x + waveX;
      int sy = tileH * y ;
      int sw = tileW;
      int sh = tileH;
      
      int dx = tileW * x;
      int dy = tileH * y;
      int dw = tileW;
      int dh = tileH;
      
      copy(pg, sx, sy, sw, sh, dx, dy, dw, dh);
      
      
    }
  }
  
  
  
  //Blur
  
  loadPixels();
  
  int blurAmount = 5;                        // change this to make the effect more pronounced
  int divider=  (2*blurAmount+1)*(2*blurAmount+1);       // calculating how many pixels will be in the neighborhood of our pixel

  for (int x = img_dx; x< img_dx+400; x++) {     // looping 100 pixels around the mouse, we have to make sure we wont 
    for (int y = img_dy; y<img_dy+400; y++) {  // be accessing pixels outside the bounds of our array
        int sumR=0;                                    // these variables will accumolate the values of R, R,B
        int sumG=0;
        int sumB=0;
        for (int blurX=x- blurAmount; blurX<=x+ blurAmount; blurX++) {     // visit every pixel in the neighborhood
          for (int blurY=y- blurAmount; blurY<=y+ blurAmount; blurY++) {
            PxPGetPixel(blurX, blurY, pixels, width);     // get the RGB of our pixel and place in RGB globals
            sumR+=R;                                           // add the R,G,B values of the neighbors
            sumG+=G;
            sumB+=B;
          }
        }
        sumR/= divider;                                         // get the average R, G B by dividing by the number of neighbors
        sumG/= divider;
        sumB/= divider;
        
        PxPSetPixel(x, y, sumR, sumG, sumB, 255, pixels, width);    // sets the R,G,B values to the window

  }
  updatePixels();
  }


}


void mousePressed(){
  pic ++;
  if(pic>2)
  pic = 1;
  ourImage = loadImage("data/cats_bw"+pic+".jpg");
  ourImage.resize(width, height);
  
  println(pic);

}














// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution)

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to define the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
