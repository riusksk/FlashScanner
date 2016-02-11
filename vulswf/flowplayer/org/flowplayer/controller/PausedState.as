package org.flowplayer.controller
{
   import org.flowplayer.model.ClipEventSupport;
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.State;
   import org.flowplayer.model.Playlist;
   import flash.utils.Dictionary;


   class PausedState extends PlayState
   {
         

      function PausedState(param1:State, param2:Playlist, param3:PlayListController, param4:Dictionary) {
         super(param1,param2,param3,param4);
         return;
      }



      override  protected function setEventListeners(param1:ClipEventSupport, param2:Boolean=true) : void {
         if(param2)
            {
               log.debug("adding event listeners");
               param1.onStop(onClipStop);
            }
         else
            {
               param1.unbind(onClipStop);
            }
         return;
      }

      override function play() : void {
         this.resume();
         return;
      }

      override function resume(param1:Boolean=false) : void {
         log.debug("resume(), changing to stage "+playingState);
         if((param1)||(dispatchBeforeEvent(ClipEventType.RESUME,[param1])))
            {
               changeState(playingState);
               onEvent(ClipEventType.RESUME,[param1]);
            }
         return;
      }

      override function stopBuffering() : void {
         log.debug("stopBuffering() called");
         stop(true);
         return;
      }

      override function seekTo(param1:Number, param2:Boolean=false) : void {
         if((param2)||(dispatchBeforeEvent(ClipEventType.SEEK,[param1,param2],param1)))
            {
               onEvent(ClipEventType.SEEK,[param1,param2]);
            }
         return;
      }

      override function switchStream(param1:Object=null) : void {
         log.debug("switchStream()");
         if(dispatchBeforeEvent(ClipEventType.SWITCH,[param1]))
            {
               onEvent(ClipEventType.SWITCH,[param1]);
            }
         return;
      }
   }

}