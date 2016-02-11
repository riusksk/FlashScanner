package org.flowplayer.view
{
   import flash.events.EventDispatcher;
   import org.flowplayer.util.Log;
   import flash.utils.Dictionary;
   import flash.system.LoaderContext;
   import org.flowplayer.util.URLUtil;
   import org.flowplayer.model.Loadable;
   import flash.system.Security;
   import flash.system.ApplicationDomain;
   import flash.system.SecurityDomain;
   import flash.events.Event;
   import flash.display.Loader;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import org.flowplayer.model.PluginModel;
   import org.flowplayer.model.PluginError;
   import flash.display.LoaderInfo;
   import flash.utils.getQualifiedClassName;
   import flash.display.AVM1Movie;
   import flash.display.DisplayObject;
   import org.flowplayer.controller.StreamProvider;
   import org.flowplayer.model.FontProvider;
   import org.flowplayer.model.DisplayPluginModel;
   import org.flowplayer.model.ProviderModel;
   import org.flowplayer.model.Plugin;
   import org.flowplayer.model.Callable;
   import org.flowplayer.config.ExternalInterfaceHelper;
   import org.flowplayer.model.PluginEvent;
   import flash.utils.getDefinitionByName;
   import org.flowplayer.controller.NetStreamControllingStreamProvider;
   import com.adobe.utils.StringUtil;


   public class PluginLoader extends EventDispatcher
   {
         

      public function PluginLoader(param1:String, param2:PluginRegistry, param3:ErrorHandler, param4:Boolean) {
         this.log=new Log(this);
         super();
         this._baseUrl=param1;
         this._pluginRegistry=param2;
         this._errorHandler=param3;
         this._useExternalInterface=param4;
         this._loadedCount=0;
         return;
      }



      private var log:Log;

      private var _loadables:Array;

      private var _loadedPlugins:Dictionary;

      private var _loadedCount:int;

      private var _errorHandler:ErrorHandler;

      private var _swiffsToLoad:Array;

      private var _pluginRegistry:PluginRegistry;

      private var _providers:Dictionary;

      private var _callback:Function;

      private var _baseUrl:String;

      private var _useExternalInterface:Boolean;

      private var _loadErrorListener:Function;

      private var _loadListener:Function;

      private var _loadComplete:Boolean;

      private var _allPlugins:Array;

      private var _loaderContext:LoaderContext;

      private var _loadStartedCount:int = 0;

      private function constructUrl(param1:String) : String {
         if(param1.indexOf("..")>=0)
            {
               return param1;
            }
         if(param1.indexOf("/")>=0)
            {
               return param1;
            }
         return URLUtil.addBaseURL(this._baseUrl,param1);
      }

      public function loadPlugin(param1:Loadable, param2:Function=null) : void {
         this._callback=param2;
         this._loadListener=null;
         this._loadErrorListener=null;
         this.load([param1]);
         return;
      }

      public function load(param1:Array, param2:Function=null, param3:Function=null) : void {
         var plugins:Array = param1;
         var loadListener:Function = param2;
         var loadErrorListener:Function = param3;
         this.log.debug("load()");
         this._loadListener=loadListener;
         this._loadErrorListener=loadErrorListener;
         Security.allowDomain("*");
         this._providers=new Dictionary();
         this._allPlugins=plugins.concat([]);
         this._loadables=plugins.filter(new function(param1:*, param2:int, param3:Array):Boolean
            {
               return (param1.url)&&String(param1.url).toLocaleLowerCase().indexOf(".swf")<0;
               });
               this._swiffsToLoad=this.getPluginSwiffUrls(plugins);
               this._loadedPlugins=new Dictionary();
               this._loadedCount=0;
               this._loadStartedCount=0;
               this._loaderContext=new LoaderContext();
               this._loaderContext.applicationDomain=ApplicationDomain.currentDomain;
               if(!URLUtil.localDomain(this._baseUrl))
                  {
                     this._loaderContext.securityDomain=SecurityDomain.currentDomain;
                  }
               var i:Number = 0;
               while(i<this._loadables.length)
                  {
                     Loadable(this._loadables[i]).onError(this._loadErrorListener);
                     i++;
                  }
               this.intitializeBuiltInPlugins(plugins);
               if(this._swiffsToLoad.length==0)
                  {
                     this.setConfigPlugins();
                     dispatchEvent(new Event(Event.COMPLETE,true,false));
                     return;
                  }
               this.loadNext();
               return;
      }

      private function loadNext() : Boolean {
         if(this._loadStartedCount>=this._swiffsToLoad.length)
            {
               this.log.debug("loadNext(): all plugins loaded");
               return false;
            }
         var _loc1_:Loader = new Loader();
         _loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaded);
         var _loc2_:String = this._swiffsToLoad[this._loadStartedCount];
         _loc1_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.createIOErrorListener(_loc2_));
         _loc1_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.log.debug("starting to load plugin from url "+this._swiffsToLoad[this._loadStartedCount]);
         _loc1_.load(new URLRequest(_loc2_),this._loaderContext);
         this._loadStartedCount++;
         return true;
      }

      private function getPluginSwiffUrls(param1:Array) : Array {
         var _loc4_:Loadable = null;
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_<param1.length)
            {
               _loc4_=Loadable(param1[_loc3_]);
               if((!_loc4_.isBuiltIn)&&(_loc4_.url)&&_loc2_.indexOf(_loc4_.url)>0)
                  {
                     _loc2_.push(this.constructUrl(_loc4_.url));
                  }
               _loc3_++;
            }
         return _loc2_;
      }

      private function intitializeBuiltInPlugins(param1:Array) : void {
         var _loc3_:Loadable = null;
         var _loc4_:Object = null;
         var _loc5_:PluginModel = null;
         var _loc2_:* = 0;
         while(_loc2_<param1.length)
            {
               _loc3_=param1[_loc2_] as Loadable;
               this.log.debug("intitializeBuiltInPlugins() "+_loc3_);
               if(_loc3_.isBuiltIn)
                  {
                     this.log.info("intitializeBuiltInPlugins(), instantiating from loadable "+_loc3_+", with config ",_loc3_.config);
                     _loc4_=_loc3_.instantiate();
                     _loc5_=this.createPluginModel(_loc3_,_loc4_);
                     _loc5_.isBuiltIn=true;
                     this.initializePlugin(_loc5_,_loc4_);
                  }
               _loc2_++;
            }
         return;
      }

      private function createIOErrorListener(param1:String) : Function {
         var url:String = param1;
         return new function(param1:IOErrorEvent):void
            {
               var event:IOErrorEvent = param1;
               log.error("onIoError "+url);
               _loadables.forEach(new function(param1:Loadable, param2:int, param3:Array):void
                     {
                           if(!param1.loadFailed&&(hasSwiff(url,param1.url)))
                                    {
                                             log.debug("onIoError: this is the swf for loadable "+param1);
                                             param1.loadFailed=true;
                                             param1.dispatchError(PluginError.INIT_FAILED);
                                             incrementLoadedCountAndFireEventIfNeeded();
                                    }
                           return;
                           });
                           return;
                  };
      }

      private function onProgress(param1:ProgressEvent) : void {
         this.log.debug("load in progress");
         return;
      }

      public function get plugins() : Dictionary {
         return this._loadedPlugins;
      }

      private function loaded(param1:Event) : void {
         var info:LoaderInfo = null;
         var instanceUsed:Boolean = false;
         var event:Event = param1;
         info=event.target as LoaderInfo;
         this.log.debug("loaded class name "+getQualifiedClassName(info.content));
         instanceUsed=false;
         this._loadables.forEach(new function(param1:Loadable, param2:int, param3:Array):void
            {
               var _loc4_:Object = null;
               if(!param1.plugin&&(hasSwiff(info.url,param1.url)))
                     {
                           log.debug("this is the swf for loadable "+param1);
                           if(param1.type=="classLibrary")
                                 {
                                       initializeClassLibrary(param1,info);
                                 }
                           else
                                 {
                                       _loc4_=info.content is AVM1Movie?info.loader:createPluginInstance(instanceUsed,info.content);
                                       initializePlugin(createPluginModel(param1,_loc4_),_loc4_);
                                       instanceUsed=true;
                                 }
                     }
               return;
               });
               this.incrementLoadedCountAndFireEventIfNeeded();
               if(this._callback!=null)
                  {
                     this._callback();
                  }
               this.loadNext();
               return;
      }

      private function incrementLoadedCountAndFireEventIfNeeded() : void {
         if(++this._loadedCount==this._swiffsToLoad.length)
            {
               this.log.debug("all plugin SWFs loaded. loaded total "+this.loadedCount+" plugins");
               this.setConfigPlugins();
               dispatchEvent(new Event(Event.COMPLETE,true,false));
            }
         return;
      }

      private function initializeClassLibrary(param1:Loadable, param2:LoaderInfo) : void {
         this.log.debug("initializing class library "+param2.applicationDomain);
         this._loadedPlugins[param1]=param2.applicationDomain;
         this._pluginRegistry.registerGenericPlugin(param1.createPlugin(param2.applicationDomain));
         return;
      }

      private function createPluginModel(param1:Loadable, param2:Object) : PluginModel {
         this.log.debug("creating model for loadable "+param1+", instance "+param2);
         this._loadedPlugins[param1]=param2;
         this.log.debug("pluginInstance "+param2);
         if(param2 is DisplayObject)
            {
               return Loadable(param1).createDisplayPlugin(param2 as DisplayObject);
            }
         if(param2 is StreamProvider)
            {
               return Loadable(param1).createProvider(param2);
            }
         return Loadable(param1).createPlugin(param2);
      }

      private function initializePlugin(param1:PluginModel, param2:Object) : void {
         if(param2 is FontProvider)
            {
               this._pluginRegistry.registerFont(FontProvider(param2).fontFamily);
            }
         else
            {
               if(param2 is DisplayObject)
                  {
                     this._pluginRegistry.registerDisplayPlugin(param1 as DisplayPluginModel,param2 as DisplayObject);
                  }
               else
                  {
                     if(param2 is StreamProvider)
                        {
                           this._providers[param1.name]=param2;
                           this._pluginRegistry.registerProvider(param1 as ProviderModel);
                        }
                     else
                        {
                           this._pluginRegistry.registerGenericPlugin(param1);
                        }
                  }
            }
         if(param2 is Plugin)
            {
               if(this._loadListener!=null)
                  {
                     param1.onLoad(this._loadListener);
                  }
               param1.onError(this.onPluginError);
            }
         if(param1 is Callable&&(this._useExternalInterface))
            {
               ExternalInterfaceHelper.initializeInterface(param1 as Callable,param2);
            }
         return;
      }

      private function onPluginError(param1:PluginEvent) : void {
         this.log.debug("onPluginError() "+param1.error);
         if(param1.error)
            {
               this._errorHandler.handleError(param1.error,param1.info+", "+param1.info2,true);
            }
         return;
      }

      private function createPluginInstance(param1:Boolean, param2:DisplayObject) : Object {
         if(param2.hasOwnProperty("newPlugin"))
            {
               return param2["newPlugin"]();
            }
         if(!param1)
            {
               this.log.debug("using existing instance "+param2);
               return param2;
            }
         var _loc3_:String = getQualifiedClassName(param2);
         this.log.info("creating new "+_loc3_);
         var _loc4_:Class = Class(getDefinitionByName(_loc3_));
         return new (_loc4_)() as DisplayObject;
      }

      public function setConfigPlugins() : void {
         this._allPlugins.forEach(new function(param1:Loadable, param2:int, param3:Array):void
            {
               var _loc4_:Object = null;
               if(!param1.loadFailed)
                     {
                           _loc4_=plugins[param1];
                           if(_loc4_)
                                 {
                                       log.info(param2+": setting config to "+_loc4_+", "+param1);
                                       if(_loc4_ is NetStreamControllingStreamProvider)
                                             {
                                                   log.debug("NetStreamControllingStreamProvider(pluginInstance).config = "+param1.plugin);
                                                   NetStreamControllingStreamProvider(_loc4_).model=ProviderModel(param1.plugin);
                                             }
                                       else
                                             {
                                                   if(_loc4_.hasOwnProperty("onConfig"))
                                                         {
                                                               _loc4_.onConfig(param1.plugin);
                                                         }
                                             }
                                 }
                     }
               return;
               });
               return;
      }

      private function hasSwiff(param1:String, param2:String) : Boolean {
         if(!param2)
            {
               return false;
            }
         var _loc3_:int = param2.lastIndexOf("/");
         var _loc4_:String = _loc3_>=0?param2.substr(_loc3_):param2;
         return StringUtil.endsWith(param1,_loc4_);
      }

      public function get providers() : Dictionary {
         return this._providers;
      }

      public function get loadedCount() : int {
         return this._loadedCount;
      }

      public function get loadComplete() : Boolean {
         return this._loadComplete;
      }
   }

}