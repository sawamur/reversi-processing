/**
* 盤面クラス
* マスを2x2の行列としてもっている
*/
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

  /**
  * あるマスに石を置いた場合にひっくりかえせるセルの配列を返す
  * @param cell 石を置こうとするマス
  * @param stone 置く石を意味する整数。Cell.BLACKまたはCell.WHITE
  */
  ArrayList<Cell> cellsToFlipWith(Cell cell, int stone) {
    ArrayList<Cell> cellsToFlip = new ArrayList<Cell>();
    if(cell.hasStone()){
      return cellsToFlip;
    }

    // 縦横斜めの8方向に対象となるマスをとってきて、引っ繰り返せるかどうか調べる
    for(int dCol = -1; dCol < 2; dCol ++){
      for(int dRow = -1; dRow < 2; dRow ++) {
        ArrayList<Cell> cellsInDir = this.getCellsInDirection(cell, dCol, dRow);
        ArrayList<Cell> checked = new ArrayList<Cell>();
        for(Cell c: cellsInDir) {
           if(c.stone == 0){
                 break;
            }
            // 色が違う場合はいったん配列に入れる
            if(c.stone != stone){
                 checked.add(c);
            }
            // 同じ色の石がみつかったら返却する配列にそこまでの石を入れてループを抜ける
            if(c.stone == stone){
               for(Object toFlip: checked){
                 cellsToFlip.add((Cell) toFlip);
               }
               break;
            }
          }
          // 同じ色の石が見つからなかったらcheckedは破棄される
       }
     }
     return cellsToFlip;
  }

  /**
  * あるマスを起点として指定された方向に並ぶセルを返す
  * 右上方向なら directionCol = 1, directionRow = -1 となる
  * @param cellAtStart 起点となるマス
  * @param directionCol 横方向 -1=左,0=そのまま,1=右
  * @param directionRow 縦方向 -1=上,0=そのまま,1=下
  */
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