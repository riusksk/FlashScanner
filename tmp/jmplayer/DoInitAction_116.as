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
if(!_global.com.jeroenwijering.utils.BandwidthCheck)
{
   register1=function(fil)
   {
      var ref=this
      if(fil.indexOf("rtmp")==-1)
      {
            this.loader=new MovieClipLoader();
            this.loader.addListener(this);
            this.clip=_root.createEmptyMovieClip("_bwchecker",1);
            this.loader.loadClip(fil+"?"+random(9999),this.clip);
      }
      else
      {
            this.connector=new NetConnection();
            this.connector.onStatus=function(info)
            {
               if(!(info.code=="NetConnection.Connect.Success"))
               {
                     ref.onComplete(0);
               }
            };
            this.connector.connect(fil,true);
            this.connector.onBWDone=function(kbps, dtd, dtt, lat)
            {
               ref.onComplete(kbps);
            };
            this.connector.onBWCheck=function()
            {
               
            };
      }
   };
   com.jeroenwijering.utils.BandwidthCheck=function(fil)
   {
      var ref=this
      if(fil.indexOf("rtmp")==-1)
      {
            this.loader=new MovieClipLoader();
            this.loader.addListener(this);
            this.clip=_root.createEmptyMovieClip("_bwchecker",1);
            this.loader.loadClip(fil+"?"+random(9999),this.clip);
      }
      else
      {
            this.connector=new NetConnection();
            this.connector.onStatus=function(info)
            {
               if(!(info.code=="NetConnection.Connect.Success"))
               {
                     ref.onComplete(0);
               }
            };
            this.connector.connect(fil,true);
            this.connector.onBWDone=function(kbps, dtd, dtt, lat)
            {
               ref.onComplete(kbps);
            };
            this.connector.onBWCheck=function()
            {
               
            };
      }
   };
   register2=register1.prototype;
   register2.onLoadComplete=function(tgt, hts)
   {
      tgt._visible=false;
      register4=new Date();
      register6=this.clip.getBytesTotal();
      register3=(register4.getTime()-this.startTime)/1000;
      register2=register6*0.0078125*0.93;
      register5=Math.floor(register2/register3);
      this.onComplete(register5);
      this.clip.removeMovieClip();
   };
   register2.onLoadError=function(tgt, err, stt)
   {
      this.onComplete(0);
   };
   register2.onLoadStart=function()
   {
      register2=new Date();
      this.startTime=register2.getTime();
   };
   register2.onComplete=function()
   {
      
   };
}
