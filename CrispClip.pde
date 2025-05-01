
import processing.video.*;

Movie[] movie;
int count = 0;
int player = 0;
boolean flag = false;
int tmr = 0;

boolean render_flag = false;

Slider sld;
Button play, restart, selectFile, render;
Window win_player, win_modify;

boolean mouseOPressed = false, mp1 = false; 

void setup() {
  size(1700, 500);
  textFont(createFont("Arial Bold", 14));

  windowResizable(true);
  
  play = new Button(loadImage("play.png"), 980, 235, 30, 30, "play");
  restart = new Button(loadImage("restart.png"), 1070, 235, 30, 30, "restart");
  sld = new Slider(loadImage("sld1.png"), loadImage("sld2.png"), 800, 270, 500, 30, 0, 1000);
  
  selectFile = new Button(loadImage("selectFile.png"), 20, 30, 50, 30, "selectFile");
  render = new Button(loadImage("render.png"), 20, 70, 50, 30, "render");

  win_player = new Window("Preview", 800, 0, 500, 300, 20);
  win_player.preventOverlapping = false;
  win_player.slds = new Slider[1];
  win_player.slds[0] = sld;
  
  win_player.togs = new Toggle[0];
  win_player.btns = new Button[2];
  win_player.btns[0] = play;
  win_player.btns[1] = restart;
  win_player.drops = new Dropdown[0];
  
  win_player.bcol = 10;
  win_player.tcol = 50;
  
  win_modify = new Window("Modify", 0, 0, 200, 300, 20);
  win_modify.preventOverlapping = false; 
  win_modify.slds = new Slider[0];
  win_modify.togs = new Toggle[0];
  win_modify.drops = new Dropdown[0];
  
  win_modify.btns = new Button[2];
  win_modify.btns[0] = selectFile;
  win_modify.btns[1] = render;
  
  win_modify.bcol = 10;
  win_modify.tcol = 50;
  
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
  render_flag = true;
  restart();
}

void position() {
  if (movie == null && movie[player] == null) return;
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
  background(20);
  
  if(!mp1 && mousePressed){
    mp1 = true;
    mouseOPressed = true;
  } else if(mp1 && mousePressed){
    mouseOPressed = false;
  } else if(!mousePressed && mp1){
    mp1 = false;
  }
  
  win_player.tick();
  win_modify.tick();
  
  if (movie != null && movie[player] != null) {
     position();
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
      image(movie[player], win_player.x + 51, win_player.y + 30, 403, 201);
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
