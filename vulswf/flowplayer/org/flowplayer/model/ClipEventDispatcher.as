package org.flowplayer.model
{
   import org.flowplayer.flow_internal;
   import flash.utils.Dictionary;

   use namespace flow_internal;

   public class ClipEventDispatcher extends EventDispatcher
   {
         

      public function ClipEventDispatcher() {
         super();
         return;
      }



      public function dispatch(param1:ClipEventType, param2:Object=null, param3:Object=null, param4:Object=null) : void {
         doDispatchEvent(new ClipEvent(param1,param2,param3,param4),false);
         return;
      }

      public function dispatchError(param1:ClipError, param2:Object=null) : void {
         doDispatchErrorEvent(new ClipEvent(param1.eventType,param1,param2),false);
         return;
      }

      public function dispatchEvent(param1:ClipEvent) : void {
         doDispatchEvent(param1,false);
         return;
      }

      public function dispatchBeforeEvent(param1:AbstractEvent) : Boolean {
         return doDispatchBeforeEvent(param1,false);
      }

      public function onUpdate(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.UPDATE,param1,param2,false,param3);
         return;
      }

      public function onBeforeAll(param1:Function, param2:Function=null) : void {
         setListener(null,param1,param2,true);
         return;
      }

      public function onAll(param1:Function, param2:Function=null) : void {
         setListener(null,param1,param2);
         return;
      }

      public function onConnect(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.CONNECT,param1,param2,false,param3);
         return;
      }

      public function onStart(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.START,param1,param2,false,param3);
         return;
      }

      public function onMetaData(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.METADATA,param1,param2,false,param3);
         return;
      }

      public function onBeforeBegin(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.BEGIN,param1,param2,true,param3);
         return;
      }

      public function onBegin(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.BEGIN,param1,param2,false,param3);
         return;
      }

      public function onBeforePause(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.PAUSE,param1,param2,true,param3);
         return;
      }

      public function onPause(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.PAUSE,param1,param2,false,param3);
         return;
      }

      public function onBeforeResume(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.RESUME,param1,param2,true,param3);
         return;
      }

      public function onResume(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.RESUME,param1,param2,false,param3);
         return;
      }

      public function onBeforeStop(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.STOP,param1,param2,true,param3);
         return;
      }

      public function onStop(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.STOP,param1,param2,false,param3);
         return;
      }

      public function onFinish(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.FINISH,param1,param2,false,param3);
         return;
      }

      public function onBeforeFinish(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.FINISH,param1,param2,true,param3);
         return;
      }

      public function onCuepoint(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.CUEPOINT,param1,param2,false,param3);
         return;
      }

      public function onBeforeSeek(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.SEEK,param1,param2,true,param3);
         return;
      }

      public function onSeek(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.SEEK,param1,param2,false,param3);
         return;
      }

      public function onBufferEmpty(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.BUFFER_EMPTY,param1,param2,false,param3);
         return;
      }

      public function onBufferFull(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.BUFFER_FULL,param1,param2,false,param3);
         return;
      }

      public function onBufferStop(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.BUFFER_STOP,param1,param2,false,param3);
         return;
      }

      public function onLastSecond(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.LAST_SECOND,param1,param2,false,param3);
         return;
      }

      public function onNetStreamEvent(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.NETSTREAM_EVENT,param1,param2,false,param3);
         return;
      }

      public function onConnectionEvent(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.CONNECTION_EVENT,param1,param2,false,param3);
         return;
      }

      public function onError(param1:Function, param2:Function=null, param3:Boolean=false) : void {
         setListener(ClipEventType.ERROR,param1,param2,false,param3);
         return;
      }

      public function onPlaylistReplace(param1:Function, param2:Boolean=false) : void {
         setListener(ClipEventType.PLAYLIST_REPLACE,param1,null,false,param2);
         return;
      }

      public function onClipAdd(param1:Function, param2:Boolean=false) : void {
         setListener(ClipEventType.CLIP_ADD,param1,null,false,param2);
         return;
      }

      public function onResized(param1:Function, param2:Boolean=false) : void {
         setListener(ClipEventType.CLIP_RESIZED,param1,null,false,param2);
         return;
      }

      public function onPlayStatus(param1:Function, param2:Boolean=false) : void {
         setListener(ClipEventType.PLAY_STATUS,param1,null,false,param2);
         return;
      }

      public function onSwitch(param1:Function, param2:Boolean=false) : void {
         setListener(ClipEventType.SWITCH,param1,null,false,param2);
         return;
      }

      public function onSwitchFailed(param1:Function, param2:Boolean=false) : void {
         setListener(ClipEventType.SWITCH_FAILED,param1,null,false,param2);
         return;
      }

      public function onSwitchComplete(param1:Function, param2:Boolean=false) : void {
         setListener(ClipEventType.SWITCH_COMPLETE,param1,null,false,param2);
         return;
      }

      public function onStageVideoStateChange(param1:Function, param2:Boolean=false) : void {
         setListener(ClipEventType.STAGE_VIDEO_STATE_CHANGE,param1,null,false,param2);
         return;
      }

      override  protected function get cancellableEvents() : Dictionary {
         return ClipEventType.cancellable;
      }

      override  protected function get allEvents() : Dictionary {
         return ClipEventType.all;
      }
   }

}