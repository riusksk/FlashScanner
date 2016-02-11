package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import org.flowplayer.config.Config;
   import org.flowplayer.model.Clip;
   import org.flowplayer.util.ObjectConverter;
   import org.flowplayer.model.ClipEventType;
   import flash.utils.Dictionary;


   public dynamic class NetStreamClient extends Object implements NetStreamCallbacks
   {
         

      public function NetStreamClient(param1:Clip, param2:Config, param3:Dictionary) {
         var _loc4_:Object = null;
         this.log=new Log(this);
         super();
         this._clip=param1;
         this._config=param2;
         for (_loc4_ in param3)
            {
               this.addStreamCallback(_loc4_ as String,param3[_loc4_]);
            }
         return;
      }



      private var log:Log;

      private var _config:Config;

      private var _clip:Clip;

      private var _previousUrl:String;

      public function onMetaData(param1:Object) : void {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         this.log.info("onMetaData, current clip "+this._clip);
         this.log.debug("onMetaData, data for clip "+this._clip+":");
         var _loc2_:Object = new Object();
         for (_loc3_ in param1)
            {
               if(((_loc3_=="duration")&&(this._clip))&&(this._clip.metaData)&&(this._clip.metaData.duration))
                  {
                     this.log.debug("Already got duration, reusing old one");
                     _loc2_.duration=this._clip.metaData.duration;
                     continue;
                  }
               _loc4_=new ObjectConverter(_loc3_).convertKey();
               _loc2_[_loc4_]=new Object();
               if(param1[_loc3_] is Array)
                  {
                     _loc2_[_loc4_]=new Array();
                  }
               if(this.needsRecursing(param1[_loc3_]))
                  {
                     for (_loc5_ in param1[_loc3_])
                        {
                           _loc6_=new ObjectConverter(_loc5_).convertKey();
                           _loc2_[_loc4_][_loc6_]=this.needsRecursing(param1[_loc3_][_loc5_])?this.checkChild(param1[_loc3_][_loc5_]):param1[_loc3_][_loc5_];
                        }
                     continue;
                  }
               _loc2_[_loc4_]=param1[_loc3_];
            }
         this.log.debug("metaData : ",_loc2_);
         this._clip.metaData=_loc2_;
         if((_loc2_.cuePoints)&&this._clip.cuepoints.length==0)
            {
               this.log.debug("clip has embedded cuepoints");
               this._clip.addCuepoints(this._config.createCuepoints(_loc2_.cuePoints,"embedded",this._clip.cuepointMultiplier));
            }
         this._previousUrl=this._clip.url;
         this._clip.dispatch(ClipEventType.METADATA);
         this.log.info("metaData parsed and injected to the clip");
         return;
      }

      private function checkChild(param1:Object) : Object {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:Object = new Object();
         if(param1 is Array)
            {
               _loc2_=new Array();
            }
         for (_loc3_ in param1)
            {
               _loc4_=new ObjectConverter(_loc3_).convertKey();
               if(this.needsRecursing(param1[_loc3_]))
                  {
                     _loc2_[_loc4_]=this.checkChild(param1[_loc3_]);
                     continue;
                  }
               _loc2_[_loc4_]=param1[_loc3_];
            }
         return _loc2_;
      }

      private function needsRecursing(param1:*) : Boolean {
         return !(param1 is Number||param1 is String||param1 is Boolean);
      }

      public function onXMPData(param1:Object) : void {
         this._clip.dispatchNetStreamEvent("onXMPData",param1);
         return;
      }

      public function onCaption(param1:String, param2:Number) : void {
         this._clip.dispatchNetStreamEvent("onCaption",{cps:param1,
         spk:param2});
         return;
      }

      public function onCaptionInfo(param1:Object) : void {
         this._clip.dispatchNetStreamEvent("onCaptionInfo",param1);
         return;
      }

      public function onImageData(param1:Object) : void {
         this._clip.dispatchNetStreamEvent("onImageData",param1);
         return;
      }

      public function RtmpSampleAccess(param1:Object) : void {
         this._clip.dispatchNetStreamEvent("RtmpSampleAccess",param1);
         return;
      }

      public function onTextData(param1:Object) : void {
         this._clip.dispatchNetStreamEvent("onTextData",param1);
         return;
      }

      public function onPlayStatus(... rest) : void {
         var _loc2_:Object = rest.length<1?rest[2]:rest[0];
         this._clip.dispatch(ClipEventType.PLAY_STATUS,_loc2_);
         return;
      }

      private function addStreamCallback(param1:String, param2:Function) : void {
         this.log.debug("registering callback "+param1);
         this[param1]=param2;
         return;
      }

      public function registerCallback(param1:String) : void {
         this._clip.dispatchNetStreamEvent("registerCallback",param1);
         return;
      }
   }

}