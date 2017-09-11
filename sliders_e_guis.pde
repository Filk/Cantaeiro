class MeuSliderEscolheThreshold
{
  Range rangeThreshold;
  
  MeuSliderEscolheThreshold(int xTemp, int yTemp, int indexTemp)
  {
      rangeThreshold = cp5.addRange("rangeController"+indexTemp)
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(xTemp,yTemp)
       .setSize(200,33)
       .setHandleSize(10)
       .setRange(0,1023)
       .setRangeValues(300,400)
       .setDecimalPrecision(0)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorForeground(color(0,21,100))
       .setColorBackground(color(255,40,100))  
       ;
       
     cp5.getController("rangeController"+indexTemp).getCaptionLabel().setFont(fonteP5).setSize(10).setText("âmbito").setColor(255);
     cp5.getController("rangeController"+indexTemp).getValueLabel().setFont(fonteP5).setSize(11);
     cp5.getController("rangeController"+indexTemp).getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  }
}

class MeuNumberMedicao
{
  Numberbox nb;

  MeuNumberMedicao (int tempX, int tempY, int tempIndex)
  {
     nb= cp5.addNumberbox("numberboxValue"+tempIndex)
     .setPosition(tempX,tempY)
     .setSize(70,33)
     .setRange(0,1023)
     .setMultiplier(1) // set the sensitifity of the numberbox
     .setValue((int) random(0,1023))
     .setDecimalPrecision (0)
     .setLock(true)
     ;
     
     cp5.getController("numberboxValue"+tempIndex).getCaptionLabel().setFont(fonteP5).setSize(10).setText("");
     cp5.getController("numberboxValue"+tempIndex).getValueLabel().setFont(fonteP5).setSize(16);
  }
}

class AssinalaThreshold
{
  int x,y,t, index;
  int limiteMax,limiteMin;
  boolean thresholdVerde;
  
  AssinalaThreshold (int tempX, int tempY, int tamanhoTemp, int indexTemp)
  {
    x=tempX;
    y=tempY;
    t=tamanhoTemp;
    index=indexTemp;
  }

  void checkaThreshold(int index)
  {
    noStroke();
    if(valorMedido[index].nb.getValue()<sliderThreshold[index].rangeThreshold.getHighValue() && valorMedido[index].nb.getValue()>sliderThreshold[index].rangeThreshold.getLowValue())
    {
      fill(0,220,10);
      thresholdVerde=true;
    }
    else
    {
      fill(220,10,10);
      thresholdVerde=false;
    }
    rect(x,y,t,t);
  }
}

class TocadorAutomatico
{
  int x,y,comp,alt;
  Textfield caixaTemporizador;
  
  TocadorAutomatico (int xTemp, int yTemp, int compTemp, int altTemp, int indexTemp)
  {
    x=xTemp;
    y=yTemp;
    comp=compTemp;
    alt=altTemp;
    
    caixaTemporizador= cp5.addTextfield("alarme"+indexTemp)
      .setPosition(x+(comp*0.5)-1,y)
      .setSize(round(comp*0.49),round(alt*0.5))
      .setFont(fonte)
      .setFocus(false)
      .setId(indexTemp)
      .setAutoClear(false)
      ;
      
    cp5.getController("alarme"+indexTemp).getCaptionLabel().setFont(fonteP5).setSize(12).setText("alarme");
  }
  
  void gui()
  {
    noStroke();
    fill(40,20,20);
    rect(x+(comp*0.49),y+(alt*0.5),comp*0.5,alt*0.5);
  }
}