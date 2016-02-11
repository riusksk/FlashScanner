package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import org.flowplayer.view.PluginRegistry;
   import org.flowplayer.model.PluginModel;
   import org.flowplayer.model.Clip;
   import flash.events.NetStatusEvent;


   public class CompositeClipUrlResolver extends Object implements ClipURLResolver
   {
         

      public function CompositeClipUrlResolver(param1:Array) {
         super();
         this._resolvers=param1;
         return;
      }

      private static var log:Log = new Log("org.flowplayer.controller::CompositeClipUrlResolver");

      public static function createResolver(param1:Array, param2:PluginRegistry) : ClipURLResolver {
         if(!param1||param1.length==0)
            {
               throw new Error("resolver name not supplied");
            }
         log.debug("creating composite resolver with "+param1.length+" resolvers");
         var _loc3_:Array = new Array();
         var _loc4_:* = 0;
         while(_loc4_<param1.length)
            {
               log.debug("initializing resolver "+param1[_loc4_]);
               _loc3_.push(getResolver(param1[_loc4_],param2));
               _loc4_++;
            }
         return new (CompositeClipUrlResolver)(_loc3_);
      }

      private static function getResolver(param1:String, param2:PluginRegistry) : ClipURLResolver {
         var _loc3_:ClipURLResolver = PluginModel(param2.getPlugin(param1)).pluginObject as ClipURLResolver;
         if(!_loc3_)
            {
               throw new Error("clipURLResolver \'"+param1+"\' not loaded");
            }
         return _loc3_;
      }

      private var _resolvers:Array;

      private var _current:int = 0;

      private var _successListener:Function;

      private var _clip:Clip;

      private var _provider:StreamProvider;

      public function resolve(param1:StreamProvider, param2:Clip, param3:Function) : void {
         if(param2.getResolvedUrl())
            {
               log.debug("clip URL has been already resolved to \'"+param2.url+"\', calling successListener");
               param3(param2);
               return;
            }
         log.debug("resolve(): resolving with "+this._resolvers.length+" resolvers");
         this._provider=param1;
         this._clip=param2;
         this._successListener=param3;
         this._current=0;
         this.resolveNext();
         return;
      }

      private function resolveNext() : void {
         var resolver:ClipURLResolver = null;
         if(this._current==this._resolvers.length)
            {
               log.debug("all resolvers done, calling the successListener");
               this._successListener(this._clip);
               return;
            }
         resolver=this._resolvers[this._current++];
         log.debug("resolving with "+resolver);
         resolver.resolve(this._provider,this._clip,new function(param1:Clip):void
            {
               log.debug("resolver "+resolver+" done, url is now "+param1.url);
               resolveNext();
               return;
               });
               return;
      }

      public function set onFailure(param1:Function) : void {
         var _loc2_:* = 0;
         while(_loc2_<this._resolvers.length)
            {
               ClipURLResolver(this._resolvers[_loc2_]).onFailure=param1;
               _loc2_++;
            }
         return;
      }

      public function handeNetStatusEvent(param1:NetStatusEvent) : Boolean {
         return true;
      }

      public function get resolvers() : Array {
         return this._resolvers;
      }
   }

}