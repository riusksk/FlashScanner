package org.flowplayer.model
{
   import flash.utils.Dictionary;


   public class ClipEventType extends EventType
   {
         

      public function ClipEventType(param1:String, param2:Boolean=false) {
         super(param1,param2);
         if(!_allValues)
            {
               _allValues=new Dictionary();
            }
         _allValues[param1]=this;
         return;
      }

      public static const CONNECT:ClipEventType = new (ClipEventType)("onConnect");

      public static const BEGIN:ClipEventType = new (ClipEventType)("onBegin");

      public static const METADATA:ClipEventType = new (ClipEventType)("onMetaData");

      public static const START:ClipEventType = new (ClipEventType)("onStart");

      public static const PAUSE:ClipEventType = new (ClipEventType)("onPause");

      public static const RESUME:ClipEventType = new (ClipEventType)("onResume");

      public static const STOP:ClipEventType = new (ClipEventType)("onStop");

      public static const FINISH:ClipEventType = new (ClipEventType)("onFinish");

      public static const CUEPOINT:ClipEventType = new (ClipEventType)("onCuepoint");

      public static const SEEK:ClipEventType = new (ClipEventType)("onSeek");

      public static const SWITCH:ClipEventType = new (ClipEventType)("onSwitch");

      public static const SWITCH_FAILED:ClipEventType = new (ClipEventType)("onSwitchFailed");

      public static const SWITCH_COMPLETE:ClipEventType = new (ClipEventType)("onSwitchComplete");

      public static const BUFFER_EMPTY:ClipEventType = new (ClipEventType)("onBufferEmpty");

      public static const BUFFER_FULL:ClipEventType = new (ClipEventType)("onBufferFull");

      public static const BUFFER_STOP:ClipEventType = new (ClipEventType)("onBufferStop");

      public static const LAST_SECOND:ClipEventType = new (ClipEventType)("onLastSecond");

      public static const UPDATE:ClipEventType = new (ClipEventType)("onUpdate");

      public static const ERROR:ClipEventType = new (ClipEventType)("onError");

      public static const NETSTREAM_EVENT:ClipEventType = new (ClipEventType)("onNetStreamEvent");

      public static const CONNECTION_EVENT:ClipEventType = new (ClipEventType)("onConnectionEvent");

      public static const PLAY_STATUS:ClipEventType = new (ClipEventType)("onPlayStatus");

      public static const PLAYLIST_REPLACE:ClipEventType = new (ClipEventType)("onPlaylistReplace");

      public static const CLIP_ADD:ClipEventType = new (ClipEventType)("onClipAdd");

      public static const CLIP_RESIZED:ClipEventType = new (ClipEventType)("onResized");

      public static const STAGE_VIDEO_STATE_CHANGE:ClipEventType = new (ClipEventType)("onStageVideoStateChange");

      private static var _allValues:Dictionary;

      private static var _cancellable:Dictionary = new Dictionary();

      public static function get cancellable() : Dictionary {
         return _cancellable;
      }

      public static function get all() : Dictionary {
         return _allValues;
      }

      public static function forName(param1:String) : ClipEventType {
         return _allValues[param1];
      }

      override  public function get isCancellable() : Boolean {
         return _cancellable[this.name];
      }

      public function toString() : String {
         return "[ClipEventType] \'"+name+"\'";
      }

      public function get playlistIsEventTarget() : Boolean {
         return this==PLAYLIST_REPLACE||this==CLIP_ADD;
      }
   }

}