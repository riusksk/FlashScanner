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
if(!_global.com.jeroenwijering.utils.ConfigManager)
{
   register1=function(stg)
   {
      this.staging=stg;
      if(this.staging==true)
      {
            Stage.scaleMode="noScale";
            Stage.align="TL";
      }
   };
   com.jeroenwijering.utils.ConfigManager=function(stg)
   {
      this.staging=stg;
      if(this.staging==true)
      {
            Stage.scaleMode="noScale";
            Stage.align="TL";
      }
   };
   register2=register1.prototype;
   register2.loadConfig=function(def)
   {
      this.config=def;
      this.config.clip._visible=false;
      if(this.staging==true&&Stage.width>1)
      {
            this.config.width=Stage.width;
            this.config.height=Stage.height;
            this.config.clip._parent.activity._x=Stage.width/2;
            this.config.clip._parent.activity._y=Stage.height/2;
            this.config.clip._parent.activity._alpha=100;
      }
      !(_root.config==undefined)?this.loadFile():this.loadCookies();
   };
   register2.loadFile=function()
   {
      var ref=this
      this.parser=new com.jeroenwijering.utils.XMLParser();
      this.parser.onComplete=function(obj)
      {
            register3=new Object();
            this=0;
            while(this<obj.childs.length)
            {
                  register3.obj.childs[this].name=obj.childs[this].value;
                  this=this+1;
            }
            ref.checkWrite(register3);
            ref.loadCookies();
      };
      this.parser.parse(_root.config);
   };
   register2.loadCookies=function()
   {
      this.cookie=SharedObject.getLocal("com.jeroenwijering.players","/");
      this.checkWrite(this.cookie.data);
      this.loadVars();
   };
   register2.loadVars=function()
   {
      this.checkWrite(_root);
      if(this.staging==true)
      {
            this.setContext();
      }
      this.onComplete();
   };
   register2.checkWrite=function(dat)
   {
      register3=register0;
      this.config.register3=unescape(dat[register3]);
      for( in this.config)
      {
            register3=register0;
            if(!(dat[register3]==undefined))
            {
               this.config.register3=unescape(dat[register3]);
            }
      }
   };
   register2.setContext=function()
   {
      register4=this;
      _root.ref=this;
      this.context=new ContextMenu();
      this.context.hideBuiltInItems();
      register3=new ContextMenuItem("About "+this.config.abouttxt+"...",register4.goTo);
      this.context.customItems.push(register3);
      this.config.clip._parent.menu=this.context;
   };
   register2.goTo=function(obj, itm)
   {
      getUrl(obj.ref.config.aboutlnk,obj.ref.config.linktarget);
   };
   register2.onComplete=function()
   {
      
   };
}
