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

//save info, trigger by the ControlP5 event
void fileSelectedGuardar(File selection) 
{  
  if (selection == null) 
  {
    
  } 
  else 
  {
    //process to save info
    String nomeProjeto=selection.getName();
    String caminhoGuardar = selection.getPath();
    XML xml = loadXML("data/cantaeiroOriginal.xml");
    xml.setName(nomeProjeto);
    
    //saves a copy of the image of the plant and the xml info
    if (bonsaiEscolhido!= null)
    {
      bonsaiEscolhido.save(caminhoGuardar + "/" + "minhaPlanta" + ".jpg");
      
      if (xml.hasChildren())
      {
        XML imagemNovaPlanta = xml.getChild("fotografiaPlanta").getChild("caminhoPlanta");
        imagemNovaPlanta.setContent("/minhaPlanta.jpg");
      }
    }
    
    //saves the plant score to the xml file
    if (plantituraPronta)
    {      
      if (xml.hasChildren())
      {
        XML plantituraNova = xml.getChild("plantitura").getChild("sequencia");
        plantituraNova.setContent(plantituraToSave);
      }
    }
    
    //saves the alarm info to the xml file
    if (plantituraPronta)
    {      
      if (xml.hasChildren())
      {
        XML plantituraNova = xml.getChild("plantitura").getChild("sequencia");
        plantituraNova.setContent(plantituraToSave);
      }
    }
    
    saveXML(xml, caminhoGuardar + "/" + "Cantaeiro" + ".xml");
    //se houver nova fotografia
    //faz cópia da nova fotografia
    //guarda na pasta
    //escreve no xml
    //se houver novos sons
    //faz cópia
    //guarda na pasta
    //escreve no xml
  }
}

//load info, trigger by the ControlP5 event
void fileSelectedAbrir(File selection) 
{ 
  if (selection == null) 
  {
    
  } 
  else
  {
    try
    {
      infoToLoadXML = loadXML(selection.getAbsolutePath());
  
      XML sensorGalvanicoHigh = infoToLoadXML.getChild("sensores").getChild("sensorGalvanicoHigh");
      sliderThreshold[0].rangeThreshold.setHighValue(sensorGalvanicoHigh.getIntContent());
      
      XML sensorGalvanicoLow = infoToLoadXML.getChild("sensores").getChild("sensorGalvanicoLow");
      sliderThreshold[0].rangeThreshold.setLowValue(sensorGalvanicoLow.getIntContent());
      
      XML sensorLuzHigh = infoToLoadXML.getChild("sensores").getChild("sensorLuzHigh");
      sliderThreshold[1].rangeThreshold.setHighValue(sensorLuzHigh.getIntContent());
      
      XML sensorLuzLow = infoToLoadXML.getChild("sensores").getChild("sensorLuzLow");
      sliderThreshold[1].rangeThreshold.setLowValue(sensorLuzLow.getIntContent());
      
      XML sensorHumidadeHigh = infoToLoadXML.getChild("sensores").getChild("sensorHumidadeHigh");
      sliderThreshold[2].rangeThreshold.setHighValue(sensorHumidadeHigh.getIntContent());
      
      XML sensorHumidadeLow = infoToLoadXML.getChild("sensores").getChild("sensorHumidadeLow");
      sliderThreshold[2].rangeThreshold.setLowValue(sensorHumidadeLow.getIntContent());
  
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
      
      //load sounds
      for (int i=0; i<numeroSamples; i++)
      {
        XML sample = infoToLoadXML.getChild("samples").getChild("sample"+i);
        //loads new sounds if they are different from the original ones
        if (sample.getContent()!= "" && !sample.getContent().equals(i+".wav"))
        {
          println("tou aqui");
          SampleManager.removeSample(tocaSamples[i].meuSample);
          tocaSamples[i].meuSample=SampleManager.sample(dataPath(sample.getContent()));
          if(tocaSamples[i].meuSample!=null)
          {
            tocaSamples[i].player.setSample(tocaSamples[i].meuSample);
          }
        }
      }
      
      //loads alarm
      for (int j=0; j<alarme.length; j++)
      {
        String alarmeTemp= "alarmePista"+(j+1);
        XML alarmeTempXML = infoToLoadXML.getChild("alarme").getChild(alarmeTemp);
        alarme[j].caixaTemporizador.setValue(alarmeTempXML.getContent());
        alarmeXML[j]=true;
        somAlarmeTocou[j]=false;
        cp5.getController("alarme"+j).setStringValue(alarmeTempXML.getContent());
        alarme[j].caixaTemporizador.submit();        
      }
      
      //loads plantitura
      XML plantituraSeq= infoToLoadXML.getChild("plantitura").getChild("sequencia");
      plantitura.plantituraSeq.setValue(plantituraSeq.getContent());
      cp5.getController("plantitura").setStringValue(plantituraSeq.getContent());
      plantituraPronta=true;
      assinalaXML=true;
      plantitura.plantituraSeq.submit();
      
      //LOADS
      XML fotografiaPlanta = infoToLoadXML.getChild("fotografiaPlanta").getChild("caminhoPlanta");
      PImage bonsaiEscolhido= loadImage(fotografiaPlanta.getContent());
      bonsaiEscolhido.resize(123, 128);
      bonsai=bonsaiEscolhido;
    }
    catch(RuntimeException e)
    {
     JOptionPane.showMessageDialog(frame, "p.f. escolher o ficheiro Cantaeiro.xml!");
    }
  }
}