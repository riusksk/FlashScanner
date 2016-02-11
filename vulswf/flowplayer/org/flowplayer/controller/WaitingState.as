package org.flowplayer.controller
{
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.State;
   import org.flowplayer.model.Playlist;
   import flash.utils.Dictionary;


   class WaitingState extends PlayState
   {
         

      function WaitingState(param1:State, param2:Playlist, param3:PlayListController, param4:Dictionary) {
         super(param1,param2,param3,param4);
         return;
      }



      override function play() : void {
         log.debug("play()");
         if(!playListReady)
            {
               return;
            }
         bufferingState.nextStateAfterBufferFull=playingState;
         if(dispatchBeforeEvent(ClipEventType.BEGIN,[false],false))
            {
               playList.current.played=true;
               changeState(bufferingState);
               onEvent(ClipEventType.BEGIN,[false]);
            }
         return;
      }

      override function stop(param1:Boolean=false, param2:Boolean=false) : void {
         if(param1)
            {
               this.stop(true);
            }
         return;
      }

      override function startBuffering() : void {
         if(!playListReady)
            {
               return;
            }
         log.debug("startBuffering()");
         bufferingState.nextStateAfterBufferFull=pausedState;
         if(dispatchBeforeEvent(ClipEventType.BEGIN,[true],true))
            {
               changeState(bufferingState);
               onEvent(ClipEventType.BEGIN,[true]);
            }
         return;
      }
   }

}