if(!_global.com)
{
   _global.com=new Object();
}
if(!_global.com.jeroenwijering)
{
   _global.com.jeroenwijering=new Object();
}
if(!_global.com.jeroenwijering.utils)
{
   _global.com.jeroenwijering.utils=new Object();
}
if(!_global.com.jeroenwijering.utils.StringMagic)
{
   register1=function()
   {
      
   };
   com.jeroenwijering.utils.StringMagic=function()
   {
      
   };
   register2=register1.prototype;
   register1.stripTagsBreaks=function(str)
   {
      if(str.length==0||str==undefined)
      {
            return "";
      }
      register4=str.split("\n");
      str=register4.join("");
      register4=str.split("\r");
      str=register4.join("");
      register2=str.indexOf("<");
      while(!(register2==-1))
      {
            register3=str.indexOf(">",register2+1);
            !(register3==-1)?null:str.length-1;
            str=str.substr(0,register2)+str.substr(register3+1,str.length);
            register2=str.indexOf("<",register2);
      }
      return str;
   };
   register1.chopString=function(str, cap, nbr)
   {
      register2=cap;
      while(register2<str.length)
      {
            if(register2==cap*nbr)
            {
               if(str.indexOf(" ",register2-5)==-1)
               {
                  return str;
               }
               else
               {
                  return str.substr(0,str.indexOf(" ",register2-5));
               }
            }
            else
            {
               if(str.indexOf(" ",register2)>0)
               {
                  str=str.substr(0,str.indexOf(" ",register2-3))+"\n"+str.substr(str.indexOf(" ",register2-3)+1);
               }
            }
            register2=register2+cap;
      }
      return str;
   };
   register1.addLeading=function(nbr)
   {
      if(nbr<10)
      {
            return "0"+Math.floor(nbr);
      }
      else
      {
            return Math.floor(nbr).toString();
      }
   };
   register1.toSeconds=function(str)
   {
      register3=str.split(":");
      register2=undefined;
      if(str.substr(-1)=="s")
      {
            register2=str.substr(0,str.length-2).valueOf();
      }
      else
      {
            if(str.substr(-1)=="m")
            {
               register2=str.substr(0,str.length-2).valueOf()*60;
            }
            else
            {
               if(str.substr(-1)=="h")
               {
                  register2=str.substr(0,str.length-2).valueOf()*3600;
               }
               else
               {
                  if(register3.length>1)
                  {
                     register2=register3[register3.length-1].valueOf();
                     register2=register2+register3[register3.length-2].valueOf()*60;
                     register2=register2+register3[register3.length-3].valueOf()*3600;
                  }
                  else
                  {
                     register2=str.valueOf();
                  }
               }
            }
      }
      if(isNaN(register2))
      {
            return 0;
      }
      else
      {
            return register2;
      }
   };
}
