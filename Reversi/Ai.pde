
class Ai {
  Board board;
  int stone;
  
  Ai(Board board, int stone) {
    this.board = board;
    this.stone = stone;
  }

  Cell think() {
    int max = 0;
    Cell cellToPut = null;
    ArrayList<Cell> candidates = board.getAvailableCells();
    for(Cell cell: candidates) {
      ArrayList<Cell> cellsToFlip = board.cellsToFlipWith(cell, Cell.WHITE);
      if(max < cellsToFlip.size()){
        max = cellsToFlip.size();
        cellToPut = cell;
      }
    }
    return cellToPut;
  }
}