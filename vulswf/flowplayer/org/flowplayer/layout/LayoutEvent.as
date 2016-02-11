package org.flowplayer.layout
{
   import flash.events.Event;


   public class LayoutEvent extends Event
   {
         

      public function LayoutEvent(param1:String, param2:Layout, param3:Boolean=false, param4:Boolean=true) {
         super(param1,param3,param4);
         this.layout=param2;
         return;
      }

      public static const RESIZE:String = "resize";

      public var layout:Layout;

      override  public function clone() : Event {
         return new LayoutEvent(type,this.layout,bubbles,cancelable);
      }

      override  public function toString() : String {
         return formatToString("ResizeEvent","type","layout","bubbles","cancelable","eventPhase");
      }
   }

}