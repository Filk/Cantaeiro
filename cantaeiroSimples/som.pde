class GereSamples
{
  SamplePlayer player;
  Sample meuSample;
  Gain gainObject;
  String pathSample;
  double duracaoFile;
  Pitch meuPitch;
  boolean sampleChegouFim, novoSom;
  
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
    novoSom=false;
    player.setToEnd();
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
