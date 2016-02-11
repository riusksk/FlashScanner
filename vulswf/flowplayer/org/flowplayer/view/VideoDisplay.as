package org.flowplayer.view
{
   import flash.media.Video;
   import flash.display.Sprite;
   import org.flowplayer.model.Clip;
   import org.flowplayer.util.Arrange;


   class VideoDisplay extends AbstractSprite implements MediaDisplay
   {
         

      function VideoDisplay(param1:Clip) {
         super();
         this._clip=param1;
         this.createOverlay();
         return;
      }



      private var video:Video;

      private var _overlay:Sprite;

      private var _clip:Clip;

      private function createOverlay() : void {
         this._overlay=new Sprite();
         addChild(this._overlay);
         this._overlay.graphics.beginFill(0,0);
         this._overlay.graphics.drawRect(0,0,10,10);
         this._overlay.graphics.endFill();
         return;
      }

      public function get overlay() : Sprite {
         return this._overlay;
      }

      override  protected function onResize() : void {
         Arrange.sameSize(this._overlay,this);
         return;
      }

      override  public function set alpha(param1:Number) : void {
         super.alpha=param1;
         if(this.video)
            {
               this.video.alpha=param1;
               log.debug("display of + "+this._clip+" new alpha "+this.video.alpha);
            }
         else
            {
               log.debug("set alpha() no video available");
            }
         return;
      }

      public function init(param1:Clip) : void {
         this._clip=param1;
         log.info("init "+this._clip);
         if(this.video)
            {
               removeChild(this.video);
            }
         this.video=param1.getContent() as Video;
         log.debug("init() video == "+this.video);
         if(this.video==null)
            {
               log.warn("no video content in clip "+param1);
               return;
            }
         this.video.width=this.width;
         this.video.height=this.height;
         addChild(this.video);
         swapChildren(this._overlay,this.video);
         return;
      }

      public function hasContent() : Boolean {
         return !(this.video==null);
      }

      override  public function toString() : String {
         return "[VideoDisplay] for clip "+this._clip;
      }
   }

}