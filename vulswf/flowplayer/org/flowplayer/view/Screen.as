package org.flowplayer.view
{
   import flash.utils.Dictionary;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.Clip;
   import flash.display.DisplayObject;
   import org.flowplayer.util.Arrange;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.model.MediaSize;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.ClipEventType;
   import flash.geom.Rectangle;
   import org.flowplayer.controller.MediaController;
   import org.flowplayer.model.ClipEventSupport;
   import org.flowplayer.model.ClipType;
   import org.flowplayer.model.PlayButtonOverlay;


   class Screen extends AbstractSprite
   {
         

      function Screen(param1:Playlist, param2:AnimationEngine, param3:PlayButtonOverlay, param4:PluginRegistry) {
         super();
         log.debug("in constructor");
         this._displays=new Dictionary();
         this._addDisplayListeners=new Dictionary();
         this._removeDisplayListeners=new Dictionary();
         this._displayFactory=new MediaDisplayFactory(param1);
         this._resizer=new ClipResizer(param1,this);
         this.createDisplays(param1.clips.concat(param1.childClips));
         this.addListeners(param1);
         this._playList=param1;
         this._animationEngine=param2;
         this._pluginRegistry=param4;
         return;
      }



      private var _displayFactory:MediaDisplayFactory;

      private var _displays:Dictionary;

      private var _resizer:ClipResizer;

      private var _playList:Playlist;

      private var _prevClip:Clip;

      private var _fullscreenManager:FullscreenManager;

      private var _animationEngine:AnimationEngine;

      private var _pluginRegistry:PluginRegistry;

      private var _addDisplayListeners:Dictionary;

      private var _removeDisplayListeners:Dictionary;

      override  public function addEventListener(param1:String, param2:Function, param3:Boolean=false, param4:int=0, param5:Boolean=false) : void {
         var type:String = param1;
         var listener:Function = param2;
         var useCapture:Boolean = param3;
         var priority:int = param4;
         var useWeakReference:Boolean = param5;
         this.addEventListenerToDisplays(this._playList.clips.concat(this._playList.childClips),type,listener);
         this._addDisplayListeners[type]=new function(param1:DisplayObject):void
            {
               param1.addEventListener(type,listener);
               return;
            };
         this._removeDisplayListeners[type]=new function(param1:DisplayObject):void
            {
               param1.removeEventListener(type,listener);
               return;
            };
         return;
      }

      private function addEventListenerToDisplays(param1:Array, param2:String, param3:Function) : void {
         var _loc5_:Clip = null;
         var _loc6_:DisplayObject = null;
         var _loc4_:Number = 0;
         while(_loc4_<param1.length)
            {
               _loc5_=param1[_loc4_];
               if(!_loc5_.isNullClip)
                  {
                     _loc6_=this._displays[_loc5_];
                     _loc6_.addEventListener(param2,param3);
                  }
               _loc4_++;
            }
         return;
      }

      private function createDisplays(param1:Array) : void {
         var _loc3_:Clip = null;
         var _loc2_:Number = 0;
         while(_loc2_<param1.length)
            {
               _loc3_=param1[_loc2_];
               if(!_loc3_.isNullClip)
                  {
                     this.createDisplay(_loc3_);
                  }
               _loc2_++;
            }
         return;
      }

      private function createDisplay(param1:Clip) : void {
         var _loc3_:Object = null;
         var _loc2_:DisplayObject = this._displayFactory.createMediaDisplay(param1);
         _loc2_.width=this.width;
         _loc2_.height=this.height;
         _loc2_.visible=false;
         addChild(_loc2_);
         log.debug("created display "+_loc2_);
         this._displays[param1]=_loc2_;
         for (_loc3_ in this._addDisplayListeners)
            {
               this._addDisplayListeners[_loc3_](_loc2_);
            }
         return;
      }

      public function setVideoApiOverlaySize(param1:Number, param2:Number) : void {
         var _loc3_:Object = this._displays[this._playList.current];
         _loc3_.overlay.width=param1;
         _loc3_.overlay.height=param2;
         return;
      }

      public function set fullscreenManager(param1:FullscreenManager) : void {
         this._fullscreenManager=param1;
         return;
      }

      override  protected function onResize() : void {
         log.debug("onResize "+Arrange.describeBounds(this));
         this._resizer.setMaxSize(width,height);
         this.resizeClip(this._playList.previousClip);
         this.resizeClip(this._playList.current);
         this.arrangePlay();
         return;
      }

      private function get play() : DisplayProperties {
         return DisplayProperties(this._pluginRegistry.getPlugin("play"));
      }

      function arrangePlay() : void {
         if(this.playView)
            {
               this.playView.setSize(this.play.dimensions.width.toPx(this.width),this.play.dimensions.height.toPx(this.height));
               Arrange.center(this.playView,width,height);
               if(this.playView.parent==this)
                  {
                     setChildIndex(this.playView,numChildren-1);
                  }
            }
         return;
      }

      private function get playView() : AbstractSprite {
         if(!this.play)
            {
               return null;
            }
         return this.play.getDisplayObject() as AbstractSprite;
      }

      private function resizeClip(param1:Clip) : void {
         if(!param1)
            {
               return;
            }
         if(!param1.getContent())
            {
               log.warn("clip does not have content, cannot resize. Clip "+param1);
            }
         if((param1)&&(param1.getContent()))
            {
               if(this._fullscreenManager.isFullscreen)
                  {
                     this._resizer.resizeClipTo(param1,param1.useHWScaling?MediaSize.ORIGINAL:param1.scaling);
                  }
               else
                  {
                     this._resizer.resizeClipTo(param1,param1.scaling);
                  }
            }
         return;
      }

      function resized(param1:Clip) : void {
         var _loc2_:DisplayObject = this._displays[param1];
         _loc2_.width=param1.width;
         _loc2_.height=param1.height;
         if((param1.useHWScaling)&&(this._fullscreenManager.isFullscreen))
            {
               log.debug("in hardware accelerated fullscreen, will not center the clip");
               _loc2_.x=0;
               _loc2_.y=0;
               return;
            }
         Arrange.center(_loc2_,width,height);
         param1.dispatchEvent(new ClipEvent(ClipEventType.CLIP_RESIZED));
         return;
      }

      public function getDisplayBounds() : Rectangle {
         var _loc3_:Rectangle = null;
         var _loc1_:Clip = this._playList.current;
         var _loc2_:DisplayObject = this._displays[_loc1_];
         if(!_loc2_)
            {
               return this.fallbackDisplayBounds();
            }
         if(!_loc2_.visible&&(this._prevClip))
            {
               _loc1_=this._prevClip;
               _loc2_=this._displays[_loc1_];
            }
         if(!((_loc2_)&&(_loc2_.visible)))
            {
               return this.fallbackDisplayBounds();
            }
         if(_loc1_.width>0)
            {
               _loc3_=new Rectangle(_loc2_.x,_loc2_.y,_loc1_.width,_loc1_.height);
               log.debug("disp size is "+_loc3_.width+" x "+_loc3_.height);
               return _loc3_;
            }
         return this.fallbackDisplayBounds();
      }

      private function fallbackDisplayBounds() : Rectangle {
         return new Rectangle(0,0,Arrange.parentWidth,Arrange.parentHeight);
      }

      public function set mediaController(param1:MediaController) : void {
         return;
      }

      private function showDisplay(param1:ClipEvent) : void {
         log.info("showDisplay()");
         var _loc2_:Clip = param1.target as Clip;
         if(_loc2_.isNullClip)
            {
               return;
            }
         this.setDisplayVisible(_loc2_,true);
         this._prevClip=_loc2_;
         log.info("showDisplay done");
         return;
      }

      private function setDisplayVisible(param1:Clip, param2:Boolean) : void {
         var disp:DisplayObject = null;
         var clipNow:Clip = param1;
         var visible:Boolean = param2;
         disp=this._displays[clipNow];
         log.debug("display "+disp+", "+disp.name+", will be made "+(visible?"visible":"hidden"));
         if(visible)
            {
               MediaDisplay(disp).init(clipNow);
               disp.visible=true;
               log.debug("starting fadeIn for "+disp);
               this._animationEngine.cancel(disp);
               this._animationEngine.animateProperty(disp,"alpha",1,clipNow.fadeInSpeed);
               Arrange.center(disp,width,height);
            }
         else
            {
               if(disp.visible)
                  {
                     this._animationEngine.cancel(disp);
                     this._animationEngine.animateProperty(disp,"alpha",0,clipNow.fadeOutSpeed,new function():void
                        {
                           disp.visible=false;
                           return;
                           });
                           return;
                        }
                  }
               return;
      }

      private function onPlaylistChanged(param1:ClipEvent) : void {
         log.info("onPlaylistChanged()");
         this._prevClip=null;
         this.removeDisplays(ClipEventSupport(param1.info).clips);
         this.createDisplays(Playlist(param1.target).clips);
         return;
      }

      private function onClipAdded(param1:ClipEvent) : void {
         log.info("onClipAdded(): "+param1.info+", "+param1.info2);
         var _loc2_:Clip = param1.info2?param1.info2 as Clip:ClipEventSupport(param1.target).clips[param1.info] as Clip;
         log.debug("added clip "+_loc2_);
         this.createDisplay(_loc2_);
         return;
      }

      private function removeDisplays(param1:Array) : void {
         var _loc3_:Object = null;
         var _loc2_:Number = 0;
         while(_loc2_<param1.length)
            {
               removeChild(this._displays[param1[_loc2_]]);
               for (_loc3_ in this._removeDisplayListeners)
                  {
                     this._removeDisplayListeners[_loc3_](this._displays[param1[_loc2_]]);
                  }
               _loc2_++;
            }
         return;
      }

      private function addListeners(param1:ClipEventSupport) : void {
         var eventSupport:ClipEventSupport = param1;
         eventSupport.onPlaylistReplace(this.onPlaylistChanged);
         eventSupport.onClipAdd(this.onClipAdded);
         eventSupport.onBufferFull(this.onBufferFull);
         eventSupport.onBegin(this.onBegin);
         eventSupport.onStart(this.onStart);
         eventSupport.onResume(this.onResume);
         eventSupport.onUpdate(this.onUpdate);
         var oneShot:Function = new function(param1:Clip):Boolean
            {
               return param1.isOneShot;
            };
         eventSupport.onStop(this.removeOneShotDisplay,oneShot);
         eventSupport.onFinish(this.removeOneShotDisplay,oneShot);
         return;
      }

      private function onUpdate(param1:ClipEvent) : void {
         this.onResize();
         return;
      }

      private function removeOneShotDisplay(param1:ClipEvent) : void {
         log.debug("removing display of a one shot clip "+param1.target);
         removeChild(this._displays[param1.target]);
         delete this._displays[[param1.target]];
         return;
      }

      private function onBegin(param1:ClipEvent) : void {
         var _loc2_:Clip = param1.target as Clip;
         if(_loc2_.metaData==false)
            {
               log.info("onBegin: clip.metaData == false, showing it");
               this.handleStart(_loc2_,param1.info as Boolean);
            }
         if((_loc2_.getContent())&&(_loc2_.metaData))
            {
               this.handleStart(_loc2_,param1.info as Boolean);
            }
         return;
      }

      private function onStart(param1:ClipEvent) : void {
         var _loc2_:Clip = param1.target as Clip;
         if(_loc2_.metaData==false)
            {
               return;
            }
         this.handleStart(_loc2_,param1.info as Boolean);
         return;
      }

      private function onResume(param1:ClipEvent) : void {
         var _loc2_:Clip = param1.target as Clip;
         this.setDisplayVisibleIfHidden(_loc2_);
         var _loc3_:Array = [this._displays[_loc2_]];
         if(this.onAudioWithRelatedImage(_loc2_))
            {
               _loc3_.push(this._displays[this._playList.previousClip]);
            }
         this.hideAllDisplays(_loc3_);
         return;
      }

      private function handleStart(param1:Clip, param2:Boolean) : void {
         if(param1.isNullClip)
            {
               return;
            }
         log.debug("handleStart(), previous clip "+this._playList.previousClip);
         if((param2)&&(this._playList.previousClip)&&this._playList.previousClip.type==ClipType.IMAGE)
            {
               log.debug("autoBuffering next clip on a splash image, will not show next display");
               this.setDisplayVisibleIfHidden(this._playList.previousClip);
               if(param1.type==ClipType.AUDIO)
                  {
                     return;
                  }
               param1.onResume(this.onFirstFrameResume);
               return;
            }
         if((this._playList.previousClip)&&(param1.type==ClipType.AUDIO)&&!param1.getContent())
            {
               if(this.onAudioWithRelatedImage(param1))
                  {
                     this.setDisplayVisibleIfHidden(this._playList.previousClip);
                  }
               else
                  {
                     if(param1.type==ClipType.AUDIO&&(param1.getCustomProperty("coverImage")))
                        {
                           this.setDisplayVisibleIfHidden(param1);
                           this.hideAllDisplays([this._displays[param1]]);
                        }
                     else
                        {
                           this.hideAllDisplays();
                        }
                  }
               this._prevClip=param1;
               return;
            }
         this.setDisplayVisibleIfHidden(param1);
         this.hideAllDisplays([this._displays[param1]]);
         return;
      }

      private function onAudioWithRelatedImage(param1:Clip) : Boolean {
         if(!this._playList.previousClip)
            {
               return false;
            }
         if(param1.type!=ClipType.AUDIO)
            {
               return false;
            }
         return this._playList.previousClip.type==ClipType.IMAGE&&(this._playList.previousClip.image);
      }

      private function setDisplayVisibleIfHidden(param1:Clip) : void {
         var _loc2_:DisplayObject = this._displays[param1];
         if(_loc2_.alpha>1||!_loc2_.visible)
            {
               this.setDisplayVisible(param1,true);
            }
         return;
      }

      private function hideAllDisplays(param1:Array=null) : void {
         var _loc4_:Clip = null;
         var _loc5_:MediaDisplay = null;
         var _loc2_:Array = this._playList.clips.concat(this._playList.childClips);
         var _loc3_:Number = 0;
         while(_loc3_<_loc2_.length)
            {
               _loc4_=_loc2_[_loc3_] as Clip;
               _loc5_=this._displays[_loc4_];
               if((_loc5_)&&(!param1||param1.indexOf(_loc5_)>0))
                  {
                     this.setDisplayVisible(_loc2_[_loc3_] as Clip,false);
                  }
               _loc3_++;
            }
         return;
      }

      private function onFirstFrameResume(param1:ClipEvent) : void {
         var _loc2_:Clip = param1.target as Clip;
         _loc2_.unbind(this.onFirstFrameResume);
         this.showDisplay(param1);
         return;
      }

      private function onBufferFull(param1:ClipEvent) : void {
         var _loc3_:MediaDisplay = null;
         var _loc2_:Clip = param1.target as Clip;
         if(_loc2_.type==ClipType.IMAGE)
            {
               this.showDisplay(param1);
            }
         if(_loc2_.type==ClipType.VIDEO)
            {
               _loc3_=this._displays[_loc2_];
               if(!_loc3_)
                  {
                     return;
                  }
               _loc3_.init(_loc2_);
               if(_loc2_.live)
                  {
                     this.showDisplay(param1);
                  }
            }
         return;
      }

      function hidePlay() : void {
         if(this.playView.parent==this)
            {
               removeChild(this.playView);
            }
         return;
      }

      function showPlay() : void {
         log.debug("showPlay");
         addChild(this.playView);
         this.playView.visible=true;
         this.playView.alpha=this.play.alpha;
         this.arrangePlay();
         log.debug("play bounds: "+Arrange.describeBounds(this.playView));
         log.debug("play parent: "+this.playView.parent);
         return;
      }
   }

}