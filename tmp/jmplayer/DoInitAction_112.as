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
if(!_global.com.jeroenwijering.utils.XMLParser)
{
   register1=function()
   {
      
   };
   com.jeroenwijering.utils.XMLParser=function()
   {
      
   };
   register2=register1.prototype;
   register2.parse=function(lnk)
   {
      var ref=this
      this.input=new XML();
      this.output=new Object();
      this.input.ignoreWhite=true;
      this.input.onLoad=function(scs)
      {
            if(scs)
            {
                  ref.processRoot();
            }
            else
            {
                  ref.onError();
            }
      };
      if(_root._url.indexOf("file://")>-1)
      {
            this.input.load(lnk);
      }
      else
      {
            if(lnk.indexOf("?")>-1)
            {
               this.input.load(lnk+"&"+random(999));
            }
            else
            {
               this.input.load(lnk+"?"+random(999));
            }
      }
   };
   register2.processRoot=function()
   {
      this.processNode(this.input.firstChild,this.output);
      delete this.input
      this.onComplete(this.output);
   };
   register2.processNode=function(nod, obj)
   {
      obj.name=nod.nodeName;
      register7=register0;
      obj.register7=nod.attributes[register7];
      !(nod.childNodes.length<2);
      obj.value=nod.firstChild.nodeValue;
      obj.childs=new Array();
      register2=nod.firstChild;
      nod.firstChild;
      register6=0;
      register3=new Object();
      new Object();
      this.processNode(register2,register3);
      obj.childs.push(register3);
      register2=register2.nextSibling;
      register2.nextSibling;
      register6=register6+1;
      register6+1;
      for( in nod.attributes)
      {
            register7=register0;
            obj.register7=nod.attributes[register7];
      }
      if(nod.childNodes.length<2&&nod.firstChild.nodeName==null)
      {
            obj.value=nod.firstChild.nodeValue;
      }
      else
      {
            obj.childs=new Array();
            register2=nod.firstChild;
            register6=0;
            while(!(register2==undefined))
            {
               register3=new Object();
               this.processNode(register2,register3);
               obj.childs.push(register3);
               register2=register2.nextSibling;
               register6=register6+1;
            }
      }
   };
   register2.onComplete=function(obj)
   {
      
   };
   register2.onError=function()
   {
      
   };
}
