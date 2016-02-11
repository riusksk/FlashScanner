package org.flowplayer.view
{
   import org.flowplayer.model.Logo;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.events.FullScreenEvent;
   import flash.events.MouseEvent;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   import flash.events.TimerEvent;


   public class LogoView extends AbstractSprite
   {
         

      public function LogoView(param1:Panel, param2:Flowplayer) {
         super();
         this._panel=param1;
         this._player=param2;
         return;
      }



      private var _model:Logo;

      private var _player:Flowplayer;

      private var _image:DisplayObject;

      private var _panel:Panel;

      private var _copyrightNotice:TextField;

      private var _preHideAlpha:Number = -1;

      private var _hideTimer:Timer;

      public function set model(param1:Logo) : void {
         this.setModel(param1);
         log.debug("fullscreenOnly "+param1.fullscreenOnly);
         this.setEventListeners();
         this._copyrightNotice=LogoUtil.createCopyrightNotice(10);
         addChild(this._copyrightNotice);
         this._model.width="6.5%";
         this._model.height="6.5%";
         this.initializeLogoImage((BuiltInAssetHelper.createLogo())||(new FlowplayerLogo()));
         log.debug("LogoView() model dimensions "+this._model.dimensions);
         return;
      }

      override  protected function onResize() : void {
         if(this._image)
            {
               log.debug("onResize, "+this._model.dimensions);
               if((this._model.dimensions.width.hasValue())&&(this._model.dimensions.height.hasValue()))
                  {
                     log.debug("onResize(), scaling image according to model");
                     if(this._image.height-this.copyrightNoticeheight()>this._image.width)
                        {
                           this._image.height=height-this.copyrightNoticeheight();
                           this._image.scaleX=this._image.scaleY;
                        }
                     else
                        {
                           this._image.width=width;
                           this._image.scaleY=this._image.scaleX;
                        }
                  }
               this._image.x=width-this._image.width;
               this._image.y=0;
               this._copyrightNotice.y=this._image.height;
               this._copyrightNotice.visible=this._copyrightNotice.textWidth>width;
               this._copyrightNotice.width=width;
            }
         return;
      }

      private function copyrightNoticeheight() : Number {
         return this._copyrightNotice.height;
      }

      private function initializeLogoImage(param1:DisplayObject) : void {
         log.debug("initializeLogoImage(), setting logo alpha to "+this._model.alpha);
         this._image=param1;
         addChild(this._image);
         log.debug("createLogoImage() logo shown in fullscreen only "+this._model.fullscreenOnly);
         if(!this._model.fullscreenOnly)
            {
               this.show();
            }
         else
            {
               this.hide(0);
            }
         this.update();
         this.onResize();
         return;
      }

      private function setEventListeners() : void {
         this._panel.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullscreen);
         this.setLinkEventListener();
         return;
      }

      private function setLinkEventListener() : void {
         if(this._model.linkUrl)
            {
               addEventListener(MouseEvent.CLICK,this.onClick);
               buttonMode=true;
            }
         return;
      }

      private function removeLinkEventListener() : void {
         removeEventListener(MouseEvent.CLICK,this.onClick);
         buttonMode=false;
         return;
      }

      private function onClick(param1:MouseEvent) : void {
         navigateToURL(new URLRequest(this._model.linkUrl),this._model.linkWindow);
         return;
      }

      private function onFullscreen(param1:FullScreenEvent) : void {
         log.debug("onFullscreen(), "+(param1.fullScreen?"enter fullscreen":"exit fullscreen"));
         if(param1.fullScreen)
            {
               if((this._hideTimer)&&(this._hideTimer.running))
                  {
                     log.debug("onFullscreen(), hide timer is running -> returning");
                     return;
                  }
               this.show();
            }
         else
            {
               if(this._model.fullscreenOnly)
                  {
                     if((this._hideTimer)&&(this._hideTimer.running))
                        {
                           this._hideTimer.reset();
                           this._hideTimer=null;
                        }
                     this.hide(0);
                  }
            }
         return;
      }

      private function show() : void {
         log.debug("show()");
         if(this._preHideAlpha!=-1)
            {
               this.alpha=this._preHideAlpha;
               this._model.alpha=this._preHideAlpha;
            }
         this._model.visible=true;
         this.visible=true;
         this._model.zIndex=100;
         if(!this.parent)
            {
               log.debug("showing "+this._model.dimensions+", "+this._model.position);
               this._panel.addView(this,null,this._model);
               if(this._model.displayTime>0)
                  {
                     log.debug("show() creating hide timer");
                     this.startTimer();
                  }
            }
         return;
      }

      private function update() : void {
         if(!this.parent)
            {
               return;
            }
         log.debug("update() "+this._model.dimensions+", "+this._model.position);
         this._panel.update(this,this._model);
         this._panel.draw(this);
         if(this._player.pluginRegistry.getPlugin(this._model.name))
            {
               this._player.pluginRegistry.updateDisplayProperties(this._model);
            }
         return;
      }

      private function hide(param1:int=0) : void {
         log.debug("hide(), hiding logo");
         this._preHideAlpha=this._model.alpha;
         if(param1>0)
            {
               this._player.animationEngine.fadeOut(this,param1);
            }
         else
            {
               this.removeFromPanel();
            }
         return;
      }

      private function removeFromPanel() : void {
         log.debug("removeFromPanel() "+this.parent);
         if(this.parent)
            {
               this._panel.removeChild(this);
            }
         return;
      }

      private function startTimer() : void {
         this._hideTimer=new Timer(this._model.displayTime*1000,1);
         this._hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE,new function(param1:TimerEvent):void
            {
               log.debug("display time complete");
               hide(_model.fadeSpeed);
               _hideTimer.stop();
               return;
               });
               this._hideTimer.start();
               return;
      }

      public function setModel(param1:Logo) : void {
         log.debug("setModel() ignoring configured logo settings");
         this._model=new Logo(this,"logo");
         this._model.fullscreenOnly=param1.fullscreenOnly;
         this._model.height="9%";
         this._model.width="9%";
         this._model.top="20";
         this._model.right="20";
         this._model.opacity=0.3;
         this._model.linkUrl="http://flowplayer.org";
         log.debug("initial model dimensions "+this._model.dimensions);
         return;
      }
   }

}