package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.Status;
   import org.flowplayer.model.State;
   import org.flowplayer.model.Clip;
   import flash.events.TimerEvent;


   class AbstractDurationTrackingController extends Object implements MediaController
   {
         

      function AbstractDurationTrackingController(param1:VolumeController, param2:Playlist) {
         this.log=new Log(this);
         super();
         this._volumeController=param1;
         this._playlist=param2;
         return;
      }



      protected var log:Log;

      protected var durationTracker:PlayTimeTracker;

      private var _volumeController:VolumeController;

      private var _playlist:Playlist;

      public final function onEvent(param1:ClipEventType, param2:Array=null) : void {
         var _loc3_:* = false;
         if(param1==ClipEventType.BEGIN)
            {
               this.load(new ClipEvent(param1),this.clip,param2?param2[0]:false);
            }
         else
            {
               if(param1==ClipEventType.PAUSE)
                  {
                     _loc3_=param2[0] as Boolean;
                     this.pause(_loc3_?null:new ClipEvent(param1));
                  }
               else
                  {
                     if(param1==ClipEventType.RESUME)
                        {
                           _loc3_=param2[0] as Boolean;
                           this.resume(_loc3_?null:new ClipEvent(param1));
                        }
                     else
                        {
                           if(param1==ClipEventType.STOP)
                              {
                                 this.stop(new ClipEvent(param1),param2?param2[0]:null,param2?param2[1]:null);
                              }
                           else
                              {
                                 if(param1==ClipEventType.SEEK)
                                    {
                                       _loc3_=param2[1] as Boolean;
                                       this.seekTo(_loc3_?null:new ClipEvent(param1,param2[0]),param2[0]);
                                    }
                                 else
                                    {
                                       if(param1==ClipEventType.SWITCH)
                                          {
                                             this.doSwitchStream(new ClipEvent(param1),this.clip,param2?param2[0]:null);
                                          }
                                    }
                              }
                        }
                  }
            }
         return;
      }

      protected final function dispatchPlayEvent(param1:ClipEvent) : void {
         if(!param1)
            {
               return;
            }
         this.log.debug("dispatching "+param1+" on clip "+this.clip);
         this.clip.dispatchEvent(param1);
         return;
      }

      public final function getStatus(param1:State) : Status {
         return new Status(param1,this.clip,this.time,this.bufferStart,this.bufferEnd,this.fileSize,this._volumeController.muted,this._volumeController.volume,this.allowRandomSeek);
      }

      private function createDurationTracker(param1:Clip) : void {
         if(this.durationTracker)
            {
               this.durationTracker.stop();
            }
         this.durationTracker=new PlayTimeTracker(param1,this);
         this.durationTracker.addEventListener(TimerEvent.TIMER_COMPLETE,this.durationReached);
         this.durationTracker.start();
         return;
      }

      public function get time() : Number {
         if(!this.durationTracker)
            {
               return 0;
            }
         var _loc1_:Number = this.durationTracker.time;
         return Math.min(_loc1_,this.clip.duration);
      }

      protected function get bufferStart() : Number {
         return 0;
      }

      protected function get bufferEnd() : Number {
         return 0;
      }

      protected function get fileSize() : Number {
         return 0;
      }

      protected function get allowRandomSeek() : Boolean {
         return false;
      }

      private final function durationReached(param1:TimerEvent) : void {
         this.log.info("durationReached()");
         if(this.durationTracker)
            {
               this.durationTracker.removeEventListener(TimerEvent.TIMER_COMPLETE,this.durationReached);
            }
         this.onDurationReached();
         if(this.clip.duration>0)
            {
               this.log.debug("dispatching FINISH from durationTracking, clip is "+this.clip);
               this.clip.dispatchBeforeEvent(new ClipEvent(ClipEventType.FINISH));
            }
         return;
      }

      protected function onDurationReached() : void {
         return;
      }

      private function load(param1:ClipEvent, param2:Clip, param3:Boolean=false) : void {
         param2.onPause(this.onPause);
         param2.onStart(this.onBegin);
         this.log.debug("calling doLoad");
         this.doLoad(param1,param2,param3);
         return;
      }

      private function onBegin(param1:ClipEvent) : void {
         this.log.debug("onBegin, creating and starting duration tracker");
         this.createDurationTracker(this.clip);
         return;
      }

      private function onPause(param1:ClipEvent) : void {
         if(!this.durationTracker)
            {
               return;
            }
         this.durationTracker.stop();
         return;
      }

      private function pause(param1:ClipEvent) : void {
         if(!this.durationTracker)
            {
               return;
            }
         this.durationTracker.stop();
         this.doPause(param1);
         return;
      }

      private function resume(param1:ClipEvent) : void {
         if(this.durationTracker)
            {
               if(this.durationTracker.durationReached)
                  {
                     this.log.debug("resume(): duration has been reached");
                     return;
                  }
               this.durationTracker.start();
            }
         this.doResume(param1);
         return;
      }

      private function stop(param1:ClipEvent, param2:Boolean, param3:Boolean=false) : void {
         this.log.debug("stop "+this.durationTracker);
         if(this.durationTracker)
            {
               this.durationTracker.stop();
               this.durationTracker.time=0;
            }
         this.doStop(param3?null:param1,param2);
         return;
      }

      private function seekTo(param1:ClipEvent, param2:Number) : void {
         if(!this.durationTracker)
            {
               this.createDurationTracker(this.clip);
            }
         this.doSeekTo(param1,param2);
         this.durationTracker.time=param2;
         return;
      }

      protected function get clip() : Clip {
         return this._playlist.current;
      }

      protected function get playlist() : Playlist {
         return this._playlist;
      }

      protected function doLoad(param1:ClipEvent, param2:Clip, param3:Boolean=false) : void {
         return;
      }

      protected function doPause(param1:ClipEvent) : void {
         return;
      }

      protected function doResume(param1:ClipEvent) : void {
         return;
      }

      protected function doStop(param1:ClipEvent, param2:Boolean) : void {
         return;
      }

      protected function doSeekTo(param1:ClipEvent, param2:Number) : void {
         return;
      }

      protected function doSwitchStream(param1:ClipEvent, param2:Clip, param3:Object=null) : void {
         return;
      }
   }

}