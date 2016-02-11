package org.flowplayer.model
{


   public interface Callable
   {
         



      function addMethod(param1:PluginMethod) : void;

      function getMethod(param1:String) : PluginMethod;

      function invokeMethod(param1:String, param2:Array=null) : Object;
   }

}