package org.flowplayer.view
{
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.events.TimerEvent;


   public class RotatingAnimation extends AbstractSprite
   {
         

      public function RotatingAnimation() {
         super();
         this.createRotation();
         this._rotationTimer=new Timer(50);
         this._rotationTimer.addEventListener(TimerEvent.TIMER,this.rotate);
         this._rotationTimer.start();
         return;
      }



      private var _rotationImage:BufferAnimation;

      private var _rotation:Sprite;

      private var _rotationTimer:Timer;

      public function start() : void {
         this._rotationTimer.start();
         return;
      }

      public function stop() : void {
         this._rotationTimer.stop();
         return;
      }

      override  protected function onResize() : void {
         this.arrangeRotation(width,height);
         return;
      }

      private function rotate(param1:TimerEvent) : void {
         this._rotation.rotation=this._rotation.rotation+10;
         return;
      }

      private function createRotation() : void {
         this._rotationImage=new BufferAnimation();
         this._rotation=new Sprite();
         this._rotation.addChild(this._rotationImage);
         addChild(this._rotation);
         return;
      }

      private function arrangeRotation(param1:Number, param2:Number) : void {
         if(this._rotationImage)
            {
               this._rotationImage.height=param2;
               this._rotationImage.scaleX=this._rotationImage.scaleY;
               this._rotationImage.x=-this._rotationImage.width/2;
               this._rotationImage.y=-this._rotationImage.height/2;
               this._rotation.x=this._rotationImage.width/2+(param1-this._rotationImage.width)/2;
               this._rotation.y=this._rotationImage.height/2+(param2-this._rotationImage.height)/2;
            }
         return;
      }
   }

}