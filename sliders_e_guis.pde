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

public void alarme0 (String horaMarcadaTemp)
{
  String horaMarcada;
  int indexAlarme=0;
  
  if(horaMarcadaTemp.matches("\\d{2}:\\d{2}"))
  {
    try
    {
        horaMarcada=horaMarcadaTemp;
        String [] setAlarme = split (horaMarcada, ":");
        horaDefinida[indexAlarme]=parseInt(setAlarme[0]);
        minutoDefinido[indexAlarme]=parseInt(setAlarme[1]);
        if (horaDefinida[indexAlarme]>=0 && horaDefinida[indexAlarme]<24 && minutoDefinido[indexAlarme]>=0 && minutoDefinido[indexAlarme]<60 && !alarmeXML0)
        {
          somAlarmeTocou[indexAlarme]=false;
          JOptionPane.showMessageDialog(frame, "Alarme Pronto!");
        }
        else if (horaDefinida[indexAlarme]>=0 && horaDefinida[indexAlarme]<24 && minutoDefinido[indexAlarme]>=0 && minutoDefinido[indexAlarme]<60 && alarmeXML0)
        {
          somAlarmeTocou[indexAlarme]=false;
          alarmeXML0=false;
        }
        else
        {
          JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme. \n"+"hora(0-23):minutos(0-59)");
        }
    }
    catch(Exception e)
    {
      e.printStackTrace();
      JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme. \n"+"hora(0-23):minutos(0-59)"); 
    }
  }
  else
  {
    JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme. \n"+"hora(0-23):minutos(0-59)");
  }
}

public void alarme1 (String horaMarcadaTemp)
{
  String horaMarcada=horaMarcadaTemp;
  int indexAlarme=1;
  
  if(horaMarcada.matches("\\d{2}:\\d{2}"))
  {
    try
    {
        String [] setAlarme = split (horaMarcada, ":");
        horaDefinida[indexAlarme]=parseInt(setAlarme[0]);
        minutoDefinido[indexAlarme]=parseInt(setAlarme[1]);
        if (horaDefinida[indexAlarme]>=0 && horaDefinida[indexAlarme]<24 && minutoDefinido[indexAlarme]>=0 && minutoDefinido[indexAlarme]<60 && !alarmeXML1)
        {
          somAlarmeTocou[indexAlarme]=false;
          JOptionPane.showMessageDialog(frame, "Alarme Pronto!");
        }
        else if (horaDefinida[indexAlarme]>=0 && horaDefinida[indexAlarme]<24 && minutoDefinido[indexAlarme]>=0 && minutoDefinido[indexAlarme]<60 && alarmeXML1)
        {
          somAlarmeTocou[indexAlarme]=false;
          alarmeXML1=false;
          println("asd");
        }
        else
        {
          JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme1. \n"+"hora(0-23):minutos(0-59)");
        }
    }
    catch(Exception e)
    {
      e.printStackTrace();
      JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme. \n"+"hora(0-23):minutos(0-59)"); 
    }
  }
  else
  {
    JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme. \n"+"hora(0-23):minutos(0-59)");
  }
}

public void alarme2 (String horaMarcadaTemp)
{
  String horaMarcada=horaMarcadaTemp;
  int indexAlarme=2;
  
  if(horaMarcada.matches("\\d{2}:\\d{2}"))
  {
    try
    {
        String [] setAlarme = split (horaMarcada, ":");
        horaDefinida[indexAlarme]=parseInt(setAlarme[0]);
        minutoDefinido[indexAlarme]=parseInt(setAlarme[1]);
        if (horaDefinida[indexAlarme]>=0 && horaDefinida[indexAlarme]<24 && minutoDefinido[indexAlarme]>=0 && minutoDefinido[indexAlarme]<60 && !alarmeXML2)
        {
          somAlarmeTocou[indexAlarme]=false;
          JOptionPane.showMessageDialog(frame, "Alarme Pronto!");
        }
        else if (horaDefinida[indexAlarme]>=0 && horaDefinida[indexAlarme]<24 && minutoDefinido[indexAlarme]>=0 && minutoDefinido[indexAlarme]<60 && alarmeXML2)
        {
          somAlarmeTocou[indexAlarme]=false;
          alarmeXML2=false;
        }
        else
        {
          JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme2. \n"+"hora(0-23):minutos(0-59)");
        }
    }
    catch(Exception e)
    {
      e.printStackTrace();
      JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme22. \n"+"hora(0-23):minutos(0-59)"); 
    }
  }
  else
  {
    JOptionPane.showMessageDialog(frame, "Ups! \n"+"Definições erradas no alarme222. \n"+"hora(0-23):minutos(0-59)");
  }
}


void rangeController0 (int integer)
{
}
void rangeController1 (int integer)
{
}
void rangeController2 (int integer)
{
}

void numberboxValue0 (int integer)
{
}
void numberboxValue1 (int integer)
{
}
void numberboxValue2 (int integer)
{
}