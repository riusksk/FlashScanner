package org.flowplayer.controller
{


   public interface NetStreamCallbacks
   {
         



      function onMetaData(param1:Object) : void;

      function onXMPData(param1:Object) : void;

      function onCaption(param1:String, param2:Number) : void;

      function onCaptionInfo(param1:Object) : void;

      function onImageData(param1:Object) : void;

      function RtmpSampleAccess(param1:Object) : void;

      function onTextData(param1:Object) : void;
   }

}