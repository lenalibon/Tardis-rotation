import processing.serial.Serial;

float s, x, y, z;

PShape tardis;
PImage[] gif;
int currentPic = 0;

Serial port;


void setup()
{  
  size(1000, 800, OPENGL);

  // Load Tardis 
  frameRate(30);
  tardis = loadShape("Doctor_Who_Tardisneu.obj");

  // Set up background 
  gif = new PImage[240];
  for (int t = 1; t <= 240; t++) {
    gif[t-1] = loadImage("Stars/frame" + t + ".png");
  }

  // Get available ports
  String[] availablePorts = Serial.list();
  if (availablePorts == null) {
    println("COM4-Port is not available!");
    exit();
  }

  // Check if com4 is an available port
  boolean com4Available = false;
  for (int i = 0; i < availablePorts.length; i++) {
    if (availablePorts[i].equals("COM4")) 
      com4Available = true;
  }

  if (!com4Available) {
    println("COM4-Port is not available!");
    exit();
  }

  // Try to open the port
  try {
    port = new Serial(this, "COM4", 115200);
    port.bufferUntil('\n');
  }
  catch (RuntimeException ex) {
  }
}

void draw()
{
  // Change the background to the next frame
  background(gif[currentPic]);
  currentPic++;

  if (currentPic > 239) {
    currentPic = 0;
  }

  // Move tardis to the center
  translate(500, 480, 0);

  // Lights
  pointLight(202, 225, 255, 400, 0, 700);
  pointLight(202, 225, 255, -400, 0, 700);
  pointLight(255, 255, 255, 500, 400, -500);


  // Rotate tardis              
  applyMatrix(y*y- z*z + s*s - x*x, 2*(y*z - s*x), 2*(x*y + s*z), 0, 
              2*(y*z + s*x), z*z - y*y - x*x + s*s, 2*(x*z - s*y), 0, 
              2*(x*y - s*z), 2*(x*z + s*y), x*x + s*s - z*z - y*y, 0, 
              0, 0, 0, 1);

  shape(tardis, 0, 0);
}

void serialEvent(Serial p) 
{
  String in = p.readString();
  
  String[] inArray = split(in, " ");
  
  if ((inArray.length > 0) && (inArray[0].equals("Quaternion:"))) {
    // Print quaternion data
    println(in);
    
    // Save quatarnion data
    s = float(inArray[1]);
    x = float(inArray[2]);
    y = float(inArray[3]);
    z = float(inArray[4]);
  } else if ((inArray.length > 0) && (inArray[0].equals("Calibration:"))) {
    // Print calibration information 
    println(in);
  }
}
