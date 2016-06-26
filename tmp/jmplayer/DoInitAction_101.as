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
if(!_global.com.jeroenwijering.players.AbstractPlayer)
{
   register1=function(tgt)
   {
      var ref=this
      this.config.clip=tgt;
      this.manager=new com.jeroenwijering.utils.ConfigManager(true);
      this.manager.onComplete=function()
      {
            ref.fillConfig();
      };
      this.manager.loadConfig(this.config);
   };
   com.jeroenwijering.players.AbstractPlayer=function(tgt)
   {
      var ref=this
      this.config.clip=tgt;
      this.manager=new com.jeroenwijering.utils.ConfigManager(true);
      this.manager.onComplete=function()
      {
            ref.fillConfig();
      };
      this.manager.loadConfig(this.config);
   };
   register2=register1.prototype;
   _global.com.jeroenwijering.players.AbstractPlayer implements _global.com.jeroenwijering.feeds.FeedListener
   register2.fillConfig=function()
   {
      if(this.config.shownavigation=="false")
      {
            this.config.controlbar=0;
      }
      if(!(this.config.search==undefined))
      {
            this.config.controlbar=this.config.controlbar+30;
      }
      if(this.config.displayheight==undefined)
      {
            this.config.displayheight=this.config.height-this.config.controlbar;
      }
      else
      {
            if(this.config.displayheight.valueOf()>this.config.height.valueOf())
            {
               this.config.displayheight=this.config.height;
            }
      }
      if(this.config.displaywidth==undefined)
      {
            this.config.displaywidth=this.config.width;
      }
      !(this.config.bwstreams==undefined)?this.checkStream():this.loadFile();
   };
   register2.checkStream=function()
   {
      
   };
   register2.loadFile=function(str)
   {
      this.feeder=new com.jeroenwijering.feeds.FeedManager(true,this.config.enablejs,this.config.prefix,str);
      this.feeder.addListener(this);
      this.feeder.loadFile({"file":this.config.file});
   };
   register2.onFeedUpdate=function(typ)
   {
      if(this.controller==undefined)
      {
            this.config.clip._visible=true;
            this.config.clip._parent.activity._visible=false;
            this.setupMCV();
      }
   };
   register2.setupMCV=function()
   {
      this.controller=new com.jeroenwijering.players.AbstractController(this.config,this.feeder);
      register5=new com.jeroenwijering.players.AbstractView(this.controller,this.config,this.feeder);
      register2=new Array(register5);
      register3=new com.jeroenwijering.players.AbstractModel(register2,this.controller,this.config,this.feeder);
      register4=new Array(register3);
      this.controller.startMCV(register4);
   };
}
