package org.flowplayer.view
{
   import org.flowplayer.util.Log;
   import flash.display.Stage;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.model.DisplayPluginModel;
   import org.flowplayer.model.DisplayPropertiesImpl;
   import flash.display.DisplayObject;
   import flash.display.StageDisplayState;
   import org.flowplayer.model.Clip;
   import flash.geom.Rectangle;
   import flash.events.FullScreenEvent;
   import org.flowplayer.model.Cloneable;
   import org.flowplayer.model.PlayerEvent;
   import org.flowplayer.util.Assert;


   class FullscreenManager extends Object
   {
         

      function FullscreenManager(param1:Stage, param2:Playlist, param3:Panel, param4:PluginRegistry, param5:AnimationEngine) {
         this.log=new Log(this);
         super();
         Assert.notNull(param1,"stage cannot be null");
         this._stage=param1;
         this._stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
         this._playlist=param2;
         this._panel=param3;
         this._pluginRegistry=param4;
         this._screen=(param4.getPlugin("screen") as DisplayProperties).getDisplayObject() as Screen;
         Assert.notNull(this._screen,"got null screen from pluginRegistry");
         this._screen.fullscreenManager=this;
         this._animations=param5;
         return;
      }



      private var log:Log;

      private var _stage:Stage;

      private var _playlist:Playlist;

      private var _panel:Panel;

      private var _pluginRegistry:PluginRegistry;

      private var _animations:AnimationEngine;

      private var _screen:Screen;

      private var _screenNormalProperties:DisplayProperties;

      private var _playerEventDispatcher:PlayerEventDispatcher;

      private function getFullscreenProperties() : DisplayProperties {
         var _loc3_:* = NaN;
         var _loc4_:DisplayProperties = null;
         var _loc1_:DisplayPluginModel = this._pluginRegistry.getPlugin("controls") as DisplayPluginModel;
         if(!_loc1_)
            {
               return DisplayPropertiesImpl.fullSize("screen");
            }
         var _loc2_:DisplayObject = _loc1_.getDisplayObject();
         this.log.debug("controls.auotoHide "+_loc2_["getAutoHide"]());
         if((_loc2_)&&!_loc2_["getAutoHide"]().enabled)
            {
               this.log.debug("autoHiding disabled in fullscreen, calculating fullscreen display properties");
               _loc3_=_loc2_.height;
               _loc4_=DisplayPropertiesImpl.fullSize("screen");
               _loc4_.bottom=_loc3_;
               _loc4_.height=(this._stage.stageHeight-_loc3_)/this._stage.stageHeight*100+"%";
               return _loc4_;
            }
         return DisplayPropertiesImpl.fullSize("screen");
      }

      public function toggleFullscreen() : void {
         this.log.debug("toggleFullsreen");
         if(this.isFullscreen)
            {
               this.exitFullscreen();
            }
         else
            {
               this.goFullscreen();
            }
         return;
      }

      private function exitFullscreen() : void {
         this.log.info("exiting fullscreen");
         this._stage.displayState=StageDisplayState.NORMAL;
         return;
      }

      private function goFullscreen() : void {
         this.log.info("entering fullscreen");
         var _loc1_:Clip = this._playlist.current;
         this.initializeHwScaling(_loc1_);
         this._stage.displayState=StageDisplayState.FULL_SCREEN;
         return;
      }

      public function get isFullscreen() : Boolean {
         this.log.debug("currently in fulscreen? "+(this._stage.displayState==StageDisplayState.FULL_SCREEN));
         return this._stage.displayState==StageDisplayState.FULL_SCREEN;
      }

      private function initializeHwScaling(param1:Clip) : void {
         if(!this._stage.hasOwnProperty("fullScreenSourceRect"))
            {
               this.log.info("hardware scaling not supported by this Flash version");
               return;
            }
         if(param1.useHWScaling)
            {
               this._stage.fullScreenSourceRect=new Rectangle(0,0,param1.originalWidth,param1.originalHeight);
               this.log.info("harware scaled fullscreen initialized with rectangle "+this._stage.fullScreenSourceRect);
            }
         else
            {
               this._stage.fullScreenSourceRect=null;
            }
         return;
      }

      private function onFullScreen(param1:FullScreenEvent) : void {
         var event:FullScreenEvent = param1;
         if(event.fullScreen)
            {
               this._screenNormalProperties=Cloneable(this._pluginRegistry.getPlugin("screen")).clone() as DisplayProperties;
            }
         this._animations.animate(this._screen,event.fullScreen?this.getFullscreenProperties():this._screenNormalProperties,0,new function():void
            {
               _playerEventDispatcher.dispatchEvent(event.fullScreen?PlayerEvent.fullscreen():PlayerEvent.fullscreenExit());
               return;
               });
               return;
      }

      public function set playerEventDispatcher(param1:PlayerEventDispatcher) : void {
         this._playerEventDispatcher=param1;
         return;
      }
   }

}