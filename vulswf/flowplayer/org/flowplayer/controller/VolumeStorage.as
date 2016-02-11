package org.flowplayer.controller
{


   interface VolumeStorage
   {
         



      function set volume(param1:Number) : void;

      function get volume() : Number;

      function set muted(param1:Boolean) : void;

      function get muted() : Boolean;

      function persist() : void;
   }

}