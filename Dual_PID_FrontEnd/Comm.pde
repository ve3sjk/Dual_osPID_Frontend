String LastError="";
void Connect()
{

  if(!madeContact)
  {
    try
    {
      LastError="";
      ConnectButton.setVisible(false);
      Connecting.setVisible(true);
      nPoints=0;
      startTime= millis();
      for(int i=0;i<CommPorts.length;i++)
      {
        if ( r1.getItem(i).getState())
        {
          myPort = new Serial(this, CommPorts[i], 115200); 
          myPort.bufferUntil(10); 
          //immediately send a request for osPID type;
          byte[] typeReq = new byte[]{
            0,0                              };
          myPort.write(typeReq);
          break;
        }
      }
    }
    catch (Exception ex)
    {
      LastError = ex.toString();
      //println(LastError);
      ConnectButton.setVisible(true);
      Connecting.setVisible(false);
      DisconnectButton.setVisible(false);
      commconfigLabel1.setVisible(true);
      commconfigLabel2.setVisible(true);
    } 

  }

}

void Disconnect()
{
  if(madeContact)
  {

    myPort.stop();
    madeContact=false;
    ConnectButton.setVisible(true);
    Connecting.setVisible(false);
    DisconnectButton.setVisible(false);
    commconfigLabel1.setVisible(true);
    commconfigLabel2.setVisible(true);
    Nullify();
  } 
}

// Sending Floating point values to the arduino
// is a huge pain.  if anyone knows an easier
// way please let know.  the way I'm doing it:
// - Take the 6 floats we need to send and
//   put them in a 6 member float array.
// - using the java ByteBuffer class, convert
//   that array to a 24 member byte array
// - send those bytes to the arduino



void Send_Dash()//To_Controller()
{
  float[] toSend = new float[4];
  byte a = (pid1_AMLabel.valueLabel().getText()=="Manual")?(byte)0:(byte)1;
  byte b = (pid2_AMLabel.valueLabel().getText()=="Manual")?(byte)0:(byte)1;
  
  // PID 001
  toSend[0] = float(pid1_SPField.getText());
  toSend[1] = float(pid1_OutField.getText());
  
  // PID 002
  toSend[2] = float(pid2_SPField.getText());
  toSend[3] = float(pid2_OutField.getText());
  

  byte pid1_identifier = 0;
    
  myPort.write(pid1_identifier);
  myPort.write(a);
  myPort.write(b);
  myPort.write(floatArrayToByteArray(toSend));

  
} 

void Send_Tunings()
{
  float[] toSend = new float[6];
  byte a = (pid1_DRLabel.valueLabel().getText()=="Direct")?(byte)0:(byte)1;
  byte b = (pid2_DRLabel.valueLabel().getText()=="Direct")?(byte)0:(byte)1;
  
  toSend[0] = float(pid1_PField.getText());
  toSend[1] = float(pid1_IField.getText());
  toSend[2] = float(pid1_DField.getText());
  
  
  toSend[3] = float(pid2_PField.getText());
  toSend[4] = float(pid2_IField.getText());
  toSend[5] = float(pid2_DField.getText());
  
  
  
  
  byte pid1_identifier = 1;
  myPort.write(pid1_identifier);
  myPort.write(a);
  myPort.write(b);
  myPort.write(floatArrayToByteArray(toSend));
}

void Send_Auto_Tune()
{
  float[] toSend = new float[6];
  
  toSend[0] = float(pid1_oSField.getText());
  toSend[1] = float(pid1_nField.getText());
  toSend[2] = float(pid1_lbField.getText());
  byte a = (pid1_ATLabel.valueLabel().getText()=="OFF")?(byte)0:(byte)1;
  
  toSend[3] = float(pid2_oSField.getText());
  toSend[4] = float(pid2_nField.getText());
  toSend[5] = float(pid2_lbField.getText());
  byte b = (pid2_ATLabel.valueLabel().getText()=="OFF")?(byte)0:(byte)1;
  
  byte pid1_identifier = 2;
  myPort.write(pid1_identifier);
  myPort.write(a);
  myPort.write(b);
  myPort.write(floatArrayToByteArray(toSend));
}

void Send_Configuration()//To_Controller()
{

  float[] toSend = new float[4];
  toSend[0] = float(R0Field.getText());
  toSend[1] = float(BetaField.getText());
  toSend[2] = float(T0Field.getText());
  toSend[3] = float(oSecField.getText());

  byte a =0;
  if(r2.getState(1)==true)a=1;
  else if(r2.getState(2)==true)a=2;

  byte o = r3.getState(0)==true ? (byte)0 : (byte)1;

  byte pid1_identifier = 5;
  myPort.write(pid1_identifier);
  myPort.write(a);
  myPort.write(o);
  myPort.write(floatArrayToByteArray(toSend));
} 
void Run_Profile()
{

  byte pid1_identifier = 6;
  byte a = 1;
  byte b = 1;
  myPort.write(pid1_identifier);
  myPort.write(a);
  myPort.write(b);
}
void Stop_Profile()
{
  byte pid1_identifier = 6;
  byte a = 0;
  byte b = 0;
  myPort.write(pid1_identifier);
  myPort.write(a);
  myPort.write(b);
}

void Send_Profile()
{
  currentxferStep=0;
  byte pid1_identifier=4;
  byte a=15;
  myPort.write(pid1_identifier);
  myPort.write(a);
  myPort.write(currentxferStep);
  SendProfileStep(byte(currentxferStep));
}
int currentxferStep=-1;

void SendProfileStep(byte step)
{
  Profile p = profs[curProf];
  float[] toSend = new float[2];
  toSend[0] = p.vals[step];
  toSend[1] = p.times[step];
  myPort.write(floatArrayToByteArray(toSend));
}

void SendProfileName()
{
  byte pid1_identifier=7;


  byte[] toSend = new byte[9];

  toSend[0] = pid1_identifier;
  toSend[1] = byte(currentxferStep);
  try
  {
    byte[] n = profs[curProf].Name.getBytes();
    int copylen = n.length>7? 7:n.length;
    for(int i=0;i<7;i++) toSend[i+2] = i<copylen? n[i] : 32;

  }
  catch(Exception ex)
  {
    print(ex.toString());
  }
  myPort.write(toSend);
}

void Reset_Factory_Defaults()
{
  Byte pid1_identifier = 3;
  myPort.write(pid1_identifier);
  myPort.write((byte)9);
  myPort.write((byte)8); 
}

byte[] floatArrayToByteArray(float[] input)
{
  int len = 4*input.length;
  int index=0;
  byte[] b = new byte[4];
  byte[] out = new byte[len];
  ByteBuffer buf = ByteBuffer.wrap(b);
  for(int i=0;i<input.length;i++) 
  {
    buf.position(0);
    buf.putFloat(input[i]);
    for(int j=0;j<4;j++) out[j+i*4]=b[3-j];
  }
  return out;
}

byte[] intArrayToByteArray(int[] input)
{
  int len = 4*input.length;
  int index=0;
  byte[] b = new byte[4];
  byte[] out = new byte[len];
  ByteBuffer buf = ByteBuffer.wrap(b);
  for(int i=0;i<input.length;i++) 
  {
    buf.position(0);
    buf.putFloat(input[i]);
    for(int j=0;j<4;j++) out[j+i*4]=b[3-j];
  }
  return out;
}

float unflip(float thisguy)
{
  byte[] b = new byte[4];
  ByteBuffer buf = ByteBuffer.wrap(b);  
  buf.position(0);
  buf.putFloat(thisguy);
  byte temp = b[0]; 
  b[0] = b[3]; 
  b[3] = temp;
  temp = b[1]; 
  b[1] = b[2]; 
  b[2] = temp;
  return buf.getFloat(0);

}

String InputCreateReq="",OutputCreateReq="";
//take the string the arduino sends us and parse it
void serialEvent(Serial myPort)
{
  String read = myPort.readStringUntil(10);
  if(outputFileName!="") output.print(str(millis())+ " "+read);
  String[] s = split(read, " ");
  print(read);

  if(s.length==3 && s[0].equals("Dual"))
  {
    ConnectButton.setVisible(false);
    Connecting.setVisible(false);
    DisconnectButton.setVisible(true);
    commconfigLabel1.setVisible(false);
    commconfigLabel2.setVisible(false);
    madeContact=true;
  }
  if(!madeContact) return;
  if(s.length==16 && s[0].equals("DASH"))
  {

    pid1_Setpoint = float(s[1]);
    pid1_Input = float(s[2]);
    pid1_Output = float(s[3]); 
    
    pid1_SPLabel.setValue(s[1]);           //   where it's needed
    pid1_InLabel.setValue(s[2]);           //
    pid1_OutLabel.setValue(s[3]);
    
    pid1_AMCurrent.setValue(int(s[4]) == 1 ? "Automatic" : "Manual"); 
    
    //if(pid1_SPField.valueLabel().equals("---"))
    if(dashNull || int(trim(s[4]))==1)
    {

      dashNull=false;
      pid1_SPField.setText(s[1]);    //   the arduino,  take the
      pid1_InField.setText(s[2]);    //   current values and put
      pid1_OutField.setText(s[3]);
      pid1_AMLabel.setValue(int(s[4]) == 1 ? "Automatic" : "Manual");   
    }
    
        
    
    pid2_Setpoint = float(s[5]);
    pid2_Input = float(s[6]);
    pid2_Output = float(s[7]); 
    
    
    pid2_SPLabel.setValue(s[5]);           //   where it's needed
    pid2_InLabel.setValue(s[6]);           //
    pid2_OutLabel.setValue(s[7]);  
    pid2_AMCurrent.setValue(int(s[8]) == 1 ? "Automatic" : "Manual");    
    //if(pid2_SPField.valueLabel().equals("---"))
    if(dashNull || int(trim(s[8]))==1)
    {

      dashNull=false;
      pid2_SPField.setText(s[5]);    //   the arduino,  take the
      pid2_InField.setText(s[6]);    //   current values and put
      pid2_OutField.setText(s[7]);
      pid2_AMLabel.setValue(int(s[8]) == 1 ? "Automatic" : "Manual");   
    }
   
    
    
    
  }
  else if(s.length==18 && s[0].equals("TUNE"))
  {
   
    //PID 001
   
    pid1_PLabel.setValue(s[1]);
    pid1_ILabel.setValue(s[2]);
    pid1_DLabel.setValue(s[3]);
    pid1_DRCurrent.setValue(int(s[4]) == 1 ? "Reverse" : "Direct");
    pid1_ATCurrent.setValue(int(s[5])==1? "ATune On" : "ATune Off");
    pid1_oSLabel.setValue(s[11]);
    pid1_nLabel.setValue(s[12]);
    pid1_lbLabel.setValue(trim(s[13]));
    if(tuneNull || int(trim(s[5]))==1)
    {
      tuneNull=false;
      pid1_PField.setText(s[1]);    //   the arduino,  take the
      pid1_IField.setText(s[2]);    //   current values and put
      pid1_DField.setText(s[3]);
      pid1_DRLabel.setValue(int(s[4]) == 1 ? "Reverse" : "Direct");  
      pid1_oSField.setText(s[11]);
      pid1_nField.setText(s[12]);
      pid1_lbField.setValue(s[13]);    
      pid1_ATLabel.setValue(int(s[5])==1? "ON" : "OFF");
    }

   //PID 002

    pid2_PLabel.setValue(s[6]);
    pid2_ILabel.setValue(s[7]);
    pid2_DLabel.setValue(s[8]);
    pid2_DRCurrent.setValue(int(s[9]) == 1 ? "Reverse" : "Direct");
    pid2_ATCurrent.setValue(int(s[10])==1? "ATune On" : "ATune Off");
    pid2_oSLabel.setValue(s[14]);
    pid2_nLabel.setValue(s[15]);
    pid2_lbLabel.setValue(trim(s[16]));
    if(tuneNull || int(trim(s[10]))==1)
    {
      tuneNull=false;
      pid2_PField.setText(s[6]);    //   the arduino,  take the
      pid2_IField.setText(s[7]);    //   current values and put
      pid2_DField.setText(s[8]);
      pid2_DRLabel.setValue(int(s[9]) == 1 ? "Reverse" : "Direct");  
      pid2_oSField.setText(s[14]);
      pid2_nField.setText(s[15]);
      pid2_lbField.setValue(s[16]);    
      pid2_ATLabel.setValue(int(s[10])==1? "ON" : "OFF");
    }



  }
  else if( s.length>3 && s[0].equals("PROF"))
  {
    lastReceiptTime=millis();
    int curType = int(trim(s[2]));
    curProfStep = int(s[1]);
    ProfCmd.setVisible(false);
    ProfCmdStop.setVisible(true);
    String[] msg;
    switch(curType)
    {
    case 1: //ramp
      msg = new String[]{
        "Running Profile", "", "Step="+s[1]+", Ramping Setpoint", float(trim(s[3]))/1000+" Sec remaining"            };
      break;
    case 2: //wait
      float helper = float(trim(s[4]));
      msg = new String[]{
        "Running Profile", "","Step="+s[1]+", Waiting","Distance Away= "+s[3],(helper<0? "Waiting for cross" :("Time in band= "+helper/1000+" Sec" ))            };
      break;
    case 3: //step
      msg = new String[]{
        "Running Profile", "","Step="+s[1]+", Stepped Setpoint"," Waiting for "+ float(trim(s[3]))/1000+" Sec"            };
      break;

    default:
      msg = new String[0];
      break;
    }
    poulateStat(msg);
  }
  else if(trim(s[0]).equals("P_DN"))
  {
    lastReceiptTime = millis()-10000;
    ProfileRunTime();
  }

  if(s.length==5 && s[0].equals("ProfAck"))
  {
    lastReceiptTime=millis();
    String[] profInfo = new String[]{
      "Transferring Profile","Step "+s[1]+" successful"            };
    poulateStat(profInfo);
    currentxferStep = int(s[1])+1;
    if(currentxferStep<pSteps) SendProfileStep(byte(currentxferStep));
    else if(currentxferStep>=pSteps) SendProfileName();

  }
  else if(s[0].equals("ProfDone"))
  {
    lastReceiptTime=millis()+7000;//extra display time
    String[] profInfo = new String[]{
      "Profile Transfer","Profile Sent Successfully"        };
    poulateStat(profInfo);
    currentxferStep=0;
  }
  else if(s[0].equals("ProfError"))
  {
    lastReceiptTime=millis()+7000;//extra display time
    String[] profInfo = new String[]{
      "Profile Transfer","Error Sending Profile"            };
    poulateStat(profInfo);
  }
}

void poulateStat(String[] msg)
{
  for(int i=0;i<6;i++)
  {
    ((controlP5.Textlabel)controlP5.controller("dashstat"+i)).setValue(i<msg.length?msg[i]:"");
    ((controlP5.Textlabel)controlP5.controller("profstat"+i)).setValue(i<msg.length?msg[i]:"");
  }
}



