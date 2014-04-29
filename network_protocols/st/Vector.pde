class Vector{
  float x,y;
  
  Vector(){}
  
  Vector(float x, float y){
    setXY(x, y);
  }
  //use two points to construct a vector
  Vector(float x1, float y1, float x2, float y2){
    float x = x2 - x1;
    float y = y2 - y1;
    setXY(x, y);
  }
  
  public void setXY(float x, float y){
    setX(x);
    setY(y);
  }
  
  public void setVector(Vector other){
    this.x = other.getX();
    this.y = other.getY();
  }
  
  public void setX(float x){
    this.x = x;
  }
  
  public void setY(float y){
    this.y = y;
  }
  
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y;
  }
  
  public void vAddition(Vector other){
    this.x += other.getX();
    this.y += other.getY();
  }
  
  public void vAddition(float x, float y){
    this.x += x;
    this.y += y;
  }
  
  public void vNormalization(){
    float magt = mag(this.x, this.y);
    this.x /= magt;
    this.y /= magt;
  }
  
  public float vLength(){
    return mag(this.x, this.y);
  }
  
  public void vScale(float multiplier){
    this.x *= multiplier;
    this.y *= multiplier;
  }
  
  public void vReverse(){
    this.x = 0 - this.x;
    this.y = 0 - this.y;
  }
  
}

