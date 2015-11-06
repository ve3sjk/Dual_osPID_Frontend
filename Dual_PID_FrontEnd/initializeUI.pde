void createTabs()
{
  controlP5.tab("Tab1").activateEvent(true);
  controlP5.tab("Tab1").setId(2);
  controlP5.tab("Tab1").setLabel("Tune");

  // in case you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)
  controlP5.tab("Tab2").activateEvent(true);
  controlP5.tab("Tab2").setId(3);
  controlP5.tab("Tab2").setLabel("Config");

  // in case you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)
  controlP5.tab("Tab3").activateEvent(true);
  controlP5.tab("Tab3").setId(4);
  controlP5.tab("Tab3").setLabel("Prefs");
  
   // in case you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)
  controlP5.tab("Tab4").activateEvent(true);
  controlP5.tab("Tab4").setId(5);
  controlP5.tab("Tab4").setLabel("Profile");

  controlP5.tab("default").activateEvent(true);
  // to rename the label of a tab, use setLabe("..."),
  // the name of the tab will remain as given when initialized.
  controlP5.tab("default").setLabel("Run");
  controlP5.tab("default").setId(1);

}

void populateDashTab()
{

  ConnectButton = controlP5.addButton("Connect",0.0,commLeft,commTop,60,20);
  DisconnectButton = controlP5.addButton("Disconnect",0.0,commLeft,commTop,60, 20);
  Connecting = controlP5.addTextlabel("Connecting","Connecting...",commLeft,commTop+3);

  //RadioButtons for available CommPorts
  r1 = controlP5.addRadioButton("radioButton",commLeft,commTop+27);
  r1.setColorForeground(color(120));
  r1.setColorActive(color(255));
  r1.setColorLabel(color(255));
  r1.setItemsPerRow(1);
  r1.setSpacingColumn(75);

  CommPorts = Serial.list();
  for(int i=0;i<CommPorts.length;i++)
  {
    r1.addItem(CommPorts[i],i); 
  }
  if(CommPorts.length>0) r1.getItem(0).setState(true);
  commH = 27+12*CommPorts.length;
  dashTop = commTop+commH+20;

  DisconnectButton.setVisible(false);
  Connecting.setVisible(false);

  //dasboard

  // PID 001
  pid1_AMButton = controlP5.addButton("pid1_T_AM",0.0,dashLeft,dashTop,60,20);      //
  pid1_AMLabel = controlP5.addTextlabel("pid1_AM","Manual",dashLeft+4,dashTop+22);        //
  pid1_SPField= controlP5.addTextfield("pid1_Setpoint",dashLeft,dashTop+40,60,20);         //   Buttons, Labels, and
  pid1_InField = controlP5.addTextfield("pid1_Input",dashLeft,dashTop+80,60,20);           //   Text Fields we'll be
  pid1_OutField = controlP5.addTextfield("pid1_Output",dashLeft,dashTop+120,60,20);         //   using
  pid1_AMCurrent = controlP5.addTextlabel("pid1_AMCurrent","Manual",dashLeft+70,dashTop+15);   //
  pid1_SPLabel = controlP5.addTextlabel("pid1_SP","3",dashLeft+70,dashTop+43);                  //
  pid1_InLabel = controlP5.addTextlabel("pid1_In","1",dashLeft+70,dashTop+83);                  //
  pid1_OutLabel = controlP5.addTextlabel("pid1_Out","2",dashLeft+70,dashTop+123);                // 
  
  
  // PID 002
  pid2_AMButton = controlP5.addButton("pid2_T_AM",0.0,dashLeft,dashTop+180,60,20);      //
  pid2_AMLabel = controlP5.addTextlabel("pid2_AM","Manual",dashLeft+4,dashTop+202);            //
  pid2_SPField = controlP5.addTextfield("pid2_Setpoint",dashLeft,dashTop+220,60,20);         //   Buttons, Labels, and
  pid2_InField = controlP5.addTextfield("pid2_Input",dashLeft,dashTop+260,60,20);           //   Text Fields we'll be
  pid2_OutField = controlP5.addTextfield("pid2_Output",dashLeft,dashTop+300,60,20);         //   using
  pid2_AMCurrent = controlP5.addTextlabel("pid2_AMCurrent","Manual",dashLeft+70,dashTop+190);   //
  pid2_SPLabel = controlP5.addTextlabel("pid2_SP","3",dashLeft+70,dashTop+223);                  //
  pid2_InLabel = controlP5.addTextlabel("pid2_In","1",dashLeft+70,dashTop+263);                  //
  pid2_OutLabel = controlP5.addTextlabel("pid2_Out","2",dashLeft+70,dashTop+303);                // 
  
  
  controlP5.addButton("Send_Dash",0.0,dashLeft,dashTop+350,160,20);         //
  


  
  
  int dashStatTop = configTop+490;
  for(int i=0;i<12;i++)
  { 
    controlP5.addTextlabel("dashstat"+i, "", configLeft, dashStatTop+12*i+5);
  }
  controlP5.addTextlabel("dashstatus", "Status", configLeft+9, dashStatTop-8);
}

void populateTuneTab()
{
  //tunings
  
  //PID 001
    
  pid1_PField = controlP5.addTextfield("pid1_Kp",tuneLeft,tuneTop,60,20);          //
  pid1_IField = controlP5.addTextfield("pid1_Ki",tuneLeft,tuneTop+40,60,20);          //
  pid1_DField = controlP5.addTextfield("pid1_Kd",tuneLeft,tuneTop+80,60,20);          //
  pid1_DRButton = controlP5.addButton("pid1_T_DR",0.0,tuneLeft,tuneTop+120,60,20);      //
  pid1_DRLabel = controlP5.addTextlabel("pid1_DR","Direct",tuneLeft+2,tuneTop+144);
  pid1_PLabel=controlP5.addTextlabel("pid1_P","4",tuneLeft+70,tuneTop+3);                    //
  pid1_ILabel=controlP5.addTextlabel("pid1_I","5",tuneLeft+70,tuneTop+43);                    //
  pid1_DLabel=controlP5.addTextlabel("pid1_D","6",tuneLeft+70,tuneTop+83);                    //
  pid1_DRCurrent = controlP5.addTextlabel("pid1_DRCurrent","Direct",tuneLeft+70,tuneTop+123);   //
      
  //PID 002
  pid2_PField = controlP5.addTextfield("pid2_Kp",tuneLeft,tuneTop+200,60,20);          //
  pid2_IField = controlP5.addTextfield("pid2_Ki",tuneLeft,tuneTop+240,60,20);          //
  pid2_DField = controlP5.addTextfield("pid2_Kd",tuneLeft,tuneTop+280,60,20);          //
  pid2_DRButton = controlP5.addButton("pid2_T_DR",0.0,tuneLeft,tuneTop+320,60,20);      //
  pid2_DRLabel = controlP5.addTextlabel("pid2_DR","Direct",tuneLeft+2,tuneTop+344);            //
  pid2_PLabel=controlP5.addTextlabel("pid2_P","7",tuneLeft+70,tuneTop+203);                    //
  pid2_ILabel=controlP5.addTextlabel("pid2_I","8",tuneLeft+70,tuneTop+243);                    //
  pid2_DLabel=controlP5.addTextlabel("pid2_D","9",tuneLeft+70,tuneTop+283);                    //
  pid2_DRCurrent = controlP5.addTextlabel("pid2_DRCurrent","Direct",tuneLeft+70,tuneTop+323);   //
  
  
  controlP5.addButton("Send_Tunings",0.0,tuneLeft,tuneTop+360,160,20);         //  

  // PID 001
  pid1_PField.moveTo("Tab1"); 
  pid1_IField.moveTo("Tab1"); 
  pid1_DField.moveTo("Tab1");
  pid1_DRButton.moveTo("Tab1");  
  pid1_DRLabel.moveTo("Tab1"); 
  pid1_PLabel.moveTo("Tab1");
  pid1_ILabel.moveTo("Tab1"); 
  pid1_DLabel.moveTo("Tab1"); 
  pid1_DRCurrent.moveTo("Tab1");
  
  // PID 002
  pid2_PField.moveTo("Tab1"); 
  pid2_IField.moveTo("Tab1"); 
  pid2_DField.moveTo("Tab1");
  pid2_DRButton.moveTo("Tab1");  
  pid2_DRLabel.moveTo("Tab1"); 
  pid2_PLabel.moveTo("Tab1");
  pid2_ILabel.moveTo("Tab1"); 
  pid2_DLabel.moveTo("Tab1"); 
  pid2_DRCurrent.moveTo("Tab1");
  controlP5.controller("Send_Tunings").moveTo("Tab1");



  //Autotune
  
  //PID 001
  pid1_oSField = controlP5.addTextfield("pid1_OS",ATLeft,ATTop,60,20);          //
  pid1_nField = controlP5.addTextfield("pid1_NB",ATLeft,ATTop+40,60,20);          //
  pid1_lbField = controlP5.addTextfield("pid1_LB",ATLeft,ATTop+80,60,20);          //
  pid1_ATButton = controlP5.addButton("pid1_AT_CMD",0.0,ATLeft,ATTop+120,60,20);      //
  pid1_ATLabel = controlP5.addTextlabel("pid1_ATune","OFF",ATLeft+2,ATTop+142);            //

  pid1_oSLabel=controlP5.addTextlabel("pid1_oStep","4",ATLeft+70,ATTop+3);                    //
  pid1_nLabel=controlP5.addTextlabel("pid1_noise","5",ATLeft+70,ATTop+43); 
  pid1_lbLabel=controlP5.addTextlabel("pid1_lback","5",ATLeft+70,ATTop+83);   //
  pid1_ATCurrent = controlP5.addTextlabel("pid1_ATuneCurrent","Start",ATLeft+70,ATTop+123);   //
  
  
  //PID --2
  pid2_oSField = controlP5.addTextfield("pid2_OS",ATLeft,ATTop+180,60,20);          //
  pid2_nField = controlP5.addTextfield("pid2_NB",ATLeft,ATTop+220,60,20);          //
  pid2_lbField = controlP5.addTextfield("pid2_LB",ATLeft,ATTop+260,60,20);          //
  pid2_ATButton = controlP5.addButton("pid2_AT_CMD",0.0,ATLeft,ATTop+300,60,20);      //
  pid2_ATLabel = controlP5.addTextlabel("pid2_ATune","OFF",ATLeft+2,ATTop+324);            //

  pid2_oSLabel=controlP5.addTextlabel("pid2_oStep","7",ATLeft+70,ATTop+183);                    //
  pid2_nLabel=controlP5.addTextlabel("pid2_noise","8",ATLeft+70,ATTop+223); 
  pid2_lbLabel=controlP5.addTextlabel("pid2_lback","9",ATLeft+70,ATTop+263);   //
  pid2_ATCurrent = controlP5.addTextlabel("pid2_ATuneCurrent","Start",ATLeft+70,ATTop+300);   //
  
  
  
  controlP5.addButton("Send_Auto_Tune",0.0,ATLeft,ATTop+350,160,20);         //  

  // PID 001
  pid1_oSField.moveTo("Tab1"); 
  pid1_nField.moveTo("Tab1"); 
  pid1_lbField.moveTo("Tab1");
  pid1_ATButton.moveTo("Tab1");
  pid1_ATLabel.moveTo("Tab1");  
  pid1_oSLabel.moveTo("Tab1"); 
  pid1_nLabel.moveTo("Tab1");
  pid1_lbLabel.moveTo("Tab1");
  pid1_ATCurrent.moveTo("Tab1"); 
  
  // PID 002
  pid2_oSField.moveTo("Tab1"); 
  pid2_nField.moveTo("Tab1"); 
  pid2_lbField.moveTo("Tab1");
  pid2_ATButton.moveTo("Tab1");
  pid2_ATLabel.moveTo("Tab1");  
  pid2_oSLabel.moveTo("Tab1"); 
  pid2_nLabel.moveTo("Tab1");
  pid2_lbLabel.moveTo("Tab1");
  pid2_ATCurrent.moveTo("Tab1"); 
  controlP5.controller("Send_Auto_Tune").moveTo("Tab1"); 
}

void populateConfigTab()
{
  controlP5.addButton("Reset_Factory_Defaults",0.0,RsLeft,RsTop,160,20);         //
  controlP5.controller("Reset_Factory_Defaults").moveTo("Tab2");

commconfigLabel1 = controlP5.addTextlabel("spec6","This area will populate when", configLeft,configTop); 
commconfigLabel2 = controlP5.addTextlabel("spec7","connection is established.", configLeft,configTop+15); 
commconfigLabel1.moveTo("Tab2");
commconfigLabel2.moveTo("Tab2");
}

void populatePrefTab()
{
   //preferences
  for(int i=0;i<prefs.length;i++)
  {
    controlP5.addTextfield(prefs[i],10,30+40*i,60,20);    
    controlP5.controller(prefs[i]).moveTo("Tab3");
  }

  controlP5.addButton("Save_Preferences", 0.0, 10,30+40*prefs.length,160,20);
  controlP5.controller("Save_Preferences").moveTo("Tab3");

  PopulatePrefVals(); 
}

void populateProfileTab(){
 LBPref = controlP5.addListBox("Available Profiles",configLeft,configTop+5,160,120);
 controlP5.addTextlabel("spec4","Currently Displaying: ", configLeft+5,configTop+10+15*profs.length);
 ProfButton = controlP5.addButton("pid1_Send_Profile",0.0,configLeft,configTop+25+15*profs.length,160,20);


 int profStatTop = configTop+490;
  ProfCmd = controlP5.addButton("pid1_Run_Profile",0.0,configLeft,profStatTop-40,160,20);
  ProfCmdStop = controlP5.addButton("pid1_Stop_Profile",0.0,configLeft,profStatTop-40,160,20);
  ProfCmdStop.setVisible(false);
 for(int i=0;i<6;i++)
 { 
   controlP5.addTextlabel("profstat"+i,"", configLeft, profStatTop+12*i+5);
   controlP5.controller("profstat"+i).moveTo("Tab4");
 }
 controlP5.addTextlabel("profstatus", "Status", configLeft+9, profStatTop-8);
   controlP5.controller("profstatus").moveTo("Tab4");
 
 for(int i=0;i<profs.length;i++) LBPref.addItem(profs[i].Name, i);
 profSelLabel  = controlP5.addTextlabel("spec5",profs.length==0? "N/A" : profs[0].Name, configLeft+100,configTop+10+15*profs.length); 
 
 LBPref.moveTo("Tab4");
 profSelLabel.moveTo("Tab4");
  ProfButton.moveTo("Tab4");
  ProfCmd.moveTo("Tab4");
  ProfCmdStop.moveTo("Tab4");
 controlP5.controller("spec4").moveTo("Tab4");
}

//void addToRadioButton(RadioButton theRadioButton, String theName, int theValue ) {
//  Toggle t = theRadioButton.addItem(theName,theValue);
//  t.captionLabel().setColorBackground(color(80));
//  t.captionLabel().style().movePadding(2,0,-1,2);
//  t.captionLabel().style().moveMargin(-2,0,0,-3);
//  t.captionLabel().style().backgroundWidth = 100;
//}

