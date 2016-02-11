package org.flowplayer.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.flowplayer.model.Clip;


   class VideoApiDisplay extends AbstractSprite implements MediaDisplay
   {
         

      function VideoApiDisplay(param1:Clip) {
         super();
         this._clip=param1;
         this.createOverlay();
         return;
      }



      private var video:DisplayObject;

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
         this._overlay.width=this.width;
         this._overlay.height=this.height;
         return;
      }

      override  public function addEventListener(param1:String, param2:Function, param3:Boolean=false, param4:int=0, param5:Boolean=false) : void {
         this._overlay.addEventListener(param1,param2,param3,param4,param5);
         return;
      }

      override  public function set alpha(param1:Number) : void {
         return;
      }

      public function init(param1:Clip) : void {
         this._clip=param1;
         log.info("init "+this._clip);
         this.video=param1.getContent();
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
         return "[VideoApiDisplay] for clip "+this._clip;
      }
   }

}