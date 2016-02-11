package org.flowplayer.model
{


   public class PluginError extends ErrorCode
   {
         

      public function PluginError(param1:int, param2:String) {
         super(PluginEventType.ERROR,param1,param2);
         return;
      }

      public static const INIT_FAILED:PluginError = new (PluginError)(100,"Plugin initialization failed");

      public static const ERROR:PluginError = new (PluginError)(200,"Error occurred in a plugin");


   }

}