package org.goasap.interfaces
{
   import flash.events.IEventDispatcher;


   public interface IPlayableBase extends IEventDispatcher
   {
         



      function get state() : String;

      function get playableID() : *;

      function set playableID(param1:*) : void;
   }

}