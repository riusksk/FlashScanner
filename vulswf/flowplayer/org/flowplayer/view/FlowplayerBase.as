package org.flowplayer.view
{
   import org.flowplayer.controller.PlayListController;
   import org.flowplayer.config.Config;
   import flash.display.Stage;
   import org.flowplayer.model.Clip;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.PlayerError;
   import org.flowplayer.model.State;
   import org.flowplayer.model.PlayerEventType;
   import org.flowplayer.model.PlayerEvent;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.util.PropertyBinder;
   import org.flowplayer.model.DisplayPropertiesImpl;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import org.flowplayer.model.Status;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.ErrorCode;
   import flash.utils.getDefinitionByName;
   import org.flowplayer.model.Loadable;
   import flash.text.TextField;
   import org.flowplayer.util.TextUtil;
   import org.flowplayer.model.DisplayPluginModel;
   import org.flowplayer.model.ProviderModel;
   import org.flowplayer.util.LogConfiguration;
   import org.flowplayer.util.Log;
   import org.flowplayer.controller.ResourceLoader;
   import org.flowplayer.controller.ResourceLoaderImpl;
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.Cuepoint;
   import org.flowplayer.controller.StreamProvider;
   import org.flowplayer.model.Plugin;
   import org.flowplayer.model.PluginFactory;
   import org.flowplayer.util.VersionUtil;
   import org.flowplayer.controller.NetConnectionClient;
   import org.flowplayer.util.TimeUtil;
   import org.flowplayer.util.Assert;
   import org.flowplayer.util.URLUtil;

   use namespace flow_internal;

   public class FlowplayerBase extends PlayerEventDispatcher implements ErrorHandler
   {
         

      public function FlowplayerBase(param1:Stage, param2:PluginRegistry, param3:Panel, param4:AnimationEngine, param5:ErrorHandler, param6:Config, param7:String) {
         var _loc8_:Plugin = null;
         var _loc9_:PluginFactory = null;
         var _loc10_:FlowStyleSheet = null;
         var _loc11_:StyleableSprite = null;
         var _loc12_:Animation = null;
         var _loc13_:VersionUtil = null;
         var _loc14_:NetConnectionClient = null;
         var _loc15_:TimeUtil = null;
         super();
         Assert.notNull(1);
         URLUtil.isCompleteURLWithProtocol("foo");
         if(_instance)
            {
               log.error("Flowplayer already instantiated");
               throw new Error("Flowplayer already instantiated");
            }
         this._stage=param1;
         this._pluginRegistry=param2;
         this._panel=param3;
         this._animationEngine=param4;
         this._errorHandler=param5;
         this._config=param6;
         this._playerSWFBaseURL=param7;
         _instance=this;
         return;
      }

      private static var _instance:FlowplayerBase = null;

      protected var _playListController:PlayListController;

      protected var _pluginRegistry:PluginRegistry;

      protected var _config:Config;

      protected var _animationEngine:AnimationEngine;

      protected var _panel:Panel;

      private var _stage:Stage;

      private var _errorHandler:ErrorHandler;

      private var _fullscreenManager:FullscreenManager;

      private var _pluginLoader:PluginLoader;

      private var _playerSWFBaseURL:String;

      private var _keyHandler:KeyboardHandler;

      function set playlistController(param1:PlayListController) : void {
         this._playListController=param1;
         this.addStreamAndConnectionCallbacks();
         return;
      }

      function set fullscreenManager(param1:FullscreenManager) : void {
         this._fullscreenManager=param1;
         this._fullscreenManager.playerEventDispatcher=this;
         return;
      }

      public function play(param1:Clip=null) : FlowplayerBase {
         log.debug("play("+param1+")");
         this._playListController.play(param1);
         return this;
      }

      public function playInstream(param1:Clip) : void {
         if(!((this.isPlaying())||(this.isPaused())))
            {
               this.handleError(PlayerError.INSTREAM_PLAY_NOTPLAYING);
               return;
            }
         param1.position=-2;
         this.addClip(param1,this.playlist.currentIndex);
         this._playListController.playInstream(param1);
         return;
      }

      public function switchStream(param1:Clip, param2:Object=null) : void {
         log.debug("playSwitchStream("+param1+")");
         this._playListController.switchStream(param1,param2);
         return;
      }

      public function startBuffering() : FlowplayerBase {
         log.debug("startBuffering()");
         this._playListController.startBuffering();
         return this;
      }

      public function stopBuffering() : FlowplayerBase {
         log.debug("stopBuffering()");
         this._playListController.stopBuffering();
         return this;
      }

      public function pause(param1:Boolean=false) : FlowplayerBase {
         log.debug("pause()");
         this._playListController.pause(param1);
         return this;
      }

      public function resume(param1:Boolean=false) : FlowplayerBase {
         log.debug("resume()");
         this._playListController.resume(param1);
         return this;
      }

      public function toggle() : Boolean {
         log.debug("toggle()");
         if(this.state==State.PAUSED)
            {
               this.resume();
               return true;
            }
         if(this.state==State.WAITING)
            {
               this.play();
               return true;
            }
         this.pause();
         return false;
      }

      public function isPaused() : Boolean {
         return this.state==State.PAUSED;
      }

      public function isPlaying() : Boolean {
         return this.state==State.PLAYING||this.state==State.BUFFERING;
      }

      public function stop() : FlowplayerBase {
         log.debug("stop()");
         this._playListController.stop();
         return this;
      }

      public function close() : FlowplayerBase {
         log.debug("close()");
         dispatch(PlayerEventType.UNLOAD,null,false);
         this._playListController.close(true);
         return this;
      }

      public function next() : Clip {
         log.debug("next()");
         return this._playListController.next(false);
      }

      public function previous() : Clip {
         log.debug("previous()");
         return this._playListController.previous();
      }

      public function toggleFullscreen() : Boolean {
         log.debug("toggleFullscreen");
         if(dispatchBeforeEvent(PlayerEvent.fullscreen()))
            {
               this._fullscreenManager.toggleFullscreen();
            }
         return this._fullscreenManager.isFullscreen;
      }

      public function get muted() : Boolean {
         return this._playListController.muted;
      }

      public function set muted(param1:Boolean) : void {
         this._playListController.muted=param1;
         return;
      }

      public function set volume(param1:Number) : void {
         this._playListController.volume=param1;
         return;
      }

      public function get volume() : Number {
         log.debug("get volume");
         return this._playListController.volume;
      }

      public function hidePlugin(param1:String) : void {
         var _loc2_:Object = this._pluginRegistry.getPlugin(param1);
         this.checkPlugin(_loc2_,param1,DisplayProperties);
         this.doHidePlugin(DisplayProperties(_loc2_).getDisplayObject());
         return;
      }

      public function showPlugin(param1:String, param2:Object=null) : void {
         this.pluginPanelOp(this.doShowPlugin,param1,param2);
         return;
      }

      public function togglePlugin(param1:String, param2:Object=null) : Boolean {
         return this.pluginPanelOp(this.doTogglePlugin,param1,param2) as Boolean;
      }

      public function bufferAnimate(param1:Boolean=true) : void {
         var _loc2_:Object = this.playButtonOverlay.getDisplayObject();
         if(param1)
            {
               _loc2_.startBuffering();
            }
         else
            {
               _loc2_.stopBuffering();
            }
         return;
      }

      private function pluginPanelOp(param1:Function, param2:String, param3:Object=null) : Object {
         var _loc4_:Object = this._pluginRegistry.getPlugin(param2);
         this.checkPlugin(_loc4_,param2,DisplayProperties);
         return param1(DisplayProperties(_loc4_).getDisplayObject(),(param3?new PropertyBinder(new DisplayPropertiesImpl(),null).copyProperties(param3):_loc4_) as DisplayProperties);
      }

      protected function doShowPlugin(param1:DisplayObject, param2:Object) : void {
         var _loc3_:DisplayProperties = null;
         if(!(param2 is DisplayProperties))
            {
               _loc3_=new PropertyBinder(new DisplayPropertiesImpl(),null).copyProperties(param2) as DisplayProperties;
            }
         else
            {
               _loc3_=param2 as DisplayProperties;
            }
         param1.alpha=_loc3_?_loc3_.alpha:1;
         param1.visible=true;
         _loc3_.display="block";
         if(_loc3_.zIndex==-1)
            {
               _loc3_.zIndex=this.newPluginZIndex;
            }
         log.debug("showPlugin, zIndex is "+_loc3_.zIndex);
         if((this.playButtonOverlay)&&param1==this.playButtonOverlay.getDisplayObject())
            {
               this.playButtonOverlay.getDisplayObject()["showButton"]();
            }
         else
            {
               this._panel.addView(param1,null,_loc3_);
            }
         var _loc4_:DisplayProperties = this._pluginRegistry.getPluginByDisplay(param1);
         if(_loc4_)
            {
               this._pluginRegistry.updateDisplayProperties(_loc3_);
            }
         return;
      }

      private function doHidePlugin(param1:DisplayObject) : void {
         if(param1.parent==this.screen&&param1==this.playButtonOverlay.getDisplayObject())
            {
               this.playButtonOverlay.getDisplayObject()["hideButton"]();
            }
         else
            {
               if((param1.parent)&&!(param1.parent is Loader))
                  {
                     param1.parent.removeChild(param1);
                  }
            }
         var _loc2_:DisplayProperties = this._pluginRegistry.getPluginByDisplay(param1);
         if(_loc2_)
            {
               _loc2_.display="none";
               this._pluginRegistry.updateDisplayProperties(_loc2_);
            }
         return;
      }

      public function doTogglePlugin(param1:DisplayObject, param2:DisplayProperties=null) : Boolean {
         if(param1.parent==this._panel)
            {
               this.doHidePlugin(param1);
               return false;
            }
         this.doShowPlugin(param1,param2);
         return true;
      }

      public function get animationEngine() : AnimationEngine {
         return this._animationEngine;
      }

      public function get pluginRegistry() : PluginRegistry {
         return this._pluginRegistry;
      }

      public function seek(param1:Number, param2:Boolean=false) : FlowplayerBase {
         log.debug("seek to "+param1+" seconds");
         this._playListController.seekTo(param1,param2);
         return this;
      }

      public function seekRelative(param1:Number, param2:Boolean=false) : FlowplayerBase {
         log.debug("seekRelative "+param1+"%, clip is "+this.playlist.current);
         this.seek(this.playlist.current.duration*param1/100,param2);
         return this;
      }

      public function get status() : Status {
         return this._playListController.status;
      }

      public function get state() : State {
         return this._playListController.getState();
      }

      public function get playlist() : Playlist {
         return this._playListController.playlist;
      }

      public function get currentClip() : Clip {
         return this.playlist.current;
      }

      public function showError(param1:String) : void {
         this._errorHandler.showError(param1);
         return;
      }

      public function handleError(param1:ErrorCode, param2:Object=null, param3:Boolean=true) : void {
         this._errorHandler.handleError(param1,param2);
         return;
      }

      public function get version() : Array {
         var _loc1_:Class = Class(getDefinitionByName("org.flowplayer.config.VersionInfo"));
         return _loc1_.version;
      }

      public function get id() : String {
         return this._config.playerId;
      }

      public function loadPlugin(param1:String, param2:String, param3:Function) : void {
         this.loadPluginLoadable(new Loadable(param1,this._config,param2),param3);
         return;
      }

      public function loadPluginWithConfig(param1:String, param2:String, param3:Object=null, param4:Function=null) : void {
         var _loc5_:Loadable = new Loadable(param1,this._config,param2);
         if(param3)
            {
               new PropertyBinder(_loc5_,"config").copyProperties(param3);
            }
         this.loadPluginLoadable(_loc5_,param4);
         return;
      }

      public function createTextField(param1:int=12, param2:Boolean=false) : TextField {
         if((this.fonts)&&this.fonts.length<0)
            {
               return TextUtil.createTextField(true,this.fonts[0],param1,param2);
            }
         return TextUtil.createTextField(false,null,param1,param2);
      }

      public function addToPanel(param1:DisplayObject, param2:Object, param3:Function=null) : void {
         var _loc4_:DisplayProperties = param2 is DisplayProperties?param2 as DisplayProperties:new PropertyBinder(new DisplayPropertiesImpl(),null).copyProperties(param2) as DisplayProperties;
         this._panel.addView(param1,param3,_loc4_);
         return;
      }

      protected function loadPluginLoadable(param1:Loadable, param2:Function=null) : void {
         var loadable:Loadable = param1;
         var callback:Function = param2;
         var loaderCallback:Function = new function():void
            {
               var _loc1_:DisplayPluginModel = null;
               log.debug("plugin loaded");
               _pluginRegistry.setPlayerToPlugin(loadable.plugin);
               if(loadable.plugin is DisplayPluginModel)
                     {
                           _loc1_=loadable.plugin as DisplayPluginModel;
                           if(_loc1_.visible)
                                 {
                                       log.debug("adding plugin to panel");
                                       if(_loc1_.zIndex<0)
                                             {
                                                   _loc1_.zIndex=newPluginZIndex;
                                             }
                                       _panel.addView(_loc1_.getDisplayObject(),null,_loc1_);
                                 }
                     }
               else
                     {
                           if(loadable.plugin is ProviderModel)
                                 {
                                       _playListController.addProvider(loadable.plugin as ProviderModel);
                                 }
                     }
               if(!(callback==null)&&!(loadable.plugin==null))
                     {
                           callback(loadable.plugin);
                     }
               return;
            };
         this._pluginLoader.loadPlugin(loadable,loaderCallback);
         return;
      }

      private function get newPluginZIndex() : Number {
         var _loc1_:DisplayProperties = this._pluginRegistry.getPlugin("play") as DisplayProperties;
         if(!_loc1_)
            {
               return 100;
            }
         return _loc1_.zIndex;
      }

      public function get fonts() : Array {
         return this._pluginRegistry.fonts;
      }

      public function isFullscreen() : Boolean {
         return this._fullscreenManager.isFullscreen;
      }

      public function reset(param1:Array=null, param2:Number=500) : void {
         if(!param1)
            {
               param1=["controls","screen"];
            }
         var _loc3_:Number = 0;
         while(_loc3_<param1.length)
            {
               this.resetPlugin(param1[_loc3_],param2);
               _loc3_++;
            }
         return;
      }

      public function logging(param1:String, param2:String="*") : void {
         var _loc3_:LogConfiguration = new LogConfiguration();
         _loc3_.level=param1;
         _loc3_.filter=param2;
         Log.configure(_loc3_);
         return;
      }

      public function get config() : Config {
         return this._config;
      }

      public function createLoader() : ResourceLoader {
         return new ResourceLoaderImpl(this._config.playerId?null:this._playerSWFBaseURL,this);
      }

      public function setPlaylist(param1:Array) : void {
         this._playListController.setPlaylist(param1);
         log.debug("setPlaylist, currentIndex is "+this.playlist.currentIndex);
         return;
      }

      public function addClip(param1:Clip, param2:int=-1) : void {
         this._playListController.playlist.addClip(param1,param2);
         return;
      }

      public function createClips(param1:Array) : Array {
         return this._config.createClips(param1);
      }

      private function resetPlugin(param1:String, param2:Number=500) : void {
         var _loc3_:DisplayProperties = this._pluginRegistry.getOriginalProperties(param1) as DisplayProperties;
         if(_loc3_)
            {
               this._animationEngine.animate(_loc3_.getDisplayObject(),_loc3_,param2);
            }
         return;
      }

      protected function checkPlugin(param1:Object, param2:String, param3:Class=null) : void {
         if(!param1)
            {
               this.showError("There is no plugin called \'"+param2+"\'");
               return;
            }
         if((param3)&&!param1 is param3)
            {
               this.showError("Specifiec plugin \'"+param2+"\' is not an instance of "+param3);
            }
         return;
      }

      public function get screen() : DisplayProperties {
         return this._pluginRegistry.getPlugin("screen") as DisplayProperties;
      }

      public function get playButtonOverlay() : DisplayProperties {
         return DisplayProperties(this._pluginRegistry.getPlugin("play")) as DisplayProperties;
      }

      private function addStreamAndConnectionCallbacks() : void {
         this.createCallbacks(this._config.connectionCallbacks,this.addConnectionCallback,ClipEventType.CONNECTION_EVENT);
         this.createCallbacks(this._config.streamCallbacks,this.addStreamCallback,ClipEventType.NETSTREAM_EVENT);
         return;
      }

      private function addConnectionCallback(param1:String, param2:Function) : void {
         this._playListController.addConnectionCallback(param1,param2);
         return;
      }

      private function addStreamCallback(param1:String, param2:Function) : void {
         this._playListController.addStreamCallback(param1,param2);
         return;
      }

      private function createCallbacks(param1:Array, param2:Function, param3:ClipEventType) : void {
         var _loc5_:String = null;
         if(!param1)
            {
               return;
            }
         log.debug("registering "+param1.length+" callbakcs");
         var _loc4_:* = 0;
         while(_loc4_<param1.length)
            {
               _loc5_=param1[_loc4_];
               param2(_loc5_,this.createCallbackListener(param3,_loc5_));
               _loc4_++;
            }
         return;
      }

      private function createCallbackListener(param1:ClipEventType, param2:String) : Function {
         var type:ClipEventType = param1;
         var name:String = param2;
         return new function(param1:Object):void
            {
               var _loc2_:* = undefined;
               var _loc3_:* = undefined;
               var _loc4_:* = undefined;
               log.debug("received callback "+type.name+" forwarding it "+typeof param1);
               if(name=="onCuePoint")
                     {
                           _loc2_=Cuepoint.createDynamic(param1["time"],"embedded");
                           for (_loc3_ in param1)
                                 {
                                       log.debug(_loc3_+": "+param1[_loc3_]);
                                       if(_loc3_=="parameters")
                                             {
                                                   for (_loc4_ in param1.parameters)
                                                         {
                                                               log.debug(_loc4_+": "+param1.parameters[_loc4_]);
                                                               _loc2_.addParameter(_loc4_,param1.parameters[_loc4_]);
                                                         }
                                                   continue;
                                             }
                                       _loc2_[_loc3_]=param1[_loc3_];
                                 }
                           playlist.current.dispatch(ClipEventType.forName(name),_loc2_);
                           return;
                     }
               playlist.current.dispatch(ClipEventType.forName(name),createInfo(param1));
               return;
            };
      }

      private function createInfo(param1:Object) : Object {
         var _loc3_:String = null;
         if(param1 is Number||param1 is String||param1 is Boolean)
            {
               return param1;
            }
         var _loc2_:Object = {};
         for (_loc3_ in param1)
            {
               _loc2_[_loc3_]=param1[_loc3_];
            }
         return _loc2_;
      }

      public function set pluginLoader(param1:PluginLoader) : void {
         this._pluginLoader=param1;
         return;
      }

      public function set keyboardHandler(param1:KeyboardHandler) : void {
         this._keyHandler=param1;
         this._keyHandler.player=this as Flowplayer;
         return;
      }

      public function isKeyboardShortcutsEnabled() : Boolean {
         return this._keyHandler.isKeyboardShortcutsEnabled();
      }

      public function setKeyboardShortcutsEnabled(param1:Boolean) : void {
         this._keyHandler.setKeyboardShortcutsEnabled(param1);
         return;
      }

      public function addKeyListener(param1:uint, param2:Function) : void {
         this._keyHandler.addKeyListener(param1,param2);
         return;
      }

      public function removeKeyListener(param1:uint, param2:Function) : void {
         this._keyHandler.removeKeyListener(param1,param2);
         return;
      }

      public function get streamProvider() : StreamProvider {
         return this._playListController.streamProvider;
      }

      public function get panel() : Panel {
         return this._panel;
      }
   }

}