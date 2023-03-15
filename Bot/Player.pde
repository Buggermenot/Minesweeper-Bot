class Player {
  final int UNKNOWN = -3,
            CONFUSED = -2,
            BOMB = -1,
            FREE = 0,
            CLK_LFT = LEFT,
            CLK_RHT = RIGHT;
  
  int bombs_found;
  int knowledge[][];
  PVector last_move;
  
  Player() {
    bombs_found = 0;
    knowledge = new int[size][size];
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        knowledge[x][y] = UNKNOWN;
      }
    }
    last_move = new PVector(0, 0);
  }
  
  void updateKnowledge() {
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        if (minesweeper.view[x][y]) {
          if (knowledge[x][y] == UNKNOWN){
            knowledge[x][y] = minesweeper.grid[x][y];
          } else if (knowledge[x][y] > FREE) {
            knowledge[x][y] = minesweeper.grid[x][y] - countBombs(x, y);
          }
        }
      }
    }
  }
  
  PVector getPos(float p){
    return new PVector(int(p % size), int(p / size));
  }
  
  void playRandom() {
    PVector pos = getPos(random(size * size));
    int x = int(pos.x), y = int(pos.y);
    if (knowledge[x][y] >= BOMB) {playRandom(); return;} // get a random UNKNOWN position
    playMove(pos, CLK_LFT);    
  }
  
  void reduceVal(int x, int y){
    if (x < 0 || x >= size || y < 0 || y >= size) {return;}
    if (knowledge[x][y] <= FREE) {return;}
    
    knowledge[x][y]--;
  }
  
  void claimBomb(int x, int y){
    knowledge[x][y] = BOMB;
    
    reduceVal(x-1, y-1);
    reduceVal(x-1, y);
    reduceVal(x-1, y+1);

    reduceVal(x, y-1);
    reduceVal(x, y+1);
    
    reduceVal(x+1, y-1);
    reduceVal(x+1, y);
    reduceVal(x+1, y+1);
  }
  
  void playMove(PVector move, int click) {
    int x = int(move.x), y = int(move.y);
    println(x, y, click - CLK_LFT);
    if (click == CLK_LFT) {
      minesweeper.clickCell(x, y);
    } else {
      claimBomb(x, y);
      bombs_found++;
    }
    last_move = new PVector(x, y);
  }
  
  int addHidden(int x, int y) {
    if (x < 0 || x >= size || y < 0 || y >= size) {return 0;}
    return (minesweeper.view[x][y] == false && knowledge[x][y] != BOMB? 1 : 0);
  }
  
  int countHidden(int x, int y) {
    int c = 0;
    
    c += addHidden(x-1, y-1);
    c += addHidden(x-1, y);
    c += addHidden(x-1, y+1);

    c += addHidden(x, y-1);
    c += addHidden(x, y+1);

    c += addHidden(x+1, y-1);
    c += addHidden(x+1, y);
    c += addHidden(x+1, y+1);
    
    return c;
  }
  
  int getKnowledge(int x, int y){
    if (x < 0 || x >= size || y < 0 || y >= size) {return 10;}
    return knowledge[x][y];
  }
  
  PVector getHidden(int x, int y) {
    if (getKnowledge(x-1, y-1) < BOMB) {return new PVector(x-1, y-1);} 
    if (getKnowledge(x-1, y) < BOMB) {return new PVector(x-1, y);} 
    if (getKnowledge(x-1, y+1) < BOMB) {return new PVector(x-1, y+1);} 
    
    if (getKnowledge(x, y-1) < BOMB) {return new PVector(x, y-1);} 
    if (getKnowledge(x, y+1) < BOMB) {return new PVector(x, y+1);} 
    
    if (getKnowledge(x+1, y-1) < BOMB) {return new PVector(x+1, y-1);} 
    if (getKnowledge(x+1, y) < BOMB) {return new PVector(x+1, y);} 
    if (getKnowledge(x+1, y+1) < BOMB) {return new PVector(x+1, y+1);}
    return new PVector(0, 0);
  }
  
  int isBomb(int x, int y) {
    if (x < 0 || x >= size || y < 0 || y >= size) {return 0;}
    return (knowledge[x][y] == BOMB ? 1 : 0);
  }
  
  int countBombs(int x, int y) {
    int c = 0;
    c += isBomb(x-1, y-1);
    c += isBomb(x-1, y);
    c += isBomb(x-1, y+1);

    c += isBomb(x, y-1);
    c += isBomb(x, y+1);

    c += isBomb(x+1, y-1);
    c += isBomb(x+1, y);
    c += isBomb(x+1, y+1);
    return c;
  }
  
  float getProb(int x, int y, int h){
    return (float(knowledge[x][y]) / float(h));
  }
  
  void play() {
    if (bombs_found != n_bombs){
      PVector bestGuess = new PVector(0, 0); boolean first = true;
      for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
          
          if (minesweeper.view[x][y]) {
            // TO OPTIMISE: Traverse known clusters first
            int h = countHidden(x, y);
            
            if(h > 0){
              
              float p = getProb(x, y, h);
              if (first) {bestGuess = new PVector(x, y, p); first = false; }
              else if(bestGuess.z > p) { bestGuess = new PVector(x, y, p); }
              
              PVector move = getHidden(x, y);
              
              if (h == knowledge[x][y]){
                // Guaranteed Bombss
                println("From:", x, y, knowledge[x][y]);
                playMove(move, CLK_RHT);
                return;
              } 
              
              if (knowledge[x][y] == 0) {
                println("From:", x, y, knowledge[x][y]);
                // Guaranteed Safe Free Space
                playMove(move, CLK_LFT);
                return;
              }
            }
          }
        }
      } 
      if (first) { print("Random: "); playRandom(); }
      else {
        println("Guess Around:", bestGuess);
        PVector move = getHidden(int(bestGuess.x), int(bestGuess.y));
        playMove(move, CLK_LFT);
      }
    }
  }
  
  void viewPlayerCell(int x, int y) {
    int c = knowledge[x][y];
    
    if (minesweeper.view[x][y]) {
      fill(100);
      stroke(0);
      rect(x * d, y * d, d, d);
    } else {
      if (c == BOMB) { fill(255, 0, 0, 50); }
      else { fill(70); }
      stroke(0);
      rect(x * d, y * d, d, d);
    }
    
    fill(0);
    textAlign(CENTER);
    textSize(d);
    text(c, (x + 0.5) * d, (y + 1) * d, d);
    noFill();
    stroke(255, 0, 0);
    rect(last_move.x * d, last_move.y * d, d, d);
  }
  
  void viewPlayer() {
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        viewPlayerCell(x, y);
      }
    }
  }
  
}
