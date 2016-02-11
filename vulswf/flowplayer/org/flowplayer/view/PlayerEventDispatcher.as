package org.flowplayer.view
{
   import org.flowplayer.model.EventDispatcher;
   import org.flowplayer.model.PlayerEventType;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.PlayerEvent;
   import org.flowplayer.model.ErrorCode;
   import flash.utils.Dictionary;

   use namespace flow_internal;

   public class PlayerEventDispatcher extends EventDispatcher
   {
         

      public function PlayerEventDispatcher() {
         super();
         return;
      }



      public function dispatch(param1:PlayerEventType, param2:Object=null, param3:Boolean=true) : void {
         doDispatchEvent(new PlayerEvent(param1,param2),param3);
         return;
      }

      public function dispatchEvent(param1:PlayerEvent) : void {
         doDispatchEvent(param1,true);
         return;
      }

      public function dispatchError(param1:ErrorCode, param2:Object=null) : void {
         doDispatchErrorEvent(new PlayerEvent(param1.eventType,param1,param2),true);
         return;
      }

      public function dispatchBeforeEvent(param1:PlayerEvent) : Boolean {
         return doDispatchBeforeEvent(param1,true);
      }

      public function onLoad(param1:Function) : void {
         setListener(PlayerEventType.LOAD,param1);
         return;
      }

      public function onUnload(param1:Function) : void {
         setListener(PlayerEventType.UNLOAD,param1);
         return;
      }

      public function onBeforeFullscreen(param1:Function) : void {
         setListener(PlayerEventType.FULLSCREEN,param1,null,true);
         return;
      }

      public function onFullscreen(param1:Function) : void {
         log.debug("adding listener for fullscreen "+PlayerEventType.FULLSCREEN);
         setListener(PlayerEventType.FULLSCREEN,param1);
         return;
      }

      public function onFullscreenExit(param1:Function) : void {
         setListener(PlayerEventType.FULLSCREEN_EXIT,param1);
         return;
      }

      public function onMute(param1:Function) : void {
         setListener(PlayerEventType.MUTE,param1);
         return;
      }

      public function onUnmute(param1:Function) : void {
         setListener(PlayerEventType.UNMUTE,param1);
         return;
      }

      public function onVolume(param1:Function) : void {
         setListener(PlayerEventType.VOLUME,param1);
         return;
      }

      public function onMouseOver(param1:Function) : void {
         setListener(PlayerEventType.MOUSE_OVER,param1);
         return;
      }

      public function onMouseOut(param1:Function) : void {
         setListener(PlayerEventType.MOUSE_OUT,param1);
         return;
      }

      override  protected function get cancellableEvents() : Dictionary {
         return PlayerEventType.cancellable;
      }

      override  protected function get allEvents() : Dictionary {
         return PlayerEventType.all;
      }
   }

}