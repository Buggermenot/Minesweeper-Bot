class Game {
  final int BOMB = -1;
  
  float d;
  boolean start, ended;
  
  int grid[][];
  boolean view[][];
  
  Game (){
    int _s = min(height, width);
    d = _s / size;
    start = true;
    ended = false;
    
    grid = new int[size][size];
    view = new boolean[size][size];
    
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        grid[x][y] = 0;
        view[x][y] = false;
      }
    }
  }
  
  PVector getPos(int p) {
    return new PVector(int(p % size), int(p / size));
  }
  
  boolean isBomb(int x, int y) {
    if (x < 0 || x >= size || y < 0 || y >= size) { return false;}
    return (grid[x][y] == BOMB);
  }
  boolean isBomb(float x, float y) {return isBomb(int(x), int(y));}
  
  void resetBombs(PVector click) {
    int c = n_bombs;
    while (c > 0) {
      int p = int(random(1, size * size));
      PVector pos = getPos(p);
      if (isBomb(pos.x, pos.y)) {continue;}
      if (click.copy().sub(pos).mag() == 0) {continue;}
      
      grid[int(pos.x)][int(pos.y)] = BOMB;
      
      c--;
    }
  }
  
  void addBomb(int x1, int y1, int x2, int y2) {
    if (isBomb(x2, y2)) {grid[x1][y1]++;}
  }
  
  void calcBombs(int x, int y) {
    if (isBomb(x, y)) {return;}
    
    addBomb(x, y, x-1, y-1);
    addBomb(x, y, x-1, y);
    addBomb(x, y, x-1, y+1);
    
    addBomb(x, y, x, y-1);
    addBomb(x, y, x, y+1);
    
    addBomb(x, y, x+1, y-1);
    addBomb(x, y, x+1, y);
    addBomb(x, y, x+1, y+1);
  }
  
  void updateCells() {
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        calcBombs(x, y);
      }
    }
  }
  
  void spreadCell(int x, int y) {
    if (x < 0 || x >= size || y < 0 || y >= size) {return;}
    if (isBomb(x, y) || view[x][y]) {return;}
    
    view[x][y] = true;
    if (grid[x][y] != 0) {return;}
    
    spreadCell(x-1, y-1);
    spreadCell(x-1, y);
    spreadCell(x-1, y+1);
  
    spreadCell(x, y-1);
    spreadCell(x, y+1);
  
    spreadCell(x+1, y-1);
    spreadCell(x+1, y);
    spreadCell(x+1, y+1);
  }
    
  void openCells(int x, int y) {
    if (view[x][y]) {return;}
    
    if (isBomb(x, y)) {
      endGame();
      return;
    }
    
    spreadCell(x, y);
  }
  
  void endGame() {
    ended = true;
  }
  
  // EntryPoint
  void clickCell (int x, int y) {
    if (start) {
      resetBombs(new PVector(x, y));
      updateCells();
      start = false;
    }
    openCells(x, y);
  }
  
  void displayCell(int x, int y) {
    if (view[x][y]) {
      fill(100);
      stroke(0);
      rect(x * d, y * d, d, d);
      int c = grid[x][y];
      if (c != 0) {
        fill(0);
        textAlign(CENTER);
        textSize(d);
        text(c, (x + 0.5) * d, (y + 1) * d, d);
      }
    } else {
      fill(70);
      stroke(0);
      rect(x * d, y * d, d, d);
    }
  }

  void runGame() {
    if (!ended){
      for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
          displayCell(x, y);
        }
      }
    }
  }
}            
