package org.flowplayer.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.flowplayer.controller.ResourceLoader;
   import flash.events.MouseEvent;
   import org.flowplayer.util.GraphicsUtil;
   import flash.utils.getQualifiedClassName;
   import org.flowplayer.layout.Length;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.utils.getDefinitionByName;


   public class StyleableSprite extends AbstractSprite implements Styleable
   {
         

      public function StyleableSprite(param1:String=null, param2:ErrorHandler=null, param3:ResourceLoader=null) {
         super();
         this._errorHandler=param2;
         this._loader=param3;
         if(param1)
            {
               this._style=new FlowStyleSheet(param1);
               this.loadOrDrawBackground();
            }
         return;
      }



      private var _style:FlowStyleSheet;

      private var _image:DisplayObject;

      private var _imageMask:DisplayObject;

      private var _imageHolder:Sprite;

      private var _errorHandler:ErrorHandler;

      private var _border:Sprite;

      private var _redrawing:Boolean;

      private var _loader:ResourceLoader;

      override  public function setSize(param1:Number, param2:Number) : void {
         super.setSize(param1,param2);
         this.redraw();
         return;
      }

      protected function onRedraw() : void {
         return;
      }

      private function redraw() : void {
         if(!this.style)
            {
               this.onRedraw();
               return;
            }
         this.drawBackground();
         this.arrangeBackgroundImage();
         this.drawBorder();
         this.setChildIndexes();
         this.addLinkListener();
         this.onRedraw();
         this._redrawing=false;
         return;
      }

      private function addLinkListener() : void {
         this.setLinkListener(this,false);
         this.setLinkListener(this._imageHolder,false);
         if(this._style.linkUrl)
            {
               this.setLinkListener((this._imageHolder)||(this),true);
            }
         return;
      }

      private function setLinkListener(param1:Sprite, param2:Boolean) : void {
         if(!param1)
            {
               return;
            }
         param1.buttonMode=param2;
         if(param2)
            {
               param1.addEventListener(MouseEvent.CLICK,this.onBackgroundImageClicked);
            }
         else
            {
               param1.removeEventListener(MouseEvent.CLICK,this.onBackgroundImageClicked);
            }
         return;
      }

      private function drawBackground() : void {
         graphics.clear();
         if(!this._style.backgroundTransparent)
            {
               log.debug("drawing background color "+this._style.backgroundColor+", alpha "+this._style.backgroundAlpha);
               graphics.beginFill(this._style.backgroundColor,this._style.backgroundAlpha);
               GraphicsUtil.drawRoundRectangle(graphics,0,0,width,height,this._style.borderRadius);
               graphics.endFill();
            }
         else
            {
               log.debug("background color is transparent");
            }
         if(this._style.backgroundGradient)
            {
               log.debug("adding gradient");
               GraphicsUtil.addGradient(this,this._imageHolder?getChildIndex(this._imageHolder):0,this._style.backgroundGradient,this._style.borderRadius);
            }
         else
            {
               GraphicsUtil.removeGradient(this);
            }
         return;
      }

      private function setChildIndexes() : void {
         if(this._imageHolder)
            {
               setChildIndex(this._imageHolder,0);
            }
         return;
      }

      public final function set style(param1:FlowStyleSheet) : void {
         log.debug("set style");
         this._style=param1;
         this.onSetStyle(param1);
         this.loadOrDrawBackground();
         return;
      }

      protected function onSetStyle(param1:FlowStyleSheet) : void {
         return;
      }

      public function onBeforeCss(param1:Object=null) : void {
         return;
      }

      public function css(param1:Object=null) : Object {
         var _loc3_:String = null;
         this._redrawing=true;
         log.debug("css "+param1);
         if(!param1)
            {
               return this._style.rootStyle;
            }
         var _loc2_:Object = null;
         for (_loc3_ in param1)
            {
               if(FlowStyleSheet.ROOT_STYLE_PROPS.indexOf(_loc3_)>=0)
                  {
                     if(!_loc2_)
                        {
                           _loc2_=new Object();
                        }
                     log.debug(_loc3_+" will affect root style, new value "+param1[_loc3_]);
                     _loc2_[_loc3_]=param1[_loc3_];
                     continue;
                  }
               log.debug("updating style of "+_loc3_);
               this.addStyleRules(_loc3_,param1[_loc3_]);
            }
         if(_loc2_)
            {
               this.addStyleRules(this._style.rootStyleName,_loc2_);
            }
         return this._style.rootStyle;
      }

      private function addStyleRules(param1:String, param2:Object) : void {
         if(param1==this._style.rootStyleName)
            {
               this._style.addToRootStyle(param2);
               this.onSetRootStyle(this._style.rootStyle);
               this.loadOrDrawBackground();
            }
         else
            {
               this._style.addStyleRules(param1,param2);
               this.onSetStyleObject(param1,param2);
            }
         return;
      }

      protected function onSetStyleObject(param1:String, param2:Object) : void {
         return;
      }

      public final function set rootStyle(param1:Object) : void {
         log.debug("setting root style to "+this);
         if(!this._style)
            {
               this._style=new FlowStyleSheet(getQualifiedClassName(this));
            }
         this._style.rootStyle=param1;
         this.onSetRootStyle(param1);
         this.loadOrDrawBackground();
         return;
      }

      public function addToRootStyle(param1:Object) : void {
         this._style.addToRootStyle(param1);
         this.onAddToRootStyle();
         this.loadOrDrawBackground();
         return;
      }

      private function onAddToRootStyle() : void {
         return;
      }

      protected function onSetRootStyle(param1:Object) : void {
         return;
      }

      public final function get style() : FlowStyleSheet {
         return this._style;
      }

      private function loadOrDrawBackground() : void {
         if((this._style.backgroundImage)&&!(this._style.backgroundImage=="none"))
            {
               if(!this._loader)
                  {
                     throw new Error("loader not available");
                  }
               log.debug("stylesheet specified a background image "+this._style.backgroundImage);
               this.loadBackgroundImage();
            }
         else
            {
               this._image=null;
               this.removeBackgroundImage();
               this.redraw();
            }
         return;
      }

      private function loadBackgroundImage() : void {
         var _loc1_:String = this._style.backgroundImage;
         if(!_loc1_)
            {
               return;
            }
         if(_loc1_.indexOf("url(")==0)
            {
               _loc1_=_loc1_.substring(4,_loc1_.length-1);
            }
         if(!this._loader)
            {
               throw new Error("ResourceLoader not available, cannot load backgroundImage");
            }
         this._loader.load(_loc1_,this.onImageLoaded);
         return;
      }

      private function onImageLoaded(param1:ResourceLoader) : void {
         this._image=param1.getContent() as DisplayObject;
         log.debug("received bacground image "+this._image);
         this.redraw();
         return;
      }

      private function arrangeBackgroundImage() : void {
         var _loc1_:Length = null;
         var _loc2_:Length = null;
         if(!this._image)
            {
               return;
            }
         this.createImageHolder();
         if(this._style.backgroundRepeat)
            {
               this.repeatBackground(this._image);
            }
         else
            {
               this.addBackgroundImage(this._image);
               _loc1_=this._style.backgroundImageX;
               _loc2_=this._style.backgroundImageY;
               log.debug("background image xPos "+_loc1_);
               log.debug("background image yPos "+_loc2_);
               if(_loc1_.px>=0)
                  {
                     this._imageHolder.x=_loc1_.px;
                  }
               else
                  {
                     if(_loc1_.pct>0)
                        {
                           this._imageHolder.x=_loc1_.pct/100*width-this._imageHolder.width/2;
                        }
                  }
               if(_loc2_.px>=0)
                  {
                     this._imageHolder.y=_loc2_.px;
                  }
               else
                  {
                     if(_loc2_.pct>0)
                        {
                           this._imageHolder.y=_loc2_.pct/100*height-this._imageHolder.height/2;
                        }
                  }
            }
         return;
      }

      private function removeBackgroundImage() : Boolean {
         if(this._imageHolder)
            {
               log.debug("removing background image");
               removeChild(this._imageHolder);
               this._imageHolder=null;
               return true;
            }
         return false;
      }

      private function createImageHolder() : void {
         this.removeBackgroundImage();
         this._imageHolder=new Sprite();
         addChild(this._imageHolder);
         this._imageMask=this.createMask();
         addChild(this._imageMask);
         this._imageHolder.mask=this._imageMask;
         this._imageHolder.x=0;
         this._imageHolder.y=0;
         return;
      }

      private function onBackgroundImageClicked(param1:MouseEvent) : void {
         navigateToURL(new URLRequest(this._style.linkUrl),this._style.linkWindow);
         param1.stopPropagation();
         return;
      }

      protected function createMask() : Sprite {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0);
         GraphicsUtil.drawRoundRectangle(_loc1_.graphics,0,0,width,height,this._style.borderRadius);
         return _loc1_;
      }

      private function addBackgroundImage(param1:DisplayObject) : DisplayObject {
         this._imageHolder.addChild(param1);
         return param1;
      }

      private function repeatBackground(param1:DisplayObject) : void {
         var _loc5_:* = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:DisplayObject = null;
         var _loc2_:int = Math.round(width/param1.width);
         var _loc3_:int = Math.round(height/param1.height);
         log.debug(_loc2_+", "+_loc3_);
         var _loc4_:* = 0;
         while(_loc4_<=_loc2_)
            {
               _loc5_=0;
               while(_loc5_<=_loc3_)
                  {
                     _loc6_=this.clone(param1);
                     if(!_loc6_)
                        {
                           return;
                        }
                     _loc7_=this.addBackgroundImage(_loc6_);
                     _loc7_.x=_loc4_*param1.width;
                     _loc7_.y=_loc5_*param1.height;
                     log.debug("added backgound at "+_loc7_.x+", "+_loc7_.y);
                     _loc5_++;
                  }
               _loc4_++;
            }
         return;
      }

      private function clone(param1:DisplayObject) : DisplayObject {
         if(!param1)
            {
               return null;
            }
         if(param1 is Bitmap)
            {
               return new Bitmap(Bitmap(param1).bitmapData);
            }
         if(param1 is Loader)
            {
               return this.clone(Loader(param1).content);
            }
         var _loc2_:Class = getDefinitionByName(getQualifiedClassName(param1)) as Class;
         return new (_loc2_)() as DisplayObject;
      }

      private function drawBorder() : void {
         if((this._border)&&this._border.parent==this)
            {
               removeChild(this._border);
            }
         if(!this._style.borderWidth>0)
            {
               return;
            }
         this._border=new Sprite();
         addChild(this._border);
         log.info("border weight is "+this._style.borderWidth+", alpha "+this._style.borderAlpha);
         this._border.graphics.lineStyle(this._style.borderWidth,this._style.borderColor,this._style.borderAlpha);
         GraphicsUtil.drawRoundRectangle(this._border.graphics,0,0,width,height,this._style.borderRadius);
         return;
      }

      protected function get bgImageHolder() : Sprite {
         return this._imageHolder;
      }

      public function onBeforeAnimate(param1:Object) : void {
         return;
      }

      public function animate(param1:Object) : Object {
         return this._style.rootStyle;
      }

      public function get redrawing() : Boolean {
         return this._redrawing;
      }

      protected function set loader(param1:ResourceLoader) : void {
         log.debug("got loader");
         this._loader=param1;
         return;
      }
   }

}