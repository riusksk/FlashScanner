package org.flowplayer.view
{
   import org.flowplayer.config.Config;
   import org.flowplayer.model.PlayButtonOverlay;
   import org.flowplayer.model.DisplayPluginModel;
   import flash.utils.Dictionary;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.flowplayer.controller.ResourceLoader;
   import flash.utils.Timer;
   import flash.events.MouseEvent;
   import org.flowplayer.util.Log;
   import flash.system.Security;
   import org.flowplayer.util.URLUtil;
   import flash.events.Event;
   import org.flowplayer.util.Arrange;
   import org.flowplayer.config.VersionInfo;
   import org.flowplayer.model.EventDispatcher;
   import org.flowplayer.controller.PlayListController;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.PlayerEvent;
   import flash.display.BlendMode;
   import org.flowplayer.model.PlayerError;
   import org.flowplayer.model.PluginEvent;
   import org.flowplayer.model.PluginModel;
   import org.flowplayer.model.Loadable;
   import org.flowplayer.model.Plugin;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.util.TextUtil;
   import flash.text.TextFieldAutoSize;
   import flash.events.TimerEvent;
   import org.flowplayer.model.ErrorCode;
   import org.osflash.thunderbolt.Logger;
   import flash.system.Capabilities;
   import org.flowplayer.model.DisplayProperties;
   import flash.display.DisplayObject;
   import org.flowplayer.config.ConfigParser;
   import org.flowplayer.controller.ResourceLoaderImpl;
   import org.flowplayer.model.ProviderModel;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.Logo;
   import org.flowplayer.model.Callable;
   import org.flowplayer.config.ExternalInterfaceHelper;
   import org.flowplayer.model.State;
   import flash.display.DisplayObjectContainer;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   import org.flowplayer.model.ClipEventType;

   use namespace flow_internal;

   public class Launcher extends StyleableSprite implements ErrorHandler
   {
         

      public function Launcher() {
         this._providers=new Dictionary();
         this._clickTimer=new Timer(200,1);
         addEventListener(Event.ADDED_TO_STAGE,new function(param1:Event):void
            {
               URLUtil.loaderInfo=loaderInfo;
               callAndHandleError(createFlashVarsConfig,PlayerError.INIT_FAILED);
               return;
               });
               super("#canvas",this);
               return;
      }



      private var _panel:Panel;

      private var _screen:Screen;

      private var _config:Config;

      private var _flowplayer:Flowplayer;

      private var _pluginRegistry:PluginRegistry;

      private var _animationEngine:AnimationEngine;

      private var _playButtonOverlay:PlayButtonOverlay;

      private var _controlsModel:DisplayPluginModel;

      private var _providers:Dictionary;

      private var _canvasLogo:Sprite;

      private var _pluginLoader:PluginLoader;

      private var _error:TextField;

      private var _pluginsInitialized:Number = 0;

      private var _enteringFullscreen:Boolean;

      private var _copyrightNotice:TextField;

      private var _playlistLoader:ResourceLoader;

      private var _fullscreenManager:FullscreenManager;

      private var _screenArrangeCount:int = 0;

      private var _clickCount:int;

      private var _clickTimer:Timer;

      private var _clickEvent:MouseEvent;

      private var _screenMask:Sprite;

      private function initPhase1() : void {
         if(this._flowplayer)
            {
               log.debug("already initialized, returning");
               return;
            }
         Log.configure(this._config.getLogConfiguration());
         this.initCustomClipEvents();
         if(this._config.playerId)
            {
               Security.allowDomain(URLUtil.pageLocation);
            }
         loader=this.createNewLoader();
         rootStyle=this._config.canvas.style;
         stage.addEventListener(Event.RESIZE,this.onStageResize);
         stage.addEventListener(Event.RESIZE,this.arrangeScreen);
         setSize(Arrange.parentWidth,Arrange.parentHeight);
         if(!VersionInfo.commercial)
            {
               log.debug("Adding logo to canvas");
               this.createLogoForCanvas();
            }
         log=new Log(this);
         EventDispatcher.playerId=this._config.playerId;
         log.debug("security sandbox type: "+Security.sandboxType);
         log.info(VersionInfo.versionInfo());
         log.debug("creating Panel");
         this.createPanel();
         this._pluginRegistry=new PluginRegistry(this._panel);
         log.debug("Creating animation engine");
         this.createAnimationEngine(this._pluginRegistry);
         log.debug("creating play button overlay");
         this.createPlayButtonOverlay();
         log.debug("creating Flowplayer API");
         this.createFlowplayer();
         this.loadPlaylistFeed();
         return;
      }

      private function initPhase2(param1:Event=null) : void {
         var event:Event = param1;
         log.info("initPhase2");
         this._flowplayer.keyboardHandler=new KeyboardHandler(stage,new function():Boolean
            {
               return enteringFullscreen;
               });
               this.loadPlugins();
               return;
      }

      private function initPhase3(param1:Event=null) : void {
         var event:Event = param1;
         log.debug("initPhase3, all plugins loaded");
         this.createScreen();
         this._config.getPlaylist().onBeforeBegin(new function(param1:ClipEvent):void
            {
               hideErrorMessage();
               return;
               });
               if(this._playButtonOverlay)
                  {
                     PlayButtonOverlayView(this._playButtonOverlay.getDisplayObject()).playlist=this._config.getPlaylist();
                  }
               log.debug("creating PlayListController");
               this._providers=this._pluginLoader.providers;
               var playListController:PlayListController = this.createPlayListController();
               this.addPlayListListeners();
               this.createFullscreenManager(playListController.playlist);
               this.addScreenToPanel();
               if(!this.validateLicenseKey())
                  {
                     this.createLogoForCanvas();
                     this.resizeCanvasLogo();
                  }
               log.debug("creating logo");
               this.createLogo();
               contextMenu=new ContextMenuBuilder(this._config.playerId,this._config.contextMenu).build();
               log.debug("initializing ExternalInterface");
               if(this.useExternalInterface())
                  {
                     this._flowplayer.initExternalInterface();
                  }
               log.debug("calling onLoad to plugins");
               this._pluginRegistry.onLoad(this._flowplayer);
               if(this.countPlugins()==0)
                  {
                     log.debug("no loadable plugins, calling initPhase4");
                     this.initPhase4();
                  }
               return;
      }

      private function initPhase4(param1:Event=null) : void {
         log.info("initPhase4, all plugins initialized");
         log.debug("Adding visible plugins to panel");
         this.addPluginsToPanel(this._pluginRegistry);
         log.debug("dispatching onLoad");
         this._flowplayer.dispatchEvent(PlayerEvent.load("player"));
         log.debug("starting configured streams");
         this.startStreams();
         this.createScreenMask();
         this.arrangeScreen();
         this.addListeners();
         return;
      }

      private function createScreenMask() : void {
         blendMode=BlendMode.LAYER;
         this._screenMask=new Sprite();
         this._screenMask.graphics.beginFill(16711680);
         this._screenMask.graphics.drawRect(0,0,1,1);
         this._screenMask.blendMode=BlendMode.ERASE;
         this._screenMask.x=0;
         this._screenMask.y=0;
         this._screenMask.width=100;
         this._screenMask.height=100;
         return;
      }

      private function resizeCanvasLogo() : void {
         this._canvasLogo.alpha=1;
         this._canvasLogo.width=150;
         this._canvasLogo.scaleY=this._canvasLogo.scaleX;
         this.arrangeCanvasLogo();
         return;
      }

      private function useExternalInterface() : Boolean {
         log.debug("useExternalInteface: "+!(this._config.playerId==null));
         return !(this._config.playerId==null);
      }

      private function onStageResize(param1:Event=null) : void {
         setSize(Arrange.parentWidth,Arrange.parentHeight);
         this.arrangeCanvasLogo();
         return;
      }

      private function arrangeCanvasLogo() : void {
         if(!this._canvasLogo)
            {
               return;
            }
         this._canvasLogo.x=15;
         this._canvasLogo.y=Arrange.parentHeight-(this._controlsModel?this._controlsModel.dimensions.height.toPx(Arrange.parentHeight)+10:10)-this._canvasLogo.height-this._copyrightNotice.height;
         this._copyrightNotice.x=12;
         this._copyrightNotice.y=this._canvasLogo.y+this._canvasLogo.height;
         return;
      }

      private function loadPlugins() : void {
         var _loc1_:Array = this._config.getLoadables();
         log.debug("will load following plugins: ");
         this.logPluginInfo(_loc1_);
         this._pluginLoader=new PluginLoader(URLUtil.playerBaseUrl,this._pluginRegistry,this,this.useExternalInterface());
         this._pluginLoader.addEventListener(Event.COMPLETE,this.pluginLoadListener);
         this._flowplayer.pluginLoader=this._pluginLoader;
         if(_loc1_.length==0)
            {
               log.debug("configuration has no plugins");
               this.initPhase3();
            }
         else
            {
               this._pluginLoader.load(_loc1_,this.onPluginLoad,this.onPluginLoadError);
            }
         return;
      }

      private function logPluginInfo(param1:Array, param2:Boolean=false) : void {
         var _loc3_:Number = 0;
         while(_loc3_<param1.length)
            {
               log.info(""+param1[_loc3_]);
               if(param2)
                  {
                  }
               _loc3_++;
            }
         return;
      }

      private function pluginLoadListener(param1:Event=null) : void {
         this._pluginLoader.removeEventListener(Event.COMPLETE,this.pluginLoadListener);
         this.callAndHandleError(this.initPhase3,PlayerError.INIT_FAILED);
         return;
      }

      private function loadPlaylistFeed() : void {
         var playlistFeed:String = this._config.playlistFeed;
         if(!playlistFeed)
            {
               this.callAndHandleError(this.initPhase2,PlayerError.INIT_FAILED);
               return;
            }
         log.info("loading playlist from "+playlistFeed);
         this._playlistLoader=this._flowplayer.createLoader();
         this._playlistLoader.addTextResourceUrl(playlistFeed);
         this._playlistLoader.load(null,new function(param1:ResourceLoader):void
            {
               log.info("received playlist feed");
               _config.playlistDocument=param1.getContent() as String;
               _config.getPlaylist().dispatchPlaylistReplace();
               callAndHandleError(initPhase2,PlayerError.INIT_FAILED);
               return;
               });
               return;
      }

      private function onPluginLoad(param1:PluginEvent) : void {
         var _loc2_:PluginModel = param1.target as PluginModel;
         log.info("plugin "+_loc2_+" initialized");
         this.checkPluginsInitialized();
         return;
      }

      private function onPluginLoadError(param1:PluginEvent) : void {
         var _loc2_:PluginModel = null;
         if(param1.target is Loadable)
            {
               this.handleError(PlayerError.PLUGIN_LOAD_FAILED,"unable to load plugin \'"+Loadable(param1.target).name+"\', url: \'"+Loadable(param1.target).url+"\'");
            }
         else
            {
               _loc2_=param1.target as PluginModel;
               this._pluginRegistry.removePlugin(_loc2_);
               this.handleError(PlayerError.PLUGIN_LOAD_FAILED,"load/init error on "+_loc2_);
            }
         return;
      }

      private function checkPluginsInitialized() : void {
         var _loc1_:int = this.countPlugins();
         if(++this._pluginsInitialized==_loc1_)
            {
               log.info("all plugins initialized");
               this.callAndHandleError(this.initPhase4,PlayerError.INIT_FAILED);
            }
         log.info(this._pluginsInitialized+" out of "+_loc1_+" plugins initialized");
         return;
      }

      private function countPlugins() : int {
         var _loc4_:PluginModel = null;
         var _loc5_:* = false;
         var _loc1_:Number = 0;
         var _loc2_:Array = this._config.getLoadables();
         var _loc3_:Number = 0;
         while(_loc3_<_loc2_.length)
            {
               _loc4_=Loadable(_loc2_[_loc3_]).plugin;
               if(!_loc4_)
                  {
                     this.handleError(PlayerError.PLUGIN_LOAD_FAILED,"Unable to load plugin, url "+Loadable(_loc2_[_loc3_]).url+", name "+Loadable(_loc2_[_loc3_]).name);
                  }
               else
                  {
                     _loc5_=_loc4_.pluginObject is Plugin;
                     if(Loadable(_loc2_[_loc3_]).loadFailed)
                        {
                           log.debug("load failed for "+_loc2_[_loc3_]);
                           _loc1_++;
                        }
                     else
                        {
                           if(!_loc4_)
                              {
                                 log.debug("this plugin is not loaded yet");
                                 _loc1_++;
                              }
                           else
                              {
                                 if(_loc5_)
                                    {
                                       log.debug("will wait for onLoad from plugin "+_loc4_);
                                       _loc1_++;
                                    }
                                 else
                                    {
                                       log.debug("will NOT wait for onLoad from plugin "+Loadable(_loc2_[_loc3_]).plugin);
                                    }
                              }
                        }
                  }
               _loc3_++;
            }
         return _loc1_+(this._playButtonOverlay?1:0);
      }

      private function validateLicenseKey() : Boolean {
         try
            {
               return LicenseKey.validate(root.loaderInfo.url,this._flowplayer.version,this._config.licenseKey,this.useExternalInterface());
            }
         catch(e:Error)
            {
               log.warn("License key not accepted, will show flowplayer logo");
            }
         return false;
      }

      private function createFullscreenManager(param1:Playlist) : void {
         this._fullscreenManager=new FullscreenManager(stage,param1,this._panel,this._pluginRegistry,this._animationEngine);
         this._flowplayer.fullscreenManager=this._fullscreenManager;
         return;
      }

      public function showError(param1:String) : void {
         if(!this._panel)
            {
               return;
            }
         if(!this._config.showErrors)
            {
               return;
            }
         if((this._error)&&this._error.parent==this)
            {
               removeChild(this._error);
            }
         this._error=TextUtil.createTextField(false);
         this._error.background=true;
         this._error.backgroundColor=0;
         this._error.textColor=16777215;
         this._error.autoSize=TextFieldAutoSize.CENTER;
         this._error.multiline=true;
         this._error.wordWrap=true;
         this._error.text=param1;
         this._error.selectable=true;
         this._error.width=Arrange.parentWidth-40;
         Arrange.center(this._error,Arrange.parentWidth,Arrange.parentHeight);
         addChild(this._error);
         this.createErrorMessageHideTimer();
         return;
      }

      private function createErrorMessageHideTimer() : void {
         var _loc1_:Timer = new Timer(10000,1);
         _loc1_.addEventListener(TimerEvent.TIMER_COMPLETE,this.hideErrorMessage);
         _loc1_.start();
         return;
      }

      private function hideErrorMessage(param1:TimerEvent=null) : void {
         var event:TimerEvent = param1;
         if((this._error)&&this._error.parent==this)
            {
               if(this._animationEngine)
                  {
                     this._animationEngine.fadeOut(this._error,1000,new function():void
                        {
                           removeChild(_error);
                           return;
                           });
                        }
                     else
                        {
                           removeChild(this._error);
                        }
                  }
               return;
      }

      public function handleError(param1:ErrorCode, param2:Object=null, param3:Boolean=true) : void {
         if(this._flowplayer)
            {
               this._flowplayer.dispatchError(param1,param2);
            }
         else
            {
               new PlayerEventDispatcher().dispatchError(param1,param2);
            }
         var _loc4_:* = "";
         if(false&&param2 is Error&&(param2.getStackTrace()))
            {
               _loc4_=param2.getStackTrace();
            }
         this.doHandleError(param1.code+": "+param1.message+(param2?": "+param2+(_loc4_?" - Stack: "+_loc4_:""):""),param3);
         return;
      }

      private function doHandleError(param1:String, param2:Boolean=true) : void {
         if((this._config)&&(this._config.playerId))
            {
               Logger.error(param1);
            }
         this.showError(param1);
         if((param2)&&(Capabilities.isDebugger)&&(this._config.showErrors))
            {
               throw new Error(param1);
            }
         return;
      }

      private function createAnimationEngine(param1:PluginRegistry) : void {
         this._animationEngine=new AnimationEngine(this._panel,param1);
         return;
      }

      private function addPluginsToPanel(param1:PluginRegistry) : void {
         var _loc2_:Object = null;
         var _loc3_:DisplayPluginModel = null;
         for each (_loc2_ in param1.plugins)
            {
               if(_loc2_ is DisplayPluginModel)
                  {
                     _loc3_=_loc2_ as DisplayPluginModel;
                     log.debug("adding plugin \'"+_loc3_.name+"\' to panel: "+_loc3_.visible+", plugin object is "+_loc3_.getDisplayObject());
                     if(_loc3_.visible)
                        {
                           if(_loc3_.zIndex==-1)
                              {
                                 _loc3_.zIndex=100;
                              }
                           this._panel.addView(_loc3_.getDisplayObject(),undefined,_loc3_);
                        }
                     if(_loc3_.name=="controls")
                        {
                           this._controlsModel=_loc3_;
                        }
                  }
            }
         if(this._controlsModel)
            {
               this.arrangeCanvasLogo();
            }
         return;
      }

      private function addScreenToPanel() : void {
         var _loc1_:DisplayProperties = this._pluginRegistry.getPlugin("screen") as DisplayProperties;
         _loc1_.display="none";
         _loc1_.getDisplayObject().visible=false;
         this._panel.addView(_loc1_.getDisplayObject(),null,_loc1_);
         return;
      }

      private function arrangeScreen(param1:Event=null) : void {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         log.debug("arrangeScreen(), already arranged "+this._screenArrangeCount);
         if(this._screenArrangeCount>1)
            {
               return;
            }
         if(!this._pluginRegistry)
            {
               return;
            }
         var _loc2_:DisplayProperties = this._pluginRegistry.getPlugin("screen") as DisplayProperties;
         if(!_loc2_)
            {
               return;
            }
         if((this._controlsModel)&&(this._controlsModel.visible))
            {
               if((this.isControlsAlwaysAutoHide())||this._controlsModel.position.bottom.px<0)
                  {
                     log.debug("controls is autoHide or it\'s in a non-default vertical position, configuring screen to take all available space");
                     this.setScreenBottomAndHeight(_loc2_,100,0);
                  }
               else
                  {
                     _loc3_=this._controlsModel.getDisplayObject().height;
                     _loc4_=this.screenTopOrBottomConfigured()?this.getScreenTopOrBottomPx(_loc2_):_loc3_;
                     log.debug("occupied by controls or screen\'s configured bottom/top is "+_loc4_);
                     _loc5_=0;
                     if((this.screenTopOrBottomConfigured())&&(_loc2_.position.top.pct>=0||_loc2_.position.bottom.pct>=0))
                        {
                           _loc5_=100-Math.abs(50-(_loc2_.position.top.pct>=0?_loc2_.position.top.pct:_loc2_.position.bottom.pct))*2;
                           this.setScreenBottomAndHeight(_loc2_,_loc5_,_loc3_);
                        }
                     else
                        {
                           _loc5_=(Arrange.parentHeight-_loc4_)/Arrange.parentHeight*100;
                           this.setScreenBottomAndHeight(_loc2_,_loc5_,_loc3_);
                        }
                  }
            }
         log.debug("arrangeScreen(): arranging screen to pos "+_loc2_.position);
         _loc2_.display="block";
         _loc2_.alpha=1;
         _loc2_.getDisplayObject().visible=true;
         this._pluginRegistry.updateDisplayProperties(_loc2_,true);
         this._panel.update(_loc2_.getDisplayObject(),_loc2_);
         this._panel.draw(_loc2_.getDisplayObject());
         this._screenArrangeCount++;
         return;
      }

      private function getScreenTopOrBottomPx(param1:DisplayProperties) : Number {
         var _loc2_:Object = this._config.getObject("screen");
         if(_loc2_.hasOwnProperty("top"))
            {
               return param1.position.top.toPx(Arrange.parentHeight);
            }
         if(_loc2_.hasOwnProperty("bottom"))
            {
               return param1.position.bottom.toPx(Arrange.parentHeight);
            }
         return 0;
      }

      private function setScreenBottomAndHeight(param1:DisplayProperties, param2:Number, param3:Number=0) : void {
         if(!this.screenTopOrBottomConfigured())
            {
               log.debug("screen vertical pos not configured, setting bottom to value "+param3);
               param1.bottom=param3;
            }
         else
            {
               log.debug("using configured top/bottom for screen");
            }
         var _loc4_:Boolean = (this._config.getObject("screen"))&&(this._config.getObject("screen").hasOwnProperty("height"));
         if(!_loc4_)
            {
               log.debug("screen height not configured, setting it to value "+param2+"%");
               param1.height=param2+"%";
            }
         else
            {
               log.debug("using configured height for screen");
            }
         return;
      }

      private function screenTopOrBottomConfigured() : Boolean {
         var _loc1_:Object = this._config.getObject("screen");
         if(!_loc1_)
            {
               return false;
            }
         if(_loc1_.hasOwnProperty("top"))
            {
               return true;
            }
         if(_loc1_.hasOwnProperty("bottom"))
            {
               return true;
            }
         return false;
      }

      private function isControlsAlwaysAutoHide() : Boolean {
         if(!this._controlsModel)
            {
               return false;
            }
         var _loc1_:DisplayObject = this._controlsModel.getDisplayObject();
         log.debug("controls.auotoHide "+_loc1_["getAutoHide"]());
         return !_loc1_["getAutoHide"]()["fullscreenOnly"];
      }

      private function createFlowplayer() : void {
         this._flowplayer=new Flowplayer(stage,this._pluginRegistry,this._panel,this._animationEngine,this,this,this._config,URLUtil.playerBaseUrl);
         this._flowplayer.onBeforeFullscreen(this.onFullscreen);
         return;
      }

      private function onFullscreen(param1:PlayerEvent) : void {
         log.debug("entering fullscreen, disabling display clicks");
         this._screenArrangeCount=100;
         stage.removeEventListener(Event.RESIZE,this.arrangeScreen);
         this._enteringFullscreen=true;
         var _loc2_:Timer = new Timer(1000,1);
         _loc2_.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         _loc2_.start();
         return;
      }

      private function onTimerComplete(param1:TimerEvent) : void {
         log.debug("fullscreen wait delay complete, display clicks are enabled again");
         this._enteringFullscreen=false;
         return;
      }

      private function createFlashVarsConfig() : void {
         log.debug("createFlashVarsConfig()");
         if(!root.loaderInfo.parameters)
            {
               return;
            }
         var configStr:String = (Preloader(root).injectedConfig)||(root.loaderInfo.parameters["config"]);
         var configObj:Object = (configStr)&&configStr.indexOf("{")==0?ConfigParser.parse(configStr):{};
         if(!configStr||((configStr)&&(configStr.indexOf("{")==0))&&(!configObj.hasOwnProperty("url")))
            {
               this._config=ConfigParser.parseConfig(configObj,BuiltInConfig.config,loaderInfo.url,VersionInfo.controlsVersion,VersionInfo.audioVersion);
               this.callAndHandleError(this.initPhase1,PlayerError.INIT_FAILED);
            }
         else
            {
               ConfigParser.loadConfig(configObj.hasOwnProperty("url")?String(configObj["url"]):configStr,BuiltInConfig.config,new function(param1:Config):void
                  {
                     _config=param1;
                     callAndHandleError(initPhase1,PlayerError.INIT_FAILED);
                     return;
                     },new ResourceLoaderImpl(null,this),loaderInfo.url,VersionInfo.controlsVersion,VersionInfo.audioVersion);
                  }
               return;
      }

      private function createPlayListController() : PlayListController {
         this.createHttpProviders();
         var _loc1_:PlayListController = new PlayListController(this._config.getPlaylist(),this._providers,this._config,this.createNewLoader());
         _loc1_.playerEventDispatcher=this._flowplayer;
         this._flowplayer.playlistController=_loc1_;
         return _loc1_;
      }

      private function createHttpProviders() : void {
         if(!this._providers)
            {
               this._providers=new Dictionary();
            }
         this._providers["http"]=this.createProvider("http");
         this._providers["httpInstream"]=this.createProvider("httpInstream");
         return;
      }

      private function createProvider(param1:String) : Object {
         log.debug("creating provider with name "+param1);
         var _loc2_:ProviderModel = this._config.createHttpProvider(param1);
         this._pluginRegistry.registerProvider(_loc2_);
         return _loc2_.pluginObject;
      }

      private function get hasHttpChildClip() : Boolean {
         var _loc1_:Array = this._config.getPlaylist().childClips;
         var _loc2_:* = 0;
         while(_loc2_<_loc1_.length)
            {
               if(Clip(_loc1_[_loc2_]).provider=="httpInstream")
                  {
                     log.info("child clip with http provider found");
                     return true;
                  }
               _loc2_++;
            }
         return false;
      }

      private function createScreen() : void {
         this._screen=new Screen(this._config.getPlaylist(),this._animationEngine,this._playButtonOverlay,this._pluginRegistry);
         var _loc1_:DisplayProperties = this._config.getScreenProperties();
         this.initView(this._screen,_loc1_,null,false);
         if(this._playButtonOverlay)
            {
               PlayButtonOverlayView(this._playButtonOverlay.getDisplayObject()).setScreen(this._screen,(this.hasClip)&&(this._config.useBufferingAnimation));
            }
         return;
      }

      private function createPlayButtonOverlay() : void {
         this._playButtonOverlay=this._config.getPlayButtonOverlay();
         if(!this._playButtonOverlay)
            {
               return;
            }
         this._playButtonOverlay.onLoad(this.onPluginLoad);
         this._playButtonOverlay.onError(this.onPluginLoadError);
         var _loc1_:PlayButtonOverlayView = new PlayButtonOverlayView(!this.playButtonOverlayWidthDefined(),this._playButtonOverlay,this._pluginRegistry);
         this.initView(_loc1_,this._playButtonOverlay,null,false);
         return;
      }

      private function playButtonOverlayWidthDefined() : Boolean {
         if(!this._config.getObject("play"))
            {
               return false;
            }
         return this._config.getObject("play").hasOwnProperty("width");
      }

      private function get hasClip() : Boolean {
         var _loc1_:Clip = this._config.getPlaylist().current;
         var _loc2_:Boolean = !_loc1_.isNullClip&&((_loc1_.url)||!(_loc1_.provider=="http"));
         return _loc2_;
      }

      private function createLogo() : void {
         var _loc1_:LogoView = new LogoView(this._panel,this._flowplayer);
         var _loc2_:Logo = (this._config.getLogo(_loc1_))||(new Logo(_loc1_,"logo"));
         _loc2_.visible=false;
         _loc1_.model=_loc2_;
         this.initView(_loc1_,_loc2_,_loc1_.draw,false);
         return;
      }

      private function initView(param1:DisplayObject, param2:DisplayProperties, param3:Function=null, param4:Boolean=true) : void {
         if(!(param2.name=="logo")||(VersionInfo.commercial))
            {
               this._pluginRegistry.registerDisplayPlugin(param2,param1);
            }
         if(param4)
            {
               this._panel.addView(param1,param3,param2);
            }
         if(param2 is Callable)
            {
               ExternalInterfaceHelper.initializeInterface(param2 as Callable,param1);
            }
         return;
      }

      private function addListeners() : void {
         this._clickTimer.addEventListener(TimerEvent.TIMER,this.onClickTimer);
         doubleClickEnabled=true;
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
         this._screen.addEventListener(MouseEvent.CLICK,this.onClickEvent);
         if(this._playButtonOverlay)
            {
               this._playButtonOverlay.getDisplayObject().addEventListener(MouseEvent.CLICK,this.onClickEvent);
            }
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,Arrange.parentWidth,Arrange.parentHeight);
         graphics.endFill();
         return;
      }

      private function onMouseOut(param1:MouseEvent) : void {
         this._flowplayer.dispatchEvent(PlayerEvent.mouseOut());
         return;
      }

      private function onMouseOver(param1:MouseEvent) : void {
         this._flowplayer.dispatchEvent(PlayerEvent.mouseOver());
         return;
      }

      private function createPanel() : void {
         this._panel=new Panel();
         addChild(this._panel);
         return;
      }

      private function startStreams() : void {
         var _loc1_:* = true;
         if(this._flowplayer.state!=State.WAITING)
            {
               log.debug("streams have been started in player.onLoad(), will not start streams here.");
               _loc1_=false;
            }
         if(!this.hasClip)
            {
               log.info("Configuration has no clips to play.");
               _loc1_=false;
            }
         var _loc2_:PlayButtonOverlayView = this._playButtonOverlay?PlayButtonOverlayView(this._playButtonOverlay.getDisplayObject()):null;
         if(_loc1_)
            {
               if(this._flowplayer.currentClip.autoPlay)
                  {
                     log.debug("clip is autoPlay");
                     this._flowplayer.play();
                  }
               else
                  {
                     if(this._flowplayer.currentClip.autoBuffering)
                        {
                           log.debug("clip is autoBuffering");
                           this._flowplayer.startBuffering();
                        }
                     else
                        {
                           if(_loc2_)
                              {
                                 _loc2_.stopBuffering();
                                 _loc2_.showButton();
                              }
                        }
                  }
            }
         else
            {
               if(_loc2_)
                  {
                     _loc2_.stopBuffering();
                  }
            }
         return;
      }

      private function addPlayListListeners() : void {
         var _loc1_:Playlist = this._config.getPlaylist();
         _loc1_.onError(this.onClipError);
         _loc1_.onBegin(this.onBegin);
         return;
      }

      private function onBegin(param1:ClipEvent) : void {
         this.buttonMode=Boolean(Clip(param1.target).linkUrl);
         return;
      }

      private function onClipError(param1:ClipEvent) : void {
         if(param1.isDefaultPrevented())
            {
               return;
            }
         this.doHandleError(param1.error.code+", "+param1.error.message+", "+param1.info2+", clip: \'"+Clip(param1.target)+"\'");
         return;
      }

      private function onClickTimer(param1:TimerEvent) : void {
         if(this._clickCount==1)
            {
               this.onSingleClick(this._clickEvent);
            }
         this._clickCount=0;
         return;
      }

      private function onDoubleClick(param1:MouseEvent=null) : void {
         log.debug("onDoubleClick");
         this._flowplayer.toggleFullscreen();
         return;
      }

      private function onSingleClick(param1:MouseEvent) : void {
         if(this.isParent(DisplayObject(param1.target),this._screen))
            {
               log.debug("screen clicked");
               this._flowplayer.toggle();
            }
         return;
      }

      private function onClickEvent(param1:MouseEvent) : void {
         var _loc2_:Clip = null;
         if(this._enteringFullscreen)
            {
               return;
            }
         log.debug("onViewClicked, target "+param1.target+", current target "+param1.currentTarget);
         param1.stopPropagation();
         if((this._playButtonOverlay)&&(this.isParent(DisplayObject(param1.target),this._playButtonOverlay.getDisplayObject())))
            {
               this._flowplayer.toggle();
               return;
            }
         _loc2_=this._flowplayer.playlist.current;
         if(_loc2_.linkUrl)
            {
               log.debug("opening linked page "+_loc2_.linkUrl);
               this._flowplayer.pause();
               URLUtil.openPage(_loc2_.linkUrl,_loc2_.linkWindow);
               return;
            }
         if(++this._clickCount==2)
            {
               this.onDoubleClick(param1);
            }
         else
            {
               this._clickEvent=param1;
               this._clickTimer.start();
            }
         return;
      }

      private function isParent(param1:DisplayObject, param2:DisplayObject) : Boolean {
         var i:Number = NaN;
         var curChild:DisplayObject = null;
         var child:DisplayObject = param1;
         var parent:DisplayObject = param2;
         try
            {
               if(DisplayObject(child).parent==parent)
                  {
                     return true;
                  }
               if(!(parent is DisplayObjectContainer))
                  {
                     return false;
                  }
               i=0;
               while(i<DisplayObjectContainer(parent).numChildren)
                  {
                     curChild=DisplayObjectContainer(parent).getChildAt(i);
                     if(this.isParent(child,curChild))
                        {
                           return true;
                        }
                     i++;
                  }
            }
         catch(e:SecurityError)
            {
               return true;
            }
         return false;
      }

      override  protected function onRedraw() : void {
         if((bgImageHolder)&&getChildIndex(bgImageHolder)<getChildIndex(this._panel))
            {
               swapChildren(bgImageHolder,this._panel);
            }
         return;
      }

      private function createLogoForCanvas() : void {
         if(this._canvasLogo)
            {
               return;
            }
         this._copyrightNotice=LogoUtil.createCopyrightNotice(8);
         addChild(this._copyrightNotice);
         this._canvasLogo=new CanvasLogo();
         this._canvasLogo.width=85;
         this._canvasLogo.scaleY=this._canvasLogo.scaleX;
         this._canvasLogo.alpha=0.4;
         this._canvasLogo.addEventListener(MouseEvent.CLICK,new function(param1:MouseEvent):void
            {
               navigateToURL(new URLRequest("http://flowplayer.org"),"_self");
               return;
               });
               this._canvasLogo.buttonMode=true;
               log.debug("adding logo to display list");
               addChild(this._canvasLogo);
               this.onStageResize();
               return;
      }

      private function createNewLoader() : ResourceLoader {
         return new ResourceLoaderImpl(this._config.playerId?null:URLUtil.playerBaseUrl,this);
      }

      private function initCustomClipEvents() : void {
         this.createCustomClipEvents(this._config.connectionCallbacks);
         this.createCustomClipEvents(this._config.streamCallbacks);
         return;
      }

      private function createCustomClipEvents(param1:Array) : void {
         if(!param1)
            {
               return;
            }
         var _loc2_:* = 0;
         while(_loc2_<param1.length)
            {
               log.debug("creating custom event type "+param1[_loc2_]);
               _loc2_++;
            }
         return;
      }

      private function callAndHandleError(param1:Function, param2:PlayerError) : void {
         var func:Function = param1;
         var error:PlayerError = param2;
         try
            {
               func();
            }
         catch(e:Error)
            {
               handleError(error,e,false);
               throw e;
            }
         return;
      }

      function get enteringFullscreen() : Boolean {
         return this._enteringFullscreen;
      }
   }

}