package org.flowplayer.config
{
   import org.flowplayer.util.Log;
   import org.flowplayer.flow_internal;
   import com.adobe.serialization.json.JSON;
   import org.flowplayer.controller.ResourceLoader;

   use namespace flow_internal;

   public class ConfigParser extends Object
   {
         

      public function ConfigParser() {
         super();
         return;
      }

      private static var log:Log = new Log(ConfigParser);

      flow_internal  static function parse(param1:String) : Object {
         return com.adobe.serialization.json.JSON.decode(param1);
      }

      flow_internal  static function parseConfig(param1:Object, param2:Object, param3:String, param4:String, param5:String) : Config {
         if(!param1)
            {
               return new Config({},param2,param3,param4,param5);
            }
         var _loc6_:Object = param1 is String?com.adobe.serialization.json.JSON.decode(param1 as String):param1;
         return new Config(_loc6_,param2,param3,param4,param5);
      }

      flow_internal  static function loadConfig(param1:String, param2:Object, param3:Function, param4:ResourceLoader, param5:String, param6:String, param7:String) : void {
         var fileName:String = param1;
         var builtInConfig:Object = param2;
         var listener:Function = param3;
         var loader:ResourceLoader = param4;
         var playerSwfName:String = param5;
         var controlsVersion:String = param6;
         var audioVersion:String = param7;
         loader.load(fileName,new function(param1:ResourceLoader):void
            {
               listener(parseConfig(param1.getContent(),builtInConfig,playerSwfName,controlsVersion,audioVersion));
               return;
               },true);
               return;
      }


   }

}