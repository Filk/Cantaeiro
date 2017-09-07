class Plantitura
{
  Textfield plantituraSeq;
  boolean playStop;
  int currentPlayingIndex=0;
  int p;
  boolean segue=true;
  
  Plantitura(int xTemp, int yTemp, int comprimentoTemp, int alturaTemp)
  { 
    plantituraSeq= cp5.addTextfield("plantitura")
    .setPosition(xTemp,yTemp)
    .setSize(comprimentoTemp,alturaTemp)
    .setFont(fonte)
    .setFocus(false)
    .setAutoClear(false)
    ;
    cp5.getController("plantitura").getCaptionLabel().setFont(fonteP5).setSize(11).setColor(0);
    
    playStop=false;
  }
  
  void transportPlantitura()
  {
    if (ratoClicado && mouseX>=605 && mouseX <=635 && mouseY>=590 && mouseY <=620 && plantituraPronta)
    {
      playStop=!playStop;
      ratoClicado=false;
      
      if (playStop)
      {
        segue=true;
        currentPlayingIndex=0;
      }
    }
    
    if (!playStop || !plantituraPronta)
    {
      image(play,605,590);
    }
    
    if (playStop && plantituraPronta)
    {
      image(stop,605,590);
      tocaPlantitura();
      //println(setSequencia);
    }
  }
  
  void tocaPlantitura()
  {     
    if (setSequencia.length>0 && setSequencia.length>currentPlayingIndex)
    { 
      if (segue)
      {
        //-1 is to compensate audiofiles start with "0.wav"
        int i=setSequencia[currentPlayingIndex]-1;
        //println(currentPlayingIndex + " " + i);
        tocaSamples[i].player.reset();
        tocaSamples[i].player.reTrigger();
        
         if (i<5)
         {
           p=0;
         }
         else if (i>=5&&i<9)
         {
           p=1;
         }
         else if (i>=9&&i<13)
         {
           p=2;
         }
        //sample box 
        fill(10,200,10);
        rect(ps[p%3].x,ps[p%3].y+ps[p%3].alturaOpen+((p%3*ps[p%3].espacamentoEntreBlocos)+ps[p%3].alturaOpen), ps[p%3].comprimentoBloco, ps[p%3].alturaBloco);
        segue=false;
      }
      
      //-1 is to compensate audiofiles start with "0.wav"
      if(tocaSamples[setSequencia[currentPlayingIndex]-1].assinalaFimSample())
      {
        //println("finalsample" + setSequencia[currentPlayingIndex]);
        currentPlayingIndex=currentPlayingIndex+1;
        //checks to see if plays next
        if (setSequencia.length>currentPlayingIndex)
        {
          segue=true;
        }
        else
        {
          playStop=false;
          plantituraPronta=false;
        }
      }
    }
  }
  
}
  
public void plantitura (String plantituraSeq)
{
  String [] getSequencia = split (plantituraSeq, ",");
  boolean envia=true;
  plantituraPronta=false;
  
  if (getSequencia.length>0)
  {
    int [] sequenciaInt = new int [getSequencia.length];
    
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
          JOptionPane.showMessageDialog(frame, "Ups! Definições plantitura erradas. \n"+" \n"+"Introduzir números entre 1 e 12. \n"+ "ex: 1,4,2,12,9 \n"+ "(terminar sem vírgula)");
          envia=false;
          break outerloop;
        }
    }
    if(envia)
    {
      JOptionPane.showMessageDialog(frame, "Plantitura pronta!");
      plantituraPronta=true;
      setSequencia=sequenciaInt;
    }
  }
  else
  {
    plantituraPronta=false;
  }
}