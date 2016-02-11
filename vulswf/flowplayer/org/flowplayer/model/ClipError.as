package org.flowplayer.model
{


   public class ClipError extends ErrorCode
   {
         

      public function ClipError(param1:EventType, param2:int, param3:String) {
         super(param1,param2,param3);
         return;
      }

      public static const STREAM_NOT_FOUND:ClipError = new (ClipError)(ClipEventType.ERROR,200,"Stream not found");

      public static const STREAM_LOAD_FAILED:ClipError = new (ClipError)(ClipEventType.ERROR,201,"Unable to load stream or clip file");

      public static const PROVIDER_NOT_LOADED:ClipError = new (ClipError)(ClipEventType.ERROR,202,"The provider specified in this clip is not loaded");


   }

}