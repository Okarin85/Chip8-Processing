class Screen{
  byte [][] sprites = new byte [64][32];
  
  void initScreen(){
    for( int i = 0; i < 64; i++){
      for(int j = 0; j < 32; j++){
        sprites[i][j] = 0;
        fill(0);
        rect(i*10, j*10, 10, 10);
      }
    }
  }
}

class Cpu{
  char memory [] = new char [4096];
  char V [] = new char [16];
  int I = 0x0;
  int pc = 0x200;
  short stack [] = new short [16];
  short stackPointer = 0;
  int delayTimer = 0;
  int soundTimer = 0;
  int opcode;
  
  int x;
  int y;
  int nn;
  int nnn;
  int n;
   
  
  //byte keys [] = new byte [16];
  //byte dispaly [] = new byte [64 * 32];
  void loadRom(){
    byte rom[] = loadBytes("MAZE");
    
    for(int i = 0; i < rom.length; i++){
      memory[pc + i] = char(rom[i]);
      //println(hex(memory[pc + i]));
    }
  }
  
  void run(){
    for(int i = 0; i < memory.length - pc; i++){
        opcode = memory[pc] << 8 | memory[pc + 1];
        println("opcode : ", hex(opcode), "nn : ", hex(nn), "v[x] : ", hex(V[x]));
        //println(hex(opcode));
        
        x    = (opcode & 0x0F00) >> 8;
        y    = (opcode & 0x00F0) >> 4;
        nn   =  opcode & 0x00FF;
        nnn =  opcode & 0x0FFF;
        n    =  opcode & 0x000F;
        
        switch(opcode & 0xF000) {
          case 0x1000:
              pc = nnn;
          break;
          
          case 0x3000:
          //println("opcode : 0x3000");
            if(V[x] == nn){
              pc+= 2;
              //println("nn : ", hex(nn));
              //println("v[x] : ", hex(V[x]));
              //println("Skipped next instruction, pc : ", hex(pc));
            }
            else{
              //println(nn);
              println("Didn't skipped next instruction, pc : ", hex(pc));
            }
            pc+= 2;
          break;
          
          case 0x7000:
          //println("opcode : 0x7000");
              V[x] = char((V[x] += nn) & 0xFF);
              //println("Add nn to V[x] : ", hex(V[x]));
              //println("nn : ", hex(nn), "v[x] : ", hex(V[x]));
              pc+= 2;
          break;
            
          case 0xA000:
              I = nnn;
              //println("I : ", hex(I));
              pc+= 2;
          break;
          
          case 0xC000:
              int randomNumber = int(random(255)) & nn;
              V[x] = char(randomNumber);
              //println(randomNumber);
              //println(hex(nn));
              pc+= 2;
          break;
          
          case 0xD000:
              for(int _i = 0; _i < n; _i++){
                int line = memory[I + _i];
                for(int j = 0; j < 8; j++){
                  int pixel = line & (0x80 >> j);
                  if(pixel != 0){
                    fill(255);
                    rect((V[x] + j) * 10, (V[y] + _i) * 10, 10, 10);
                  }
                }
              }
              pc+= 2;
          break;
                                                          
          default:
              //println("Can't execute : ", hex(opcode));
              pc+= 2;
          break;
         }
      }
  }
}


void setup(){
  size(640, 320);
  noStroke();
  Screen display = new Screen();
  display.initScreen();
  Cpu chip8 = new Cpu();
  chip8.loadRom();
  chip8.run();
}

void draw(){

}