import java.util.*;
import beads.*;
import org.jaudiolibs.beads.*;
import javax.swing.*;
import java.io.IOException;
import javax.swing.ImageIcon;
import processing.serial.*;
import cc.arduino.*;

AudioContext ac;

int numeroDeDivisoes=3;

PImage fundo, logos, cant;

int [] Ythreshold = new int [numeroDeDivisoes];
float [] ellipseX = new float [numeroDeDivisoes];
int [] ellipseY = new int [numeroDeDivisoes];
int tamanhoCirculo=10;
int [] pontoMedioX = new int [numeroDeDivisoes];
int numeroAcordes=4;
int numeroSamples=numeroAcordes+2;

GereSamples [] tocaSamples = new GereSamples [numeroSamples];

Arduino arduino;
String arduinoSelection;
int totalPortas, escolhaPorta;
float [] valorMedido = new float [numeroDeDivisoes];

void setup() 
{
  // put setup code here
  size(640, 480);
  ac = new AudioContext();
  smooth();
  surface.setTitle("Cant(a)eiro simples");
  
  fundo= loadImage("fundo.png");
  logos= loadImage("logos.png");
  cant= loadImage("icon_32x32.png");

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
  
  // Prints out the available serial ports.
  String [] arduinoLista = Arduino.list();  
  JOptionPane.showMessageDialog(frame, arduinoLista, "", JOptionPane.INFORMATION_MESSAGE, new ImageIcon(loadBytes("data/icon_32x32.png")));
  
  //choose arduino port
  arduinoSelection = JOptionPane.showInputDialog (frame ,"", "Porta Arduino",JOptionPane.QUESTION_MESSAGE);
  
  try
  {
    if (arduinoSelection!=null || arduinoSelection!="")
    {
      escolhaPorta=Integer.parseInt(arduinoSelection);
      totalPortas = arduinoLista.length;
    }
    if (arduinoSelection!=null && escolhaPorta>=0 && escolhaPorta<arduinoLista.length)
    {
      arduino = new Arduino(this, Arduino.list()[escolhaPorta], 57600);
    }
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
  
  ac.start();
}

void draw() 
{
  image(fundo, 0, 0);
  image(logos,0,height*0.91);
  image(cant,width-50,height*0.915);
  barras();
  atualizaMedicoes();
  
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
    
    //colocar aqui valores lido do arduino
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

//read values from Arduino inputs
void atualizaMedicoes()
{
  for (int i=0; i<numeroDeDivisoes; i++)
  {
    valorMedido[i]=map(arduino.analogRead(i), 1, 1023, 10, (height*0.9));
    //mapear valores lidos no arduino para o movimento no canvas;
    //exagerar movimento de acordo com cada sensor
    if (i==0)
    {
      ellipseY[i]=(int) valorMedido[i]*1;
    }
    if (i==1)
    {
      ellipseY[i]=(int) valorMedido[i]*2;
    }
    if (i==2)
    {
      ellipseY[i]=(int) valorMedido[i];
    }
  }
  println(valorMedido[1]);
}
