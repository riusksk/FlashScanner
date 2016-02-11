package org.flowplayer.view
{
   import flash.display.DisplayObject;
   import org.flowplayer.model.Clip;


   class ImageDisplay extends AbstractSprite implements MediaDisplay
   {
         

      function ImageDisplay(param1:Clip) {
         super();
         this._clip=param1;
         return;
      }



      private var image:DisplayObject;

      private var _clip:Clip;

      public function init(param1:Clip) : void {
         log.debug("received image to display");
         if(this.image)
            {
               removeChild(this.image);
            }
         if(!param1.getContent())
            {
               return;
            }
         this.image=param1.getContent();
         addChild(this.image);
         return;
      }

      public function hasContent() : Boolean {
         return !(this.image==null);
      }

      override  public function toString() : String {
         return "[ImageDisplay] for clip "+this._clip;
      }
   }

}