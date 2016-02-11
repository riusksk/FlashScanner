package org.flowplayer.controller
{
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.Status;
   import org.flowplayer.model.State;


   public interface MediaController
   {
         



      function onEvent(param1:ClipEventType, param2:Array=null) : void;

      function getStatus(param1:State) : Status;

      function get time() : Number;
   }

}