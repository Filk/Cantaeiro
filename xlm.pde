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
    String nomeProjeto=selection.getName();
    String caminhoGuardar = selection.getPath();
    
    XML xml = loadXML("data/cantaeiroOriginal.xml");
    xml.setName(nomeProjeto);
    //needed to create a file and thus create a folder
    saveXML(xml, caminhoGuardar + "/" + "Cantaeiro" + ".xml");
    
    //process to save info
      if (xml.hasChildren())
      { 
        XML sensorGalvanicoHigh = xml.getChild("sensores").getChild("sensorGalvanicoHigh");
        sensorGalvanicoHigh.setContent(str(sliderThreshold[0].rangeThreshold.getHighValue()));
        
        XML sensorGalvanicoLow = xml.getChild("sensores").getChild("sensorGalvanicoLow");
        sensorGalvanicoLow.setContent(str(sliderThreshold[0].rangeThreshold.getLowValue()));
        
        XML sensorLuzHigh = xml.getChild("sensores").getChild("sensorLuzHigh");
        sensorLuzHigh.setContent(str(sliderThreshold[1].rangeThreshold.getHighValue()));
        
        XML sensorLuzLow = xml.getChild("sensores").getChild("sensorLuzLow");
        sensorLuzLow.setContent(str(sliderThreshold[1].rangeThreshold.getLowValue()));
        
        XML sensorHumidadeHigh = xml.getChild("sensores").getChild("sensorHumidadeHigh");
        sensorHumidadeHigh.setContent(str(sliderThreshold[2].rangeThreshold.getHighValue()));
        
        XML sensorHumidadeLow = xml.getChild("sensores").getChild("sensorHumidadeLow");
        sensorHumidadeLow.setContent(str(sliderThreshold[2].rangeThreshold.getLowValue()));
        
        for (int k=0; k<numeroPistas; k++)
        {
          XML pistasSaveXml = xml.getChild("pistasSensorEscolhido").getChild("pista"+(k+1));
          pistasSaveXml.setContent(str((int)ps[k].sl.getValue()));
        }
        
        XML fichaNome = xml.getChild("ficha").getChild("nome");
        fichaNome.setContent(ficha.entrada[0].getText());
        
        XML fichaAltura = xml.getChild("ficha").getChild("altura");
        fichaAltura.setContent(ficha.entrada[1].getText());
        
        XML fichaCor = xml.getChild("ficha").getChild("cor");
        fichaCor.setContent(ficha.entrada[2].getText());
        
        XML fichaForma = xml.getChild("ficha").getChild("forma");
        fichaForma.setContent(ficha.entrada[3].getText());
        
        XML fichaTamanho = xml.getChild("ficha").getChild("tamanho");
        fichaTamanho.setContent(ficha.entrada[4].getText());
        
        XML fichaCientifico = xml.getChild("ficha").getChild("cientifico");
        fichaCientifico.setContent(ficha.entrada[5].getText());

        XML espaco = xml.getChild("descricao").getChild("espaco");
        espaco.setContent(ficha.adicionalComentarios.getText());
        
      //saves sounds
      for (int i=0; i<numeroSamples; i++)
      {
        //String guarda = caminhoGuardar + System.getProperty("file.separator") + tocaSamples[i].meuSample.getSimpleName();
        String guarda = caminhoGuardar + "/" + tocaSamples[i].meuSample.getSimpleName();
        
        if (tocaSamples[i].novoSom)
        {
          Sample sampleParaGravar;
          sampleParaGravar=tocaSamples[i].meuSample;
          try 
          {
            sampleParaGravar.write(guarda);
            println("foi");
          } 
          catch (Exception e) 
          {
            System.out.println("Couldn't save sound:");
            e.printStackTrace();
          }
          XML novoSom = xml.getChild("samples").getChild("sample"+i);
          novoSom.setContent(tocaSamples[i].meuSample.getSimpleName());
        }
      }
      
      //saves alarm info
      for (int j=0; j<alarme.length; j++)
      {
        XML alarmInfo = xml.getChild("alarme").getChild("alarmePista"+(j+1));
        if(alarme[j].caixaTemporizador.getText()!= " ")
        {
          alarmInfo.setContent(alarme[j].caixaTemporizador.getText());
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
      
      //saves a copy of the image of the plant and the xml info
      if (bonsaiEscolhido!= null)
      {
        bonsaiEscolhido.save(caminhoGuardar + "/" + "minhaPlanta" + ".jpg");
        XML imagemNovaPlanta = xml.getChild("fotografiaPlanta").getChild("caminhoPlanta");
        imagemNovaPlanta.setContent("/minhaPlanta.jpg");
      }
      else
      {
        bonsai.save(caminhoGuardar + "/" + "minhaPlanta" + ".jpg");
        XML imagemNovaPlanta = xml.getChild("fotografiaPlanta").getChild("caminhoPlanta");
        imagemNovaPlanta.setContent("/minhaPlanta.jpg");
      }
            
      saveXML(xml, caminhoGuardar + "/" + "Cantaeiro" + ".xml");
    }
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
      sliderThreshold[0].rangeThreshold.setHighValue(sensorGalvanicoHigh.getFloatContent());
      
      XML sensorGalvanicoLow = infoToLoadXML.getChild("sensores").getChild("sensorGalvanicoLow");
      sliderThreshold[0].rangeThreshold.setLowValue(sensorGalvanicoLow.getFloatContent());
      
      XML sensorLuzHigh = infoToLoadXML.getChild("sensores").getChild("sensorLuzHigh");
      sliderThreshold[1].rangeThreshold.setHighValue(sensorLuzHigh.getFloatContent());
      
      XML sensorLuzLow = infoToLoadXML.getChild("sensores").getChild("sensorLuzLow");
      sliderThreshold[1].rangeThreshold.setLowValue(sensorLuzLow.getFloatContent());
      
      XML sensorHumidadeHigh = infoToLoadXML.getChild("sensores").getChild("sensorHumidadeHigh");
      sliderThreshold[2].rangeThreshold.setHighValue(sensorHumidadeHigh.getFloatContent());
      
      XML sensorHumidadeLow = infoToLoadXML.getChild("sensores").getChild("sensorHumidadeLow");
      sliderThreshold[2].rangeThreshold.setLowValue(sensorHumidadeLow.getFloatContent());
      
      for (int k=0; k<numeroPistas; k++)
      {
        XML pistas = infoToLoadXML.getChild("pistasSensorEscolhido").getChild("pista"+(k+1));
        ps[k].sl.setValue(pistas.getIntContent());
      }
  
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
        XML sampleToLoad = infoToLoadXML.getChild("samples").getChild("sample"+i);
        //println(selection.getParent()+ System.getProperty("file.separator") + sampleToLoad.getContent());
        //loads new sounds if they are different from the original ones
        SampleManager.removeSample(tocaSamples[i].meuSample);
        tocaSamples[i].meuSample=SampleManager.sample(selection.getParent()+ System.getProperty("file.separator") + sampleToLoad.getContent());
        if(tocaSamples[i].meuSample!=null)
        {
          tocaSamples[i].player.setSample(tocaSamples[i].meuSample);
          tocaSamples[i].player.setToEnd();
          tocaSamples[i].novoSom=true;
        }
      }
      
      //loads alarm
      for (int j=0; j<alarme.length; j++)
      {
        String alarmeTemp= "alarmePista"+(j+1);
        XML alarmeTempXML = infoToLoadXML.getChild("alarme").getChild(alarmeTemp);
        alarmeTempXML.getContent();
        if(alarmeTempXML.getContent()!="")
        {
          alarme[j].caixaTemporizador.setValue(alarmeTempXML.getContent());
          alarmeXML[j]=true;
          somAlarmeTocou[j]=false;
          cp5.getController("alarme"+j).setStringValue(alarmeTempXML.getContent());
          alarme[j].caixaTemporizador.submit();
        }
      }
      
      //loads plantitura
      XML plantituraSeq= infoToLoadXML.getChild("plantitura").getChild("sequencia");
      plantitura.plantituraSeq.setValue(plantituraSeq.getContent());
      cp5.getController("plantitura").setStringValue(plantituraSeq.getContent());
      plantituraPronta=true;
      assinalaXML=true;
      plantitura.plantituraSeq.submit();
      
      //loads plant picture
      XML fotografiaPlanta = infoToLoadXML.getChild("fotografiaPlanta").getChild("caminhoPlanta");
      String caminhoLoudar = selection.getParent();
      PImage bonsaiEscolhido= loadImage(caminhoLoudar + fotografiaPlanta.getContent());
      bonsaiEscolhido.resize(123, 128);
      bonsai=bonsaiEscolhido;
    }
    catch(RuntimeException e)
    {
     JOptionPane.showMessageDialog(frame, "p.f. escolher o ficheiro Cantaeiro.xml!");
    }
  }
}