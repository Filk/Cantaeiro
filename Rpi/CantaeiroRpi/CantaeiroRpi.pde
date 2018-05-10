/*
Cant(a)eiro is an ongoing project that proposes to investigate the potential of congregating plants with 
current computer technologies as a catalyst for musical creation with children within school environments.
This software was developed to allow children and teachers to interact with the hardware! 
It features the possibility to play sounds automatically or manually, to programm specific (musical) behaviours 
and to write information about the plant with which it is interacting.
With this research we will provide inspiring ideas to pump up musical creation in which 
plants and children interact and are both actively contributing to the soundscape of its environment.

Developed at Orquestra Jazz de Matosinhos and 
CIPEM (Research Center in Psychology of Music and Music Education)

ABeeZee:
Copyright (c) 2011 by Anja Meiners (www.carrois.com post@carrois.com), with Reserved Font Name ‘ABeeZee’
This Font Software is licensed under the SIL Open Font License, Version 1.1.
 
Speaker image from (https://pixabay.com/pt/auto-falante-som-%C3%ADcone-volume-1042642/)
*/

// para activar o SPI primeiro correr um sketch em Python que use SPI!!! (incluído na pasta do projeto)
import processing.io.*;
SPI MCP;
import controlP5.*;
import java.util.*;
import beads.*;
import org.jaudiolibs.beads.*;
import javax.swing.*;
import java.io.IOException;
import javax.swing.ImageIcon;

AudioContext ac;
ControlP5 cp5;
PFont fonte;
ControlFont fonteP5;

int numeroSamples = 12;
GereSamples [] tocaSamples = new GereSamples [numeroSamples];

ArrayList<Sine> sinusoide = new ArrayList<Sine>();

int numeroSlides=3;
MeuSliderEscolheThreshold [] sliderThresholdEscolhido = new MeuSliderEscolheThreshold[numeroSlides];
MeuNumberMedicao [] valorMedido = new MeuNumberMedicao[numeroSlides];
AssinalaThreshold [] thresholdBox = new AssinalaThreshold [numeroSlides];
MeuSliderEscolheThreshold [] sliderThreshold = new MeuSliderEscolheThreshold[numeroSlides];
//added value for touch plant sensor
MeuNumberMedicao valorMedidoToque;

PImage fundo, play, stop, bonsai;

//scrolabble list of sensors
List listaSensores = Arrays.asList("sem sensor", "condutividade", "luminosidade", "humidade");
int numeroSampleBoxes=4;
StringList nomesSons;
int numeroPistas=3;
PistaSamples [] ps = new PistaSamples[numeroSampleBoxes];

boolean ratoClicado=false;

TocadorAutomatico [] alarme = new TocadorAutomatico[numeroPistas];
int horas, minutos;
String displayHoras, displayMinutos;
int [] horaDefinida = new int [numeroPistas];
int [] minutoDefinido = new int [numeroPistas];

FichaDescritiva ficha;
int xStartPosFicha;
int yStartPosFicha;
int comprimentoFicha;
int alturaFicha;
boolean areaSelecionada;

int posXClock;
int posYClock;
boolean [] somAlarmeTocou= new boolean[numeroPistas];

public int valor_0;
public int valor_1;
public int valor_2;

XML infoToLoadXML, infoToSaveXML;
loadSaveXML lsXML;
boolean [] alarmeXML = new boolean [alarme.length];

Plantitura plantitura;
int [] setSequencia = new int[0];
boolean plantituraPronta=false;
PImage bonsaiEscolhido;
String plantituraToSave;
boolean assinalaXML=false;

NovosSons [] nSons = new NovosSons [numeroSamples];
int indexNovoSom;

boolean gravouBem=false;

String arduinoSelection;
int totalPortas, escolhaPorta;

Toqueplanta sinusoidePlanta;

void setup()
{
  size (1024, 700);
  
  //uncomment the first two lines below when compiling for Pc's or Linux
  //PImage titlebaricon=loadImage("icon_32x32.png");
  //surface.setTitle(titlebaricon);
  
  surface.setTitle("Cant(a)eiro for RPi");

  fonte= createFont("ABeeZee-Regular.otf", 14, true);
  fonteP5= new ControlFont(fonte, 10);

  textFont(fonte);
  fundo= loadImage("layout.jpg");
  play= loadImage("play.png");
  stop= loadImage("stop.png");
  bonsai= loadImage("planta.jpg");

  ac = new AudioContext();
  cp5 = new ControlP5(this);

  for (int i=0; i<numeroSamples; i++)
  {
    tocaSamples[i]=new GereSamples (i+".wav");
  }

  int yInicioSliders=25;
  int alturaSliders=33;
  int espacamentoAlturaSliders=40;

  //sliders
  for (int j=0; j<numeroSlides; j++)
  {
    valorMedido[j] = new MeuNumberMedicao (240, yInicioSliders+(j*espacamentoAlturaSliders), j);
    sliderThreshold[j] = new MeuSliderEscolheThreshold (345, yInicioSliders+(j*espacamentoAlturaSliders), j);
    thresholdBox[j] = new AssinalaThreshold (600, yInicioSliders+(j*espacamentoAlturaSliders), alturaSliders, j);
  }

  nomesSons = new StringList();

  for (int k=0; k<numeroPistas; k++)
  {
    ps[k]= new PistaSamples(15+(210*k), 170, 200, 70, k, numeroSampleBoxes, k*4);
    alarme[k]= new TocadorAutomatico (140+(140*k), 659, 270, 40, k);
    horaDefinida[k]=99;
    minutoDefinido[k]=99;
    somAlarmeTocou[k]=true;
    alarmeXML[k]=false;
  }
  
  //dimensões ficha
  xStartPosFicha=670;
  yStartPosFicha=25;
  comprimentoFicha=320;
  alturaFicha=140;
  areaSelecionada=false;
  ficha=new FichaDescritiva(xStartPosFicha, yStartPosFicha, comprimentoFicha, alturaFicha);

  posXClock=15;
  posYClock=685;

  plantitura= new Plantitura(15, 590, 580, 30);

  lsXML= new loadSaveXML(100, 660, 60, 30);
  
  int alturaPistasInicio=189;
  
  for (int l=0; l<nSons.length; l++)
  {
    if(l<4)
    {
      nSons[l]= new NovosSons (155,alturaPistasInicio+(l*ps[0].espacamentoEntreBlocos),60,20,l);
    }
    if(l>=4&&l<8)
    {
      nSons[l]= new NovosSons (368,alturaPistasInicio+((l-4)*ps[0].espacamentoEntreBlocos),60,20,l);
    }
    if(l>=8&&l<12)
    {
      nSons[l]= new NovosSons (577,alturaPistasInicio+((l-8)*ps[0].espacamentoEntreBlocos),60,20,l);
    }
  }
  
  //info in ficha
  ficha.entrada[0].setText("Cant(a)eiro");
  ficha.entrada[1].setText("10cm");
  ficha.entrada[2].setText("verde");
  ficha.entrada[3].setText("elipse");
  ficha.entrada[4].setText("planta de interior, meia luz, 12ºC, média água");
  ficha.entrada[5].setText("Clusia Rosea");
  ficha.adicionalComentarios.setText("Notas sobre minha planta...");
  
  //printArray(SPI.list());
  MCP = new SPI(SPI.list()[0]); // raspberry pi has 2 SPI interfaces, SPI.list()[1] is the other
  MCP.settings(1000000, SPI.MSBFIRST, SPI.MODE0); // 1MHz should be OK...
  
  
  //added box value for touch plant sensor
  valorMedidoToque = new MeuNumberMedicao (660, 535, 3);
  sinusoidePlanta = new Toqueplanta (762, 535, 33);
  
  ac.start();
}

//read values from Arduino inputs
void atualizaMedicoes()
{
  for (int i=0; i<numeroSlides; i++)
  {
    valorMedido[i].nb.setValue((returnADC(i)+1)* (3.3/1023)*1000);
  }
  
  //added value for touch plant sensor
  valorMedidoToque.nb.setValue((returnADC(3)+1)* (3.3/1023)*1000);
}

//read values from RPi inputs
int returnADC(int ch) 
{
  byte[] out = {1, byte((8 + ch) << 4), 0}; // outgoing bytes to the MCP
  byte[] in = MCP.transfer(out); // sends & returns
  int highInt = in[1] & 0xFF; // processing sees bytes as signed (-128 to 127) which is not what we want here
  int lowInt = in[2] & 0xFF; // doing this converts to unsigned ints (0 to 255)
  int result = ((highInt & 3) << 8) + lowInt; // adds lowest 2 bits of 2nd byte to 3rd byte to get 10 bit result 
  //println (result);
  return result;
}

void draw()
{
  image(fundo, 0, 0);
  //println(mouseX+ " " +mouseY);

  sabeQueEstaNaZona(mouseX, mouseY);

  for (int i=0; i<numeroSlides; i++)
  {
    thresholdBox[i].checkaThreshold(i);
  }

  for (int k=0; k<numeroPistas; k++)
  {
    ps[k].tocaPistaSample(mouseX, mouseY);
    ps[k].tocaSamplesQuandoThreshold(k);
  }
  
  plantitura.transportPlantitura();

  horasSegundos();
  
  //plant picture
  image(bonsai,667,26);
  
  if(gravouBem)
  {
    JOptionPane.showMessageDialog(frame, "Cant(a)eiro guardado!", "", JOptionPane.INFORMATION_MESSAGE, new ImageIcon(loadBytes("data/icon_32x32.png")));
    gravouBem=false;
  }
  
  sinusoidePlanta.toque();
  
  if (sinusoide.size()>0)
  {
    for (int i=0; i<sinusoide.size(); i++)
    {
      sinusoide.get(i).gSinusoide.setGain(sinusoide.get(i).envolvente());
      sinusoide.get(i).killStuff(i);
    }
  }
  
  atualizaMedicoes();
  
  //link to help
  if (mouseX>=717 && mouseX<=744 && mouseY>=660 && mouseY<=692 && ratoClicado)
  {
    link("http://www.filipelopes.net/Software/cantaeiro.html");
  }
}

void mousePressed()
{
  ratoClicado=true;
  //sinusoide.add(new Sine());
}

void mouseReleased()
{
  ratoClicado=false;
}

void horasSegundos()
{
  horas = hour();
  minutos = minute();
  displayHoras=str(horas);
  displayMinutos=str(minutos);

  textSize(26);
  fill(0);

  if (minutos>=1 && minutos <10)
  {
    text(displayHoras + ":" + "0" + displayMinutos, posXClock, posYClock);
  }
  if (minutos>=10)
  {
    text(displayHoras + ":" + displayMinutos, posXClock, posYClock);
  }
  if (minutos==0)
  {
    text(displayHoras + ":" + "0" + displayMinutos, posXClock, posYClock);
  }

  for (int i=0; i<numeroPistas; i++)
  {
    if (horas==horaDefinida[i]&& minutos==minutoDefinido[i] && !somAlarmeTocou[i])
    {
      tocaSamples[i*4].player.reTrigger();
      ratoClicado=false;
      somAlarmeTocou[i]=true;
    }
    if (horas==0 && minutos==0 && !somAlarmeTocou[i])
    {
      somAlarmeTocou[i]=false;
    }
  }
}

//handles all ControlP5 events
public void controlEvent(ControlEvent theEvent) 
{
  //replace sounds
  for (int i=0;i<numeroSamples;i++) 
  {
    if (theEvent.isFrom("novoSom"+i)) 
    {
      //open dialog box to choose new sound file
      indexNovoSom=i;
      selectInput("Escolhe novo som:", "loadNovoSom");
    }
  }
  
  //update sliders
  for (int j=0;j<numeroSlides;j++) 
  {
    if (theEvent.isFrom("rangeController"+j)) 
    {
      //println(sliderThreshold[j].rangeThreshold.getHighValue());
    }
    if (theEvent.isFrom("numberboxValue"+j)) 
    {
      //println("number box"+j);
    }
  }
  
  //saves Cantaeiro
  if (theEvent.isFrom("guardar"))
  {
    selectOutput("Guardar o ficheiro Cant(a)eiro:", "fileSelectedGuardar");
  }
  
  //load Cantaeiro
  if (theEvent.isFrom("abrir")) 
  {
    selectInput("Escolhe o ficheiro Cant(a)eiro:", "fileSelectedAbrir");
  }

  //loads plant photo
  if (theEvent.isFrom("imagem")) 
  {
    selectInput("Escolhe fotografia da planta", "fileSelectedFotografia");
  }  

  //loads alarm info
  if (theEvent.isAssignableFrom(Textfield.class))
  {    
    //update alarm
    for (int k=0;k<alarme.length;k++) 
    {
      if (theEvent.getName().equals(("alarme")+k)) 
      {
        String horaMarcada=theEvent.getStringValue();
        int indexAlarme=k;
        
        if(horaMarcada.matches("\\d{2}:\\d{2}"))
        {
          try
          {
              String [] setAlarme = split (horaMarcada, ":");
              horaDefinida[indexAlarme]=parseInt(setAlarme[0]);
              minutoDefinido[indexAlarme]=parseInt(setAlarme[1]);
              //user input
              if (horaDefinida[indexAlarme]>=0 && horaDefinida[indexAlarme]<24 && minutoDefinido[indexAlarme]>=0 && minutoDefinido[indexAlarme]<60 && !alarmeXML[k])
              {
                somAlarmeTocou[indexAlarme]=false;
                JOptionPane.showMessageDialog(frame, "Alarme Pronto!", "", JOptionPane.INFORMATION_MESSAGE, new ImageIcon(loadBytes("data/icon_32x32.png")));
              }
              //loaded from XML file
              else if (horaDefinida[indexAlarme]>=0 && horaDefinida[indexAlarme]<24 && minutoDefinido[indexAlarme]>=0 && minutoDefinido[indexAlarme]<60 && alarmeXML[k])
              {
                somAlarmeTocou[indexAlarme]=false;
                alarmeXML[k]=false;
              }
              else
              {
                JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme2. \n"+"hora(0-23):minutos(0-59)", "", JOptionPane.INFORMATION_MESSAGE, new ImageIcon(loadBytes("data/icon_32x32.png")));
              }
          }
          catch(Exception e)
          {
            e.printStackTrace();
            JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme22. \n"+"hora(0-23):minutos(0-59)", "", JOptionPane.INFORMATION_MESSAGE, new ImageIcon(loadBytes("data/icon_32x32.png"))); 
          }
        }
        else
        {
          JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme222. \n"+"hora(0-23):minutos(0-59)", "", JOptionPane.INFORMATION_MESSAGE, new ImageIcon(loadBytes("data/icon_32x32.png")));
        }
     }
   }
   
    //plantitura stuff
    if (theEvent.getName().equals("plantitura")) 
    {
      String [] getSequencia = split (theEvent.getStringValue(), ",");
      boolean assinalaPlantituraPronta=true;
      plantituraPronta=false;
      
      if (getSequencia.length>0)
      {
        int [] sequenciaInt = new int [getSequencia.length];
        plantituraToSave=theEvent.getStringValue();
        
        //command to break out of loop before it reaches end
        outerloop:
        for (int i=0; i<getSequencia.length;i++)
        {
          sequenciaInt[i]=parseInt(getSequencia[i]);
            
            if (sequenciaInt[i]==1 ||sequenciaInt[i]==2 ||sequenciaInt[i]==3 ||sequenciaInt[i]==4 ||sequenciaInt[i]==5 ||sequenciaInt[i]==6 ||sequenciaInt[i]==7 ||sequenciaInt[i]==8 ||sequenciaInt[i]==9 ||sequenciaInt[i]==10 ||sequenciaInt[i]==11 ||sequenciaInt[i]==12)
            {
              sequenciaInt[i]=sequenciaInt[i];
            }
            else
            {
              JOptionPane.showMessageDialog(frame, "Ups! Definições plantitura erradas. \n"+" \n"+"Introduzir números entre 1 e 12. \n"+ "ex: 1,4,2,12,9 \n"+ "(terminar sem vírgula)", "", JOptionPane.INFORMATION_MESSAGE, new ImageIcon(loadBytes("data/icon_32x32.png")));
              assinalaPlantituraPronta=false;
              //breaks out of loop before it gets to the end
              break outerloop;
            }
        }
        if(assinalaPlantituraPronta)
        {
          if(!assinalaXML)
          {
            JOptionPane.showMessageDialog(frame, "Plantitura pronta!", "", JOptionPane.INFORMATION_MESSAGE, new ImageIcon(loadBytes("data/icon_32x32.png")));
          }
          plantituraPronta=true;
          setSequencia=sequenciaInt;
        }
      }
      else
      {
        plantituraPronta=false;
      }
      assinalaXML=false;
   }
  }
  
    //touch stuff
  if (theEvent.getName().equals("sliderToquePlanta")) 
  {
   
  }
}