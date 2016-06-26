if(!_global.com)
{
   _global.com=new Object();
}
if(!_global.com.jeroenwijering)
{
   _global.com.jeroenwijering=new Object();
}
if(!_global.com.jeroenwijering.players)
{
   _global.com.jeroenwijering.players=new Object();
}
if(!_global.com.jeroenwijering.players.MediaPlayer)
{
   register1=function(tgt)
   {
      super(tgt);
   };
   com.jeroenwijering.players.MediaPlayer=function(tgt)
   {
      super(tgt);
   };
   com.jeroenwijering.players.MediaPlayer extends com.jeroenwijering.players.AbstractPlayer
   register2=register1.prototype;
   register2.checkStream=function()
   {
      var ref=this
      var str=this.config.bwstreams.split(",")
      register4=new com.jeroenwijering.utils.BandwidthCheck(this.config.bwfile);
      register4.onComplete=function(kbps)
      {
            trace("bandwidth: "+kbps);
            register3=new ContextMenuItem("Detected bandwidth: "+kbps+" kbps");
            register3.separatorBefore=true;
            ref.manager.context.customItems.push(register3);
            if(ref.config.enablejs=="true"&&flash.external.ExternalInterface.available)
            {
                  flash.external.ExternalInterface.call("getBandwidth",kbps);
            }
            this=1;
            while(this<str.length)
            {
                  if(kbps<str[this].valueOf())
                  {
                     ref.loadFile(str[this-1]);
                     return undefined;
                  }
                  this=this+1;
            }
            ref.loadFile(str[str.length-1]);
      };
   };
   register2.setupMCV=function()
   {
      this.controller=new com.jeroenwijering.players.PlayerController(this.config,this.feeder);
      register6=new com.jeroenwijering.players.DisplayView(this.controller,this.config,this.feeder);
      register2=new Array(register6);
      if(this.config.shownavigation=="true")
      {
            register16=new com.jeroenwijering.players.ControlbarView(this.controller,this.config,this.feeder);
            register2.push(register16);
      }
      else
      {
            this.config.clip.controlbar._visible=false;
      }
      if(this.config.displayheight<this.config.height-this.config.controlbar||this.config.displaywidth<this.config.width)
      {
            register8=new com.jeroenwijering.players.PlaylistView(this.controller,this.config,this.feeder);
            register2.push(register8);
      }
      else
      {
            register0=false;
            this.config.clip.playlistmask._visible=false;
            this.config.clip.playlist._visible=register0;
      }
      if(this.config.usekeys=="true")
      {
            register11=new com.jeroenwijering.players.InputView(this.controller,this.config,this.feeder);
            register2.push(register11);
      }
      if(this.config.showeq=="true")
      {
            register7=new com.jeroenwijering.players.EqualizerView(this.controller,this.config,this.feeder);
            register2.push(register7);
      }
      else
      {
            this.config.clip.equalizer._visible=false;
      }
      register3=undefined;
      if(this.feeder.captions==true)
      {
            register3=new com.jeroenwijering.players.CaptionsView(this.controller,this.config,this.feeder);
            register2.push(register3);
      }
      else
      {
            this.config.clip.captions._visible=false;
      }
      if(!(this.config.recommendations==undefined))
      {
            register9=new com.jeroenwijering.players.RecommendationsView(this.controller,this.config,this.feeder);
            register2.push(register9);
      }
      else
      {
            this.config.clip.recommendations._visible=false;
      }
      if(this.feeder.audio==true)
      {
            register14=new com.jeroenwijering.players.AudioView(this.controller,this.config,this.feeder,true);
            register2.push(register14);
      }
      if(this.config.enablejs=="true")
      {
            register10=new com.jeroenwijering.players.JavascriptView(this.controller,this.config,this.feeder);
            register2.push(register10);
      }
      if(!(this.config.callback==undefined))
      {
            register5=new com.jeroenwijering.players.CallbackView(this.controller,this.config,this.feeder);
            register2.push(register5);
      }
      register15=new com.jeroenwijering.players.MP3Model(register2,this.controller,this.config,this.feeder,this.config.clip);
      register4=new com.jeroenwijering.players.FLVModel(register2,this.controller,this.config,this.feeder,this.config.clip.display.video);
      register12=new com.jeroenwijering.players.ImageModel(register2,this.controller,this.config,this.feeder,this.config.clip.display.image);
      register13=new Array(register15,register4,register12);
      if(this.feeder.captions==true)
      {
            register4.capView=register3;
      }
      this.controller.startMCV(register13);
   };
   register1.main=function()
   {
      register2=new com.jeroenwijering.players.MediaPlayer(_root.player);
   };
   register2.config={"aboutlnk":"http://www.jeroenwijering.com/?about=JW_FLV_Media_Player","abouttxt":"JW FLV Media Player 3.15","usekeys":"true","usemute":"false","usecaptions":"true","useaudio":"true","streamscript":undefined,"recommendations":undefined,"prefix":"","linktarget":"_self","linkfromdisplay":"false","javascriptid":"","enablejs":"false","callback":undefined,"bwstreams":undefined,"bwfile":"100k.jpg","volume":80,"smoothing":"true","shuffle":"true","rotatetime":5,"repeat":"false","overstretch":"false","deblocking":4,"bufferlength":3,"autostart":"false","fsbuttonlink":undefined,"usefullscreen":"true","thumbsinplaylist":"true","showstop":"false","shownavigation":"true","showicons":"true","showeq":"false","showdownload":"false","showdigits":"true","logo":undefined,"largecontrols":"false","displaywidth":undefined,"autoscroll":"false","screencolor":0,"lightcolor":0,"backcolor":16777215,"frontcolor":0,"displayheight":undefined,"controlbar":20,"width":320,"height":260,"file":"video.flv","clip":undefined};
}
