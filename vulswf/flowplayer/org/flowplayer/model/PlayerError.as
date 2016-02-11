package org.flowplayer.model
{


   public class PlayerError extends ErrorCode
   {
         

      public function PlayerError(param1:EventType, param2:int, param3:String) {
         super(param1,param2,param3);
         return;
      }

      public static const INIT_FAILED:PlayerError = new (PlayerError)(PlayerEventType.ERROR,300,"Player initialization failed");

      public static const PLUGIN_LOAD_FAILED:PlayerError = new (PlayerError)(PlayerEventType.ERROR,301,"Unable to load plugin");

      public static const PLUGIN_INVOKE_FAILED:PlayerError = new (PlayerError)(PlayerEventType.ERROR,302,"Error when invoking plugin external method");

      public static const RESOURCE_LOAD_FAILED:PlayerError = new (PlayerError)(PlayerEventType.ERROR,303,"Failed to load a resource");

      public static const INSTREAM_PLAY_NOTPLAYING:PlayerError = new (PlayerError)(PlayerEventType.ERROR,304,"Cannot start instream playback, when not playing currently");


   }

}