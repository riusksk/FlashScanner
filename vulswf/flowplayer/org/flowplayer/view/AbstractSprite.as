package org.flowplayer.view
{
   import flash.display.Sprite;
   import org.flowplayer.util.Log;
   import org.flowplayer.layout.LayoutEvent;
   import flash.geom.Rectangle;


   public class AbstractSprite extends Sprite
   {
         

      public function AbstractSprite() {
         this.log=new Log(this);
         super();
         return;
      }



      protected var log:Log;

      protected var _width:Number = 0;

      protected var _height:Number = 0;

      public function setSize(param1:Number, param2:Number) : void {
         this._width=param1;
         this._height=param2;
         this.onResize();
         return;
      }

      override  public function get width() : Number {
         if(scaleX!=1)
            {
               return this._width*scaleX;
            }
         return (this._width)||(super.width);
      }

      override  public function set width(param1:Number) : void {
         this.setSize(param1,this.height);
         return;
      }

      override  public function get height() : Number {
         if(scaleY!=1)
            {
               return this._height*scaleY;
            }
         return (this._height)||(super.height);
      }

      override  public function set height(param1:Number) : void {
         this.setSize(this.width,param1);
         return;
      }

      protected function get managedWidth() : Number {
         return this._width;
      }

      protected function get managedHeight() : Number {
         return this._height;
      }

      protected function onResize() : void {
         return;
      }

      public function draw(param1:LayoutEvent) : void {
         var _loc2_:Rectangle = param1.layout.getBounds(this);
         this.setSize(_loc2_.width,_loc2_.height);
         return;
      }
   }

}