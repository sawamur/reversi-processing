/**
* メインのクラス
*/

Board board;
Ai ai;
Ui ui;
int myStone = Cell.BLACK;
int aiStone = Cell.WHITE;
int turn = Cell.BLACK;
int aiTurnStartTime; // AIが考えるフリをするために考え始める時間を記録する

void setup() {
  size(640 ,680 );
  board = new Board();
  board.initGame();
  ai = new Ai(board, aiStone);
  ui = new Ui();
}

void draw(){
  background(255);
  board.display();
  
  // 置けるマスがなくなったらゲーム終了
  if(board.getAvailableCells().size() == 0){ 
    gameOver();
    return;
  }  
  
  ui.display();
  
  showGhost();
  
  if(!isMyTurn()) {
    // AIのターン
    // 考えてるっぽい雰囲気をだすため2秒ほど待たせる
    if( aiTurnStartTime == 0){
      aiTurnStartTime = millis(); 
    }
    showThinking();
    if(millis() - aiTurnStartTime > 2000){
      turnForAi();
      aiTurnStartTime = 0; // 考えるフリのためタイマーをリセット
    }
  }  
}

void showGhost() {
  if(!isMyTurn()){
    return;
  }
  Cell cell = board.getCellAtGeometry(mouseX, mouseY);
  if(cell != null){
    cell.showGhost(turn);    
  }
}

boolean isMyTurn() {
  return (myStone == turn); 
}

void turnEnd() {
  turn = turn * -1;
}

void mouseClicked() {
  if(!isMyTurn()){
    // 自分のターンではな場合は何もしない
    return;  
  }  
  if(ui.hitAnyButton(mouseX, mouseY) == ui.SKIP){
    turnEnd();
    return; 
  }


  // その座標の対象となるセル
  Cell cell = board.getCellAtGeometry(mouseX, mouseY);
  // もしそこに石をおいた場合に引っ繰り返せるセル
  ArrayList<Cell> cellsToFlip = board.cellsToFlipWith(cell, myStone);
  
  //引っ繰り返せるセルがある場合は石が置ける
  if(cellsToFlip.size() > 0){   
   cell.putStone(turn);
   for(Object c: cellsToFlip){
     ((Cell)c).flip();
   }
   turnEnd();
  } else {
    // 何もしない
  }
}

void turnForAi() {
  Cell cell = ai.think();
  ArrayList<Cell> cellsToFlip = board.cellsToFlipWith(cell, turn);
  
  if(cellsToFlip.size() == 0){
    turnEnd(); 
    return;
  }
  
  cell.putStone(turn);
  for(Object c: cellsToFlip){
    ((Cell)c).flip();
  }
  turnEnd();
}

void showThinking() {
  textSize(20);
  fill(0);
  text("AI thinking..", 20 , 640 + 30);
}

void gameOver() {
  textSize(20);
  fill(0);
  String message;
  if( board.winner() == Cell.BLACK ){
    message = "YOU Win!";
  } else {
    message = "YOU Lose!";
  } 
  text(message, 20 , 640 + 30);
  noLoop();  
}