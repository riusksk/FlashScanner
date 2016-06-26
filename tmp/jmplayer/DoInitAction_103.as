if(!_global.com)
{
   _global.com=new Object();
}
if(!_global.com.jeroenwijering)
{
   _global.com.jeroenwijering=new Object();
}
if(!_global.com.jeroenwijering.feeds)
{
   _global.com.jeroenwijering.feeds=new Object();
}
if(!_global.com.jeroenwijering.feeds.AbstractParser)
{
   register1=function(pre)
   {
      this.setElements();
      this.setMimes();
   };
   com.jeroenwijering.feeds.AbstractParser=function(pre)
   {
      this.setElements();
      this.setMimes();
   };
   register2=register1.prototype;
   register2.setElements=function()
   {
      this.elements=new Object();
   };
   register2.setMimes=function()
   {
      this.mimetypes=new Object();
      this.mimetypes.mp3="mp3";
      this.mimetypes.audio/mpeg="mp3";
      this.mimetypes.flv="flv";
      this.mimetypes.video/x-flv="flv";
      this.mimetypes.jpeg="jpg";
      this.mimetypes.jpg="jpg";
      this.mimetypes.image/jpeg="jpg";
      this.mimetypes.png="png";
      this.mimetypes.image/png="png";
      this.mimetypes.gif="gif";
      this.mimetypes.image/gif="gif";
      this.mimetypes.rtmp="rtmp";
      this.mimetypes.swf="swf";
      this.mimetypes.application/x-shockwave-flash="swf";
      this.mimetypes.rtmp="rtmp";
      this.mimetypes.application/x-fcs="rtmp";
      this.mimetypes.audio/x-m4a="m4a";
      this.mimetypes.video/x-m4v="m4v";
      this.mimetypes.video/H264="mp4";
      this.mimetypes.video/3gpp="3gp";
      this.mimetypes.video/x-3gpp2="3g2";
      this.mimetypes.audio/x-3gpp2="3g2";
   };
   register2.parse=function(xml)
   {
      register3=new Array();
      register1=0;
      while(register1<xml.firstChild.childNodes.length)
      {
            register3.push(xml.firstChild.childNodes[register1].nodeName);
            register1=register1+1;
      }
      return register3;
   };
   register2.rfc2Date=function(dat)
   {
      if(isNaN(dat))
      {
            register2=dat.split(" ");
            !(register2[1]=="")?null:register2.splice(1,1);
            register9=this.MONTH_INDEXES[register2[2]];
            register7=register2[1].substring(0,2);
            register10=register2[3];
            register3=register2[5];
            register5=register2[4].split(":");
            register6=new Date(register10,register9,register7,register5[0],register5[1],register5[2]);
            register4=Math.round(register6.valueOf()/1000)-register6.getTimezoneOffset()*60;
            if(isNaN(register3))
            {
               register4=register4-3600*this.timezones[register3];
            }
            else
            {
               register4=register4-3600*register3.substring(0,3).valueOf()-60*register3.substring(3,2).valueOf();
            }
            return register4;
      }
      else
      {
            return dat.valueOf();
      }
   };
   register2.iso2Date=function(dat)
   {
      if(isNaN(dat))
      {
            while(dat.indexOf(" ")>-1)
            {
               register2=dat.indexOf(" ");
               dat=dat.substr(0,register2)+dat.substr(register2+1);
            }
            register4=new Date(dat.substr(0,4),dat.substr(5,2)-1,dat.substr(8,2),dat.substr(11,2),dat.substr(14,2),dat.substr(17,2));
            register3=Math.round(register4.valueOf()/1000)-register4.getTimezoneOffset()*60;
            if(dat.length>20)
            {
               register5=dat.substr(20,2).valueOf();
               register6=dat.substr(23,2).valueOf();
               if(dat.charAt(19)=="-")
               {
                  register3=register3-register5*3600-register6*60;
               }
               else
               {
                  register3=register3+register5*3600+register6*60;
               }
            }
            return register3;
      }
      else
      {
            return dat;
      }
   };
   register2.timezones={"NZST":12,"PETT":12,"IDLE":12,"MAGT":11,"GST":10,"SAKT":10,"ACDT":10.5,"VLAT":10,"ACST":9.5,"EIT":9,"KST":9,"JST":9,"YAKT":9,"BNT":8,"CIT":8,"CST":8,"ULAT":8,"IRKT":8,"WAST":7,"WIT":7,"ICT":7,"KRAT":7,"MMT":6.5,"LKT":6,"NOVT":6,"OMST":6,"TJT":5,"TMT":5,"YEKT":5,"SAMT":4,"IRT":3.5,"MSK":3,"EEDT":3,"EET":2,"CEST":1,"CET":1,"WET":0,"GMT":0,"UT":0,"UTC":0,"WAT":-1,"AT":-2,"EBT":-3,"NT":-3.5,"AST":-4,"WBT":-4,"ADT":-3,"EDT":-4,"CDT":-5,"EST":-5,"CST":-6,"PDT":-7,"MST":-7,"PST":-8,"YST":-9,"HST":-10,"CAT":-10,"AHST":-10,"NT":-11,"IDLW":-12};
   register2.MONTH_INDEXES={"Dec":11,"Nov":10,"Oct":9,"Sep":8,"Aug":7,"Jul":6,"Jun":5,"May":4,"Apr":3,"Mar":2,"Feb":1,"Jan":0,"December":11,"November":10,"October":9,"September":8,"August":7,"July":6,"June":5,"May":4,"April":3,"March":2,"February":1,"January":0};
}
