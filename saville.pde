import ddf.minim.*;
 
Minim minim;
AudioInput in;

import processing.opengl.*;
import processing.video.*;
float xx = 320;
float yy = 220;
float len = 8;
float ss = 1.6;
float brt;
boolean inverse, sound;
Capture video;

void setup() {
  size(640, 480,P3D);
  frameRate(100);
  smooth();
  video = new Capture(this, width, height, 30);
  video.start();
  minim = new Minim(this);
  minim.debugOn();
 
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 256);
}

void draw() {
  
  noFill();
  lights();
  strokeWeight(1);
  background(0);
  if (video.available()) {
      // println("Video Available :D ");
      video.read();
      video.loadPixels();
      pushMatrix();
      translate( width/2, height/2+600, -400 );
      rotateY( radians( xx-(width/2) ) );
      rotateX( radians( -(yy-(height/2)) ) );
      translate(-width/2, -height/2-600, 400);
      int index = 0;
      for (int y = 0; y < video.height; y+=len){
        beginShape();
        for (int x = 0; x < video.width; x++){
          getBright(x,y);
          if (sound){
            ss = constrain(1+in.left.get(255)*40, 1.8, 2.8);
          } else {
            ss = 2.5;
          }
          //println(ss);
          vertex (width-x, y, (brt/ss)-100);
          index++;
        }
        endShape();
      }
      popMatrix();
    } else {
      println("No video :( ");
    }
}

void mouseDragged(){
  xx=mouseX;
  yy=mouseY;
  println(xx+ " : " + yy);
}

void keyPressed(){
   if ( key == 'p' || key == 'P' ) {
     save("screenshot.tif");
   } else if ( key == 's' || key == 'S' ) {
     if ( !sound ) {
       sound=true;
     } else {
       sound=false;
     }
   } else if ( keyCode == UP ) {
     len++;
     len= constrain(len, 1,25);
   } else if ( keyCode == DOWN ) {
     len--;
     len= constrain(len, 3,11);
   } else if ( keyCode == 'i' || keyCode == 'I' ){
     if ( !inverse ) {
       inverse = true;
     } else {
       inverse = false;
     }
   }
}

void getBright(int xx, int yy){
  int col = video.pixels[xx+(yy*video.width)];
  if (!inverse) {
    stroke(brt, 220);
    brt = brightness(col);
  } else {
    stroke(brt-100, 220);
    brt = 255-brightness(col);
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  super.stop();
}

