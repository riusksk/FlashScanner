package org.flowplayer.controller
{
   import org.flowplayer.model.Clip;
   import flash.events.NetStatusEvent;


   public interface ConnectionProvider
   {
         



      function set connectionClient(param1:Object) : void;

      function set onFailure(param1:Function) : void;

      function connect(param1:StreamProvider, param2:Clip, param3:Function, param4:uint, param5:Array) : void;

      function handeNetStatusEvent(param1:NetStatusEvent) : Boolean;
   }

}