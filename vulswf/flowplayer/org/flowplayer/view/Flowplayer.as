package org.flowplayer.view
{
   import org.flowplayer.config.ExternalInterfaceHelper;
   import flash.external.ExternalInterface;
   import org.flowplayer.util.ObjectConverter;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.PlayerError;
   import org.flowplayer.controller.ResourceLoader;
   import org.flowplayer.model.Clip;
   import org.flowplayer.util.NumberUtil;
   import org.flowplayer.model.DisplayPluginModel;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.model.Callable;
   import org.flowplayer.util.PropertyBinder;
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.PluginModel;
   import org.flowplayer.model.PluginEventType;
   import org.flowplayer.model.PluginEvent;
   import flash.utils.getDefinitionByName;
   import flash.display.Stage;
   import org.flowplayer.config.Config;

   use namespace flow_internal;

   public class Flowplayer extends FlowplayerBase
   {
         

      public function Flowplayer(param1:Stage, param2:PluginRegistry, param3:Panel, param4:AnimationEngine, param5:StyleableSprite, param6:ErrorHandler, param7:Config, param8:String) {
         super(param1,param2,param3,param4,param6,param7,param8);
         this._canvas=param5;
         return;
      }

      private static function addCallback(param1:String, param2:Function) : void {
         ExternalInterfaceHelper.addCallback("fp_"+param1,param2);
         return;
      }

      private var _keyHandler:KeyboardHandler;

      private var _canvas:StyleableSprite;

      public function initExternalInterface() : void {
         var wrapper:WrapperForIE = null;
         if(!ExternalInterface.available)
            {
               log.info("ExternalInteface is not available in this runtime. JavaScript access will be disabled.");
            }
         try
            {
               addCallback("getVersion",new function():Array
                  {
                     return version;
                     });
                     addCallback("getPlaylist",new function():Array
                        {
                           return convert(playlist.clips) as Array;
                           });
                           addCallback("getId",new function():String
                              {
                                 return id;
                                 });
                                 addCallback("play",this.genericPlay);
                                 addCallback("playFeed",this.playFeed);
                                 addCallback("startBuffering",new function():void
                                    {
                                       startBuffering();
                                       return;
                                       });
                                       addCallback("stopBuffering",new function():void
                                          {
                                             stopBuffering();
                                             return;
                                             });
                                             addCallback("isFullscreen",isFullscreen);
                                             addCallback("toggleFullscreen",toggleFullscreen);
                                             addCallback("toggle",toggle);
                                             addCallback("getState",new function():Number
                                                {
                                                   return state.code;
                                                   });
                                                   addCallback("getStatus",new function():Object
                                                      {
                                                         return convert(status);
                                                         });
                                                         addCallback("isPlaying",isPlaying);
                                                         addCallback("isPaused",isPaused);
                                                         wrapper=new WrapperForIE(this);
                                                         addCallback("stop",wrapper.fp_stop);
                                                         addCallback("pause",wrapper.fp_pause);
                                                         addCallback("resume",wrapper.fp_resume);
                                                         addCallback("close",wrapper.fp_close);
                                                         addCallback("getTime",new function():Number
                                                            {
                                                               return status.time;
                                                               });
                                                               addCallback("mute",new function():void
                                                                  {
                                                                     muted=true;
                                                                     return;
                                                                     });
                                                                     addCallback("unmute",new function():void
                                                                        {
                                                                           muted=false;
                                                                           return;
                                                                           });
                                                                           addCallback("isMuted",new function():Boolean
                                                                              {
                                                                                 return muted;
                                                                                 });
                                                                                 addCallback("setVolume",new function(param1:Number):void
                                                                                    {
                                                                                       volume=param1;
                                                                                       return;
                                                                                       });
                                                                                       addCallback("getVolume",new function():Number
                                                                                          {
                                                                                             return volume;
                                                                                             });
                                                                                             addCallback("seek",this.genericSeek);
                                                                                             addCallback("getCurrentClip",new function():Object
                                                                                                {
                                                                                                   return new ObjectConverter(currentClip).convert();
                                                                                                   });
                                                                                                   addCallback("getClip",new function(param1:Number):Object
                                                                                                      {
                                                                                                         return convert(playlist.getClip(param1));
                                                                                                         });
                                                                                                         addCallback("setPlaylist",new function(param1:Object):void
                                                                                                            {
                                                                                                               if(param1 is String)
                                                                                                                     {
                                                                                                                           loadPlaylistFeed(param1 as String,_playListController.setPlaylist);
                                                                                                                     }
                                                                                                               else
                                                                                                                     {
                                                                                                                           setPlaylist(_config.createClips(param1));
                                                                                                                     }
                                                                                                               return;
                                                                                                               });
                                                                                                               addCallback("addClip",new function(param1:Object, param2:int=-1):void
                                                                                                                  {
                                                                                                                     addClip(_config.createClip(param1),param2);
                                                                                                                     return;
                                                                                                                     });
                                                                                                                     addCallback("showError",showError);
                                                                                                                     addCallback("loadPlugin",this.pluginLoad);
                                                                                                                     addCallback("showPlugin",showPlugin);
                                                                                                                     addCallback("hidePlugin",hidePlugin);
                                                                                                                     addCallback("togglePlugin",togglePlugin);
                                                                                                                     addCallback("animate",this.animate);
                                                                                                                     addCallback("css",this.css);
                                                                                                                     addCallback("reset",reset);
                                                                                                                     addCallback("fadeIn",this.fadeIn);
                                                                                                                     addCallback("fadeOut",this.fadeOut);
                                                                                                                     addCallback("fadeTo",this.fadeTo);
                                                                                                                     addCallback("getPlugin",new function(param1:String):Object
                                                                                                                        {
                                                                                                                           return new ObjectConverter(_pluginRegistry.getPlugin(param1)).convert();
                                                                                                                           });
                                                                                                                           addCallback("getRawPlugin",new function(param1:String):Object
                                                                                                                              {
                                                                                                                                 return _pluginRegistry.getPlugin(param1);
                                                                                                                                 });
                                                                                                                                 addCallback("invoke",this.invoke);
                                                                                                                                 addCallback("addCuepoints",this.addCuepoints);
                                                                                                                                 addCallback("updateClip",this.updateClip);
                                                                                                                                 addCallback("logging",logging);
                                                                                                                                 addCallback("setKeyboardShortcutsEnabled",setKeyboardShortcutsEnabled);
                                                                                                                                 addCallback("isKeyboardShortcutsEnabled",isKeyboardShortcutsEnabled);
                                                                                                                                 addCallback("validateKey",this.validateKey);
                                                                                                                                 addCallback("bufferAnimate",bufferAnimate);
                                                                                                                              }
                                                                                                                           catch(e:Error)
                                                                                                                              {
                                                                                                                                 handleError(PlayerError.INIT_FAILED,"Unable to add callback to ExternalInterface");
                                                                                                                              }
                                                                                                                           return;
      }

      private function loadPlaylistFeed(param1:String, param2:Function) : void {
         var feedName:String = param1;
         var clipHandler:Function = param2;
         var feedLoader:ResourceLoader = createLoader();
         feedLoader.addTextResourceUrl(feedName);
         feedLoader.load(null,new function(param1:ResourceLoader):void
            {
               log.info("received playlist feed");
               clipHandler(_config.createClips(param1.getContent()));
               return;
               });
               return;
      }

      private function pluginLoad(param1:String, param2:String, param3:Object=null, param4:String=null) : void {
         loadPluginWithConfig(param1,param2,param3,param4!=null?this.createCallback(param4):null);
         return;
      }

      private function genericPlay(param1:Object=null, param2:Boolean=false) : void {
         if(param1==null)
            {
               play();
               return;
            }
         if(param1 is Number)
            {
               _playListController.play(null,param1 as Number);
               return;
            }
         if(param1 is Array)
            {
               _playListController.playClips(_config.createClips(param1 as Array));
               return;
            }
         var _loc3_:Clip = _config.createClip(param1);
         if(!_loc3_)
            {
               showError("cannot convert "+param1+" to a clip");
               return;
            }
         if(param2)
            {
               playInstream(_loc3_);
               return;
            }
         play(_loc3_);
         return;
      }

      private function playFeed(param1:String) : void {
         this.loadPlaylistFeed(param1,_playListController.playClips);
         return;
      }

      private function genericSeek(param1:Object) : void {
         var _loc2_:Number = param1 is String?NumberUtil.decodePercentage(param1 as String):NaN;
         if(isNaN(_loc2_))
            {
               seek(param1 is String?parseInt(param1 as String):param1 as Number);
            }
         else
            {
               seekRelative(_loc2_);
            }
         return;
      }

      public function css(param1:String, param2:Object=null) : Object {
         log.debug("css, plugin "+param1);
         if(param1=="canvas")
            {
               this._canvas.css(param2);
               return param2;
            }
         return this.style(param1,param2,false,0);
      }

      private function convert(param1:Object) : Object {
         return new ObjectConverter(param1).convert();
      }

      private function collectDisplayProps(param1:Object, param2:Boolean) : Object {
         var _loc5_:String = null;
         var _loc3_:Object = new Object();
         var _loc4_:Array = ["width","height","left","top","bottom","right","opacity"];
         if(!param2)
            {
               _loc4_=_loc4_.concat("display","zIndex");
            }
         for (_loc5_ in param1)
            {
               if(_loc4_.indexOf(_loc5_)>=0)
                  {
                     _loc3_[_loc5_]=param1[_loc5_];
                  }
            }
         return _loc3_;
      }

      private function animate(param1:String, param2:Object, param3:Number=400, param4:String=null) : Object {
         return this.style(param1,param2,true,param3,param4);
      }

      private function style(param1:String, param2:Object, param3:Boolean, param4:Number=400, param5:String=null) : Object {
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc6_:Object = _pluginRegistry.getPlugin(param1);
         checkPlugin(_loc6_,param1,DisplayPluginModel);
         log.debug("going to animate plugin "+param1);
         if(_loc6_ is DisplayProperties&&DisplayProperties(_loc6_).getDisplayObject() is Styleable)
            {
               Styleable(DisplayProperties(_loc6_).getDisplayObject())[param3?"onBeforeAnimate":"onBeforeCss"](param2);
            }
         if(param2)
            {
               if(param1=="play")
                  {
                     _loc7_=this.convert(_animationEngine.animateNonPanel(DisplayProperties(_pluginRegistry.getPlugin("screen")).getDisplayObject(),DisplayProperties(_loc6_).getDisplayObject(),this.collectDisplayProps(param2,param3),param4,this.createCallback(param5,_loc6_)));
                  }
               else
                  {
                     _loc7_=this.convert(_animationEngine.animate(DisplayProperties(_loc6_).getDisplayObject(),this.collectDisplayProps(param2,param3),param4,this.createCallback(param5,_loc6_)));
                  }
            }
         else
            {
               _loc7_=this.convert(_loc6_);
            }
         if(_loc6_ is DisplayProperties&&DisplayProperties(_loc6_).getDisplayObject() is Styleable)
            {
               _loc8_=Styleable(DisplayProperties(_loc6_).getDisplayObject())[param3?"animate":"css"](param2);
               for (_loc9_ in _loc8_)
                  {
                     _loc7_[_loc9_]=_loc8_[_loc9_];
                  }
            }
         return _loc7_;
      }

      private function fadeOut(param1:String, param2:Number=400, param3:String=null) : void {
         var _loc4_:DisplayProperties = this.prepareFade(param1,false);
         _animationEngine.fadeOut(_loc4_.getDisplayObject(),param2,this.createCallback(param3,_loc4_));
         return;
      }

      private function fadeIn(param1:String, param2:Number=400, param3:String=null) : void {
         var _loc4_:DisplayProperties = this.prepareFade(param1,true);
         if(param1=="play")
            {
               Screen(screen.getDisplayObject()).showPlay();
            }
         _animationEngine.fadeIn(_loc4_.getDisplayObject(),param2,this.createCallback(param3,_loc4_),!(param1=="play"));
         return;
      }

      private function fadeTo(param1:String, param2:Number, param3:Number=400, param4:String=null) : void {
         var _loc5_:DisplayProperties = this.prepareFade(param1,true);
         if(param1=="play")
            {
               Screen(screen.getDisplayObject()).showPlay();
            }
         _animationEngine.fadeTo(_loc5_.getDisplayObject(),param2,param3,this.createCallback(param4,_loc5_),!(param1=="play"));
         return;
      }

      private function prepareFade(param1:String, param2:Boolean) : DisplayProperties {
         var _loc4_:DisplayProperties = null;
         var _loc3_:Object = _pluginRegistry.getPlugin(param1);
         checkPlugin(_loc3_,param1,DisplayProperties);
         if(param2)
            {
               _loc4_=_loc3_ as DisplayProperties;
               if(!_loc4_.getDisplayObject().parent||!(_loc4_.getDisplayObject().parent==_panel))
                  {
                     _loc4_.alpha=0;
                  }
               doShowPlugin(_loc4_.getDisplayObject(),_loc4_);
            }
         return _loc3_ as DisplayProperties;
      }

      private function invoke(param1:String, param2:String, param3:Object=null) : Object {
         var pluginName:String = param1;
         var methodName:String = param2;
         var args:Object = param3;
         var plugin:Callable = _pluginRegistry.getPlugin(pluginName) as Callable;
         checkPlugin(plugin,pluginName,Callable);
         try
            {
               if(plugin.getMethod(methodName).hasReturnValue)
                  {
                     log.debug("method has a return value");
                     return plugin.invokeMethod(methodName,args is Array?args as Array:[args]);
                  }
               log.debug("method does not have a return value");
               plugin.invokeMethod(methodName,args is Array?args as Array:[args]);
            }
         catch(e:Error)
            {
               throw e;
            }
         return "undefined";
      }

      private function addCuepoints(param1:Array, param2:int, param3:String) : void {
         var _loc4_:Clip = _playListController.playlist.getClip(param2);
         var _loc5_:Array = _config.createCuepoints(param1,param3,1);
         if(!_loc5_||_loc5_.length==0)
            {
               showError("unable to create cuepoints from "+param1);
            }
         _loc4_.addCuepoints(_loc5_);
         log.debug("clip has now cuepoints "+_loc4_.cuepoints);
         return;
      }

      private function updateClip(param1:Object, param2:int) : void {
         log.debug("updateClip()",param1);
         var _loc3_:Clip = _playListController.playlist.getClip(param2);
         new PropertyBinder(_loc3_,"customProperties").copyProperties(param1);
         _loc3_.dispatch(ClipEventType.UPDATE);
         return;
      }

      private function createCallback(param1:String, param2:Object=null) : Function {
         var listenerId:String = param1;
         var pluginArg:Object = param2;
         if(!listenerId)
            {
               return null;
            }
         return new function(param1:PluginModel=null):void
            {
               if((param1)||pluginArg is PluginModel)
                     {
                           PluginModel((pluginArg)||(param1)).dispatch(PluginEventType.PLUGIN_EVENT,listenerId);
                     }
               else
                     {
                           new PluginEvent(PluginEventType.PLUGIN_EVENT,pluginArg is DisplayProperties?DisplayProperties(pluginArg).name:pluginArg.toString(),listenerId).fireExternal(_playerId);
                     }
               return;
            };
      }

      private function validateKey(param1:Object, param2:Boolean) : Boolean {
         var _loc3_:Class = Class(getDefinitionByName("org.flowplayer.view.LicenseKey"));
         return _loc3_["validate"](this._canvas.loaderInfo.url,version,param1,param2);
      }
   }

}