package org.flowplayer.controller
{
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.ClipEventSupport;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.State;
   import org.flowplayer.model.Playlist;
   import flash.utils.Dictionary;


   class PlayingState extends PlayState
   {
         

      function PlayingState(param1:State, param2:Playlist, param3:PlayListController, param4:Dictionary) {
         super(param1,param2,param3,param4);
         this._inStreamTracker=new InStreamTracker(param3);
         playList.onStart(this.onStart,this.hasMidstreamClips);
         playList.onResume(this.onResume,this.hasMidstreamClips);
         return;
      }



      private var _inStreamTracker:InStreamTracker;

      private function hasMidstreamClips(param1:Clip) : Boolean {
         var _loc2_:Array = param1.playlist;
         if(_loc2_.length==0)
            {
               return false;
            }
         var _loc3_:* = 0;
         while(_loc3_<_loc2_.length)
            {
               if(Clip(_loc2_[_loc3_]).isMidroll)
                  {
                     return true;
                  }
               _loc3_++;
            }
         return false;
      }

      override function play() : void {
         log.debug("play()");
         stop();
         bufferingState.nextStateAfterBufferFull=playingState;
         if(dispatchBeforeEvent(ClipEventType.BEGIN,[false]))
            {
               changeState(bufferingState);
               playList.current.played=true;
               onEvent(ClipEventType.BEGIN,[false]);
            }
         return;
      }

      override function switchStream(param1:Object=null) : void {
         log.debug("cannot start playing in this state");
         if(dispatchBeforeEvent(ClipEventType.SWITCH,[param1]))
            {
               onEvent(ClipEventType.SWITCH,[param1]);
            }
         return;
      }

      override  protected function setEventListeners(param1:ClipEventSupport, param2:Boolean=true) : void {
         if(param2)
            {
               log.debug("adding event listeners");
               param1.onPause(this.onPause);
               param1.onStop(this.onStop);
               param1.onFinish(this.onFinish);
               param1.onBeforeFinish(onClipDone);
               param1.onStop(this.onClipStop);
               param1.onSeek(this.onSeek,this.hasMidstreamClips);
               param1.onClipAdd(this.onClipAdd);
            }
         else
            {
               param1.unbind(this.onPause);
               param1.unbind(this.onStop);
               param1.unbind(this.onFinish);
               param1.unbind(onClipDone,ClipEventType.FINISH,true);
               param1.unbind(this.onClipStop);
               param1.unbind(this.onSeek);
               param1.unbind(this.onClipAdd);
            }
         return;
      }

      private function onClipAdd(param1:ClipEvent) : void {
         if(playList.current.playlist.length>0)
            {
               this._inStreamTracker.start();
            }
         return;
      }

      private function onStart(param1:ClipEvent) : void {
         log.debug("onStart");
         this._inStreamTracker.start(true);
         return;
      }

      private function onResume(param1:ClipEvent) : void {
         this._inStreamTracker.start();
         return;
      }

      private function onPause(param1:ClipEvent) : void {
         this._inStreamTracker.stop();
         return;
      }

      private function onStop(param1:ClipEvent) : void {
         this._inStreamTracker.stop();
         playList.setInStreamClip(null);
         return;
      }

      private function onFinish(param1:ClipEvent) : void {
         this._inStreamTracker.stop();
         removeOneShotClip(param1.target as Clip);
         return;
      }

      private function onSeek(param1:ClipEvent) : void {
         this._inStreamTracker.reset();
         this._inStreamTracker.start();
         return;
      }

      override function stopBuffering() : void {
         log.debug("stopBuffering() called");
         stop(true);
         return;
      }

      override function pause(param1:Boolean=false) : void {
         if((param1)||(dispatchBeforeEvent(ClipEventType.PAUSE,[param1])))
            {
               if((playList.current.live)&&(playList.current.stopLiveOnPause))
                  {
                     stop();
                     return;
                  }
               changeState(pausedState);
               onEvent(ClipEventType.PAUSE,[param1]);
            }
         return;
      }

      override function seekTo(param1:Number, param2:Boolean=false) : void {
         if((param2)||(dispatchBeforeEvent(ClipEventType.SEEK,[param1,param2],param1)))
            {
               onEvent(ClipEventType.SEEK,[param1,param2]);
            }
         return;
      }

      override  protected function onClipStop(param1:ClipEvent) : void {
         super.onClipStop(param1);
         var _loc2_:Clip = param1.target as Clip;
         if(_loc2_.isMidroll)
            {
               this._inStreamTracker.stop();
               this._inStreamTracker.reset();
            }
         return;
      }
   }

}