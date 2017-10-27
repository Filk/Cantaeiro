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
       .setDecimalPrecision(1)
       .setRange(0,1023)
       .setRangeValues(300,400)
       // after the initialization we turn broadcast back on again
       .setBroadcast(true)
       .setColorCaptionLabel(color (4,57,27))
       .setColorForeground(color (14,232,66))
       .setColorBackground(color (125, 159, 53))
       .setColorActive(color (54, 80, 0))
       ;

     cp5.getController("rangeController"+indexTemp).getCaptionLabel().setFont(fonteP5).setSize(10).setText("âmbito");
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
     .setColorCaptionLabel(color (4,57,27))
     .setColorForeground(color (14,232,66))
     .setColorBackground(color (0,68,0))
     .setColorActive(color (103, 155, 153))
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
      .setPosition(x+(comp*0.45)-1,y)
      .setSize(round(comp*0.4),round(alt*0.45))
      .setFont(fonte)
      .setFocus(false)
      .setId(indexTemp)
      .setAutoClear(false)
      .setColorCaptionLabel(0)
      .setColorForeground(0)
      .setColorBackground(color (213,239,159))
      .setColorActive(color (103, 155, 153))
      ;
      
    cp5.getController("alarme"+indexTemp).getCaptionLabel().setFont(fonteP5).setSize(12).setText("alarme");
  }
}