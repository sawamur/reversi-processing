/**
* メインのロジック
*/

Board board; // 盤面
Ai ai; // 敵AI
Ui ui; // スキップボタンなどのユーザーインタフェースをとり仕切る

int myStone = Cell.BLACK; // 自分は黒
int aiStone = Cell.WHITE; // 敵は白
int turn = Cell.BLACK; // どちらのターンか。最初は黒から

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
  // ボタン類を表示
  ui.display();
  
  // 自分のターンの場合は、マウスの位置に半透明の石を表示する
  if(isMyTurn()){
    showGhost();
  }
  
  // 敵のターン
  if(!isMyTurn()) {
    // 考えてるっぽい雰囲気をだすため2秒ほど待たせる
    // そうじゃないと一瞬で敵の手が終わり分かりにくい
    // AIのロジックを複雑にしていくと不要になるはず
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

/**
* 自分のターンの際に半透明の石をマウスの位置に表示する
*/
void showGhost() {
  Cell cell = board.getCellAtGeometry(mouseX, mouseY);
  if(cell != null){
    cell.showGhost(turn);    
  }
}

/**
* 自分のターンかどうか
*/
boolean isMyTurn() {
  return (myStone == turn); 
}

/**
* ターンエンド
*/
void turnEnd() {
  turn = turn * -1;
}

/**
* マウスがクリックされたときの処理
* 自分のターンかどうか、石を置けるマスかどうかで処理がわかれる
*/
void mouseClicked() {
  // 自分のターンではない場合はクリックしても何もおこらない
  if(!isMyTurn()){
    return;  
  }  

  // スキップボタンが押された場合はそのままターンエンド
  if(ui.hitAnyButton(mouseX, mouseY) == ui.SKIP){
    turnEnd();
    return; 
  }

  // マウス座標のところにあるマスを得る
  Cell cell = board.getCellAtGeometry(mouseX, mouseY);
  // もしそこに石をおいた場合に引っ繰り返せるマスの配列を得る
  ArrayList<Cell> cellsToFlip = board.cellsToFlipWith(cell, myStone);
  
  //引っ繰り返せるマスがある場合は石が置ける
  if(cellsToFlip.size() > 0){
    //石を置く
    cell.putStone(myStone);
   
    // それぞれひっくりかえす
    for(Cell c: cellsToFlip){
      c.flip();
    }
    
    turnEnd();
  } else {
    // ひっくりかえせるマスがない場合は何もしない
  }
}

/**
* 敵AIのターン
*/
void turnForAi() {
  // 置くマスを考えてかえす
  Cell cell = ai.think();
 
  // 置くマスが見つからなかった場合はターンエンド
  if(cell ==null){
    turnEnd(); 
    return;
  }
  
  // そこに置いた場合にひっくりかえすマス
  ArrayList<Cell> cellsToFlip = board.cellsToFlipWith(cell, turn);

  // 石を置いて
  cell.putStone(turn);  
  // それぞれひっくり返す
  for(Cell c: cellsToFlip){
    c.flip();
  }
  turnEnd();
}

/**
* 「AIが考えてる」と表示する
*/
void showThinking() {
  textSize(20);
  fill(0);
  text("AI thinking..", 20 , 640 + 30);
}

/**
* ゲームオーバー
* どちらが勝ったか表示する
*/
void gameOver() {
  textSize(20);
  fill(0);
  String message;
  if( board.winner() == myStone ){
    message = "YOU Win!";
  } else if ( board.winner() == aiStone ){
    message = "YOU Lose!";
  } else {
    // 引き分けもありえる
    message = "Draw!";
  }
  text(message, 20 , 640 + 30);
  noLoop();  
}