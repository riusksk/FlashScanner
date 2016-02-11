package org.flowplayer.model
{
   import flash.events.Event;


   public class PlayerEvent extends AbstractEvent
   {
         

      public function PlayerEvent(param1:EventType, param2:Object=null, param3:Object=null, param4:Object=null) {
         super(param1,param2,param3,param4);
         return;
      }

      public static function load(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.LOAD,param1);
      }

      public static function keyPress(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.KEYPRESS,param1);
      }

      public static function mute(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.MUTE,param1);
      }

      public static function unMute(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.UNMUTE,param1);
      }

      public static function volume(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.VOLUME,param1);
      }

      public static function fullscreen(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.FULLSCREEN,param1);
      }

      public static function fullscreenExit(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.FULLSCREEN_EXIT,param1);
      }

      public static function mouseOver(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.MOUSE_OVER,param1);
      }

      public static function mouseOut(param1:Object=null) : PlayerEvent {
         return new (PlayerEvent)(PlayerEventType.MOUSE_OUT,param1);
      }

      override  public function clone() : Event {
         return new PlayerEvent(eventType,info);
      }

      override  public function toString() : String {
         return formatToString("PlayerEvent","type","info");
      }

      override  protected function get externalEventArgument() : Object {
         return info;
      }

      override  protected function get externalEventArgument2() : Object {
         return info2;
      }

      override  protected function get externalEventArgument3() : Object {
         return info3;
      }

      override  protected function get externalEventArgument4() : Object {
         return null;
      }
   }

}