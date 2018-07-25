class FichaDescritiva
{
  int numeroDescritores= 7;
  Textfield [] entrada = new Textfield[numeroDescritores];
  Textarea adicionalComentarios;
  StringList descritores = new StringList();
  String infoEspaco;

  FichaDescritiva (int xTemp, int yTemp, int comprimentoXTemp, int alturaYTemp)
  {
    descritores.append("Nome de baptismo");
    descritores.append("Altura");
    descritores.append("Cores");
    descritores.append("Forma das folhas");
    descritores.append("Características");
    descritores.append("Nome Científico da Planta");
    descritores.append("Histórias da minha planta...");

    for (int i=0; i<numeroDescritores; i++)
    {
      if (i<3)
      {
        entrada[i]= cp5.addTextfield(descritores.get(i))
          .setPosition(xTemp+130, yTemp+(55*i))
          .setSize(comprimentoXTemp-130, 20)
          .setFont(fonte)
          .setFocus(false)
          .setAutoClear(false)
          ;
        cp5.getController(descritores.get(i)).getCaptionLabel().setFont(fonteP5).setSize(11).setColor(0);
      }
      if (i>=3 && i<6)
      {
        entrada[i]= cp5.addTextfield(descritores.get(i))
          .setPosition(xTemp, yTemp+(55*i))
          .setSize(comprimentoXTemp, 20)
          .setFont(fonte)
          .setFocus(false)
          .setAutoClear(false)
          ;
        cp5.getController(descritores.get(i)).getCaptionLabel().setFont(fonteP5).setSize(12).setColor(0);
      }
      if (i==6)
      {
        adicionalComentarios=cp5.addTextarea("espaco"+i)
          .setPosition(xTemp, yTemp+(55*i))
          .setLineHeight(14)
          .setColorForeground(color(100, 200))
          .setSize(comprimentoXTemp, alturaYTemp)
          .setFont(fonte)
          .setColor(color(0))
          .setColorBackground(color(233, 100))
          ;
        adicionalComentarios.setText(descritores.get(i));
        infoEspaco=descritores.get(i);
      }
    }
  }
}

void keyPressed()
{
  //code to write text in the description of the plant
  if (areaSelecionada)
  {    
    if (keyCode==BACKSPACE && keyCode!=131 && keyCode!=128 && keyCode!=129 && keyCode!=130)
    {
      if (ficha.infoEspaco.length() > 0)
      {
        ficha.infoEspaco = ficha.infoEspaco.substring(0, ficha.infoEspaco.length()-1);
      }
    } 
    else if (keyCode == DELETE && keyCode!=131 && keyCode!=128 && keyCode!=129 && keyCode!=130)
    {
      ficha.infoEspaco = "";
    } 
    else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode!=131 && keyCode!=128 && keyCode!=129 && keyCode!=130)
    {
      ficha.infoEspaco= ficha.infoEspaco+key;
    } 
    else if (keyCode==131)
    {
      if (keyCode==65)
      {
        ficha.infoEspaco= ficha.infoEspaco+"ã";
      }
    }

    ficha.adicionalComentarios.setText(ficha.infoEspaco);
  }
}

//function to make it green when user if able to write text in the description of the plant
void sabeQueEstaNaZona(int xTemp, int yTemp)
{  
  if (xTemp>=xStartPosFicha && xTemp<xStartPosFicha+comprimentoFicha && yTemp>=yStartPosFicha+(55*6) && yTemp<yStartPosFicha+(55*6)+alturaFicha && ratoClicado)
  {
    ficha.adicionalComentarios.setText(ficha.infoEspaco);
    areaSelecionada=!areaSelecionada;
    ratoClicado=false;
  }
  if (areaSelecionada && xTemp<=xStartPosFicha && ratoClicado)
  {
    areaSelecionada=false;
    ratoClicado=false;
  }
  if (areaSelecionada)
  {
    stroke(0, 200, 10);
    strokeWeight(1);
    line(xStartPosFicha, yStartPosFicha+(55*6), xStartPosFicha+comprimentoFicha, yStartPosFicha+(55*6));
    line(xStartPosFicha, yStartPosFicha+(55*6), xStartPosFicha, yStartPosFicha+(55*6)+alturaFicha);
    line(xStartPosFicha, yStartPosFicha+(55*6)+alturaFicha, xStartPosFicha+comprimentoFicha, yStartPosFicha+(55*6)+alturaFicha);
    line(xStartPosFicha+comprimentoFicha, yStartPosFicha+(55*6)+alturaFicha, xStartPosFicha+comprimentoFicha, yStartPosFicha+(55*6));
    noStroke();
  }
}