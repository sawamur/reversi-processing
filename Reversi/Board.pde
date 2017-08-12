
class Board {
  int cellSize = 80;
  ArrayList<ArrayList> cells = new ArrayList();
  
  Board() {    
    for(int i=0;i < 8; i++){
      ArrayList<Cell> row = new ArrayList();
      for(int j=0;j < 8; j++){
        //rect(i * cellSize,j * cellSize, cellSize,cellSize);
        row.add(new Cell(j,i ));
      }
      cells.add(row);       //<>//
    }   
  }
  
  void initGame() {
   getCellAt(3,3).putStone( Cell.BLACK);
   getCellAt(4,4).putStone( Cell.BLACK);
   getCellAt(3,4).putStone( Cell.WHITE);
   getCellAt(4,3).putStone( Cell.WHITE);
  }
  
  Cell getCellAtGeometry(int x, int y) {
    int numCol = floor( x / cellSize);
    int numRow = floor( y / cellSize);
    return this.getCellAt(numCol, numRow);
  }
  
  Cell getCellAt(int col, int row) {
    if(col < 0 || col > 7 || row < 0 || row > 7){
      return null;
     } 
     return (Cell)cells.get(row).get(col);
  }
    
  ArrayList<Cell> cellsToFlipWith(Cell cell, int colorToBe) { 
    ArrayList<Cell> cellsToFlip = new ArrayList<Cell>();
    if(cell.hasStone()){
      return cellsToFlip; 
    }
    
    for(int dCol = -1; dCol < 2; dCol ++){
      for(int dRow = -1; dRow < 2; dRow ++) {
        ArrayList<Cell> cellsInDir = this.getCellsInDirection(cell, dCol, dRow);
        ArrayList<Cell> checked = new ArrayList<Cell>();
        for(Cell c: cellsInDir) {
           if(c.stone == 0){
                 break; 
            }
            if(c.stone != colorToBe){
                 checked.add(c);
            }
            if(c.stone == colorToBe){
               for(Object toFlip: checked){
                 cellsToFlip.add((Cell) toFlip);            
               }
              
               break;
            }
          }
       }
     }
     return cellsToFlip;
  }
  
  ArrayList<Cell> getCellsInDirection(Cell cellAtStart,int directionCol, int directionRow ) {
    ArrayList<Cell> cellsToReturn  = new ArrayList<Cell>();
    if(directionCol == 0 && directionRow == 0){
      return cellsToReturn;  
    }
    int col = cellAtStart.getCol() + directionCol;
    int row = cellAtStart.getRow() + directionRow;
    Cell nextCell = getCellAt(col,row);
    while(nextCell != null){
      cellsToReturn.add(nextCell);
      col += directionCol;
      row += directionRow;
      nextCell = getCellAt(col,row);
    }
    return cellsToReturn;
  }  
  
  void display() {
    for(ArrayList row: cells){
      for(Object c: row){
        Cell cell = (Cell) c;
        cell.display();
      }
    }
  }
  
  ArrayList<Cell> getAvailableCells() {
    ArrayList<Cell> aCells = new ArrayList<Cell>();
    for(ArrayList<Cell> row: cells){
      for(Cell cell: row){
        if(!cell.hasStone()){
          aCells.add(cell);
        }
      }
    }
    return aCells;
  }
  
  int calcScore() {
    int score = 0;
    for(ArrayList row: cells) {
      for(Object c: row) {
        Cell cell = (Cell)c;
        score += cell.getScore();
      }
    }
    return score;
  }
  
  int winner() {
    int score = this.calcScore(); 
    if( score > 0 ){
      return Cell.BLACK; 
    } else if( score < 0 ) {
      return Cell.WHITE;  
    } else {
      return 0;  
    }
  }
}