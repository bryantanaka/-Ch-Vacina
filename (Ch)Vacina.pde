import ddf.minim.*; 

Minim som;
AudioPlayer smash;
AudioPlayer explosao;
AudioPlayer fundo;
//Declarações das variáveis
int timer;               //Tempo total do programa
int resetTimer;          //reseta o tempo
int segundosTemp;        //Segundos temporários (dias)
int minutosTemp;         //Minutos temporários (meses)
int xAleatorio;          //xAleatorio do vírus
int yAleatorio;          //yAleatorio do vírus
int timerTemp = 0;       //Tempo temporário de explosão do vírus
int dificuldade = 0;     //Dificuldade do jogo
int velocidade;          //velocidade de explosão do vírus (Fácil = 5 segundos | Médio = 4 segundos | Difícil - 2 segundos)
int tempoTotal;          //Tempo total durante o play
int tempoInicio;         //Tempo de início do game
int timerInit;           //Init do tempo de explosão
int estado = 0;          //Estado do jogo(Telas | 0 = menu | 1 = jogo | 2 - dificuldade | 3 - tutorial | 4 - tela final)
int xTemp = 0;           //x do efeito da explosão
int yTemp = 0;           //y do efeito da explosão
int indexAlpha = 255;    //Alpha da explosão
int vidas = 5;           //Vidas do jogo

boolean clickCorreto = false; //Clique correto dentro do joog
boolean play = true;          //Jogo rodando
boolean feedCorreto = false;  //Feedback do efeito correto
boolean feedIncorreto = false;//Feedback do efeito incorreto

String segTempEscrito;      //String do tempo (dias)
String minTempEscrito;      //String do tempo (meses)
String tempoEscrito;        //String total do tempo
String msgFinal;            //Mensagem da tela final
String dificuldadeEscrita;  //Escrita da dificuldade

PImage backgroundInicial;   //Background da tela inicial
PImage backgroundJogo;      //Background do jogo (mapa mundi)
PImage virusImage;          //Imagem do vírus
PImage efeito;              //Imagem do efeito (fumaça)
PImage vidasImagem;         //Imagem das seringas de vida

PFont fonteGame48;          //Fonte tamanho 48
PFont fonteGame28;          //Fonte tamanho 28

void setup(){  
  //Setups de sons
  som = new Minim(this);
  smash = som.loadFile("smash.wav");
  explosao = som.loadFile("explosao.wav");
  fundo = som.loadFile("fundo.mp3");
  fundo.setVolume(0.5);
  fundo.loop();
  //Setups imagens
  backgroundInicial = loadImage("(Ch)Vacina.png");
  backgroundJogo = loadImage("Mapa.jpg");
  virusImage = loadImage("virus.png");
  efeito = loadImage("effect.png");
  vidasImagem = loadImage("seringa.png");
  //tamanho da tela
  size(1024,768);
  //setups fontes
  fonteGame48 = createFont("Bad Signal.otf",48);
  fonteGame28 = createFont("Bad Signal.otf",28);
  textFont(fonteGame48);
  background(backgroundInicial);
  
  //Seta os valores iniciais do jogo de acordo com a dificuldade (Início é fácil (0))
  switch (dificuldade) {
    case 0:
      velocidade = 5;
      tempoTotal = 3;
      dificuldadeEscrita = "Fácil";
    break;
    
    case 1:
      velocidade = 4;
      tempoTotal = 4;
      dificuldadeEscrita = "Média";
    break;
    
    case 2:
      velocidade = 2;
      tempoTotal = 5;
      dificuldadeEscrita = "Difícil";
    break;
  }  
  //Seta um valor inicial randomico para iniciar o virus
  xAleatorio = int(random(25,1000));
  yAleatorio = int(random(125,700));
}

void draw(){
  //Interface das telas
  switch (estado) {
    case 0: //Tela Inicial
      textFont(fonteGame48);
      background(backgroundInicial);
      rectMode(CENTER);
      fill(128);
      stroke(0);
      rect(512,500,250,50);
      rect(512,575,250,50);
      rect(512,650,250,50);
      textAlign(CENTER,CENTER);
      fill(0);
      text("Play",512,498);
      text("Dificuldade",512,573);
      text("Tutorial",512,648);
    break;
    
    case 1: //Jogo
      textFont(fonteGame28);
      background(backgroundJogo);
      tempo();
      jogo();
      tint(255,255,255);
      for (int i = 0; i < vidas; i += 1) {
        image(vidasImagem,625 + (i*60),15);
      }
    break;
    
    case 2: //Dificuldade
      textFont(fonteGame48);
      background(backgroundInicial);
      rectMode(CENTER);
      fill(128);
      stroke(0);
      rect(170,650,250,50);
      rect(512,650,250,50);
      rect(852,650,250,50);
      rect(852,750,250,50);
      textAlign(CENTER,CENTER);
      fill(255);
      text("A dificuldade atual é: " + dificuldadeEscrita,512,500);
      fill(0);
      text("Fácil",170,648);
      text("Médio",512,648);
      text("Difícil",852,648);
      text("Voltar",852,748);
    break;
    
    case 3: //Tutorial
      textFont(fonteGame48);
    break;
    
    case 4: //Final
      background(0);
      textAlign(CENTER,CENTER);
      textFont(fonteGame48);
      text(msgFinal,512,384);
      rect(852,750,250,50);
      text("Voltar",852,748);
    break;
  }
}

void tempo(){ //Mecânica do tempo
  timer = millis()/1000 - tempoInicio;
  
  segundosTemp = (timer % 31);
  minutosTemp = (timer / 31);
  
  segTempEscrito = (segundosTemp < 10 ? "0" : "") + (segundosTemp);
  minTempEscrito = (minutosTemp < 10 ? "0" : "") + (minutosTemp);
  
  tempoEscrito = "Tempo de pandemia I " + minTempEscrito + " meses e " + segTempEscrito + " dias.";
  fill(255,255,255);
  textAlign(LEFT,TOP);
  text(tempoEscrito,25,25);
  
  if (minutosTemp >= tempoTotal || vidas == 0) {
    switch (vidas) {
        case 5:
          msgFinal = "Parabéns, você produziu uma vacina \n antes mesmo que houvessem casos graves!!";
        break;
      
        case 4:
          msgFinal = "Parabéns, a vacina salvou mais \n de 85% da população mundial!!";
        break;
      
        case 3:
          msgFinal = "A vacina demorou um pouco mas a grande \n maioria da população sobreviveu à essa pandemia.";
        break;
      
        case 2:
          msgFinal = "Infelizmente a vacina demorou muito para ser \n produzida e apenas 25% da população sobreviveu...";
        break;
      
        case 1:
          msgFinal = "A vacina não foi produzida a tempo e poucas \n pessoas sobreviveram... mas ainda sim existe esperanças...";
        break;  
      
        case 0:
          msgFinal = "Oh não! Infelizmente a vacina não foi \n produzida a tempo de salvar a humanidade...";
        break;
    }
    estado = 4;
  }
  
}

void jogo() { //Mecânica do jogo
 if (timerTemp >= velocidade || clickCorreto) {
    timerTemp = 0;
    timerInit = timer;
    
    xTemp = xAleatorio;
    yTemp = yAleatorio;
    
    indexAlpha = 255;
    
    xAleatorio = int(random(25,1000));
    yAleatorio = int(random(125,680));
    
    if (clickCorreto) {
      feedCorreto = true;
      smash.play();
      smash.rewind();
    } else {
      feedIncorreto = true;
      explosao.play();
      explosao.rewind();
      vidas -= 1;
    }
    
    clickCorreto = false;
 } else {
    timerTemp = timer - timerInit;
 }
 
 if (feedCorreto) {
   tint(0,0,255,indexAlpha);
   image(efeito,xTemp-25,yTemp-25);
 }
 
 if (feedIncorreto) {
   tint(255,0,0,indexAlpha);
   image(efeito,(xTemp-25),(yTemp-25));
 }
 
 if (feedIncorreto || feedCorreto) {
    if (indexAlpha > 0) {
      indexAlpha -= 5;
    } else {
      feedIncorreto = false;
      feedCorreto = false;
      indexAlpha = 255;
    }
 }
  
 tint(50,255,50,255);
 image(virusImage,xAleatorio-25,yAleatorio-25);
}

void mousePressed(){ //Comandos de cliques do botão
  if (mouseButton == LEFT) {
    switch (estado) {
      case 0:
        if (mouseX > (387) && mouseX < (637) && mouseY > (450) && mouseY < (550)) {
          play = true;
          tempoInicio = millis()/1000;
          vidas = 5;
          estado = 1;
        }
        
        if (mouseX > (387) && mouseX < (637) && mouseY > (550) && mouseY < (600)) {
          estado = 2;
        }
        
        if (mouseX > (387) && mouseX < (637) && mouseY > (625) && mouseY < (675)) {
          estado = 3;
        }
      break;
      
      case 1:
      break;
      
      case 2:
        if (mouseX > (45) && mouseX < (295) && mouseY > (625) && mouseY < (675)) {
          dificuldade = 0;
          velocidade = 5;
          tempoTotal = 3;
          dificuldadeEscrita = "Fácil";
        }
        
        if (mouseX > (387) && mouseX < (637) && mouseY > (625) && mouseY < (675)) {
          dificuldade = 1;
          velocidade = 4;
          tempoTotal = 4;
          dificuldadeEscrita = "Média";
        }
        
        if (mouseX > (727) && mouseX < (977) && mouseY > (625) && mouseY < (675)) {
          dificuldade = 2;
          velocidade = 2;
          tempoTotal = 5;
          dificuldadeEscrita = "Difícil";
        }
        
        if (mouseX > (727) && mouseX < (977) && mouseY > (725) && mouseY < (775)) {
          estado = 0;
        }
   
      break;
      
      case 4:
        if (mouseX > (727) && mouseX < (977) && mouseY > (725) && mouseY < (775)) {
          estado = 0;
        }
      break;
      
    }
    
    if (play) {
      if (mouseX > (xAleatorio - 25) && mouseX < (xAleatorio + 25) && mouseY > (yAleatorio - 25) && mouseY < (yAleatorio + 25)) {
        clickCorreto = true;
      }
    }
  }
}
