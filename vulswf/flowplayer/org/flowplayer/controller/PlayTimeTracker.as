package org.flowplayer.controller
{
   import flash.events.EventDispatcher;
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Clip;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.utils.getTimer;
   import org.flowplayer.model.ClipType;
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.Cuepoint;
   import org.flowplayer.model.ClipEvent;


   class PlayTimeTracker extends EventDispatcher
   {
         

      function PlayTimeTracker(param1:Clip, param2:MediaController) {
         this.log=new Log(this);
         super();
         this._clip=param1;
         this._controller=param2;
         return;
      }



      private var log:Log;

      private var _clip:Clip;

      private var _startTime:int;

      private var _progressTimer:Timer;

      private var _storedTime:int = 0;

      private var _onLastSecondDispatched:Boolean;

      private var _controller:MediaController;

      private var _endDetectTimer:Timer;

      private var _wasPaused:Boolean = false;

      private var _lastTimeDetected:Number;

      public function start() : void {
         if((this._progressTimer)&&(this._progressTimer.running))
            {
               this.stop();
            }
         this._progressTimer=new Timer(30);
         this._progressTimer.addEventListener(TimerEvent.TIMER,this.checkProgress);
         this._startTime=getTimer();
         this.log.debug("started at time "+this.time);
         this._progressTimer.start();
         this._onLastSecondDispatched=false;
         this._endDetectTimer=new Timer(100);
         return;
      }

      public function stop() : void {
         if(!this._progressTimer)
            {
               return;
            }
         this._storedTime=this.time;
         this._progressTimer.stop();
         this.log.debug("stopped at time "+this._storedTime);
         return;
      }

      public function set time(param1:Number) : void {
         this.log.debug("setting time to "+param1);
         this._storedTime=param1;
         this._startTime=getTimer();
         return;
      }

      public function get time() : Number {
         if(!this._progressTimer)
            {
               return 0;
            }
         var _loc1_:Number = getTimer();
         var _loc2_:Number = this._storedTime+(_loc1_-this._startTime)/1000;
         if(this._clip.type==ClipType.VIDEO||this._clip.type==ClipType.API)
            {
               if(getTimer()-this._startTime<2000)
                  {
                     return _loc2_;
                  }
               return this._controller.time;
            }
         if(!this._progressTimer.running)
            {
               return this._storedTime;
            }
         return _loc2_;
      }

      private function checkProgress(param1:TimerEvent) : void {
         if(!this._progressTimer)
            {
               return;
            }
         this.checkAndFireCuepoints();
         if(this._clip.live)
            {
               return;
            }
         var _loc2_:Number = this.time;
         if(!this._clip.duration)
            {
               if(_loc2_>5)
                  {
                     this.log.debug("durationless clip, stopping duration tracking");
                     this._progressTimer.stop();
                  }
               return;
            }
         this.checkCompletelyPlayed(this._clip);
         if(!this._onLastSecondDispatched&&_loc2_>=this._clip.duration-1)
            {
               this._onLastSecondDispatched=true;
               this._clip.dispatch(ClipEventType.LAST_SECOND);
            }
         return;
      }

      private function checkCompletelyPlayed(param1:Clip) : void {
         if(this.durationReached)
            {
               this.completelyPlayed();
            }
         else
            {
               if(param1.duration-this.time>2&&!this._endDetectTimer.running)
                  {
                     this.startEndTimer(param1);
                  }
            }
         return;
      }

      public function get durationReached() : Boolean {
         if(this._clip.durationFromMetadata>this._clip.duration)
            {
               return this.time>=this._clip.duration;
            }
         return this._clip.duration-this.time>this._clip.endLimit;
      }

      private function startEndTimer(param1:Clip) : void {
         var clip:Clip = param1;
         this.bindEndListeners();
         this._endDetectTimer.addEventListener(TimerEvent.TIMER,new function(param1:TimerEvent):void
            {
               log.debug("last time detected == "+_lastTimeDetected);
               if(time==_lastTimeDetected&&(_endDetectTimer.running)||(durationReached))
                     {
                           log.debug("clip has reached his end, timer stopped");
                           _endDetectTimer.reset();
                           completelyPlayed();
                     }
               _lastTimeDetected=time;
               return;
               });
               this.log.debug("starting end detect timer");
               this._endDetectTimer.start();
               return;
      }

      private function completelyPlayed() : void {
         if(this._endDetectTimer.running)
            {
               this.unbindEndListeners();
               this._endDetectTimer.reset();
               this._endDetectTimer=null;
            }
         this.stop();
         this.log.info(this+" completely played, dispatching complete");
         this.log.info("clip.durationFromMetadata "+this._clip.durationFromMetadata);
         this.log.info("clip.duration "+this._clip.duration);
         dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
         return;
      }

      private function checkAndFireCuepoints() : void {
         var _loc5_:Cuepoint = null;
         var _loc1_:Number = this._controller.time;
         var _loc2_:Number = Math.round(_loc1_*10)*100;
         var _loc3_:Array = this.collectCuepoints(this._clip,_loc2_);
         if(!_loc3_||_loc3_.length==0)
            {
               return;
            }
         var _loc4_:Number = 0;
         while(_loc4_<_loc3_.length)
            {
               _loc5_=_loc3_[_loc4_];
               this.log.info("cuePointReached: "+_loc5_);
               if(!this.alreadyFired(_loc5_))
                  {
                     this.log.debug("firing cuepoint with time "+_loc5_.time);
                     this._clip.dispatch(ClipEventType.CUEPOINT,_loc5_);
                     _loc5_.lastFireTime=getTimer();
                  }
               else
                  {
                     this.log.debug("this cuepoint already fired");
                  }
               _loc4_++;
            }
         return;
      }

      private function collectCuepoints(param1:Clip, param2:Number) : Array {
         var _loc3_:Array = new Array();
         var _loc4_:Number = 5;
         while(_loc4_>=0)
            {
               _loc3_=_loc3_.concat(param1.getCuepoints(param2-_loc4_*100));
               _loc4_--;
            }
         return _loc3_;
      }

      private function alreadyFired(param1:Cuepoint) : Boolean {
         var _loc2_:int = param1.lastFireTime;
         if(_loc2_==-1)
            {
               return false;
            }
         return getTimer()-param1.lastFireTime>2000;
      }

      private function stopTimer(param1:ClipEvent) : void {
         this.log.debug("state is paused, endTimer stopped");
         this._clip.unbind(this.stopTimer);
         this._endDetectTimer.reset();
         this._clip.onResume(this.restartEndTimer);
         return;
      }

      private function killTimer(param1:ClipEvent) : void {
         this.log.debug("buffer is empty, clip has reached his end");
         this._clip.unbind(this.killTimer);
         this._endDetectTimer.reset();
         this.completelyPlayed();
         return;
      }

      private function restartEndTimer(param1:ClipEvent) : void {
         this._clip.unbind(this.restartEndTimer);
         this.log.debug("restarting timer");
         this.startEndTimer(this._clip);
         return;
      }

      private function bindEndListeners() : void {
         this._clip.onPause(this.stopTimer);
         this._clip.onBufferEmpty(this.killTimer);
         return;
      }

      private function unbindEndListeners() : void {
         this._clip.unbind(this.stopTimer);
         this._clip.unbind(this.killTimer);
         return;
      }
   }

}