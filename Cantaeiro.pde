/*
ABeeZee:
 Copyright (c) 2011 by Anja Meiners (www.carrois.com post@carrois.com), with Reserved Font Name ‘ABeeZee’
 This Font Software is licensed under the SIL Open Font License, Version 1.1.
 */

//cp5.getController("valor_"+indexTemp).getCaptionLabel().setFont(fonteP5).setSize(10).setText("desvio");
//.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);

import controlP5.*;
import java.util.*;
import beads.*;
import org.jaudiolibs.beads.*;
import javax.swing.*;

AudioContext ac;
ControlP5 cp5;
PFont fonte;
ControlFont fonteP5;

int numeroSamples = 12;
GereSamples [] tocaSamples = new GereSamples [numeroSamples];

int numeroSlides=3;
MeuSliderEscolheThreshold [] sliderThresholdEscolhido = new MeuSliderEscolheThreshold[numeroSlides];
MeuNumberMedicao [] valorMedido = new MeuNumberMedicao[numeroSlides];
AssinalaThreshold [] thresholdBox = new AssinalaThreshold [numeroSlides];
MeuSliderEscolheThreshold [] sliderThreshold = new MeuSliderEscolheThreshold[numeroSlides];

PImage fundo, play, stop;

//scrolabble list of sensors
List listaSensores = Arrays.asList("Pausa", "condutividade", "luminosidade", "humidade");
int numeroSampleBoxes=4;
StringList nomesSons;
int numeroPistas=3;
PistaSamples [] ps = new PistaSamples[numeroSampleBoxes];
char [] makey = new char [numeroSamples];

boolean ratoClicado=false;

TocadorAutomatico [] alarme = new TocadorAutomatico[numeroPistas];
int horas, minutos;
String displayHoras, displayMinutos;
int [] horaDefinida = new int [numeroPistas];
int [] minutoDefinido = new int [numeroPistas];

FichaDescritiva ficha;
int xStartPosFicha=670;
int yStartPosFicha=25;
int comprimentoFicha=320;
int alturaFicha=240;
boolean areaSelecionada=false;

int posXClock;
int posYClock;
boolean [] somAlarmeTocou= new boolean[numeroPistas];

public int valor_0;
public int valor_1;
public int valor_2;

XML infoToLoadXML, infoToSaveXML;
LoadInfo infoToLoad;
loadSaveXML lsXML;
boolean alarmeXML0;
boolean alarmeXML1;
boolean alarmeXML2;

Plantitura plantitura;
int [] setSequencia = new int[0];
boolean plantituraPronta=false;

void setup()
{
  size (1024, 700);
  surface.setTitle("Cant(a)eiro");

  fonte= createFont("ABeeZee-Regular.otf", 14, true);
  fonteP5= new ControlFont(fonte, 10);

  textFont(fonte);
  fundo= loadImage("layout_1.jpg");
  play= loadImage("play.png");
  stop= loadImage("stop.png");

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
    valorMedido[j] = new MeuNumberMedicao (225, yInicioSliders+(j*espacamentoAlturaSliders), j);
    sliderThreshold[j] = new MeuSliderEscolheThreshold (330, yInicioSliders+(j*espacamentoAlturaSliders), j);
    thresholdBox[j] = new AssinalaThreshold (600, yInicioSliders+(j*espacamentoAlturaSliders), alturaSliders, j);
  }

  nomesSons = new StringList();

  for (int k=0; k<numeroPistas; k++)
  {
    ps[k]= new PistaSamples(15+(210*k), 170, 200, 70, k, numeroSampleBoxes, k*4);
    alarme[k]= new TocadorAutomatico (180+(130*k), 649, 200, 40, k);
    horaDefinida[k]=99;
    minutoDefinido[k]=99;
    somAlarmeTocou[k]=true;
  }

  //xStartPos, yStartPos,comprimento, altura
  ficha=new FichaDescritiva(xStartPosFicha, yStartPosFicha, comprimentoFicha, alturaFicha);

  posXClock=15;
  posYClock=685;

  plantitura= new Plantitura(15, 590, 580, 30);

  //infoToLoadXML = loadXML("cantaeiroOriginal.xml");
  infoToLoad= new LoadInfo();
  lsXML= new loadSaveXML(120, 660, 60, 30);

  makey[0]='w';
  makey[1]='a';
  makey[2]='s';
  makey[3]='d';
  makey[4]='f';
  makey[5]='g';
  makey[6]='h';
  makey[7]='j';
  makey[8]='k';
  makey[9]='l';
  makey[10]='o';
  makey[11]='p';

  ac.start();
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
    alarme[k].gui();
    ps[k].tocaSamplesQuandoThreshold(k);
  }
  
  //if (!tocaSamples[0].fimSample)
  //{
  //  println("asdasd");
  //}
  
  for (int j=0; j<numeroSamples; j++)
  {
    reiniciaSamples(j);
  }
  
  plantitura.transportPlantitura();

  horasSegundos();
}

void mousePressed()
{
  ratoClicado=true;
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
    if (horas==horaDefinida[i]&&minutos==minutoDefinido[i] && !somAlarmeTocou[i])
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

void reiniciaSamples(int index)
{
  if (tocaSamples[index].fimSample)
  {
    tocaSamples[index].fimSample=false;
  }
}