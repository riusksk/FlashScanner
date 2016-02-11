package org.flowplayer.controller
{
   import flash.utils.Timer;
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Clip;
   import flash.events.TimerEvent;
   import org.flowplayer.flow_internal;

   use namespace flow_internal;

   public class InStreamTracker extends Object
   {
         

      public function InStreamTracker(param1:PlayListController) {
         this.log=new Log(this);
         super();
         this._controller=param1;
         return;
      }



      private var _controller:PlayListController;

      private var _timer:Timer;

      private var log:Log;

      private var _prevStartTime:Number = 0;

      public function start(param1:Boolean=false) : void {
         var _loc4_:Clip = null;
         this.log.debug("start()");
         if(!this.clip.hasChildren)
            {
               throw new Error("this clip does not have child clips");
            }
         if(param1)
            {
               this.reset();
            }
         var _loc2_:Array = this.clip.playlist;
         var _loc3_:* = 0;
         while(_loc3_<_loc2_.length)
            {
               _loc4_=_loc2_[_loc3_] as Clip;
               this.log.debug("start(): child clip at "+_loc4_.position+": "+_loc4_);
               _loc3_++;
            }
         if(!this._timer)
            {
               this._timer=new Timer(200);
               this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            }
         this._timer.start();
         return;
      }

      public function stop() : void {
         this.log.debug("stop()");
         if((this._timer)&&(this._timer.running))
            {
               this._timer.stop();
            }
         return;
      }

      private function onTimer(param1:TimerEvent) : void {
         var _loc2_:Number = this._controller.status.time;
         this.log.debug("time "+Math.round(_loc2_));
         var _loc3_:Clip = this.clip.getMidroll(_loc2_);
         if((_loc3_)&&_loc2_-this._prevStartTime<2)
            {
               this.stop();
               this.log.info("found child clip with start time "+_loc2_+": "+_loc3_);
               this._controller.playInstream(_loc3_);
               this._prevStartTime=_loc3_.position;
            }
         return;
      }

      private function get clip() : Clip {
         return this._controller.playlist.current;
      }

      public function reset() : void {
         this.log.debug("reset()");
         this._prevStartTime=0;
         return;
      }
   }

}