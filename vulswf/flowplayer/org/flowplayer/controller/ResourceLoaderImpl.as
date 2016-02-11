package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import org.flowplayer.view.ErrorHandler;
   import flash.net.URLLoader;
   import flash.system.LoaderContext;
   import org.flowplayer.util.URLUtil;
   import flash.net.URLRequest;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import org.flowplayer.model.PlayerError;


   public class ResourceLoaderImpl extends Object implements ResourceLoader
   {
         

      public function ResourceLoaderImpl(param1:String, param2:ErrorHandler=null) {
         this.log=new Log(this);
         this._loaders=new Object();
         this._urls=new Array();
         super();
         this._baseUrl=param1;
         this._errorHandler=param2;
         return;
      }



      private var log:Log;

      private var _loaders:Object;

      private var _errorHandler:ErrorHandler;

      private var _urls:Array;

      private var _loadedCount:Number;

      private var _completeListener:Function;

      private var _baseUrl:String;

      private var _loadCompete:Boolean;

      public function addTextResourceUrl(param1:String) : void {
         this._urls.push(param1);
         this._loaders[param1]=this.createURLLoader();
         return;
      }

      public function addBinaryResourceUrl(param1:String) : void {
         this._urls.push(param1);
         this._loaders[param1]=this.createLoader();
         return;
      }

      public function set completeListener(param1:Function) : void {
         this._completeListener=param1;
         return;
      }

      public function load(param1:String=null, param2:Function=null, param3:Boolean=false) : void {
         if(param2!=null)
            {
               this._completeListener=param2;
            }
         if(param1)
            {
               this.clear();
               if(param3)
                  {
                     this.log.debug("loading text resource from "+param1);
                     this.addTextResourceUrl(param1);
                  }
               else
                  {
                     this.log.debug("loading binary resource from "+param1);
                     this.addBinaryResourceUrl(param1);
                  }
            }
         if(!this._urls||this._urls.length==0)
            {
               this.log.debug("nothing to load");
               return;
            }
         this.startLoading();
         return;
      }

      public function getContent(param1:String=null) : Object {
         var loader:Object = null;
         var url:String = param1;
         try
            {
               loader=this._loaders[url?url:this._urls[0]];
               return loader is URLLoader?URLLoader(loader).data:loader;
            }
         catch(e:SecurityError)
            {
               handleError("cannot access file (try loosening Flash security settings): "+e.message);
            }
         return null;
      }

      private function startLoading() : void {
         var _loc1_:String = null;
         var _loc2_:LoaderContext = null;
         this._loadedCount=0;
         this._loadCompete=false;
         for (_loc1_ in this._loaders)
            {
               this.log.debug("startLoading() "+URLUtil.addBaseURL(this._baseUrl,_loc1_));
               if(this._loaders[_loc1_] is URLLoader)
                  {
                     this._loaders[_loc1_].load(new URLRequest(URLUtil.addBaseURL(this._baseUrl,_loc1_)));
                     continue;
                  }
               _loc2_=new LoaderContext();
               _loc2_.checkPolicyFile=true;
               Loader(this._loaders[_loc1_]).load(new URLRequest(URLUtil.addBaseURL(this._baseUrl,_loc1_)),_loc2_);
            }
         return;
      }

      private function createURLLoader() : URLLoader {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onLoadComplete);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         _loc1_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         return _loc1_;
      }

      private function createLoader() : Loader {
         this.log.debug("creating new loader");
         var _loc1_:Loader = new Loader();
         _loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         _loc1_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         _loc1_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         return _loc1_;
      }

      private function onLoadComplete(param1:Event) : void {
         this.log.debug("onLoadComplete, loaded "+(this._loadedCount+1)+" resources out of "+this._urls.length);
         if(++this._loadedCount==this._urls.length)
            {
               this._loadCompete=true;
               this.log.debug("onLoadComplete, all resources were loaded");
               if(this._completeListener!=null)
                  {
                     this.log.debug("calling complete listener function");
                     this._completeListener(this);
                  }
            }
         return;
      }

      private function onIOError(param1:IOErrorEvent) : void {
         this.log.error("IOError: "+param1.text);
         this.handleError("Unable to load resources: "+param1.text);
         return;
      }

      private function onSecurityError(param1:SecurityErrorEvent) : void {
         this.log.error("SecurityError: "+param1.text);
         this.handleError("cannot access the resource file (try loosening Flash security settings): "+param1.text);
         return;
      }

      protected function handleError(param1:String, param2:Error=null) : void {
         if(this._errorHandler)
            {
               this._errorHandler.handleError(PlayerError.RESOURCE_LOAD_FAILED,param1+(param2?": "+param2.message:""));
            }
         return;
      }

      public function set errorHandler(param1:ErrorHandler) : void {
         this._errorHandler=param1;
         return;
      }

      public function clear() : void {
         this._urls=new Array();
         this._loaders=new Array();
         return;
      }

      public function get loadComplete() : Boolean {
         return this._loadCompete;
      }

      public function get baseUrl() : String {
         return this._baseUrl;
      }
   }

}