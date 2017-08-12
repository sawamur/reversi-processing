
class Cell {
  static final int SIZE = 80;
  static final int BLACK = 1;
  static final int WHITE = -1;
  
  int x;
  int y;
  int stone = 0;
  int size = SIZE;
  
  Cell(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  int getCol() {
    return this.x; 
  }
  
  int getRow() {
    return this.y; 
  }
  
  boolean hasStone() {
    return (this.stone != 0);
  }
  
  int getScore() {
    return this.stone; 
  }

  void showGhost(int colorToShow) {
    if(this.hasStone()){
     return; 
    }
    noStroke();
    if(colorToShow == BLACK){
      fill(0, 255 * 0.3);  
    } else {
      fill(255, 255 * 0.3);
    }
    ellipse(this.x * size + (size/2),  this.y * size + (size/2), size * 0.9,size * 0.9);   
  }
  
  void display() {
    stroke(0);
    fill(0,0.6 * 255,0);
    rect(x * size, y * size, size, size);
    if(this.stone != 0){
      if( this.stone == BLACK){        
        fill(0);
      } else {
        fill(255); 
      }
      noStroke();
      ellipse(x * size + (size/2), y * size + (size/2),size * 0.9,size * 0.9);
    }
  }
  
  boolean putStone(int stoneColor) {
    this.stone = stoneColor;
    return true;
  }
  
  void flip() {
    this.stone *= -1; 
  }
}