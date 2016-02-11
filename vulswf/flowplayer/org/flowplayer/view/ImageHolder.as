package org.flowplayer.view
{
   import flash.display.Sprite;
   import flash.display.Loader;


   public class ImageHolder extends Sprite
   {
         

      public function ImageHolder(param1:Loader) {
         super();
         this._loader=param1;
         this._originalWidth=param1.contentLoaderInfo.width;
         this._originalHeight=param1.contentLoaderInfo.height;
         this._width=param1.width;
         this._height=param1.height;
         this._widthRatio=this._width/this._originalWidth;
         this._heightRatio=this._height/this._originalHeight;
         graphics.drawRect(0,0,this._originalWidth,this._originalHeight);
         addChild(this._loader);
         this.updateMask();
         return;
      }

      public static function hasOffscreenContent(param1:Loader) : Boolean {
         return !(param1.width==param1.contentLoaderInfo.width)||!(param1.height==param1.contentLoaderInfo.height);
      }

      private var _loader:Loader;

      private var _mask:Sprite;

      private var _width:int;

      private var _height:int;

      private var _originalWidth:int;

      private var _originalHeight:int;

      private var _widthRatio:Number;

      private var _heightRatio:Number;

      private function updateMask() : void {
         if(!(this._mask==null)&&(contains(this._mask)))
            {
               removeChild(this._mask);
            }
         this._mask=new Sprite();
         this._mask.graphics.beginFill(16711680);
         this._mask.graphics.drawRect(0,0,this._width,this._height);
         addChild(this._mask);
         this._loader.mask=this._mask;
         return;
      }

      override  public function get width() : Number {
         return (this._width)||(super.width);
      }

      override  public function set width(param1:Number) : void {
         this._width=param1;
         this._loader.width=param1*this._widthRatio;
         this.updateMask();
         return;
      }

      override  public function get height() : Number {
         return (this._height)||(super.height);
      }

      override  public function set height(param1:Number) : void {
         this._height=param1;
         this._loader.height=param1*this._heightRatio;
         this.updateMask();
         return;
      }

      public function get originalWidth() : int {
         return this._originalWidth;
      }

      public function get originalHeight() : int {
         return this._originalHeight;
      }
   }

}