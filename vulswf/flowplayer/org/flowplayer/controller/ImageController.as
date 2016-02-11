package org.flowplayer.controller
{
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.view.ImageHolder;
   import flash.display.Loader;
   import flash.display.DisplayObject;
   import org.flowplayer.model.Playlist;


   class ImageController extends AbstractDurationTrackingController implements MediaController
   {
         

      function ImageController(param1:ResourceLoader, param2:VolumeController, param3:Playlist) {
         super(param2,param3);
         this._loader=new ClipImageLoader(param1,null);
         return;
      }



      private var _loader:ClipImageLoader;

      override  protected function get allowRandomSeek() : Boolean {
         return true;
      }

      override  protected function doLoad(param1:ClipEvent, param2:Clip, param3:Boolean=false) : void {
         if(durationTracker)
            {
               durationTracker.stop();
               durationTracker.time=0;
            }
         log.info("Starting to load "+param2);
         this._loader.loadClip(param2,this.onLoadComplete);
         dispatchPlayEvent(param1);
         return;
      }

      override  protected function doPause(param1:ClipEvent) : void {
         dispatchPlayEvent(param1);
         return;
      }

      override  protected function doResume(param1:ClipEvent) : void {
         dispatchPlayEvent(param1);
         return;
      }

      override  protected function doStop(param1:ClipEvent, param2:Boolean) : void {
         dispatchPlayEvent(param1);
         return;
      }

      override  protected function doSeekTo(param1:ClipEvent, param2:Number) : void {
         if(param1)
            {
               dispatchPlayEvent(new ClipEvent(ClipEventType.SEEK,param2));
            }
         return;
      }

      private function onLoadComplete(param1:ClipImageLoader) : void {
         var holder:ImageHolder = null;
         var loader:ClipImageLoader = param1;
         if(loader.getContent() is Loader&&(ImageHolder.hasOffscreenContent(loader.getContent() as Loader)))
            {
               holder=new ImageHolder(loader.getContent() as Loader);
               clip.originalHeight=holder.originalHeight;
               clip.originalWidth=holder.originalWidth;
               clip.setContent(holder);
            }
         else
            {
               clip.setContent(loader.getContent() as DisplayObject);
               clip.originalHeight=loader.getContent().height;
               clip.originalWidth=loader.getContent().width;
            }
         log.info("image loaded "+clip+", content "+loader.getContent()+", width "+clip.originalWidth+", height "+clip.originalHeight+", duration "+clip.duration);
         clip.dispatch(ClipEventType.START);
         clip.dispatch(ClipEventType.METADATA);
         clip.dispatch(ClipEventType.BUFFER_FULL);
         if(clip.duration==0)
            {
               clip.onResume(new function(param1:ClipEvent):void
                  {
                     clip.dispatchBeforeEvent(new ClipEvent(ClipEventType.FINISH));
                     return;
                     });
                     clip.dispatchEvent(new ClipEvent(ClipEventType.RESUME));
                  }
               return;
      }
   }

}