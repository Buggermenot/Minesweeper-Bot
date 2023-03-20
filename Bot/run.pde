int n_bombs = 99;
int size = 22;
float d;
int games = 0;
boolean view = false, pause = false;

int seed;

Game minesweeper;
Player bot;

void setup() {
  size(400, 600);
  
  // Fix Seed value here and comment line 23 in reset()
  // seed = 2902
  
  reset();
}

void reset() {
  games++;
  seed = int(random(10000));
  println("NEW GAME:", games, " SEED: ", seed);
  randomSeed(seed);
  minesweeper = new Game();
  bot = new Player();
  d = minesweeper.d;
  pause = false;
}

void mousePressed () {
  int x = int(mouseX / d), y = int(mouseY / d); 
  if (x < 0 || x >= size || y < 0 || y >= size) {return;}
  bot.playMove(new PVector(x, y), mouseButton);  
}

void keyPressed() {
  switch (key) {
    case 'r':
      reset();
      break;
    case 'q':
      view = !view;
      break;
    case 'p':
      pause = !pause;
      break;
  }
}

void draw() {
  background(10);
  
  if (view) {
    minesweeper.runGame();
  } else {  
    bot.viewPlayer();
  }
  // Limiting FrameRate
  if (frameCount % 5 == 0) {
    if (!pause){ 
      bot.play(); 
      //pause = true;
    }
  }
  
  bot.updateKnowledge();
  
  if (minesweeper.ended) {pause = true;}
  
  // DEBUG
  fill(255);
  stroke(255);
  int x = int(mouseX / d), y = int(mouseY / d);
  textAlign(LEFT);
  text("Seed: " + seed, 10, height - 180, 10);
  text("Game No.: " + games, 10, height - 150, 10);
  text("Total Bombs: " + n_bombs + ", Bombs Found: " + bot.bombs_found, 10, height - 90, 10);
  
  if (x >= 0 && x < size && y >= 0 && y < size) {
    text(x + ", " + y, 10, height - 120, 10);
    text("Actual: " + minesweeper.grid[x][y] + ", Knowledge: " + bot.knowledge[x][y], 10, height - 60, 10);
    text("Bombs: " + bot.countBombs(x, y) + ", Hidden: " + bot.countHidden(x, y), 10, height - 30, 10);
  }
}
