import controlP5.*;
ControlP5 cp5;
import processing.video.*;

Movie movie;
boolean flag = false;
Slider sl;
int tmr = 0;

void setup() {
  size(1000, 500, P3D);
  cp5 = new ControlP5(this);
  cp5.addButton("play")
  .linebreak()
  .setPosition(680, 15)
  ;
  
  cp5.addButton("restart")
  .linebreak()
  .setPosition(780, 15)
  ;
  
  cp5.addButton("selectFile")
  .linebreak()
  .setPosition(880, 15)
  ;
  
  sl = cp5.addSlider("position")
  .setPosition(680, 50)
  .setRange(0, 1000)
  .setSize(200, 30)
  ;
  
  movie = new Movie(this, "C:\\Users\\nicol\\Documents\\Processing\\CrispClip\\test.mov");
  movie.loop();
}

void selectFile(){
  selectInput("Hello, world", "fileSelected");
}

void play(){
  if(flag){
    movie.play();
  } else {  
    movie.pause();
  }
  
  flag = !flag;
}

void restart(){
  movie.stop();
  movie.play();
}

void position(float value){
  float position = value / 1000;
  position = movie.duration() * position; 
  if(abs(position - movie.time()) <= 0.01) return;
  movie.jump(position);
}

void movieEvent(Movie movie) {
  movie.read();
}

void draw() {
  background(120);
  if(millis() - tmr >= 50){  
    sl.setValue(movie.time() / movie.duration() * 1000);
    tmr = millis();
  }
  
  
  image(movie, 0, 0);
}

void fileSelected(File file){
  if(file == null) return;
  movie = new Movie(this, file.toString());
  movie.loop();
}
