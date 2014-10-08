/*
* Name : Magic of Symmetry
* File : Assignment_3.pde
* Version : 1.0
* Last changed : 21/09/2014 13:33
* Purpose : Creates an interactive Canvas
* Author : Lucile C
* Website : LLucile.github.io
* Licence :
* This work is licensed under the Creative Commons
* Attribution-NonCommercial-ShareAlike 4.0 International
* License. To view a copy of this license, visit
* http://creativecommons.org/licenses/by-nc-sa/4.0/.
*/

boolean running=false;
int c;
int sym = 1;
boolean started = false;
color[] pixels_table;
int mouse_y;
int mouse_x;
int pmouse_x;
int pmouse_y;

void setup(){
  frameRate(30);
  jProcessingJS(this, {fullscreen:true, mouseoverlay:true}); //comment if using java mode
  //size(800,600);
  c=0;
  background(255);
  pixels_table = new color[width*height];
}


void keyPressed(){
  if(started){
    switch(key){
      case 'S': case 's':
        saveFrame("Screenshot.png");
        break;
      case 'E': case 'e':
        background(0);
        break;
      case '+':
        if(sym<20){ sym++;}
        break;
      case '-' :
        if(sym>1){sym--;}
        break;
      case 'h': case 'H':
        started=false;
        loadPixels();
        for(int i = 0; i<width*height;i++){
          pixels_table[i]=pixels[i];
        }
        background(255);
        displayadvices();  
        break;      
      case 'i':
        started=false;
        break;
    }
  }
  else{
   switch(key){
    case 'E' : case 'e' :
      background(0);
      started=true;
      break;
    case 'h' : case 'H':
     if(running) {
       background(0);
       loadPixels();
       for(int i = 0; i<width*height;i++){
          pixels[i]=pixels_table[i];
        }
       updatePixels();
     }
     else{
       background(255,0,0);
     }
     running=true;
     started=true;
     break;
   default :
    displayadvices();
    }
  }
}


void mousePressed(){
  if(!started){
    displayadvices();
  }    
}


void mouseDragged(){
  if(started){
    mouse_x=mouseX-width/2;
    mouse_y=mouseY-height/2;
    pmouse_x=pmouseX-width/2;
    pmouse_y=pmouseY-height/2;
    float speed = dist(pmouse_x, pmouse_y, mouse_x, mouse_y);
    translate(width*.5,height*.5);
    float px=speed;
    float py=speed;
    float alpha=map(speed*3,0,40,255,0);
    float alpha_fill=map(sqrt(mouseX*mouseX+mouseY*mouseY),0,sqrt((width/2)*(width/2)+(height/2)*(height/2)),255,0);
    float lineWidth = map(speed, 0, 10, 10, 1);
    lineWidth = constrain(lineWidth, 0, 10);
    strokeWeight(lineWidth);
    if(sym==1){
      colorMode(HSB);
      stroke(c,150,255, alpha);
      fill(255, 255, 255, alpha_fill);  
      line(pmouse_x, pmouse_y,mouse_x, mouse_y);
      smooth();
    }
    else{
      float angle=2*PI/sym;
      float c_angle=0;
      float r = sqrt(mouse_x*mouse_x+mouse_y*mouse_y);
      float theta;
      if(mouse_x==0){
        theta=atan(mouse_y/0.001);
      }
      else{
        theta=atan(mouse_y/mouse_x);
      }
      float r_p=sqrt(pmouse_x*pmouse_x+pmouse_y*pmouse_y);
      float theta_p;
      if(pmouse_x==0){
        theta_p=atan(pmouse_y/0.001);
      }
      else{
        theta_p=atan(pmouse_y/pmouse_x);
      }
      colorMode(HSB);
      stroke(c,150,255, alpha);
      fill(255, 255, 255, alpha_fill);  
      while(c_angle<=2*PI){
        line(r_p*cos(theta_p+c_angle),  r_p*sin(theta_p+c_angle),r*cos(theta+c_angle), r*sin(theta+c_angle));
        smooth();
        c_angle+=angle;
      }
    }
    if(c<=255){
      c++;
    }
    else{
      c=0;
    }
    translate(-width*.5,-height*.5); //note : translate has been put here because the draw tricks detailed on processingjs reference doesn't seem to work

    fill(255,0,0);
  }
}

void displayadvices(){
  fill(#667AB7);
  textSize(width/50);
  text(" Press E to erase the canvas \n Press H to display or exit the help menu \n Press S to save your drawing \n Press + to increase the number of symmetry fold \n Press - to decrease the number of symmetry fold. ", width/4, 300);
}

