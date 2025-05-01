class VideoExport {
  PApplet app;
  String COMMAND = "ffmpeg -y -f rawvideo -vcodec rawvvideo -s 1920x1080 -pix_fmt rgb24 -r 60 -i temp.png -an -vcodec h264 -pix_fmt yuv420p -crf 720 -metadata comment=Render render.png";
  
  VideoExport(PApplet app){
    this.app = app;
  }
  
  void startMoive(){
    
  }
  
  void endMovie(){
  
  }
  
  void tick(){
    //app.save("temp.png");
    //launch(COMMAND);
  }
}
