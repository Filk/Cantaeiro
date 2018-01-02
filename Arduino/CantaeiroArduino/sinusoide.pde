class Sine
{ 
  Gain gSinusoide = new Gain(ac, 1, 0.0);
  Glide freqSinusoide = new Glide(ac, (int)random(300,600));
  WavePlayer wpSinusoide = new WavePlayer(ac, freqSinusoide, Buffer.SINE);  
  Envelope freqEnvSinusoide;
  
  Sine()
  {
    freqEnvSinusoide = new Envelope(ac, 0);
    freqSinusoide.setValue((int)random(300,600));
    gSinusoide.addInput(wpSinusoide);
    ac.out.addInput(gSinusoide);
  }
  
  Bead myTrigger = new Bead() 
  {
     public void messageReceived(Bead message) 
     {
        //System.out.println("I've been triggered!");
        try
        {
          gSinusoide.zeroIns();
        }
        catch (IndexOutOfBoundsException e)
        {
        }
        wpSinusoide.kill();
        freqEnvSinusoide.kill();
        freqSinusoide.kill();
        gSinusoide.kill();
     }
   };
  
  void killStuff(int j)
  {
    if (sinusoide.get(j).gSinusoide.isDeleted())
    {
      sinusoide.remove(j);
    }
  }
  
  Envelope envolvente()
  { 
    freqEnvSinusoide.addSegment(0.2, 10);
    freqEnvSinusoide.addSegment(0.0, 4000, myTrigger);
    return freqEnvSinusoide;
  }
}

class Toqueplanta
{
  Slider abc;
  int x,y, size;
  boolean thresholdToque, stopCrash;
  
  Toqueplanta (int xTemp, int yTemp, int sizeTemp)
  {
      abc = cp5.addSlider("sliderToquePlanta")
       .setBroadcast(false)
       .setPosition(xTemp,yTemp)
       .setSize(180,33)
       .setRange(0,3300)
       .setValue(1500)
       .setHandleSize(10)
       .setBroadcast(true)
       .setColorCaptionLabel(color (4,57,27))
       .setColorForeground(color (14,232,66))
       .setColorBackground(color (125, 159, 53))
       .setColorActive(color (14,232,66))
       ;
       
     cp5.getController("sliderToquePlanta").getCaptionLabel().setFont(fonteP5).setSize(10).setText("threshold");
     cp5.getController("sliderToquePlanta").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     x=xTemp;
     y=yTemp;
     size=sizeTemp;
     stopCrash=true;
  }
  
  void toque()
  {
    noStroke();
    
    if(valorMedidoToque.nb.getValue()<sinusoidePlanta.abc.getValue() && stopCrash)
    {
      fill(0,220,10);
      thresholdToque=true;
      if (stopCrash)
      {
        sinusoide.add(new Sine());
        stopCrash=false;
      }
    }
    else if (valorMedidoToque.nb.getValue()>sinusoidePlanta.abc.getValue())
    {
      fill(220,10,10);
      thresholdToque=false;
      stopCrash=true;
    }
    rect(x+200,y,size,size);
  }

}