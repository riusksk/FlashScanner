package org.flowplayer.controller
{
   import org.flowplayer.util.Log;


   class NullVolumeStorage extends Object implements VolumeStorage
   {
         

      function NullVolumeStorage() {
         this.log=new Log(this);
         super();
         this.log.warn("not allowed to store data on this machine");
         return;
      }



      private var log:Log;

      public function persist() : void {
         return;
      }

      public function get volume() : Number {
         return 1;
      }

      public function get muted() : Boolean {
         return false;
      }

      public function set volume(param1:Number) : void {
         return;
      }

      public function set muted(param1:Boolean) : void {
         return;
      }
   }

}