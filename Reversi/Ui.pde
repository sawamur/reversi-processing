
class Ui {
  static final int SKIP = 1; 

  int skipButtonX = 640 - 80;
  int skipButtonY = 640 + 5;
  int skipButtonWidth = 70;
  int skipButtonHeight = 30;
  
  
  void display() {
    displaySkipButton();
  }  
  
  void displaySkipButton() {
    stroke(100);
    fill(100,100,100);
    rect(skipButtonX, skipButtonY, skipButtonWidth, skipButtonHeight);
    textSize(18);
    fill(0);
    text("Skip",skipButtonX + 14, skipButtonY + 23);
  }
  
  int hitAnyButton(int x, int y) {
    if(x > skipButtonX && x < skipButtonX + skipButtonWidth &&
       y > skipButtonY && y < skipButtonY + skipButtonHeight ){
      return SKIP;
    }
    return 0;
  }  
}