class Screen{
  byte [][] sprites = new byte [64][32];
  
  void initScreen(){
    for( int i = 0; i < 64; i++){
      for(int j = 0; j < 32; j++){
        sprites[i][j] = 0;
        rect(i*10, j*10, 10, 10);
      }
    }
  }
}

class Cpu{
  int memory [] = new int [4096];
  int V [] = new int [16];
  int I = 0x0;
  int pc = 0x200;
  int stack [] = new int [16];
  int stackPointer = 0;
  int delayTimer = 0;
  int soundTimer = 0;
   
  
  //byte keys [] = new byte [16];
  //byte dispaly [] = new byte [64 * 32];
  void loadRom(){
    byte rom[] = loadBytes("MAZE");
    
    for(int i = 0; i < rom.length; i++){
      memory[pc + i] = rom[i];
      //println(hex(memory[pc + i]));
    }
  }
  
  void run(){
    for(int i = 0; i < memory.length - pc; i++){
        int opcode = (int)((memory[pc] << 8) | memory[pc + 1]);
        //println(hex(opcode));
        
        int x    = (opcode & 0x0F00) >> 8;
        int y    = (opcode & 0x00F0) >> 4;
        int kk   =  opcode & 0x00FF;
        int nnn =  opcode & 0x0FFF;
        int n    =  opcode & 0x000F;
        
        switch(opcode & 0xF000) {
          case 0x1000:
              pc = nnn;
          break;
          
          case 0x3000:
            if(V[x] == kk){
              pc+= 2;
              println(kk);
              println("Skipped next instruction, pc : ", hex(pc));
            }
            else{
              println(kk);
              println("Didn't skipped next instruction, pc : ", hex(pc));
            }
          break;
          
          case 0x7000:
              V[x] = (V[x] += kk) & 0xFF;
              //println("Add kk to V[x] : ", hex(V[x]));
          break;
            
          case 0xA000:
              I = nnn;
              //println("I : ", hex(I));
          break;
          
          case 0xC000:
              int randomNumber = int(random(255)) & kk;
              V[x] = randomNumber;
              println(randomNumber);
              //println(hex(kk));
          break;
          
          case 0xD000:
              for(int _i = 0; _i < n; _i++){
                int line = memory[I + _i];
                for(int j = 0; j < 8; j++){
                  int pixel = line & (0x80 >> j);
                  if(pixel != 0){
                    fill(0);
                    rect((V[x] + j) * 10, (V[y] + _i) * 10, 10, 10);
                  }
                }
              }
          break;
                                                          
          default:
              //println("Can't execute : ", hex(opcode));
          break;
         }
      pc+= 2;
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