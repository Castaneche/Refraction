void setup()
{
  size(800,600); 
  frameRate(60);
}

int mX;
float pxN1 = 400, pyN1 = 0, pxN2 = 400, pyN2 = 600, newX,newY; //Position normale 

/*class bouton{
  void afficher();
  void  
}*/
void draw()
{  
  
  background(40);
  
  mX = mouseX;
  noStroke();
  fill(150);
  ellipse(400,300,150,150);
  
  fill(255,255,255,200);
  demiCercle(400,300,145,180,360);
  
    stroke(0,255,0,20);
    line(pxN1,pyN1,pxN2,pyN2);
    stroke(0);
    fonction(mouseX, mouseY);
}

void demiCercle(float x, float y, float r, float degStart, float degEnd)
{
   // Conversion des angle en radian pour dessiner un arc de cercle
   float radStart = degStart * PI/180;
   float radEnd = degEnd * PI/180;
   
   arc(x, y, r, r, radStart, radEnd);
}
float distanceEntrePoints(float x1, float y1, float x2, float y2)
{
  //calcul de la distance entre deux points
  float distance = sqrt(pow(x2 - x1,2)+pow(y2-y1,2));
  return distance;
}
void fonction(float plx, float ply)
{ 
  float n1 = 1.00, n2 = 1.33;
  
  PVector p = new PVector(400, 300); // Le milieu du cercle
 
  // determine the angle
  float dx = mouseX - p.x;
  float dy = mouseY - p.y;
  float angle = atan2(dy, dx);
 
  // calculate the end point
  newX = p.x + cos(angle) * 200;
  newY = p.y + sin(angle) * 200;
  
  stroke(255,0,0);
  line(p.x,p.y,newX,newY);

  float coteOp;
  float coteAdj;
  coteOp = abs(mouseX-p.x);
  coteAdj = abs(mouseY-p.y);
  
  if(mouseY < p.y)
  {
     float copie = n1;
     n1 = n2;
     n2 = n1; 
  }
  
  float i;
  i = (atan(coteOp/coteAdj));
  float itest = i *180/PI;
  println("i  " + itest);
  
  float r;
  r = (asin(i*(n1/n2)));
  float rtest = r *180/PI;
  
  float pxr2=0,pyr2=0; //position pour rayon reflechi
  float pxr=0,pyr=0; //position rayon refracté
  if(mouseX <= 400) {
    pxr = (tan(r)*p.y)+p.x;
    pxr2 = (tan(i)*p.y)+p.x;
  }
  else if(mouseX > 400) {
    pxr = p.x-(tan(r)*p.y);
    pxr2 = p.x-(tan(i)*300);
  }
  if(mouseY < p.y) {
     pyr = 600;
     pyr2 = 0;
  }
  else {
     pyr = 0;
     pyr2 = 600;
  }
  int intensiteR; //intensite du rayon refracter
  int intensiteR2; // intensiter du rayon reflechi
  if(Float.isNaN(r))
  {
    print(".");
    intensiteR2 = 255;
  }
  else
  {
    intensiteR2 = int(i*180/PI+60); //Calcul chiant et degueu 
  }
  intensiteR = int(255-r*180/PI);
  
  stroke(255,0,0,intensiteR);
  line(p.x,p.y,pxr,pyr); //rayon refracté
  stroke(255,0,0,intensiteR2);
  line(p.x,p.y,pxr2,pyr2);
}

