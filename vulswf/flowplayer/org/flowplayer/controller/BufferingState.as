package org.flowplayer.controller
{
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.ClipEventSupport;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.Status;
   import org.flowplayer.model.State;
   import org.flowplayer.model.Playlist;
   import flash.utils.Dictionary;

   use namespace flow_internal;

   class BufferingState extends PlayState
   {
         

      function BufferingState(param1:State, param2:Playlist, param3:PlayListController, param4:Dictionary) {
         super(param1,param2,param3,param4);
         return;
      }



      private var _nextStateAfterBufferFull:PlayState;

      override function play() : void {
         log.debug("play()");
         stop();
         bufferingState.nextStateAfterBufferFull=playingState;
         if(dispatchBeforeEvent(ClipEventType.BEGIN,[false]))
            {
               playList.current.played=true;
               changeState(bufferingState);
               onEvent(ClipEventType.BEGIN,[false]);
            }
         return;
      }

      override function stopBuffering() : void {
         log.debug("stopBuffering() called");
         stop(true);
         return;
      }

      override function pause(param1:Boolean=false) : void {
         if(dispatchBeforeEvent(ClipEventType.PAUSE,[param1]))
            {
               changeState(pausedState);
               onEvent(ClipEventType.PAUSE,[param1]);
            }
         return;
      }

      override function seekTo(param1:Number, param2:Boolean=false) : void {
         if((param2)||(dispatchBeforeEvent(ClipEventType.SEEK,[param1,param2])))
            {
               onEvent(ClipEventType.SEEK,[param1]);
            }
         return;
      }

      override  protected function setEventListeners(param1:ClipEventSupport, param2:Boolean=true) : void {
         if(param2)
            {
               param1.onBufferFull(this.moveState);
               param1.onPause(this.moveState);
               param1.onError(this.onError);
            }
         else
            {
               param1.unbind(this.moveState);
               param1.unbind(this.onError);
            }
         return;
      }

      private function onError(param1:ClipEvent) : void {
         getMediaController().onEvent(ClipEventType.STOP);
         return;
      }

      private function moveState(param1:ClipEvent) : void {
         log.debug("moving to state "+this._nextStateAfterBufferFull);
         playListController.setPlayState(this._nextStateAfterBufferFull);
         return;
      }

      public function set nextStateAfterBufferFull(param1:PlayState) : void {
         this._nextStateAfterBufferFull=param1;
         return;
      }

      override function get status() : Status {
         return getMediaController().getStatus(state);
      }
   }

}