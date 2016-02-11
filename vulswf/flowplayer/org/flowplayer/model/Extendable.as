package org.flowplayer.model
{


   public interface Extendable
   {
         



      function set customProperties(param1:Object) : void;

      function get customProperties() : Object;

      function setCustomProperty(param1:String, param2:Object) : void;

      function getCustomProperty(param1:String) : Object;

      function deleteCustomProperty(param1:String) : void;
   }

}