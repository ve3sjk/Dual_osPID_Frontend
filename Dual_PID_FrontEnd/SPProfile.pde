int pSteps=15;

class Profile
{
  public float times[] = new float[pSteps];
  public float vals[] = new float[pSteps];
  public byte types[] = new byte[pSteps];
  public String errorMsg="";
  public String Name="";
}
Profile pid1_profs[];
int pid1_curProf=-1;

int lastReceiptTime=-1000;
String pid1_profname="";
int pid1_curProfStep=-1;


void pid1_ProfileRunTime()
{

  if (lastReceiptTime+3000<millis())
  {
    for(int i=0;i<6;i++)
    { 
      ((controlP5.Textlabel)controlP5.controller("pid1_profstat"+i)).setValue("");
      ((controlP5.Textlabel)controlP5.controller("dashstat"+i)).setValue("");
      pid1_curProfStep=-1;
          pid1_ProfCmd.setVisible(true);
    pid1_ProfCmdStop.setVisible(false);
    } 

  }
}


void pid1_ReadProfiles(String directory)
{
  //get all text files in the directory 
  String[] files = listFileNames(directory);
  pid1_profs = new Profile[files.length];
  for(int i=0;i<files.length;i++)
  {
    pid1_profs[i] = CreateProfile(directory+ File.separator +files[i]); 
  }
  if(pid1_profs.length>0)pid1_curProf=0;
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } 
  else {
    // If it's not a directory
    return null;
  }
}


Profile CreateProfile(String filename)
{
  BufferedReader reader = createReader(filename);
  String ln=null;
  int count=0;
  Profile ret = new Profile();
  while (count==0 || (ln!=null && count-1<pSteps))
  {
    try {
      ln = reader.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace();
      ln = null;
    }
    if (ln != null) {
      //pull the commands from this line.  if there's an error, record and leave
      try
      {
        int ind = ln.indexOf("//");
        if(ind>0) ln = trim(ln.substring(0,ind));
        
        if(count==0) ret.Name = (ln.length()<7)? ln : ln.substring(0,7);
        else
        {

          String s[] = split(ln, ','); 
          byte t = (byte)int(trim(s[0]));
          float v = float(trim(s[1]));
          float time = float(trim(s[2]));
          //int time = int(trim(s[2]));
          ret.types[count-1] = t;
          ret.vals[count-1] = v;
          ret.times[count-1] = time;
          if(time<0)ret.errorMsg = "Time cannot be negative";
          else if(t==2 && v<0)ret.errorMsg = "Wait Band cannot be negative";
          else if(t<0 || (t>3 && t!=127))
          {
            ret.errorMsg = "Unrecognized step type";
          }
    
          if(ret.errorMsg!="") ret.errorMsg = "Error on line "+ (count+1)+". "+ret.errorMsg;
        }
      }
      catch(Exception ex)
      {
        if(ret.times[count]<0)ret.errorMsg = "Error on line "+ (count+1)+ ". "+ex.getMessage();      
      }
      println(ret.errorMsg);
      if(ret.errorMsg!="") return ret;
    }
    count++;
  } 
  return ret;
}


void DrawProfile(Profile pid1_p, float x, float y, float w, float h)
{
  //if(p==null)return; 
  float step = w/(float)pSteps;
textFont(AxisFont);
  //scan for the minimum and maximum
  float minimum = 100000000,maximum=-10000000;
  for(int i=0;i<pSteps;i++)
  {
    byte t = pid1_p.types[i];
    if(t==1 || t== 3)
    {
      float v = pid1_p.vals[i];
      if(v<minimum)minimum=v;
      if(v>maximum)maximum=v;
    }
  }
  if (minimum==maximum)
  {
    minimum-=1;
    maximum+=1;
  }

  float bottom = y + h;
  
  strokeWeight(4);
  float lasty = bottom-h/2;
  for(int i=0;i<pSteps;i++)
  {

    if(i==pid1_curProfStep && (millis() % 2000<1000))stroke(255,0,0);
    else stroke(255);
    
    byte t = pid1_p.types[i];
    float v = bottom - (pid1_p.vals[i]-minimum)/(maximum-minimum) * h;
    float x1 = x+step*(float)i;
    float x2 = x+step*(float)(i+1);
    if(t==1)//Ramp
    {
      line(x1,lasty, x2,v);
      text(pid1_p.vals[i],x2,v-4);
      lasty=v;
    }
    else if(t==2)//Wait
    {    
      strokeWeight(8);
      line(x1,lasty, x2,lasty);        
      strokeWeight(4);
    }
    else if(t==3)//Step
    {
      line(x1,lasty, x1,v);
      line(x1,v, x2,v);
      lasty=v;
      text(pid1_p.vals[i],x1,lasty-4);
    }
    else if(t==127)//Buzz
    {
      line(x1,lasty, x2,lasty);
    }
    else if(t==0)
    {
      //if 0 do nothing
    }
    else
    { //unrecognized, this is a problem
      break;
    }
  }

  fill(0);
   
  rotate(-90*PI/180);
  float lastv = 999;
  for(int i=0;i<pSteps; i++)
  {
    byte t = pid1_p.types[i];
    float v = pid1_p.vals[i];
    String s1="",s2="", s3="";

    if(t==0)//end
    {
break;
    }
    if(t==1)//Ramp
    {
      s1 = "Ramp SP to " + v; 
      s2 = "Over " + pid1_p.times[i] + " Sec";
    }
    else if (t==2 && v==0) //Wait cross
    {
      s1 = "Wait until Input"; 
      s2 = "Crosses " + lastv;
    }
    else if(t==2)
    {
      s1 = "Wait until Input is"; 
      s2="Within "+v+ " of " + lastv;
      s3= "for "+pid1_p.times[i] +" Sec";
    }
    else if(t==3)
    {
      s1 = "Step SP to "+ v +" then"; 
      s2="wait " + pid1_p.times[i] + " Sec";
    }
    else if(t==127)
    {
      s1 = "Buzz for " + pid1_p.times[i] + " Sec"; 
    }
    else
    { //unrecognized
      break;
    }

    if(s1!="")
    {
      text(s1, -(outputTop+outputHeight-30), x+i*step+10);
      text(s2, -(outputTop+outputHeight-30), x+i*step+20);
      text(s3, -(outputTop+outputHeight-30), x+i*step+30);
    }
    lastv = v;
  }

  rotate(90*PI/180);

  textFont(pid1_ProfileFont);
  for(int i=0;i<pSteps; i++)
  {
    byte t = pid1_p.types[i];
    if(t==0)//end
    {
      break;
    }
    text(i, x+i*step+5, outputTop+outputHeight);
  }


  if(pid1_p.errorMsg!="")
  {

    fill(255,0,0);
    text(pid1_p.errorMsg, ioLeft, inputTop);
    fill(0);

  }
  strokeWeight(1);
}








