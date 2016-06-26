function showMSG(MSG)
{
   msgbox.mymsg.htmlText=MSG;
}
function mytimer()
{
   this.onEnterFrame=function()
   {
         timer=getTimer();
         if(timer<overtime*1000)
         {
               trace(timer);
               showMSG("正在读取服务器数据...");
         }
         else
         {
               delete this.onEnterFrame
               trace(timer);
               showMSG("显示此处信息需网络支持，请检查网络链接是否正常");
         }
   };
}
function run()
{
   function scrol()
   {
         if(k==0)
         {
               showMSG(msg);
               k=1;
         }
         else
         {
               if(k==1)
               {
                  m=m+1;
                  if(!(m<t*10))
                  {
                     k=2;
                     m=0;
                  }
               }
               else
               {
                  if(k==2)
                  {
                     if(a<100)
                     {
                        a=a+10;
                        msgmark._alpha=a;
                     }
                     else
                     {
                        register1=random(newsArray.length);
                        msg="<a href=\'"+linkArray[register1]+"\' target=\'_blank\'>"+newsArray[register1]+"</a>";
                        showMSG(msg);
                        k=3;
                     }
                  }
                  else
                  {
                     if(k==3)
                     {
                        if(a>0)
                        {
                           a=a-10;
                           msgmark._alpha=a;
                        }
                        else
                        {
                           k=1;
                        }
                     }
                  }
               }
         }
   }
   register1=new String();
   register1=lv.texts;
   mylinks=lv.links;
   newsArray=register1.split("|",register1.length);
   linkArray=mylinks.split("|",mylinks.length);
   register2=random(newsArray.length);
   msg="<a href=\'"+linkArray[register2]+"\' target=\'_blank\'>"+newsArray[register2]+"</a>";
   register3=setInterval(scrol,runFre);
}
var k=0
var t=3
var a=0
msgmark._alpha=a;
var timer
var overtime=20
var fliePath=_root.msg_url+"msg.txt"
var newsArray
var linkArray
var runFre=_root.msg_speed
var lv=new LoadVars()
var mydate=new Date()
var myrandom=mydate.getTime()
lv.load(fliePath+"?"+myrandom);
lv.onLoad=function(success)
{
   if(success)
   {
         run();
   }
   else
   {
         mytimer();
   }
};
