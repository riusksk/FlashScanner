package org.flowplayer.controller
{
   import org.flowplayer.view.ErrorHandler;


   public interface ResourceLoader
   {
         



      function addTextResourceUrl(param1:String) : void;

      function addBinaryResourceUrl(param1:String) : void;

      function clear() : void;

      function set completeListener(param1:Function) : void;

      function set errorHandler(param1:ErrorHandler) : void;

      function load(param1:String=null, param2:Function=null, param3:Boolean=false) : void;

      function getContent(param1:String=null) : Object;

      function get loadComplete() : Boolean;
   }

}