package org.flowplayer.config
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.Clip;
   import com.adobe.utils.XMLUtil;
   import org.flowplayer.util.PropertyBinder;
   import org.flowplayer.model.ClipType;


   class RSSPlaylistParser extends Object
   {
         

      function RSSPlaylistParser() {
         this.log=new Log(this);
         this.ns=new Namespace("");
         this.ym=new Namespace("http://search.yahoo.com/mrss/");
         this.fp=new Namespace("http://flowplayer.org/fprss/");
         super();
         return;
      }

      private static const UNSUPPORTED_TYPE:int = 10;

      private var log:Log;

      private var ns:Namespace;

      private var ym:Namespace;

      private var fp:Namespace;

      public function createClips(param1:String, param2:Playlist, param3:Object) : Array {
         return this.parse(param1,param2,param3);
      }

      public function parse(param1:String, param2:Playlist, param3:Object) : Array {
         var item:XML = null;
         var clip:Clip = null;
         var thumbnail:Clip = null;
         var rawRSS:String = param1;
         var playlist:Playlist = param2;
         var commonClipObject:Object = param3;
         var result:Array = [];
         if(!XMLUtil.isValidXML(rawRSS))
            {
               throw new Error("Feed does not contain valid XML.");
            }
         default xml namespace = this.ns;
         var rss:XML = new XML(rawRSS);
         if(rss.name()=="rss"&&Number(rss.@version)<=2)
            {
               for each (item in rss.channel.item)
                  {
                     try
                        {
                           if(item.this.ym::content.length()<0&&item.this.ym::thumbnail.length()<0)
                              {
                                 thumbnail=this.parseThumbnail(item,commonClipObject);
                              }
                           else
                              {
                                 thumbnail=null;
                              }
                           clip=this.parseClip(item,commonClipObject,!(thumbnail==null));
                        }
                     catch(e:Error)
                        {
                           if(e.errorID==UNSUPPORTED_TYPE)
                              {
                                 log.info("unsupported media type, ignoring this item");
                              }
                           else
                              {
                                 throw e;
                              }
                        }
                     if(clip)
                        {
                           this.log.info("created clip "+clip);
                           result.push(clip);
                           if(playlist)
                              {
                                 playlist.addClip(clip,-1,true);
                              }
                        }
                     if(thumbnail)
                        {
                           this.log.info("created thumbnail clip "+thumbnail);
                           this.log.info("clip.index == "+playlist.indexOf(clip));
                           result.push(thumbnail);
                           if(playlist)
                              {
                                 playlist.addClip(thumbnail,playlist.indexOf(clip),true);
                              }
                        }
                  }
            }
         if(playlist)
            {
               playlist.toIndex(0);
            }
         return result;
      }

      private function parseClip(param1:XML, param2:Object, param3:Boolean=false) : Clip {
         var _loc5_:XML = null;
         default xml namespace = this.ns;
         var _loc4_:Clip = new Clip();
         if(param3)
            {
               _loc4_.autoPlay=false;
            }
         if(!_loc4_.getCustomProperty("bitrates"))
            {
               _loc4_.setCustomProperty("bitrates",[]);
            }
         if(param1.link)
            {
               _loc4_.linkUrl=param1.link;
            }
         if(param1.this.ym::group.this.ym::content.length()>0)
            {
               this.parseMediaGroup(param1.this.ym::group,_loc4_);
            }
         if(param1.this.ym::content.length()>0)
            {
               this.parseMediaItem(XML(param1.this.ym::content),_loc4_);
               this.addBitrateItems(XML(param1.this.ym::content),_loc4_);
            }
         if(param1.this.fp::clip.attributes().length()>0)
            {
               this.parseClipProperties(param1.this.fp::clip,_loc4_);
            }
         for each (_loc5_ in param1.children())
            {
               this.addClipCustomProperty(_loc4_,_loc5_,this.parseCustomProperty(_loc5_));
            }
         this.log.debug("created clip "+_loc4_);
         return _loc4_;
      }

      private function parseThumbnail(param1:XML, param2:Object) : Clip {
         var _loc4_:XML = null;
         default xml namespace = this.ns;
         var _loc3_:Clip = new Clip();
         if(param1.this.ym::thumbnail.length()>0)
            {
               this.parseMediaThumbnail(XML(param1.this.ym::thumbnail),_loc3_);
            }
         if(param1.this.fp::thumbnail.attributes().length()>0)
            {
               this.parseClipProperties(param1.this.fp::thumbnail,_loc3_);
            }
         for each (_loc4_ in param1.children())
            {
               this.addClipCustomProperty(_loc3_,_loc4_,this.parseCustomProperty(_loc4_));
            }
         return _loc3_;
      }

      private function setClipType(param1:Clip, param2:String) : void {
         default xml namespace = this.ns;
         var _loc3_:ClipType = ClipType.fromMimeType(param2);
         if(!_loc3_)
            {
               throw new Error("unsupported media type \'"+param2+"\'",UNSUPPORTED_TYPE);
            }
         param1.type=_loc3_;
         return;
      }

      private function parseClipProperties(param1:XMLList, param2:Clip) : void {
         var _loc4_:XML = null;
         default xml namespace = this.ns;
         var _loc3_:PropertyBinder = new PropertyBinder(param2,"customProperties");
         for each (_loc4_ in param1.attributes())
            {
               this.log.debug("parseClipProperties(), initializing clip property \'"+_loc4_.name()+"\' to value "+_loc4_.toString());
               _loc3_.copyProperty(_loc4_.name().toString(),_loc4_.toString(),true);
            }
         return;
      }

      private function addClipCustomProperty(param1:Clip, param2:XML, param3:Object) : void {
         var _loc6_:Array = null;
         default xml namespace = this.ns;
         this.log.debug("getting property name for "+param2.localName()+" value is ",param3);
         var _loc4_:String = this.getCustomPropName(param2);
         var _loc5_:Object = param1.getCustomProperty(_loc4_);
         if(_loc5_)
            {
               this.log.debug("found existing "+_loc5_);
               _loc6_=_loc5_ is Array?_loc5_ as Array:[_loc5_];
               _loc6_.push(param3);
               param1.customProperties[_loc4_]=_loc6_;
            }
         else
            {
               param1.setCustomProperty(_loc4_,param3);
            }
         this.log.debug("clip custom property "+_loc4_+" now has value ",param1.customProperties[_loc4_]);
         return;
      }

      private function getCustomPropName(param1:XML) : String {
         default xml namespace = this.ns;
         if(!param1.namespace())
            {
               return param1.localName().toString();
            }
         if(!param1.namespace().prefix)
            {
               return param1.localName().toString();
            }
         return "\'"+param1.namespace().prefix+":"+param1.localName().toString()+"\'";
      }

      private function parseCustomProperty(param1:XML) : Object {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         default xml namespace = this.ns;
         if(param1.children().length()==0&&param1.attributes().length()==0)
            {
               return param1.toString();
            }
         if(param1.children().length()==1&&XML(param1.children()[0]).nodeKind()=="text"&&param1.attributes().length()==0)
            {
               this.log.debug("has one text child only, retrieving it\'s contents");
               return param1.text().toString();
            }
         var _loc2_:Object = new Object();
         for each (_loc3_ in param1.attributes())
            {
               _loc2_[_loc3_.localName().toString()]=_loc3_.toString();
            }
         for each (_loc4_ in param1.children())
            {
               _loc2_[_loc4_.localName()?_loc4_.localName().toString():"text"]=this.parseCustomProperty(_loc4_);
            }
         return _loc2_;
      }

      private function parseMediaGroup(param1:XMLList, param2:Clip) : Boolean {
         var clipAdded:Boolean = false;
         var defaultItem:XMLList = null;
         var item:XML = null;
         var itm:XML = null;
         var group:XMLList = param1;
         var clip:Clip = param2;
         default xml namespace = this.ns;
         clipAdded=false;
         defaultItem=group.this.ym::content.((hasOwnProperty("@isDefault"))&&@isDefault=="true");
         if(defaultItem[0])
            {
               this.log.debug("parseMedia(): found default media item");
               if(this.parseMediaItem(defaultItem[0],clip))
                  {
                     this.log.debug("parseMedia(): using the default media item");
                     clipAdded=true;
                  }
            }
         else
            {
               for each (itm in group.this.ym::content)
                  {
                     if(this.parseMediaItem(itm,clip))
                        {
                           clipAdded=true;
                           break;
                        }
                  }
            }
         for each (item in group.this.ym::content)
            {
               this.addBitrateItems(item,clip);
            }
         if(clipAdded)
            {
               return true;
            }
         this.log.info("could not find valid media type");
         throw new Error("Could not find a supported media type",UNSUPPORTED_TYPE);
      }

      private function parseMediaItem(param1:XML, param2:Clip) : Boolean {
         var elem:XML = param1;
         var clip:Clip = param2;
         default xml namespace = this.ns;
         clip.url=elem.@url.toString();
         if(int(elem.@duration.toString())>0)
            {
               clip.duration=int(elem.@duration.toString());
            }
         if(elem.@type)
            {
               try
                  {
                     this.setClipType(clip,elem.@type.toString());
                     this.log.info("found valid type "+elem.@type.toString());
                     return true;
                  }
               catch(e:Error)
                  {
                     if(e.errorID==UNSUPPORTED_TYPE)
                        {
                           log.info("skipping unsupported media type "+elem.@type.toString());
                        }
                     else
                        {
                           throw e;
                        }
                  }
            }
         return false;
      }

      private function parseMediaThumbnail(param1:XML, param2:Clip) : Boolean {
         var elem:XML = param1;
         var clip:Clip = param2;
         default xml namespace = this.ns;
         clip.url=elem.@url.toString();
         if(elem.@type)
            {
               try
                  {
                     this.setClipType(clip,elem.@type.toString());
                     this.log.info("found valid type "+elem.@type.toString());
                     return true;
                  }
               catch(e:Error)
                  {
                     if(e.errorID==UNSUPPORTED_TYPE)
                        {
                           log.info("skipping unsupported media type "+elem.@type.toString());
                        }
                     else
                        {
                           throw e;
                        }
                  }
            }
         return false;
      }

      private function addBitrateItems(param1:XML, param2:Clip) : void {
         default xml namespace = this.ns;
         if((param1.@bitrate)&&(param1.@width))
            {
               param2.customProperties["bitrates"].push({url:new String(param1.@url),
               bitrate:new Number(param1.@bitrate),
               width:new Number(param1.@width),
               height:new Number(param1.@height)});
            }
         return;
      }
   }

}