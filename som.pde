class GereSamples
{
  SamplePlayer player;
  Sample meuSample;
  Gain gainObject;
  String pathSample;
  double duracaoFile;
  boolean sampleChegouFim;
  
  GereSamples (String tempFicheiroInicio)
  {
    pathSample=tempFicheiroInicio;
    meuSample= SampleManager.sample(dataPath(pathSample));
    player = new SamplePlayer(ac,meuSample);
    gainObject = new Gain(ac,2,0.5);
    gainObject.addInput(player);
    ac.out.addInput(gainObject);
    player.setSample(meuSample);
    player.setKillOnEnd(false);
    duracaoFile=meuSample.getLength();
    sampleChegouFim=false;
    player.reTrigger();
  }
  
  boolean assinalaFimSample()
  {    
    if(!player.isPaused())
    {
      if(player.getPosition()>duracaoFile)
      {
        sampleChegouFim= true;
      }
      else
      {
        sampleChegouFim= false;
      }
    } 
    return sampleChegouFim;
  }
  
}

class PistaSamples
{
  int x,y,a,b, indexPista, numeroSampleBoxesTotal, inicioQualSample;
  int comprimentoBloco, alturaBloco, espacamentoEntreBlocos;
  int alturaOpen;
  ScrollableList sl;
  
  PistaSamples(int tempX, int tempY, int comprimentoBlocoTemp, int alturaBlocoTemp, int indexPistaTemp, int numeroSampleBoxesTotalTemp, int inicioQualSampleTemp)
  {
    x=tempX;
    y=tempY;
    comprimentoBloco=comprimentoBlocoTemp;
    alturaBloco=alturaBlocoTemp;
    numeroSampleBoxesTotal=numeroSampleBoxesTotalTemp;
    inicioQualSample=inicioQualSampleTemp;
    alturaOpen=20;
    espacamentoEntreBlocos=100;
    indexPista=indexPistaTemp;
    for (int i=0; i<numeroSampleBoxesTotal; i++)
    {
      nomesSons.append("Som" + " " + ((i+inicioQualSample)+1));
    }

    sl =cp5.addScrollableList("Lista Sensores"+ " " + (indexPista))
     .setPosition(15+(indexPista*210),y-15)
     .setSize(200, 200)
     .setBarHeight(30)
     .setItemHeight(30)
     .addItems(listaSensores)
     .setId(indexPista)
     .setFont(fonte)
     .setValue(0)
     .setType(ScrollableList.DROPDOWN)
     .close()
     ;
  }
  
  void tocaPistaSample(int tempA, int tempB)
  {
    for (int i=0; i<numeroSampleBoxesTotal; i++)
    {
      noStroke();
      ////open menu sample box
      fill(0,0,100);
      rect(x,y+alturaOpen+(i*espacamentoEntreBlocos), comprimentoBloco, alturaOpen);
      textSize(12);
      fill(40,200,10);
      text(nomesSons.get(i+4*indexPista), x+5 ,y+alturaOpen+(i*espacamentoEntreBlocos)+13); 
      //sample box 
      fill(100,100,100);
      rect(x,y+alturaOpen+((i*espacamentoEntreBlocos)+alturaOpen), comprimentoBloco, alturaBloco);
      
      //checks if mouse is inside sample box
      if (tempA>=x && tempA<(x+comprimentoBloco) && tempB>=y+alturaOpen+(i*espacamentoEntreBlocos) && tempB<(y+alturaBloco+alturaOpen+(i*espacamentoEntreBlocos)) && !sl.isOpen() && ratoClicado || keyPressed && key==makey[i+4*indexPista])
      {
         tocaSamples[i+inicioQualSample].player.reTrigger();
         //sample box 
         fill(10,200,10);
         rect(x,y+alturaOpen+((i*espacamentoEntreBlocos)+alturaOpen), comprimentoBloco, alturaBloco);
         ratoClicado=false;
         keyPressed=false;
      }
    }
  }
  
  void tocaSamplesQuandoThreshold(int numeroPistas)
  {
    if(ps[numeroPistas].sl.getValue()>0)
    {
       if (thresholdBox[(int) ps[numeroPistas].sl.getValue()-1].thresholdVerde)
       {
         for (int i=0; i<numeroSlides; i++)
         {
            i=i+(4*numeroPistas);
            if(tocaSamples[i].assinalaFimSample())
            {
             int randomSom=(int) random(4);
             tocaSamples[randomSom+inicioQualSample].player.reset();
             tocaSamples[randomSom+inicioQualSample].player.reTrigger();
             //sample box 
             fill(10,200,10);
             rect(x,y+alturaOpen+((randomSom*espacamentoEntreBlocos)+alturaOpen), comprimentoBloco, alturaBloco);
             thresholdBox[numeroPistas].thresholdVerde=false;
            }
         }
       }
     }
   }
}