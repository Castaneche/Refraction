Bouton n;
Bouton couleur;

void setup()
{
  size(800,600); 
  frameRate(120);
  n = new Bouton();
  couleur = new Bouton();
}
//Les Positions
PVector p = new PVector(400, 300); // Le milieu du cercle
float pxN1 = 400, pyN1 = 0, pxN2 = 400, pyN2 = 600; //Position de la normale 
float newX,newY; //Position pour le laser
float pxr = 0, pyr = 0; //position rayon refracté
float pxr2 = 0, pyr2 = 0; //position pour rayon reflechi
float pxBox = 10, pyBox = 10; // position du hud
float wBox = 100, hBox = 130;
float difx, dify;

//Les Calculs
float coteOp, coteAdj; //Pour le calcul de i
float n1 = 1.00, n2 = 1.5; // les indices des milieux
float i, r;
int intensiteR; //intensite du rayon refracter
int intensiteR2; // intensiter du rayon reflechi

int red = 255, green, blue;

boolean locked,block = false, info = false; //pour deplacer l'hud

class Bouton{  
  boolean afficher(float x,float y, float longueur, float largeur, String texte){
    if(mouseX < x+longueur && mouseX > x && mouseY <  y+largeur && mouseY > y){
       fill(0);
    }
    else {
      fill(100);    
    }
    stroke(0);
    rect(x,y,longueur,largeur);
    fill(255);
    textAlign(CENTER);
    text(texte,x+(longueur/2),y+(largeur/1.6));
    textAlign(0);
    
    if(mousePressed == true){
      if(mouseX < x+longueur && mouseX > x && mouseY <  y+largeur && mouseY > y){
        return true;
      }
    }
      return false;
  }
}

void draw()
{
 background(40);
  
   if(n.afficher(10,200,110,40,"n1 = Air")) n1 = 1.00;
   if(n.afficher(10,250,110,40,"n1 = Eau")) n1 = 1.33;
   if(n.afficher(10,300,110,40,"n2 = Diamant")) n2 = 2.4175;
   if(n.afficher(10,350,110,40,"n2 = Plexi")) n2 = 1.5;
   if(couleur.afficher(width-100,200,80,40, "Rouge")){
     red = 255;
     blue = 0;
     green = 0;
   }
   if(couleur.afficher(width-100,250,80,40, "Bleu")){
     red = 0;
     blue = 255;
     green = 0;
   }
   if(couleur.afficher(width-100,300,80,40, "Vert")){
     red = 0;
     blue = 0;
     green = 255;
   }   
   
  noStroke();
  fill(150);
  ellipse(400,300,150,150);
  
  fill(255,255,255,200);
  demiCercle(400,300,145,180,360);
  
  noCursor();
  rect(mouseX-2.5, mouseY-2.5, 5,5);
  if(block)
  { 
     text("BLOCK", width/2-20, height-50);
  }
  hud(15); 
  
  stroke(0,255,0,20);
  line(pxN1,pyN1,pxN2,pyN2);
  stroke(0);
  afficherRayons();
  
  fill(255,255,255,130);
  if(info){
    textSize(20);
    textAlign(CENTER,CENTER);
    rect(10,10,width-20,height-20);
    fill(0);
    text("INFORMATIONS", width/2, height/5);
    textSize(15);
    text("Bougez la souris pour déplacer le rayon.", width/2, height/5+30);
    text("Vous pouvez déplacer le menu d'affichage avec la souris.", width/2, height/5+50);
    text("Appuyez sur 'b' pour mettre la simulation en pause.", width/2, height/5+70);
    text("Le menu d'affichage contient les informations suivantes :", width/2, height/5+100);
    text("i -> angle d'incidence", width/2, height/5+120);
    text("r -> angle de réfraction", width/2, height/5+140);
    text("n1 -> indice de milieu 1 (partie noire)", width/2, height/5+160);
    text("n2 -> indice de milieu 2 (hémicylindre)", width/2, height/5+180);
    text("Note: le rayon ne se réfractera pas en fonction de la longueur d'onde (fonction non-implémentée).", width/2, height/5+300);
    text("Appuyez sur 'i' pour quitter le menu d'informations.", width/2, height/5+350);
  }
  else
  {
    textAlign(CENTER,CENTER);
    text("Appuyez sur 'i' pour afficher l'aide", width/2, 15); 
  }
}
void keyPressed() {
  if(key=='b' && block == false) {
    block = true;
  }
  else if(key=='b' && block == true){
    mouseX = int(newX);
    mouseY = int(newY);
  
    block = false;
  } 
  if(key=='i' && info == false){
   info = true;
   block = true;
  }
  else if(key=='i' && info == true){
    info = false;
    block = false;
  }
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
void afficherRayons()
{ 
  dessinerLaser(p.x,p.y,150);
  
  coteOp = abs(newX-p.x);
  coteAdj = abs(newY-p.y);
  
  
  //Calcul de i
  i = (atan(coteOp/coteAdj));
  if(newY < p.y) //Inversion des milieux
  {
    //Calcul de r
    r = asin(sin(i)*(n2/n1));
  }
  else {
    //Calcul de r
    r = asin(sin(i)*(n1/n2));
  }
  //Plein de calculs pour les positions des rayons
    if(newX <= 400) {
      pxr = (tan(r)*p.y)+p.x;
      pxr2 = (tan(i)*p.y)+p.x;
    }
    else if(newX > 400) {
      pxr = p.x-(tan(r)*p.y);
      pxr2 = p.x-(tan(i)*300);
    }
    if(newY < p.y) {
       pyr = 600;
       pyr2 = 0;
    }
    else {
       pyr = 0;
       pyr2 = 600;
    }
  
    if(Float.isNaN(r))
    {
      intensiteR2 = 255;
    }
    else
    {
      intensiteR2 = int(i*180/PI+60); //Calcul chiant et degueu 
    }
    intensiteR = int(255-r*180/PI);

  stroke(red,green,blue,intensiteR);
  line(p.x,p.y,pxr,pyr); //rayon refracté
  stroke(red,green,blue,intensiteR2);
  line(p.x,p.y,pxr2,pyr2); //rayon reflechi
  
}
void dessinerLaser(float pInitX, float pInitY,float lengthLine)
{
  if(block == false){
    // determine the angle
    float dx = mouseX - pInitX;
    float dy = mouseY - pInitY;
    float angle = atan2(dy, dx);
    
    // calculate the end point
    newX = pInitX + cos(angle) * lengthLine;
    newY = pInitY + sin(angle) * lengthLine;
  }
  
  stroke(red,green,blue);
  line(pInitX,pInitY,newX,newY);
}
void hud(float size)
{ //Affichage d'un menu avec simplement 2 coordonnees :
  // Calcul les emplacements relativement aux 2 coordonnees
  
  textSize(size);
  float pxI = pxBox + 10, pyI = pyBox + 10 + size; // position de i
  float pxR = pxBox + 10, pyR = pyBox + 10*2 + size*2; //position de r
  float pxNI = pxBox + 10, pyNI = pyBox + 10*3 + size*3; //position de n1
  float pxNR = pxBox + 10, pyNR = pyBox + 10*4 + size*4; //position de n2
  
  fill(0);
  rect(pxBox,pyBox,wBox,hBox);
  fill(255);
  text("i : " + Math.floor((i*180/PI)*100)/100,pxI,pyI);
  text("r : " + Math.floor((r*180/PI)*100)/100,pxR,pyR);
  text("n1 : " + n1,pxNI,pyNI);
  text("n2 : " + n2, pxNR, pyNR);
  
    if(mouseX < pxBox + wBox && mouseX > pxBox && mouseY > pyBox && mouseY < pyBox + hBox)
    {
       if(mousePressed) {
         locked = true;
         difx = mouseX-pxBox;
         dify = mouseY-pyBox;
       }
       else
      {
         locked = false;   
      }  
    }
  if(pxBox < 0) pxBox = 0;
  if(pxBox + wBox > width) pxBox = width - wBox;
  if(pyBox < 0) pyBox = 0;
  if(pyBox + hBox > height) pyBox = height - hBox;
}
void mouseDragged() {
  if(locked) {
     pxBox = mouseX-difx;
     pyBox = mouseY-dify;
  } 
}
void mouseReleased() {
   locked = false; 
}