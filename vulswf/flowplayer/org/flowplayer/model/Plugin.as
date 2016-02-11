package org.flowplayer.model
{
   import org.flowplayer.view.Flowplayer;


   public interface Plugin
   {
         



      function onConfig(param1:PluginModel) : void;

      function onLoad(param1:Flowplayer) : void;

      function getDefaultConfig() : Object;
   }

}