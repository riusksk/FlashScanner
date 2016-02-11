package org.flowplayer.model
{
   import org.flowplayer.flow_internal;

   use namespace flow_internal;

   public class ClipEventSupport extends ClipEventDispatcher
   {
         

      public function ClipEventSupport(param1:Clip, param2:Array=null) {
         super();
         this._commonClip=param1;
         this._clips=param2;
         return;
      }

      public static function typeFilter(param1:ClipType) : Function {
         var type:ClipType = param1;
         return new function(param1:Clip):Boolean
            {
               return param1.type==type;
            };
      }

      private var _clips:Array;

      private var _commonClip:Clip;

      flow_internal function setClips(param1:Array) : void {
         this._clips=param1;
         return;
      }

      flow_internal function get allClips() : Array {
         return this._clips;
      }

      public function get clips() : Array {
         return this._clips.filter(new function(param1:*, param2:int, param3:Array):Boolean
            {
               return !Clip(param1).isInStream;
               });
      }

      override flow_internal function setListener(param1:EventType, param2:Function, param3:Function=null, param4:Boolean=false, param5:Boolean=false) : void {
         var _loc6_:ClipEventType = param1 as ClipEventType;
         if((_loc6_)&&(_loc6_.playlistIsEventTarget))
            {
               super.setListener(_loc6_,param2,param3,param4,param5);
            }
         else
            {
               this._commonClip.setListener(_loc6_,param2,param3,param4,param5);
            }
         return;
      }

      override function removeListener(param1:EventType, param2:Function, param3:Boolean=false) : void {
         var _loc4_:ClipEventType = param1 as ClipEventType;
         if(_loc4_.playlistIsEventTarget)
            {
               super.removeListener(param1,param2,param3);
            }
         else
            {
               this._commonClip.removeListener(param1,param2,param3);
            }
         return;
      }

      public function get childClips() : Array {
         var _loc1_:Array = new Array();
         var _loc2_:* = 0;
         while(_loc2_<this._clips.length)
            {
               _loc1_=_loc1_.concat(Clip(this._clips[_loc2_]).playlist);
               _loc2_++;
            }
         return _loc1_;
      }
   }

}