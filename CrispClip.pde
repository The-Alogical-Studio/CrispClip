//import controlP5.*;
//ControlP5 cp5;
import processing.video.*;

Movie[] movie;
int count = 0;
int player = 0;
boolean flag = false;
int tmr = 0;

boolean render_flag = false;

Slider sld;
Button play, restart, selectFile, render;



void setup() {
  size(1000, 500, P3D);
  /*
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Consolas", 14));
  
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

  cp5.addButton("render")
    .linebreak()
    .setPosition(680, 90)
    ;
  */
  play = new Button(loadImage("play.png"), 680, 15, 50, 30, "play");
  sld = new Slider(loadImage("sld1.png"), loadImage("sld2.png"), 680, 50, 200, 30, 0, 1000);
  selectFile = new Button(loadImage("selectFile.png"), 780, 15, 50, 30, "selectFile");
  restart = new Button(loadImage("restart.png"), 880, 15, 50, 30, "restart");
  render = new Button(loadImage("render.png"), 680, 90, 50, 30, "render");
}

void selectFile() {
  selectInput("Select a sample video file", "fileSelected");
}

void play() {
  if (flag) {
    movie[player].play();
  } else {
    movie[player].pause();
  }

  flag = !flag;
}

void restart() {
  movie[player].stop();
  player = 0;
  movie[player].play();
}

void render() {
  //PImage map = movie;
  //println(movie[player].pixels[500]);
  render_flag = true;
  restart();
}

void position() {
  if (movie == null) return;
  float position = sld.value / 1000;
  position = movie[player].duration() * position;
  if (abs(position - movie[player].time()) <= 0.1) return;
  movie[player].jump(position);
}

void movieEvent(Movie movie) {
  if (movie == null) return;
  movie.read();
  if (render_flag == true) {
    PImage img = movie;
    
  }
}

void draw() {
  background(120);
  sld.tick();
  play.tick();
  restart.tick();
  selectFile.tick();
  render.tick();
  position();
  if (movie != null) {
    if (millis() - tmr >= 50) {
      sld.value = movie[player].time() / movie[player].duration() * 1000;

      if (movie[player].duration() - movie[player].time() <= 0.01f && player + 1 != movie.length) {
        movie[player].stop();
        player += 1;
        movie[player].play();
      }

      tmr = millis();
    }

    if (!render_flag) {
      image(movie[player], 0, 0, 640, 360);
    }
  }
}

void fileSelected(File file) {
  if (file == null) return;
  if (movie == null || movie.length == 0) {
    movie = new Movie[1];
  }
  if (movie.length == count && !(movie.length == 0)) {
    println(count);
    movie = (Movie[]) expand(movie);
  }
  movie[count] = new Movie(this, file.toString());
  play();
  //movie[count].loop();
  count += 1;
  
}
