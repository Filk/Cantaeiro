import beads.*;
import org.jaudiolibs.beads.*;
import java.util.Arrays; 

AudioContext ac;

int numeroDeDivisoes=3;

//experimentar com acordes no piano

int [] Ythreshold = new int [numeroDeDivisoes];
float [] ellipseX = new float [numeroDeDivisoes];
int [] ellipseY = new int [numeroDeDivisoes];
int tamanhoCirculo=10;
int [] pontoMedioX = new int [numeroDeDivisoes];
float [] transposicoesUp = new float [6];
float [] transposicoesDown = new float [6];
float [] transposicoes;
int numeroAcordes=4;
int numeroSamples=numeroAcordes+2;

GereSamples [] tocaSamples = new GereSamples [numeroSamples];

void setup() 
{
  // put setup code here
  size(640, 480);
  ac = new AudioContext();
  background(120, 200, 110);
  smooth();

  for (int i=1; i<=numeroDeDivisoes; i++)
  {
    Ythreshold[i-1]=height/(int)random(3,10);
    ellipseX[i-1]=(int)((width/3)-((width/3)*0.5))+(width/3)*(i-1);
    ellipseY[i-1]=(int)(height*0.5);
    pontoMedioX[i-1]=(int)((width/3)-((width/3)*0.5))+(width/3)*(i-1);;
  }
  
  for (int j=0; j<numeroSamples; j++)
  {
    tocaSamples[j]=new GereSamples (j+".aif");
  }
  
  //up pentatonic
  transposicoesUp[0]= 1;
  transposicoesUp[1]= 0.083*2;
  transposicoesUp[2]= 0.083*4;
  transposicoesUp[3]= 0.083*7;
  transposicoesUp[4]= 0.083*9;
  transposicoesUp[5]= 2;
  
  //down pentatonic
  transposicoesDown[0]= (0.045*(0))+0.5;
  transposicoesDown[1]= (0.045*(2))+0.5;
  transposicoesDown[2]= (0.045*(4))+0.5;
  transposicoesDown[3]= (0.045*(7))+0.5;
  transposicoesDown[4]= (0.045*(9))+0.5;
  transposicoesDown[5]= 1;

  transposicoes = concat(transposicoesDown, transposicoesUp);
  ac.start();
}

void draw() 
{
  background(120, 200, 110);
  barras();
  
  //bolas sensores
  for (int i=0; i<numeroDeDivisoes; i++)
  {  
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

    //calcula distancia
    int d = int (dist(ellipseX[i], ellipseY[i], pontoMedioX[i], Ythreshold[i]));

    //disparar som
    if (d<20)
    { 
      fill(255);
      tamanhoCirculo=20;
      
      //PIANO
      if (i==0 && tocaSamples[0].assinalaFimSample() && tocaSamples[1].assinalaFimSample() && tocaSamples[2].assinalaFimSample() && tocaSamples[3].assinalaFimSample())
      {
        //escolhe sample      
        int acorde = (int)random(0,3);
        
        for (int k=0; k<numeroAcordes; k++)
        {
          if (tocaSamples[k].assinalaFimSample())
          { 
            tocaSamples[acorde].gainObject.setGain(0.5);
            tocaSamples[acorde].player.reTrigger();
          }
        }
      }
      
      //CONTRABAIXO
      if (i==1  && tocaSamples[i+(numeroAcordes-1)].assinalaFimSample())
      {
        //choose value for tranposicao      
        float intensidade = random(0.2,0.9);
        tocaSamples[i+(numeroAcordes-1)].gainObject.setGain(intensidade);
        tocaSamples[i+(numeroAcordes-1)].player.reTrigger();
      }
      
      //INSTRUMENTOS
      //bateria
      if (i==2 && tocaSamples[i+(numeroAcordes-1)].assinalaFimSample())
      {
        tocaSamples[i+(numeroAcordes-1)].gainObject.setGain(0.5);
        tocaSamples[i+(numeroAcordes-1)].player.setPitch(new Glide(ac,1));
        tocaSamples[i+(numeroAcordes-1)].player.reTrigger();
      }
    }
    else
    {
      fill(0);
      tamanhoCirculo=10;
    }

    noStroke();
    ellipse(ellipseX[i], ellipseY[i], tamanhoCirculo, tamanhoCirculo);
  }
}

void barras()
{
  //barras separadoras
  strokeWeight(1);
  stroke(20, 100, 10);
  line(width/numeroDeDivisoes, 0, width/3, height*0.9);
  line((width/numeroDeDivisoes)*(numeroDeDivisoes-1), 0, (width/numeroDeDivisoes)*(numeroDeDivisoes-1), height*0.9);
  
  //barra dividir zona dos volumes
  strokeWeight(5);
  line(0, height*0.9, width, height*0.9);
}
