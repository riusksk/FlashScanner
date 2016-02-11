package org.flowplayer.view
{
   import org.flowplayer.model.Plugin;
   import flash.display.DisplayObject;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.PlayButtonOverlay;
   import flash.utils.Timer;
   import flash.events.MouseEvent;
   import org.flowplayer.model.PluginEventType;
   import org.flowplayer.model.ClipEventSupport;
   import org.flowplayer.model.Clip;
   import flash.events.TimerEvent;
   import flash.utils.getDefinitionByName;
   import org.flowplayer.util.Arrange;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.model.State;
   import org.flowplayer.model.PluginModel;
   import org.flowplayer.model.DisplayPluginModel;


   public class PlayButtonOverlayView extends AbstractSprite implements Plugin
   {
         

      public function PlayButtonOverlayView(param1:Boolean, param2:PlayButtonOverlay, param3:PluginRegistry) {
         super();
         this._resizeToTextWidth=param1;
         this._pluginRegistry=param3;
         this._pluginRegistry.registerDisplayPlugin(param2,this);
         this._play=param2;
         this.createChildren();
         buttonMode=true;
         this.startBuffering();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         return;
      }



      private var _button:DisplayObject;

      private var _pluginRegistry:PluginRegistry;

      private var _player:Flowplayer;

      private var _showButtonInitially:Boolean;

      private var _tween:Animation;

      private var _resizeToTextWidth:Boolean;

      private var _screen:Screen;

      private var _playlist:Playlist;

      private var _origAlpha:Number;

      private var _play:PlayButtonOverlay;

      private var _rotation:RotatingAnimation;

      private var _playDetectTimer:Timer;

      public function set playlist(param1:Playlist) : void {
         this._playlist=param1;
         this.addListeners(param1);
         return;
      }

      public function set label(param1:String) : void {
         this._play.label=param1;
         this.switchLabel(param1);
         this._pluginRegistry.update(this._play);
         return;
      }

      private function switchLabel(param1:String) : void {
         if(!this._player)
            {
               return;
            }
         log.debug("switchLabel() label \'"+param1+"\'");
         if((param1)&&(!this._button||!(this._button is LabelPlayButton)))
            {
               log.debug("switching to label button ");
               this.switchButton(new LabelPlayButton(this._player,param1));
            }
         if(!param1&&(!this._button||this._button is LabelPlayButton))
            {
               log.debug("switching to standard non-label button ");
               this.switchButton(new PlayOverlay());
            }
         if(param1)
            {
               LabelPlayButton(this._button).setLabel(param1,this._resizeToTextWidth);
            }
         this.onResize();
         return;
      }

      public function set replayLabel(param1:String) : void {
         if(!this._player)
            {
               return;
            }
         log.debug("set replayLabel \'"+param1+"\'");
         this._play.replayLabel=param1;
         this._pluginRegistry.update(this._play);
         return;
      }

      override  public function set alpha(param1:Number) : void {
         log.debug("setting alpha to "+param1+" tween "+this._tween);
         super.alpha=param1;
         if(this._button)
            {
               this._button.alpha=param1;
            }
         this._rotation.alpha=param1;
         return;
      }

      private function switchButton(param1:DisplayObject) : void {
         this.removeChildIfAdded(this._button);
         this._button=param1;
         if(this._button is AbstractSprite)
            {
               AbstractSprite(this._button).setSize(width-15,height-15);
            }
         return;
      }

      private function onMouseOut(param1:MouseEvent=null) : void {
         if(!this._button)
            {
               return;
            }
         this._button.alpha=Math.max(0,this.model.alpha-0.3);
         return;
      }

      private function onMouseOver(param1:MouseEvent) : void {
         if(!this._button)
            {
               return;
            }
         this._button.alpha=this.model.alpha;
         return;
      }

      public function onLoad(param1:Flowplayer) : void {
         log.debug("onLoad");
         this._player=param1;
         if((this._play.label)&&(this._showButtonInitially))
            {
               this.showButton(null,this._play.label);
            }
         log.debug("dispatching complete");
         this._play.dispatch(PluginEventType.LOAD);
         return;
      }

      private function addListeners(param1:ClipEventSupport) : void {
         param1.onConnect(this.startBuffering);
         param1.onBeforeBegin(this.hideButton);
         param1.onBegin(this.bufferUntilStarted);
         param1.onResume(this.hide);
         param1.onResume(this.bufferUntilStarted);
         param1.onPause(this.stopBuffering);
         param1.onPause(this.showButton);
         param1.onStop(this.stopBuffering);
         param1.onStop(this.showButton,this.isParentClip);
         param1.onBeforeFinish(this.stopBuffering);
         param1.onBeforeFinish(this.showReplayButton,this.isParentClipOrPostroll);
         param1.onBufferEmpty(this.startBuffering,this.applyForClip);
         param1.onBufferFull(this.stopBuffering,this.applyForClip);
         param1.onBeforeSeek(this.bufferUntilStarted);
         param1.onSeek(this.stopBuffering);
         param1.onBufferStop(this.stopBuffering);
         param1.onBufferStop(this.showButton);
         return;
      }

      private function applyForClip(param1:Clip) : Boolean {
         if(this._player.status.time>=param1.duration-2)
            {
               return false;
            }
         return !param1.live;
      }

      private function isParentClip(param1:Clip) : Boolean {
         return !param1.isInStream;
      }

      private function isParentClipOrPostroll(param1:Clip) : Boolean {
         return (param1.isPostroll)||!param1.isInStream;
      }

      private function rotate(param1:TimerEvent) : void {
         this._rotation.rotation=this._rotation.rotation+10;
         return;
      }

      private function createChildren() : void {
         this._rotation=new RotatingAnimation();
         if(!this._play.label)
            {
               this.createInternalButton();
            }
         return;
      }

      private function createInternalButton() : void {
         this._button=(BuiltInAssetHelper.createPlayButton())||(new PlayOverlay());
         this.addButton();
         this.onResize();
         return;
      }

      private function getClass(param1:String) : Class {
         return getDefinitionByName(param1) as Class;
      }

      private function addButton() : void {
         log.debug("addButton");
         if(this.model.visible)
            {
               addChild(this._button);
            }
         return;
      }

      override  protected function onResize() : void {
         log.debug("onResise "+width);
         if(!this._button)
            {
               return;
            }
         this.onMouseOut();
         if(this._button is LabelPlayButton)
            {
               AbstractSprite(this._button).setSize(width-15,height-15);
            }
         else
            {
               this._button.height=height;
               this._button.scaleX=this._button.scaleY;
            }
         this._rotation.setSize(width,height);
         Arrange.center(this._button,width,height);
         log.debug("arranged to y "+this._button.y+", this height "+height+", screen height "+(this._screen?this._screen.height:0));
         return;
      }

      private function hide(param1:ClipEvent=null) : void {
         log.debug("hide()");
         if(!this.parent)
            {
               return;
            }
         if(this._player)
            {
               log.debug("fading out with speed "+this._play.fadeSpeed+" current alpha is "+alpha);
               this._origAlpha=this.model.alpha;
               this._tween=this._player.animationEngine.fadeOut(this._button,this._play.fadeSpeed,this.onFadeOut,false);
            }
         else
            {
               this.onFadeOut();
            }
         return;
      }

      private function onFadeOut() : void {
         this.restoreOriginalAlpha();
         if((this._tween)&&(this._tween.canceled))
            {
               this._tween=null;
               return;
            }
         this._tween=null;
         log.debug("removing button");
         this.removeChildIfAdded(this._button);
         return;
      }

      private function show() : void {
         if(this._tween)
            {
               this.restoreOriginalAlpha();
               log.debug("canceling fadeOut tween");
               this._tween.cancel();
            }
         if((this._screen)&&this.parent==this._screen)
            {
               this._screen.arrangePlay();
               return;
            }
         if(this._screen)
            {
               log.debug("calling screen.showPlay");
               this._screen.showPlay();
            }
         return;
      }

      private function restoreOriginalAlpha() : void {
         this.alpha=this._origAlpha;
         var _loc1_:DisplayProperties = this.model;
         _loc1_.alpha=this._origAlpha;
         this._pluginRegistry.updateDisplayProperties(_loc1_);
         return;
      }

      public function showButton(param1:ClipEvent=null, param2:String=null) : void {
         var _loc3_:DisplayProperties = null;
         log.debug("showButton(), label "+param2);
         this.switchLabel((param2)||(this._play.label));
         if(!this._button)
            {
               return;
            }
         if(this._rotation.parent==this)
            {
               return;
            }
         if(param1==null)
            {
               _loc3_=this.model;
               _loc3_.display="block";
               this._pluginRegistry.updateDisplayProperties(_loc3_);
            }
         this.stopBuffering();
         this.addButton();
         this.show();
         this.onResize();
         return;
      }

      public function showReplayButton(param1:ClipEvent=null) : void {
         log.info("showReplayButton, playlist has more clips "+this._playlist.hasNext(false));
         if((param1.isDefaultPrevented())&&(this._playlist.hasNext(false)))
            {
               log.debug("showing replay button");
               this.showButton(null,this._play.replayLabel);
               return;
            }
         if((this._playlist.hasNext(false))&&(this._playlist.nextClip.autoPlay))
            {
               return;
            }
         this.showButton(param1,this._playlist.hasNext(false)?null:this._play.replayLabel);
         return;
      }

      public function hideButton(param1:ClipEvent=null) : void {
         log.debug("hideButton() "+this._button);
         this.removeChildIfAdded(this._button);
         return;
      }

      public function startBuffering(param1:ClipEvent=null) : void {
         log.debug("startBuffering()"+param1);
         if((param1)&&(param1.isDefaultPrevented()))
            {
               return;
            }
         if(!this._play.buffering)
            {
               return;
            }
         addChild(this._rotation);
         if((this._tween)&&(this._player)&&this._player.state==State.PLAYING)
            {
               this.removeChildIfAdded(this._button);
            }
         this.show();
         this._rotation.start();
         return;
      }

      public function stopBuffering(param1:ClipEvent=null) : void {
         log.debug("stopBuffering()");
         this._rotation.stop();
         this.removeChildIfAdded(this._rotation);
         if(!this._tween&&this._player.state==State.BUFFERING||this._player.state==State.BUFFERING)
            {
               this.removeChildIfAdded(this._button);
            }
         return;
      }

      private function removeChildIfAdded(param1:DisplayObject) : void {
         if(!param1)
            {
               return;
            }
         if(param1.parent!=this)
            {
               return;
            }
         log.debug("removing child "+param1);
         removeChild(param1);
         return;
      }

      public function onConfig(param1:PluginModel) : void {
         return;
      }

      public function getDefaultConfig() : Object {
         return null;
      }

      public function setScreen(param1:Screen, param2:Boolean=false) : void {
         this._screen=param1;
         this._showButtonInitially=param2;
         if(param2)
            {
               this.showButton();
            }
         this.startBuffering();
         return;
      }

      private function get model() : DisplayPluginModel {
         return DisplayPluginModel(this._pluginRegistry.getPlugin("play"));
      }

      private function bufferUntilStarted(param1:ClipEvent=null) : void {
         if((param1)&&(param1.isDefaultPrevented()))
            {
               return;
            }
         this.startBuffering();
         this.createPlaybackStartedCallback(this.stopBuffering);
         return;
      }

      private function createPlaybackStartedCallback(param1:Function) : void {
         var time:Number = NaN;
         var callback:Function = param1;
         log.debug("detectPlayback()");
         if(!this._player.isPlaying())
            {
               log.debug("detectPlayback(), not playing, returning");
               return;
            }
         if((this._playDetectTimer)&&(this._playDetectTimer.running))
            {
               log.debug("detectPlayback(), not playing, returning");
               return;
            }
         time=this._player.status.time;
         this._playDetectTimer=new Timer(200);
         this._playDetectTimer.addEventListener(TimerEvent.TIMER,new function(param1:TimerEvent):void
            {
               var _loc2_:Number = _player.status.time;
               log.debug("on detectPlayback() currentTime "+_loc2_+", time "+time);
               if(Math.abs(_loc2_-time)>0.2)
                     {
                           _playDetectTimer.stop();
                           log.debug("playback started");
                           callback();
                     }
               else
                     {
                           log.debug("not started yet, currentTime "+_loc2_+", time "+time);
                     }
               return;
               });
               log.debug("doStart(), starting timer");
               this._playDetectTimer.start();
               return;
      }
   }

}