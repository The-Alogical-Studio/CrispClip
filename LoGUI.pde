class Button {
  PImage sprite;
  int x, y, w, h;
  boolean flag;
  String name;

  Button(PImage img, int px, int py, int pw, int ph, String nam) {
    sprite = img;
    x = px;
    y = py;
    w = pw;
    h = ph;
    flag = false;
    name = nam;
  }

  void tick() {
    if (mouseOPressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h / 2)) {
      method(name);
      flag = mousePressed;
    } else if (!mousePressed) {
      flag = false;
    }

    image(sprite, x, y, w, h);
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Slider {
  PImage bg, fg;
  int x, y, w, h;
  float value, minV, maxV;

  Slider(PImage b, PImage f, int px, int py, int pw, int ph, float minValue, float maxValue) {
    bg = b;
    fg = f;
    x = px;
    y = py;
    w = pw;
    h = ph;
    value = 0;
    minV = minValue;
    maxV = maxValue;
  }

  void tick() {
    float curPos = (value + minV) / (abs(minV) + abs(maxV));
    curPos *= w;
    if (mousePressed && abs((x + (w >> 1)) - mouseX) <= w && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      value += (((float) (mouseX - curPos - x) / w) * (abs(minV) + abs(maxV))) - minV;
      value = clamp(value, minV, maxV);
    }

    image(bg, x, y, w, h);
    image(fg, x + curPos, y, 20, h);
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Toggle {
  PImage bg, fg;
  int x, y, w, h;
  boolean flag, value;

  Toggle(PImage b, PImage f, int px, int py, int pw, int ph) {
    bg = b;
    fg = f;
    x = px;
    y = py;
    w = pw;
    h = ph;
    flag = false;
  }

  void tick() {
    if (mouseOPressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      value = !value;
      flag = mousePressed;
    } else if (!mousePressed) {
      flag = false;
    }

    image(bg, x, y, w, h);
    image(fg, value ? x + w - 20 : x, y, 20, h);
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Dropdown {
  int x, y, w, h, d;
  boolean open, flag;
  String[] mens;
  int value;

  Dropdown(String[] values, int px, int py, int pw, int ph, int dh) {
    x = px;
    y = py;
    w = pw;
    h = ph;
    d = dh;
    mens = values;
  }

  void tick() {
    if (mousePressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= w && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      open = !open;
      flag = mousePressed;
    } else if (!mousePressed) {
      flag = false;
    }

    if (open) {
      for (int i = 0; i < mens.length; i++) {
        int yn = y + d * (i+1);
        fill(color(75, 75, 200));
        rect(x, yn, w, h);
        fill(255);
        text(mens[i], x, yn+d/2);
        if (mousePressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= w && abs((yn + (h >> 1)) - mouseY) <= (h/2)) {
          value = i;
          open = false;
          flag = mousePressed;
        } else if (!mousePressed) {
          flag = false;
        }
      }
    }
    fill(color(75, 75, 200));
    rect(x, y, w, h);
    fill(255);
    text(mens[value], x, y + d/2);
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Window {
  boolean flag = false;
  boolean preventOverlapping = false; 
  int x, y, w, h, d, bcol, tcol, tDX, tDY;
  String name;
  Slider[] slds;
  Button[] btns;
  Toggle[] togs;
  Dropdown[] drops;

  Window(String name1, int px, int py, int pw, int ph, int dh) {
    name = name1;
    x = px;
    y = py;
    w = pw;
    h = ph;
    d = dh;
    bcol = 255;
    tcol = 120;
  }

  void tick() {
    fill(bcol);
    rect(x, y, w, h);
    fill(tcol);
    rect(x, y, w, d);
    fill(255);
    text(name, x + 10, y + ((float) d * 0.75));

    // Handle dragging
    if (flag || (mouseOPressed && abs((x + (w >> 1)) - mouseX) <= (w / 2) && abs((y + (d >> 1)) - mouseY) <= (d / 2))) {
      if (!mousePressed) {
        flag = false;
        return;
      }
      if (!flag) {
        tDX = mouseX - x;
        tDY = mouseY - y;
        flag = true;
      }

      
      int deltaX = mouseX - x - tDX;
      int deltaY = mouseY - y - tDY;

      
      if (deltaX != 0 || deltaY != 0) {
        x += deltaX;
        y += deltaY;

        
        moveElements(deltaX, deltaY);

        
        if (preventOverlapping) {
            preventOverlap();
        }
      }
    }

    
    for (int i = 0; i < slds.length; i++) {
      slds[i].tick();
    }
    for (int i = 0; i < btns.length; i++) {
      btns[i].tick();
    }
    for (int i = 0; i < togs.length; i++) {
      togs[i].tick();
    }
    for (int i = 0; i < drops.length; i++) {
      drops[i].tick();
    }
  }

  void moveElements(int deltaX, int deltaY) {
    
    for (int i = 0; i < slds.length; i++) {
      slds[i].move(deltaX, deltaY);
    }
    for (int i = 0; i < btns.length; i++) {
      btns[i].move(deltaX, deltaY);
    }
    for (int i = 0; i < togs.length; i++) {
      togs[i].move(deltaX, deltaY);
    }
    for (int i = 0; i < drops.length; i++) {
      drops[i].move(deltaX, deltaY);
    }
  }

  void preventOverlap() {
    if (!isOverlapping(this == win_player ? win_modify : win_player)) {
        return;
    }

    Window other = this == win_player ? win_modify : win_player;
    
    
    float overlapLeft = (x + w) - other.x;
    float overlapRight = (other.x + other.w) - x;
    float overlapTop = (y + h) - other.y;
    float overlapBottom = (other.y + other.h) - y;

    
    float minOverlap = min(min(overlapLeft, overlapRight), min(overlapTop, overlapBottom));

    int deltaX = 0;
    int deltaY = 0;

    
    if (minOverlap == overlapLeft) {
        deltaX = -(int)(overlapLeft + 10);
    } else if (minOverlap == overlapRight) {
        deltaX = (int)(overlapRight + 10);
    } else if (minOverlap == overlapTop) {
        deltaY = -(int)(overlapTop + 10);
    } else if (minOverlap == overlapBottom) {
        deltaY = (int)(overlapBottom + 10);
    }

    
    x += deltaX;
    y += deltaY;
    moveElements(deltaX, deltaY);
  }

  boolean isOverlapping(Window other) {
    return !(x + w < other.x || x > other.x + other.w || y + h < other.y || y > other.y + other.h);
  }
}

class Tab {
  String[] subTabs;
  int x, y, w, h, d, value;
  boolean flag;

  Tab(String[] subTb, int px, int py, int pw, int ph, int dw) {
    subTabs = subTb;
    x = px;
    y = py;
    w = pw;
    h = ph;
    d = dw;
  }

  void tick() {
    for (int i = 0; i < subTabs.length; i++) {
      int xn = x + i * d;
      fill(255);
      rect(xn, y, d, h);
      fill(0);
      text(subTabs[i], xn, y + h/2);

      if (mousePressed && flag != mousePressed && abs((xn + (d >> 1)) - mouseX) <= (d/2) && abs((y + (h >> 1)) - mouseY) <= (h / 2)) {
        value = i;
        flag = mousePressed;
      } else if (!mousePressed) {
        flag = false;
      }
    }
    method(subTabs[value]);
  }
}

float clamp(float val, float minV, float maxV) {
  return min(max(val, minV), maxV);
}


class TextField {

  char[] value;
  int cnt, trc;
  int x, y, w, h, tmr = 0;
  boolean flag = false, isTaken;


  TextField(int px, int py, int pw, int ph, int buf) {
    cnt = 0;
    x = px;
    y = py;
    w = pw;
    h = ph;
    value = new char[buf + 1];
    value[0] = '\0';
  }

  void tick() {
    if (isTaken) {
      if (keyPressed && (!flag || millis() - tmr >= 200)) {
        flag = true;
        if (key != '' && keyCode == 0) {
          freeKey(value, trc);
          value[trc] = key;
          trc += 1;
          cnt += 1;
        } else if (key == '') {
          deleteKey(value, trc-1);
          trc -= 1;
          cnt -= 1;
        } else {
          switch(keyCode) {
          case LEFT:
            trc -= 1;
            break;
          case RIGHT:
            trc += 1;
            break;
          }
        }
        cnt = (int) clamp(cnt, 0, value.length - 1);
        trc = (int) clamp(trc, 0, value.length - 1);
        tmr = millis();
      } else if (!keyPressed) {
        flag = false;
      }

      if (mouseOPressed) {
        isTaken = false;
      }
    }

    if (mouseOPressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h / 2)) {
      isTaken = true;
    }

    fill(50);
    rect(x, y, w, h);
    fill(255);
    text(value, 0, cnt, x, y + h/2);
    stroke(255);
    line(x + 9.75 * trc, y, x + 9.75 * trc, y + h);
    stroke(0);
  }
}

class MainMenu {
  String[] top_text;
  String[][] funcs;
  int value;
  boolean spamclick, closer;

  boolean[] flg;

  MainMenu(int count) {
    top_text = new String[count];
    funcs = new String[count][];
    flg = new boolean[count];
  }

  void addNextMenu(int id, String name, String[] dropNames) {
    top_text[id] = name;
    funcs[id] = dropNames;
  }

  void tick() {
    for (int i = 0; i < top_text.length; i++) {

      if (mouseOPressed && spamclick != mousePressed && abs((i * (20 * top_text[i].length()) + (20 * top_text[i].length() >> 1)) - mouseX) <= (10 * top_text[i].length()) && abs(15 - mouseY) <= 15) {
        value = i;
        flg[i] = !flg[i];
        closer = true;
        spamclick = mousePressed;
      } else {
        spamclick = false;
      }

      if (flg[i]) {
        for (int j = 0; j < funcs[i].length; j++) {
          rect(i * (20 * top_text[i].length()), 30 + j * 30, 20 * top_text[i].length(), 30);
          fill(0);
          text(funcs[i][j], i * (20 * top_text[i].length()), 30*0.75 + 30 + j * 30);
          fill(255);
          if (mouseOPressed && spamclick != mousePressed && abs((i * (20 * top_text[i].length()) + (20 * top_text[i].length() >> 1)) - mouseX) <= (10 * top_text[i].length()) && abs(30*0.75 + 30 + j * 30 - mouseY) <= 15) {
            method(funcs[i][j]);
            flg[i] = false;
          }
        }
      }

      rect(i * (20 * top_text[i].length()), 0, 20 * top_text[i].length(), 30);
      fill(0);
      text(top_text[i], i * (20 * top_text[i].length()), 30*0.75);
      fill(255);
    }
  }
}

void freeKey(char[] value, int snuf) {
  for (int i = value.length-1; i > snuf; i--) {
    value[i] = value[i - 1];
  }
}

void deleteKey(char[] value, int snuf) {
  for (int i = snuf; i < value.length - 1; i++) {
    value[i] = value[i + 1];
  }
}
