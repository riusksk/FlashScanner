package org.flowplayer.controller
{
   import org.flowplayer.model.Clip;
   import flash.events.NetStatusEvent;


   public interface ClipURLResolver
   {
         



      function set onFailure(param1:Function) : void;

      function resolve(param1:StreamProvider, param2:Clip, param3:Function) : void;

      function handeNetStatusEvent(param1:NetStatusEvent) : Boolean;
   }

}