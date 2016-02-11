package org.flowplayer.model
{


   class NullClip extends Clip
   {
         

      function NullClip() {
         super();
         url="null clip";
         autoPlay=false;
         autoBuffering=false;
         type=ClipType.VIDEO;
         return;
      }



      override  public function get isNullClip() : Boolean {
         return true;
      }
   }

}