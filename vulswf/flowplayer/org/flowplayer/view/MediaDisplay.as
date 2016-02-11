package org.flowplayer.view
{
   import org.flowplayer.model.Clip;


   interface MediaDisplay
   {
         



      function init(param1:Clip) : void;

      function hasContent() : Boolean;
   }

}