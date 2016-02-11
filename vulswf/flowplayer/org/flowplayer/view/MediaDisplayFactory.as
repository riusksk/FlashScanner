package org.flowplayer.view
{
   import org.flowplayer.model.Playlist;
   import flash.display.DisplayObject;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.ClipType;


   class MediaDisplayFactory extends Object
   {
         

      function MediaDisplayFactory(param1:Playlist) {
         super();
         this.playList=param1;
         return;
      }



      private var playList:Playlist;

      public function createMediaDisplay(param1:Clip) : DisplayObject {
         var _loc2_:DisplayObject = null;
         if(param1.type==ClipType.VIDEO)
            {
               _loc2_=new VideoDisplay(param1);
            }
         if(param1.type==ClipType.API)
            {
               _loc2_=new VideoApiDisplay(param1);
            }
         if(param1.type==ClipType.IMAGE||param1.type==ClipType.AUDIO)
            {
               _loc2_=new ImageDisplay(param1);
            }
         return _loc2_;
      }
   }

}