/**
* AIクラス
*/
class Ai {
  Board board;
  int stone;

  Ai(Board board, int stone) {
    this.board = board;
    this.stone = stone;
  }

  /**
  * どのマスに置くか考える
  * いまのところは愚直に一番ひっくりかえせる数が多いのを選んでる
  * そのうち2〜３手先を計算するようにするつもり
  * @return 置くマス
  */
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
