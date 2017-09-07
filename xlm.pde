class LoadInfo
{ 
  LoadInfo()
  {
  }

  void loadXMLInfo()
  {
    alarmeXML0=true;
    alarmeXML1=true;
    alarmeXML2=true;

    XML sensorGalvanico = infoToLoadXML.getChild("sensores").getChild("sensorGalvanico");
    //sliderThresholdEscolhido[0].valorThreshold=(int) map(sensorGalvanico.getIntContent(), 0, 1024, 0 , sliderThresholdEscolhido[0].tamanhoSlider);

    XML sensorLuz = infoToLoadXML.getChild("sensores").getChild("sensorLuz");
    //sliderThresholdEscolhido[1].valorThreshold=(int) map(sensorLuz.getIntContent(), 0, 1024, 0 , sliderThresholdEscolhido[1].tamanhoSlider);

    XML sensorHumidade = infoToLoadXML.getChild("sensores").getChild("sensorHumidade");
    //sliderThresholdEscolhido[2].valorThreshold=(int) map(sensorHumidade.getIntContent(), 0, 1024, 0 , sliderThresholdEscolhido[2].tamanhoSlider);

    XML pista1 = infoToLoadXML.getChild("pistasSensorEscolhido").getChild("pista1");
    ps[0].sl.setValue(pista1.getIntContent());
    XML pista2 = infoToLoadXML.getChild("pistasSensorEscolhido").getChild("pista2");
    ps[1].sl.setValue(pista2.getIntContent());
    XML pista3 = infoToLoadXML.getChild("pistasSensorEscolhido").getChild("pista3");
    ps[2].sl.setValue(pista3.getIntContent());

    XML nome = infoToLoadXML.getChild("ficha").getChild("nome");
    ficha.entrada[0].setText(nome.getContent());

    XML altura = infoToLoadXML.getChild("ficha").getChild("altura");
    ficha.entrada[1].setText(altura.getContent());

    XML cor = infoToLoadXML.getChild("ficha").getChild("cor");
    ficha.entrada[2].setText(cor.getContent());

    XML forma = infoToLoadXML.getChild("ficha").getChild("forma");
    ficha.entrada[3].setText(forma.getContent());

    XML tamanho = infoToLoadXML.getChild("ficha").getChild("tamanho");
    ficha.entrada[4].setText(tamanho.getContent());

    XML cientifico = infoToLoadXML.getChild("ficha").getChild("cientifico");
    ficha.entrada[5].setText(cientifico.getContent());

    XML espaco = infoToLoadXML.getChild("descricao").getChild("espaco");
    ficha.adicionalComentarios.setText(espaco.getContent());
    ficha.infoEspaco=espaco.getContent();

    for (int i=0; i<numeroSamples; i++)
    {
      XML sample = infoToLoadXML.getChild("samples").getChild("sample"+i);
      String loadFile= sample.getContent();
      if (loadFile!= "")
      {
        SampleManager.removeSample(tocaSamples[i].meuSample);
        tocaSamples[i].meuSample=SampleManager.sample(dataPath(sample.getContent()));
        tocaSamples[i].player.setSample(tocaSamples[i].meuSample);
      }
    }

    XML alarmePista1 = infoToLoadXML.getChild("alarme").getChild("alarmePista1");
    alarme[0].caixaTemporizador.setValue(alarmePista1.getContent());
    alarme0(alarmePista1.getContent());
    XML alarmePista2 = infoToLoadXML.getChild("alarme").getChild("alarmePista2");
    XML alarmePista3 = infoToLoadXML.getChild("alarme").getChild("alarmePista3");

    XML plantituraSeq= infoToLoadXML.getChild("plantitura").getChild("sequencia");
    plantitura.plantituraSeq.setValue(plantituraSeq.getContent());
  }
}

class loadSaveXML
{
  Bang guardar, load, fotografia;

  loadSaveXML(int xTemp, int yTemp, int comprimentoTemp, int alturaTemp)
  {
    load= cp5.addBang("abrir")
      .setPosition(xTemp, yTemp)
      .setSize(comprimentoTemp, alturaTemp)
      .setFont(fonte)
      .setLabel("abrir")
      ;

    guardar= cp5.addBang("guardar")
      .setPosition(xTemp+70, yTemp)
      .setSize(comprimentoTemp, alturaTemp)
      .setFont(fonte)
      .setLabel("guardar")
      ;

    fotografia= cp5.addBang("imagem")
      .setPosition(667, 156)
      .setSize(comprimentoTemp-10, alturaTemp-10)
      .setFont(fonte)
      .setLabel("imagem")
      ;

    cp5.getController("abrir").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    cp5.getController("abrir").getCaptionLabel().setFont(fonteP5).setSize(10);
    cp5.getController("guardar").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    cp5.getController("guardar").getCaptionLabel().setFont(fonteP5).setSize(10);
    cp5.getController("imagem").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    cp5.getController("imagem").getCaptionLabel().setFont(fonteP5).setSize(8);
  }
}

public void guardar() 
{
  selectOutput("Guardar o ficheiro Cant(a)eiro:", "fileSelectedGuardar");
}

public void abrir() 
{
  selectInput("Escolhe o ficheiro Cant(a)eiro:", "fileSelectedAbrir");
}

public void imagem() 
{
  selectInput("Escolhe fotografia da planta", "fileSelectedFotografia");
}

void fileSelectedGuardar(File selection) 
{  
  if (selection == null) 
  {
    println("Window was closed or the user hit cancel.");
  } 
  else 
  {
    String nomeProjeto=selection.getName();

    if (selection != null)
    {
      String caminhoGuardar = selection.getPath();
      XML xml = loadXML("data/cantaeiroOriginal.xml");
      xml.setName(nomeProjeto);
      saveXML(xml, caminhoGuardar + "/" + "Cantaeiro" + ".xml");
    }
  }
}

void fileSelectedAbrir(File selection) 
{ 
  if (selection == null) 
  {
    
  } 
  else
  {
    infoToLoadXML = loadXML(selection.getAbsolutePath());

    alarmeXML0=true;
    alarmeXML1=true;
    alarmeXML2=true;

    XML sensorGalvanico = infoToLoadXML.getChild("sensores").getChild("sensorGalvanico");
    //sliderThresholdEscolhido[0].valorThreshold=(int) map(sensorGalvanico.getIntContent(), 0, 1024, 0 , sliderThresholdEscolhido[0].tamanhoSlider);

    XML sensorLuz = infoToLoadXML.getChild("sensores").getChild("sensorLuz");
    //sliderThresholdEscolhido[1].valorThreshold=(int) map(sensorLuz.getIntContent(), 0, 1024, 0 , sliderThresholdEscolhido[1].tamanhoSlider);

    XML sensorHumidade = infoToLoadXML.getChild("sensores").getChild("sensorHumidade");
    //sliderThresholdEscolhido[2].valorThreshold=(int) map(sensorHumidade.getIntContent(), 0, 1024, 0 , sliderThresholdEscolhido[2].tamanhoSlider);

    XML pista1 = infoToLoadXML.getChild("pistasSensorEscolhido").getChild("pista1");
    ps[0].sl.setValue(pista1.getIntContent());
    XML pista2 = infoToLoadXML.getChild("pistasSensorEscolhido").getChild("pista2");
    ps[1].sl.setValue(pista2.getIntContent());
    XML pista3 = infoToLoadXML.getChild("pistasSensorEscolhido").getChild("pista3");
    ps[2].sl.setValue(pista3.getIntContent());

    XML nome = infoToLoadXML.getChild("ficha").getChild("nome");
    ficha.entrada[0].setText(nome.getContent());

    XML altura = infoToLoadXML.getChild("ficha").getChild("altura");
    ficha.entrada[1].setText(altura.getContent());

    XML cor = infoToLoadXML.getChild("ficha").getChild("cor");
    ficha.entrada[2].setText(cor.getContent());

    XML forma = infoToLoadXML.getChild("ficha").getChild("forma");
    ficha.entrada[3].setText(forma.getContent());

    XML tamanho = infoToLoadXML.getChild("ficha").getChild("tamanho");
    ficha.entrada[4].setText(tamanho.getContent());

    XML cientifico = infoToLoadXML.getChild("ficha").getChild("cientifico");
    ficha.entrada[5].setText(cientifico.getContent());

    XML espaco = infoToLoadXML.getChild("descricao").getChild("espaco");
    ficha.adicionalComentarios.setText(espaco.getContent());
    ficha.infoEspaco=espaco.getContent();

    for (int i=0; i<numeroSamples; i++)
    {
      XML sample = infoToLoadXML.getChild("samples").getChild("sample"+i);
      String loadFile= sample.getContent();
      if (loadFile!= "")
      {
        SampleManager.removeSample(tocaSamples[i].meuSample);
        tocaSamples[i].meuSample=SampleManager.sample(dataPath(sample.getContent()));
        tocaSamples[i].player.setSample(tocaSamples[i].meuSample);
      }
    }

    XML alarmePista1 = infoToLoadXML.getChild("alarme").getChild("alarmePista1");
    alarme[0].caixaTemporizador.setValue(alarmePista1.getContent());
    alarme0(alarmePista1.getContent());
    XML alarmePista2 = infoToLoadXML.getChild("alarme").getChild("alarmePista2");
    alarme[1].caixaTemporizador.setValue(alarmePista2.getContent());
    alarme1(alarmePista2.getContent());
    XML alarmePista3 = infoToLoadXML.getChild("alarme").getChild("alarmePista3");
    alarme[2].caixaTemporizador.setValue(alarmePista3.getContent());
    alarme2(alarmePista3.getContent());

    XML plantituraSeq= infoToLoadXML.getChild("plantitura").getChild("sequencia");
    plantitura.plantituraSeq.setValue(plantituraSeq.getContent());
    
    XML fotografiaPlanta = infoToLoadXML.getChild("fotografiaPlanta").getChild("caminhoPlanta");
    println(fotografiaPlanta);
    //PImage bonsaiEscolhido= loadImage(fotografiaPlanta.getContent());
    //bonsaiEscolhido.resize(123, 128);
    //bonsai=bonsaiEscolhido;
  }
}

void fileSelectedFotografia (File selection) 
{  
  if (selection == null) 
  {
    
  } 
  else
  {
    println(selection.getAbsolutePath());
    PImage bonsaiEscolhido= loadImage(selection.getAbsolutePath());
    bonsaiEscolhido.resize(123, 128);
    bonsai=bonsaiEscolhido;
  }
}