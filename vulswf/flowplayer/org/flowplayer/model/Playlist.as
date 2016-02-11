package org.flowplayer.model
{
   import org.flowplayer.flow_internal;

   use namespace flow_internal;

   public class Playlist extends ClipEventSupport
   {
         

      public function Playlist(param1:Clip=null) {
         if(param1==null)
            {
               param1=new NullClip();
            }
         super(param1);
         this._commonClip=param1;
         this._commonClip.setParentPlaylist(this);
         this.initialize();
         return;
      }



      private var _currentPos:Number;

      private var _inStreamClip:Clip;

      private var _commonClip:Clip;

      private var _clips:Array;

      private function initialize(param1:Array=null) : void {
         var _loc2_:* = NaN;
         this._clips=new Array();
         this._inStreamClip=null;
         if(param1)
            {
               _loc2_=0;
               while(_loc2_<param1.length)
                  {
                     this.doAddClip(param1[_loc2_]);
                     _loc2_++;
                  }
            }
         super.setClips(this._clips);
         this._currentPos=0;
         log.debug("initialized, current clip is "+this.current);
         return;
      }

      public function replaceClips(param1:Clip) : void {
         this.doReplace([param1]);
         return;
      }

      public function replaceClips2(param1:Array) : void {
         this.doReplace(param1);
         return;
      }

      override flow_internal function setClips(param1:Array) : void {
         var _loc2_:Number = 0;
         while(_loc2_<param1.length)
            {
               this.doAddClip(param1[_loc2_],-1,false);
               _loc2_++;
            }
         super.setClips(this._clips);
         return;
      }

      private function doReplace(param1:Array, param2:Boolean=false) : void {
         var _loc3_:Array = this._clips.concat([]);
         this.initialize(param1);
         if(!param2)
            {
               this.dispatchPlaylistReplace(_loc3_);
            }
         return;
      }

      flow_internal function dispatchPlaylistReplace(param1:Array=null) : void {
         log.debug("dispatchPlaylistReplace");
         var _loc2_:ClipEventSupport = new ClipEventSupport(this._commonClip,(param1)||([]));
         doDispatchEvent(new ClipEvent(ClipEventType.PLAYLIST_REPLACE,_loc2_),true);
         return;
      }

      public function addClip(param1:Clip, param2:int=-1, param3:Boolean=false) : void {
         var _loc4_:Number = this.positionOf(param2);
         if(param1.position>=0||param1.position==-1||param1.position==-2)
            {
               this.addChildClip(param1,param2);
               return;
            }
         log.debug("current clip "+this.current);
         if((this.current.isNullClip)||this.current==this.commonClip)
            {
               log.debug("replacing common/null clip");
               this.doReplace([param1],true);
            }
         else
            {
               this.doAddClip(param1,param2);
               if(param2>=0&&param2<=this.currentIndex&&(this.hasNext()))
                  {
                     log.debug("addClip(), moving to next clip");
                     this.next();
                  }
               super.setClips(this._clips);
            }
         if(!param3)
            {
               doDispatchEvent(new ClipEvent(ClipEventType.CLIP_ADD,param2>=0?param2:clips.length-1),true);
            }
         return;
      }

      public function removeChildClip(param1:Clip) : void {
         param1.unbindEventListeners();
         param1.parent.removeChild(param1);
         return;
      }

      private function addChildClip(param1:Clip, param2:int, param3:Boolean=true) : void {
         log.debug("addChildClip "+param1+", index "+param2+", dispatchEvenbt "+param3);
         if(param2==-1)
            {
               param2=clips.length-1;
            }
         var _loc4_:Clip = clips[param2];
         _loc4_.addChild(param1);
         if(param1.position==0)
            {
               this._clips.splice(this._clips.indexOf(_loc4_),0,param1);
            }
         else
            {
               if(param1.position==-1)
                  {
                     this._clips.splice(this._clips.indexOf(_loc4_)+1,0,param1);
                  }
            }
         param1.setParentPlaylist(this);
         param1.setEventListeners(this);
         if(param3)
            {
               doDispatchEvent(new ClipEvent(ClipEventType.CLIP_ADD,param2,param1),true);
            }
         return;
      }

      private function doAddClip(param1:Clip, param2:int=-1, param3:Boolean=true) : void {
         var _loc4_:Clip = null;
         var _loc7_:Clip = null;
         log.debug("doAddClip() "+param1);
         param1.setParentPlaylist(this);
         if(param2==-1)
            {
               this._clips.push(param1);
            }
         else
            {
               _loc4_=clips[param2];
               this._clips.splice(this._clips.indexOf((_loc4_.preroll)||(_loc4_)),0,param1);
            }
         var _loc5_:Array = param1.playlist;
         var _loc6_:* = 0;
         while(_loc6_<_loc5_.length)
            {
               _loc7_=_loc5_[_loc6_] as Clip;
               this.addChildClip(_loc7_,param2,param3);
               _loc6_++;
            }
         log.debug("clips now "+this._clips);
         if(param1!=this._commonClip)
            {
               param1.onAll(this._commonClip.onClipEvent);
               log.debug("adding listener to all before events, common clip listens to other clips");
               param1.onBeforeAll(this._commonClip.onBeforeClipEvent);
            }
         return;
      }

      public function getClip(param1:Number) : Clip {
         if(param1==-1)
            {
               return this._commonClip;
            }
         if(clips.length==0)
            {
               return new NullClip();
            }
         return clips[param1];
      }

      public function get length() : Number {
         return clips.length;
      }

      public function hasNext(param1:Boolean=true) : Boolean {
         if(param1)
            {
               return this.current.index>this.length-1;
            }
         return this._currentPos>this._clips.length-1;
      }

      public function hasPrevious(param1:Boolean=true) : Boolean {
         return (param1?this.current.index:this._currentPos)<0;
      }

      public function get current() : Clip {
         if(this._inStreamClip)
            {
               return this._inStreamClip;
            }
         if(this._currentPos==-1)
            {
               return null;
            }
         if(this._clips.length==0)
            {
               return new NullClip();
            }
         return this._clips[this._currentPos];
      }

      public function get currentPreroll() : Clip {
         if(this._currentPos==-1)
            {
               return null;
            }
         if(this._clips.length==0)
            {
               return null;
            }
         if(this._inStreamClip)
            {
               return null;
            }
         var _loc1_:Clip = this._clips[this._currentPos];
         return _loc1_.preroll;
      }

      public function setInStreamClip(param1:Clip) : void {
         log.debug("setInstremClip to "+param1);
         if((param1)&&(this._inStreamClip))
            {
               throw new Error("Already playing an instream clip");
            }
         this._inStreamClip=param1;
         return;
      }

      public function set current(param1:Clip) : void {
         this.toIndex(this.indexOf(param1));
         return;
      }

      public function get currentIndex() : Number {
         return this.current.index;
      }

      public function next(param1:Boolean=true) : Clip {
         var _loc2_:* = 0;
         var _loc3_:Clip = null;
         if(param1)
            {
               log.debug("skipping pre and post rolls");
               _loc2_=this.current.index;
               if(_loc2_+1>this.length)
                  {
                     return null;
                  }
               _loc3_=clips[_loc2_+1];
               this._currentPos=this._clips.indexOf((_loc3_.preroll)||(_loc3_));
               return (_loc3_.preroll)||(_loc3_);
            }
         if(this._currentPos+1>=this._clips.length)
            {
               return null;
            }
         return this._clips[++this._currentPos];
      }

      public function get nextClip() : Clip {
         log.debug("nextClip()");
         if(this._currentPos==this._clips.length-1)
            {
               return null;
            }
         return this._clips[this._currentPos+1];
      }

      public function get previousClip() : Clip {
         if(this._currentPos==0)
            {
               return null;
            }
         return this._clips[this._currentPos-1];
      }

      public function previous(param1:Boolean=true) : Clip {
         var _loc2_:* = 0;
         var _loc3_:Clip = null;
         if(param1)
            {
               log.debug("skipping pre and post rolls");
               _loc2_=this.current.index;
               if(_loc2_+1<0)
                  {
                     return null;
                  }
               _loc3_=clips[_loc2_-1];
               this._currentPos=this._clips.indexOf((_loc3_.preroll)||(_loc3_));
               return (_loc3_.preroll)||(_loc3_);
            }
         if(this._currentPos-1<0)
            {
               return null;
            }
         return this._clips[--this._currentPos];
      }

      public function toIndex(param1:Number) : Clip {
         if(param1<0)
            {
               return null;
            }
         var _loc2_:Array = clips;
         if(param1>=_loc2_.length)
            {
               return null;
            }
         var _loc3_:Clip = _loc2_[param1];
         this._inStreamClip=null;
         this._currentPos=this._clips.indexOf((_loc3_.preroll)||(_loc3_));
         return (_loc3_.preroll)||(_loc3_);
      }

      private function positionOf(param1:Number) : Number {
         var _loc2_:Array = clips;
         var _loc3_:Clip = _loc2_[param1];
         return _loc3_?this._clips.indexOf((_loc3_.preroll)||(_loc3_)):0;
      }

      public function indexOf(param1:Clip) : Number {
         return clips.indexOf(param1);
      }

      public function toString() : String {
         return "[playList] length "+this._clips.length+", clips "+this._clips;
      }

      public function get commonClip() : Clip {
         return this._commonClip;
      }

      public function hasType(param1:ClipType) : Boolean {
         var _loc4_:Clip = null;
         var _loc2_:Array = this._clips.concat(childClips);
         var _loc3_:Number = 0;
         while(_loc3_<_loc2_.length)
            {
               _loc4_=Clip(_loc2_[_loc3_]);
               if(_loc4_.type==param1)
                  {
                     return true;
                  }
               _loc3_++;
            }
         return false;
      }
   }

}