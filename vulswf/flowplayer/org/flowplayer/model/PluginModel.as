package org.flowplayer.model
{


   public interface PluginModel extends Identifiable, Callable, Cloneable
   {
         



      function get url() : String;

      function set url(param1:String) : void;

      function get isBuiltIn() : Boolean;

      function set isBuiltIn(param1:Boolean) : void;

      function dispatchOnLoad() : void;

      function dispatchError(param1:PluginError, param2:Object=null) : void;

      function dispatch(param1:PluginEventType, param2:Object=null, param3:Object=null, param4:Object=null, param5:Object=null) : void;

      function dispatchEvent(param1:PluginEvent) : void;

      function dispatchBeforeEvent(param1:PluginEventType, param2:Object=null, param3:Object=null, param4:Object=null, param5:Object=null) : Boolean;

      function onPluginEvent(param1:Function) : void;

      function onBeforePluginEvent(param1:Function) : void;

      function onLoad(param1:Function) : void;

      function onError(param1:Function) : void;

      function unbind(param1:Function, param2:EventType=null, param3:Boolean=false) : void;

      function get config() : Object;

      function set config(param1:Object) : void;

      function get pluginObject() : Object;

      function set pluginObject(param1:Object) : void;
   }

}