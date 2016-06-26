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
if(!_global.com.jeroenwijering.players.CaptionsParser)
{
   register1=function()
   {
      
   };
   com.jeroenwijering.players.CaptionsParser=function()
   {
      
   };
   register2=register1.prototype;
   register2.parse=function(url)
   {
      this.parseURL=url;
      this.parseArray=new Array();
      !(this.parseURL.indexOf(".srt")==-1)?this.parseSRT():this.parseTT();
   };
   register2.parseSRT=function()
   {
      var ref=this
      this.parseLV=new LoadVars();
      this.parseLV.onLoad=function(scs)
      {
            if(scs)
            {
                  register11="";
                  register5=-2;
                  while(register5<unescape(this).length)
                  {
                     register10=register5;
                     register5=unescape(this).indexOf("=&",register5+2);
                     !(register5==-1)?null:unescape(this).length;
                     register11="&"+unescape(this).substring(register10+2,register5)+register11;
                  }
                  register3=register11.split("\r\n\r\n");
                  _root=0;
                  while(_root<register3.length)
                  {
                     register4=new Object();
                     register6=register3[_root].indexOf(":");
                     register4.bgn=register3[_root].substr(register6-2,2).valueOf()*3600+register3[_root].substr(register6+1,2).valueOf()*60+register3[_root].substr(register6+4,2)+"."+register3[_root].substr(register6+7,2).valueOf();
                     register7=register3[_root].indexOf(":",register6+6);
                     register4.dur=register3[_root].substr(register7-2,2).valueOf()*3600+register3[_root].substr(register7+1,2).valueOf()*60+register3[_root].substr(register7+4,2)+"."+register3[_root].substr(register7+7,2).valueOf()-register4.bgn;
                     register8=register3[_root].indexOf("\r\n",register7);
                     if(register3[_root].indexOf("\r\n",register8+5)>-1)
                     {
                        register9=register3[_root].indexOf("\r\n",register8+5);
                        register3._root=register3[_root].substr(0,register9)+"<br />"+register3[_root].substr(register9+2);
                     }
                     register4.txt=register3[_root].substr(register8+2);
                     if(!isNaN(register4.bgn))
                     {
                        ref.parseArray.push(register4);
                     }
                     _root=_root+1;
                  }
            }
            else
            {
                  ref.parseArray.push({"dur":5,"bgn":1,"txt":"File not found: "+ref.parseURL});
            }
            if(ref.parseArray.length==0)
            {
                  ref.parseArray.push({"dur":5,"bgn":1,"txt":"Empty file: "+ref.parseURL});
            }
            delete ref.parseLV
            ref.onParseComplete();
      };
      if(_root._url.indexOf("file://")>-1)
      {
            this.parseLV.load(this.parseURL);
      }
      else
      {
            if(this.parseURL.indexOf("?")>-1)
            {
               this.parseLV.load(this.parseURL+"&"+random(999));
            }
            else
            {
               this.parseLV.load(this.parseURL+"?"+random(999));
            }
      }
   };
   register2.parseTT=function()
   {
      var ref=this
      this.parseXML=new XML();
      this.parseXML.ignoreWhite=true;
      this.parseXML.onLoad=function(scs)
      {
            if(scs)
            {
                  if(this.firstChild.nodeName.toLowerCase()=="tt")
                  {
                     register5=this.firstChild.childNodes[1];
                     if(register5.firstChild.firstChild.attributes.begin==undefined)
                     {
                        register3=0;
                        while(register3<register5.childNodes.length)
                        {
                           _root=new Object();
                           register8=register5.childNodes[register3].attributes.begin;
                           _root.bgn=com.jeroenwijering.utils.StringMagic.toSeconds(register8);
                           register7=register5.childNodes[register3].attributes.dur;
                           _root.dur=com.jeroenwijering.utils.StringMagic.toSeconds(register7);
                           _root.txt=register5.childNodes[register3].firstChild.childNodes.join("").toString();
                           ref.parseArray.push(_root);
                           register3=register3+1;
                        }
                     }
                     else
                     {
                        register4=register5.firstChild;
                        register3=0;
                        while(register3<register4.childNodes.length)
                        {
                           _root=new Object();
                           register8=register4.childNodes[register3].attributes.begin;
                           _root.bgn=com.jeroenwijering.utils.StringMagic.toSeconds(register8);
                           register6=register4.childNodes[register3].attributes.end;
                           if(register6==undefined)
                           {
                              register7=register4.childNodes[register3].attributes.dur;
                              _root.dur=com.jeroenwijering.utils.StringMagic.toSeconds(register7);
                           }
                           else
                           {
                              _root.dur=com.jeroenwijering.utils.StringMagic.toSeconds(register6)-_root.bgn;
                           }
                           _root.txt=register4.childNodes[register3].childNodes.join("");
                           ref.parseArray.push(_root);
                           register3=register3+1;
                        }
                     }
                  }
            }
            else
            {
                  ref.parseArray.push({"txt":"File not found: "+ref.parseURL});
            }
            if(ref.parseArray.length==0)
            {
                  ref.parseArray.push({"txt":"Incompatible file: "+ref.parseURL});
            }
            delete ref.parseXML
            ref.onParseComplete();
      };
      if(_root._url.indexOf("file://")>-1)
      {
            this.parseXML.load(this.parseURL);
      }
      else
      {
            if(this.parseURL.indexOf("?")>-1)
            {
               this.parseXML.load(this.parseURL+"&"+random(999));
            }
            else
            {
               this.parseXML.load(this.parseURL+"?"+random(999));
            }
      }
   };
   register2.onParseComplete=function()
   {
      
   };
}
