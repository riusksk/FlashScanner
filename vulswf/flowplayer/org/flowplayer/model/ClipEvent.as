package org.flowplayer.model
{
   import flash.events.Event;


   public class ClipEvent extends AbstractEvent
   {
         

      public function ClipEvent(param1:EventType, param2:Object=null, param3:Object=null, param4:Object=null) {
         super(param1,param2,param3,param4);
         return;
      }



      override  public function clone() : Event {
         return new ClipEvent(eventType,info);
      }

      override  public function toString() : String {
         return formatToString("ClipEvent","type","info");
      }

      override  protected function get externalEventArgument() : Object {
         if(eventType==ClipEventType.PLAYLIST_REPLACE)
            {
               return (target as ClipEventSupport).clips;
            }
         if(eventType==ClipEventType.CLIP_ADD)
            {
               return (info2)||((target as ClipEventSupport).clips[info]);
            }
         if(target is Clip)
            {
               return Clip(target).index;
            }
         return target;
      }

      override  protected function get externalEventArgument2() : Object {
         if(eventType==ClipEventType.CUEPOINT)
            {
               return Cuepoint(info).callbackId;
            }
         if([ClipEventType.START,ClipEventType.UPDATE,ClipEventType.METADATA,ClipEventType.RESUME,ClipEventType.BEGIN].indexOf(eventType)>=0)
            {
               return target;
            }
         return super.externalEventArgument2;
      }

      override  protected function get externalEventArgument3() : Object {
         if(eventType==ClipEventType.CLIP_ADD)
            {
               return null;
            }
         if(eventType==ClipEventType.CUEPOINT)
            {
               return info is DynamicCuepoint?info:Cuepoint(info).time;
            }
         return super.externalEventArgument3;
      }
   }

}