import java.nio.ByteBuffer;
import processing.serial.*;
import controlP5.*;

/***********************************************
 * User spcification section
 **********************************************/
int windowWidth = 1500;      // set the size of the 
int windowHeight = 900;     // form

float pid1_InScaleMin = 0;       // set the Y-Axis Min
float pid1_InScaleMax = 300;    // and Max for both
float pid1_OutScaleMin = 0;      // the top and 
float pid1_OutScaleMax = 300;    // bottom trends


int windowSpan = 300000;    // number of mS into the past you want to display
int refreshRate = 100;      // how often you want the graph to be reDrawn;

//float displayFactor = 1; //display Time as Milliseconds
//float displayFactor = 1000; //display Time as Seconds
float displayFactor = 60000; //display Time as Minutes

String outputFileName = "dualpidtest.txt"; // if you'd like to output data to 
// a file, specify the path here

/***********************************************
 * end user spec
 **********************************************/

int nextRefresh;
int arrayLength = windowSpan / refreshRate+1;
float[] pid1_InputData = new float[arrayLength];     //we might not need them this big, but
float[] pid1_SetpointData = new float[arrayLength];  // this is worst case
float[] pid1_OutputData = new float[arrayLength];

float[] pid2_InputData = new float[arrayLength];     //we might not need them this big, but
float[] pid2_setpointdata = new float[arrayLength];  // this is worst case
float[] pid2_OutputData = new float[arrayLength];


int startTime;

float inputTop = 25;
float inputHeight = (windowHeight-70)*2/3;
float outputTop = inputHeight+50;
float outputHeight = (windowHeight-70)*1/3;

float ioLeft = 180, ioWidth = windowWidth-ioLeft-50;
float ioRight = ioLeft+ioWidth;
float pointWidth= (ioWidth)/float(arrayLength-1);

int vertCount = 10;
int nPoints = 0;
float pid1_Input, pid1_Setpoint, pid1_Output;
float pid2_Input, pid2_Setpoint, pid2_Output;

boolean madeContact =false;

Serial myPort;

ControlP5 controlP5;
controlP5.Button pid1_AMButton, pid2_AMButton, pid1_DRButton, pid2_DRButton, pid1_ATButton, pid2_ATButton, ConnectButton, DisconnectButton, ProfButton, ProfCmd, ProfCmdStop;
controlP5.Textlabel pid1_AMLabel, pid2_AMLabel, pid1_AMCurrent, pid2_AMCurrent, pid1_INLabel, pid2_INLabel, pid1_OutLabel, pid2_OutLabel, pid1_SPLabel, pid2_SPLabel, pid1_PLabel, pid2_PLabel, pid1_ILabel, pid2_ILabel, pid1_DLabel, pid2_DLabel, pid1_DRLabel, pid2_DRLabel, pid1_DRCurrent, pid2_DRCurrent, pid1_ATLabel, pid2_ATLabel, pid1_oSLabel, pid2_oSLabel, pid1_InLabel, pid2_InLabel, pid1_ATCurrent, pid2_ATCurrent, Connecting, pid1_nLabel, pid2_nLabel, pid1_lbLabel, pid2_lbLabel, profSelLabel, commconfigLabel1, commconfigLabel2;
RadioButton r1,r2,r3; 
ListBox LBPref;
String[] CommPorts;
String[] prefs;
float[] prefVals;
controlP5.Textfield pid1_SPField, pid2_SPField, pid1_InField, pid2_InField, pid1_OutField, pid2_OutField, 
pid1_PField, pid2_PField, pid1_IField, pid2_IField, pid1_DField, pid2_DField, pid1_oSField, pid2_oSField, 
pid1_nField, pid2_nField, T0Field, R0Field, BetaField, pid1_lbField, pid2_lbField, oSecField;
String pHold="", iHold="", dHold="";
PrintWriter output;
PFont AxisFont, TitleFont, ProfileFont; 

int dashTop = 200, dashLeft = 10, dashW=160, dashH=380; 
int tuneTop = 100, tuneLeft = 10, tuneW=160, tuneH=380;
int ATTop = 500, ATLeft = 10, ATW=160, ATH=380;
int commTop = 30, commLeft = 10, commW=160, commH=180; 
int configTop = 30, configLeft = 10, configW=160, configH=200;
int RsTop = configTop+2*configH+30, RsLeft = 10, RsW=160, RsH=30;

BufferedReader reader;



void setup()
{
  size(100, 100);
  frameRate(30);
  reader = createReader("prefs.txt");

  //read in preferences
  prefs = new String[] {
    "Form Width", "Form Height", "pid1_Input Scale Minimum","pid1_Input Scale Maximum","pid1_Output Scale Minimum","pid1_Output Scale Maximum", "Time Span (Min)"        };   
  prefVals = new float[] {
    windowWidth, windowHeight, pid1_InScaleMin, pid1_InScaleMax, pid1_OutScaleMin, pid1_OutScaleMax, windowSpan / 1000 / 60        };
////  try
////  {
//    if(reader!=null)
//    {
//      for(int i=0;i<prefVals.length;i++)prefVals[i] = float(reader.readLine());
//    } 
////  }
////  catch(FileNotFoundException  ex)  {    
////    println("here2");   
////  }
////  catch(IOException ex)  {    
////    println("here3");   
////  }
 
  

  PrefsToVals(); //read pref array into global variables

  String curDir = sketchPath;
  ReadProfiles(curDir+ File.separator + "profiles");



  controlP5 = new ControlP5(this);                                  // * Initialize the various

    //initialize UI
  createTabs();
  populateDashTab();
  populateTuneTab();
  populateConfigTab();
  populatePrefTab();
  populateProfileTab();

  AxisFont = loadFont("axis.vlw");
  TitleFont = loadFont("Titles.vlw");
  ProfileFont = loadFont("profilestep.vlw");

  //blank out data fields since we're not connected
  Nullify();
  nextRefresh=millis();
  if (outputFileName!="") output = createWriter(outputFileName);


}

void draw()
{
  ProfileRunTime();

  background(200);

  strokeWeight(1);

  drawButtonArea();
  AdvanceData();
  if(currentTab==5 && curProf>-1)DrawProfile(profs[curProf], ioLeft+4, inputTop, ioWidth-1 , inputHeight);
  else drawGraph();

}


//keeps track of which tab is selected so we know 
//which bounding rectangles to draw
int currentTab=1;
void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) { 
    currentTab = theControlEvent.tab().id();
  }
  else if(theControlEvent.isGroup() && theControlEvent.group().name()=="Available Profiles")
  {// a list item was clicked
    curProf=(int)theControlEvent.group().value();
    profSelLabel.setValue(profs[curProf].Name);
  }
}

//puts preference array into the correct fields
void PopulatePrefVals()
{
  for(int i=0;i<prefs.length;i++)controlP5.controller(prefs[i]).setValueLabel(prefVals[i]+""); 
}

//translates the preferebce array in the corresponding local variables
//and makes any required UI changes
void PrefsToVals()
{
  windowWidth = int(prefVals[0]);
  windowHeight = int(prefVals[1]);
  pid1_InScaleMin = prefVals[2];
  pid1_InScaleMax = prefVals[3];
  pid1_OutScaleMin = prefVals[4];
  pid1_OutScaleMax = prefVals[5];    
  windowSpan = int(prefVals[6] * 1000 * 60);

  inputTop = 25;
  inputHeight = (windowHeight-70)*2/3;
  outputTop = inputHeight+50;
  outputHeight = (windowHeight-70)*1/3;


  ioWidth = windowWidth-ioLeft-50;
  ioRight = ioLeft+ioWidth;

  arrayLength = windowSpan / refreshRate+1;
  
  pid1_InputData = (float[])resizeArray(pid1_InputData,arrayLength);
  pid1_SetpointData = (float[])resizeArray(pid1_SetpointData,arrayLength);
  pid1_OutputData = (float[])resizeArray(pid1_OutputData,arrayLength); 



  pointWidth= (ioWidth)/float(arrayLength-1);
  resizer(windowWidth, windowHeight);
}


private static Object resizeArray (Object oldArray, int newSize) {
  int oldSize = java.lang.reflect.Array.getLength(oldArray);
  Class elementType = oldArray.getClass().getComponentType();
  Object newArray = java.lang.reflect.Array.newInstance(
  elementType,newSize);
  int preserveLength = Math.min(oldSize,newSize);
  if (preserveLength > 0)
    System.arraycopy (oldArray,0,newArray,0,preserveLength);
  return newArray; 
}

//resizes the form
void resizer(int w, int h)
{
  size(w,h);
  frame.setSize(w,h+25);
}

void Save_Preferences()
{
  for(int i=0;i<prefs.length;i++)
  {
    try
    {
      prefVals[i] = float(controlP5.controller(prefs[i]).valueLabel().getText()); 
    }
    catch(Exception ex){
    }
  }
  PrefsToVals();
  PopulatePrefVals(); //in case there was an error we want to put the good values back in

  PrintWriter output;
  try
  {
    output = createWriter("prefs.txt");
    for(int i=0;i<prefVals.length;i++) output.println(prefVals[i]);
    output.flush();
    output.close();
  }
  catch(Exception ex){
  }
}

//puts a "---" into all live fields when we're not connected
boolean dashNull=false, tuneNull=false;
void Nullify()
{

  String[] names = {
    "pid1_AM", "pid1_Setpoint", "pid1_Input", "pid1_Output", "pid1_AMCurrent", "pid1_SP", "pid1_In", "pid1_Out", "pid1_Kp",
    "pid1_Ki","pid1_Kd","pid1_DR","pid1_P","pid1_I","pid1_D","pid1_DRCurrent",
    "pid1_NB","pid1_ATune","pid1_OS","pid1_noise","pid1_ATuneCurrent","pid1_LB","pid1_lback"  }; //,"  "," ","","pid1_Output Step","   ",
  for(int i=0;i<names.length;i++)controlP5.controller(names[i]).setValueLabel("---");
  
  String[] names2 = {
    "pid2_AM", "pid2_Setpoint", "pid1_Input", "pid2_Output", "pid2_AMCurrent", "pid2_SP", "pid2_In", "pid2_Out", "pid2_Kp",
    "pid2_Ki","pid2_Kd","pid2_DR","pid2_P","pid2_I","pid2_D","pid2_DRCurrent",
    "pid2_NB","pid2_ATune","pid2_OS","pid2_noise","pid2_ATuneCurrent","pid2_LB","pid2_lback"  }; //,"  "," ","","pid2_Output Step","   ",
  for(int i=0;i<names2.length;i++)controlP5.controller(names2[i]).setValueLabel("---");
  
  
  dashNull=true;tuneNull=true;
}

//draws bounding rectangles based on the selected tab
void drawButtonArea()
{

  stroke(0);
  fill(100);
  rect(0, 0, ioLeft, windowHeight);
  if(currentTab==1) //dash
  {
    rect(commLeft-5, commTop-5, commW+10, commH+10);
    fill(100,220,100);
    rect(dashLeft-5, dashTop-5, dashW+10, dashH+10);
    
    fill(140);
    rect(configLeft-5, configTop+485, configW+10, 82);
    rect(configLeft+5, configTop+479, 35, 12);

  }
  else if(currentTab==2) //tune
  {
    fill(140);
    rect(tuneLeft-5, tuneTop-5, tuneW+10, tuneH+10);
    fill(120);
    rect(ATLeft-5, ATTop-5, ATW+10, ATH+10);
  }
  else if(currentTab==3) //config
  {
    fill(140);
    if(madeContact)
    {
    rect(configLeft-5, configTop-5, configW+10, configH+10);
    rect(configLeft-5, configTop+configH+10, configW+10, configH+10);
    }
    else rect(configLeft-5, configTop-5, configW+10, 2*configH+20);

  }
  else if(currentTab==5) //profile
  {
      fill(140);
    rect(configLeft-5, configTop+485, configW+10, 82);
    rect(configLeft+5, configTop+479, 35, 12);
    
  }

}

void pid1_T_AM() {
  if(pid1_AMLabel.valueLabel().getText()=="Manual") 
  {
    pid1_AMLabel.setValue("Automatic");
  }
  else
  {
    pid1_AMLabel.setValue("Manual");   
  }
}

void pid2_T_AM() {
  if(pid2_AMLabel.valueLabel().getText()=="Manual") 
  {
    pid2_AMLabel.setValue("Automatic");
  }
  else
  {
    pid2_AMLabel.setValue("Manual");   
  }
}

void pid1_T_DR() {
  if(pid1_DRLabel.valueLabel().getText()=="Direct") 
  {
    pid1_DRLabel.setValue("Reverse");
  }
  else
  {
    pid1_DRLabel.setValue("Direct");   
  }
}

void pid2_T_DR() {
  if(pid2_DRLabel.valueLabel().getText()=="Direct") 
  {
    pid2_DRLabel.setValue("Reverse");
  }
  else
  {
    pid2_DRLabel.setValue("Direct");   
  }
}

void pid1_ATune_CMD() {
  if(pid1_ATLabel.valueLabel().getText()=="OFF") 
  {
    pid1_ATLabel.setValue("ON");
  }
  else
  {
    pid1_ATLabel.setValue("OFF");   
  }
}

void pid2_ATune_CMD() {
  if(pid2_ATLabel.valueLabel().getText()=="OFF") 
  {
    pid2_ATLabel.setValue("ON");
  }
  else
  {
    pid2_ATLabel.setValue("OFF");   
  } 
}













