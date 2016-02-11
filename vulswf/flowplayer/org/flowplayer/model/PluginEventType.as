package org.flowplayer.model
{
   import flash.utils.Dictionary;


   public class PluginEventType extends EventType
   {
         

      public function PluginEventType(param1:String) {
         super(param1);
         if(!_allValues)
            {
               _allValues=new Dictionary();
            }
         _allValues[param1]=this;
         return;
      }

      public static const PLUGIN_EVENT:PluginEventType = new (PluginEventType)("onPluginEvent");

      public static const LOAD:PluginEventType = new (PluginEventType)("onLoad");

      public static const ERROR:PluginEventType = new (PluginEventType)("onError");

      private static var _allValues:Dictionary;

      private static var _cancellable:Dictionary = new Dictionary();

      public static function get cancellable() : Dictionary {
         return _cancellable;
      }

      public static function get all() : Dictionary {
         return _allValues;
      }

      override  public function get isCancellable() : Boolean {
         return _cancellable[this.name];
      }

      public function toString() : String {
         return "[PluginEventType] \'"+name+"\'";
      }
   }

}