package org.flowplayer.config
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.flow_internal;
   import org.flowplayer.util.URLUtil;
   import org.flowplayer.util.PropertyBinder;
   import org.flowplayer.model.Cuepoint;

   use namespace flow_internal;

   class PlaylistBuilder extends Object
   {
         

      function PlaylistBuilder(param1:String, param2:Object, param3:Object) {
         this.log=new Log(this);
         super();
         this._playerId=param1;
         this._commonClipObject=param3;
         if(param2 is Array)
            {
               this._clipObjects=param2 as Array;
            }
         return;
      }

      private static const NESTED_PLAYLIST:String = "playlist";

      private var log:Log;

      private var _clipObjects:Array;

      private var _commonClipObject:Object;

      private var _commonClip:Clip;

      private var _playerId:String;

      private var _playlistFeed:String;

      public function set playlistFeed(param1:String) : void {
         this._playlistFeed=param1;
         return;
      }

      public function createPlaylist() : Playlist {
         if(this._commonClipObject)
            {
               this._commonClip=this.createClip(this._commonClipObject);
            }
         var _loc1_:Playlist = new Playlist(this._commonClip);
         if(this._playlistFeed)
            {
               this.parse(this._playlistFeed,_loc1_,this._commonClipObject);
            }
         else
            {
               if((this._clipObjects)&&this._clipObjects.length<0)
                  {
                     _loc1_.setClips(this.createClips(this._clipObjects));
                  }
               else
                  {
                     if(this._commonClip)
                        {
                           _loc1_.addClip(this.createClip(this._commonClipObject));
                        }
                  }
            }
         return _loc1_;
      }

      public function createClips(param1:Object) : Array {
         var _loc4_:Object = null;
         if(param1 is String)
            {
               return new RSSPlaylistParser().parse(param1 as String,null,this._commonClipObject);
            }
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_<(param1 as Array).length)
            {
               _loc4_=(param1 as Array)[_loc3_];
               if(_loc4_ is String)
                  {
                     _loc4_={url:_loc4_};
                  }
               _loc2_.push(this.createClip(_loc4_));
               _loc3_++;
            }
         return _loc2_;
      }

      public function createClip(param1:Object, param2:Boolean=false) : Clip {
         var _loc7_:* = NaN;
         this.log.debug("createClip, from ",param1);
         if(!param1)
            {
               return null;
            }
         if(param1 is String)
            {
               param1={url:param1};
            }
         this.setDefaults(param1);
         var _loc3_:String = param1.url;
         var _loc4_:String = param1.baseUrl;
         var _loc5_:String = _loc3_;
         if(URLUtil.isCompleteURLWithProtocol(_loc3_))
            {
               _loc7_=_loc3_.lastIndexOf("/");
               _loc4_=_loc3_.substring(0,_loc7_);
               _loc5_=_loc3_.substring(_loc7_+1);
            }
         var _loc6_:Clip = Clip.create(param1,_loc5_,_loc4_);
         if((param2)||(param1.hasOwnProperty("position")))
            {
               return _loc6_;
            }
         if(param1.hasOwnProperty(NESTED_PLAYLIST))
            {
               this.addChildClips(_loc6_,param1[NESTED_PLAYLIST]);
            }
         else
            {
               if((this._commonClipObject)&&(this._commonClipObject.hasOwnProperty(NESTED_PLAYLIST)))
                  {
                     this.addChildClips(_loc6_,this._commonClipObject[NESTED_PLAYLIST]);
                  }
            }
         return _loc6_;
      }

      private function addChildClips(param1:Clip, param2:Array) : void {
         var _loc4_:Object = null;
         var _loc3_:* = 0;
         while(_loc3_<param2.length)
            {
               _loc4_=param2[_loc3_];
               if(!_loc4_.hasOwnProperty("position"))
                  {
                     if(_loc3_==0)
                        {
                           _loc4_["position"]=0;
                        }
                     else
                        {
                           if(_loc3_==param2.length-1)
                              {
                                 _loc4_["position"]=-1;
                              }
                           else
                              {
                                 throw new Error("position not defined in a nested clip");
                              }
                        }
                  }
               param1.addChild(this.createClip(_loc4_,true));
               _loc3_++;
            }
         return;
      }

      public function createCuepointGroup(param1:Array, param2:String, param3:Number) : Array {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         this.log.debug("createCuepointGroup(), creating "+param1.length+" cuepoints");
         var _loc4_:Array = new Array();
         var _loc5_:Number = 0;
         while(_loc5_<param1.length)
            {
               _loc6_=param1[_loc5_];
               _loc7_=this.createCuepoint(_loc6_,param2,param3);
               _loc4_.push(_loc7_);
               _loc5_++;
            }
         return _loc4_;
      }

      private function setDefaults(param1:Object) : void {
         var _loc2_:String = null;
         if(param1==this._commonClipObject)
            {
               return;
            }
         for (_loc2_ in this._commonClipObject)
            {
               if(!param1.hasOwnProperty(_loc2_)&&!(_loc2_==NESTED_PLAYLIST))
                  {
                     param1[_loc2_]=this._commonClipObject[_loc2_];
                  }
            }
         return;
      }

      private function createCuepoint(param1:Object, param2:String, param3:Number) : Object {
         var _loc6_:String = null;
         var _loc7_:String = null;
         this.log.debug("createCuepoint(), creating cuepoint from: ",param1);
         if(param1 is Number)
            {
               return new Cuepoint(this.roundTime(param1 as int,param3),param2);
            }
         if(!param1.hasOwnProperty("time"))
            {
               throw new Error("Cuepoint does not have time: "+param1);
            }
         var _loc4_:Object = Cuepoint.createDynamic(this.roundTime(param1.time,param3),param2);
         var _loc5_:Object = {};
         for (_loc6_ in param1)
            {
               if(_loc6_=="parameters")
                  {
                     for (_loc7_ in param1[_loc6_])
                        {
                           _loc5_[_loc7_]=param1[_loc6_][_loc7_];
                        }
                     _loc4_["parameters"]=_loc5_;
                     continue;
                  }
               if(_loc6_!="time")
                  {
                     _loc4_[_loc6_]=param1[_loc6_];
                     this.log.debug("added prop "+_loc6_,param1[_loc6_]);
                  }
            }
         return _loc4_;
      }

      private function roundTime(param1:int, param2:Number) : int {
         return Math.round(param1*param2/100)*100;
      }

      private function parse(param1:String, param2:Playlist, param3:Object) : void {
         var _loc4_:Object = null;
         var param2:Playlist = param2;
         if(param1.indexOf("[")==0)
            {
               _loc4_=ConfigParser.parse(param1);
               param2.setClips(this.createClips(_loc4_));
            }
         else
            {
               new RSSPlaylistParser().parse(param1,param2,param3);
            }
         return;
      }

      public function get playlistFeed() : String {
         return this._playlistFeed;
      }
   }

}