import beads.*;
import org.jaudiolibs.beads.*;
import java.util.Arrays; 

AudioContext ac;

int numeroDeDivisoes=3;

int [] Ythreshold = new int [numeroDeDivisoes]; //Ythreshold1, Ythreshold2, Ythreshold3;
float [] ellipseX = new float [numeroDeDivisoes]; //var ellipse1X,ellipse2X, ellipse3X;
int [] ellipseY = new int [numeroDeDivisoes]; //var ellipse1Y,ellipse2Y, ellipse3Y;
int [] pontoMedioX = new int [numeroDeDivisoes]; //var ellipse1Y,ellipse2Y, ellipse3Y;
float [] transposicoesUp = new float [11];
float [] transposicoesDown = new float [11];


GereSamples [] tocaSamples = new GereSamples [numeroDeDivisoes];

void setup() 
{
  // put setup code here
  size(640, 480);
  ac = new AudioContext();
  background(120, 200, 110);
  smooth();

  for (int i=1; i<=numeroDeDivisoes; i++)
  {
    Ythreshold[i-1]=height/4;
    ellipseX[i-1]=(int)((width/3)-((width/3)*0.5))+(width/3)*(i-1);
    ellipseY[i-1]=(int)(height*0.5);
    pontoMedioX[i-1]=(int)((width/3)-((width/3)*0.5))+(width/3)*(i-1);;
    
    tocaSamples[i-1]=new GereSamples ((i-1)+".mp3");
  }
  
  for (int j=1; j<=transposicoesUp.length; j++)
  {
    transposicoesUp[j-1]= 0.083*j;
    transposicoesDown[j-1]= (0.045*(j-1))+0.5;
  }
  
  ac.start();
}

void draw() 
{
  background(120, 200, 110);

  //barras separadoras
  strokeWeight(1);
  stroke(20, 100, 10);
  line(width/numeroDeDivisoes, 0, width/3, height);
  line((width/numeroDeDivisoes)*(numeroDeDivisoes-1), 0, (width/numeroDeDivisoes)*(numeroDeDivisoes-1), height);
  
  //barra dividir zona dos volumes
  line(0, height*0.9, width, height*0.9);

  //bolas sensores
  for (int i=0; i<numeroDeDivisoes; i++)
  {
    fill(0);
    noStroke();
    ellipse(ellipseX[i], ellipseY[i], 10, 10);
  
    //linha threshold
    if (mouseX>i*(width/numeroDeDivisoes) && mouseX<(width/numeroDeDivisoes)+((width/numeroDeDivisoes)*i) && mouseY>0 && mouseY<height*0.9 && mousePressed)
    {
      Ythreshold[i]=mouseY;
    }
    
    //barra threshold
    fill(0);
    stroke(0);
    strokeWeight(2);
    line(i*(width/numeroDeDivisoes), Ythreshold[i], (width/numeroDeDivisoes)+((width/numeroDeDivisoes)*i), Ythreshold[i]);

    //calculates distance
    int d = int (dist(ellipseX[i], ellipseY[i], pontoMedioX[i], Ythreshold[i]));

    //disparar som
    if (d<20 && tocaSamples[i].assinalaFimSample())
    { 
      float pitch;
      float [] transposicoes = concat(transposicoesDown, transposicoesUp);
      //choose value for tranposicao      
      int transp = (int)random(0,22);
      //transpose down
      if (transp<=11)
      {
         pitch = transposicoes[transp];
      }
      //transpose up
      else
      {
        pitch = 1 + transposicoes[transp];
      }
      
      //if drums, no pitch shift
      if (i==2)
      {
        pitch=1;
      }
      tocaSamples[i].player.setPitch(new Glide(ac,pitch));
      tocaSamples[i].player.reTrigger();
    }
  }
}
