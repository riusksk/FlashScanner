package org.flowplayer.view
{
   import org.flowplayer.model.ErrorCode;


   public interface ErrorHandler
   {
         



      function showError(param1:String) : void;

      function handleError(param1:ErrorCode, param2:Object=null, param3:Boolean=true) : void;
   }

}