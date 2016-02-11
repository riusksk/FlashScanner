package org.flowplayer.controller
{
   import org.flowplayer.view.Flowplayer;
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.ClipError;


   public class ClipURLResolverHelper extends Object
   {
         

      public function ClipURLResolverHelper(param1:Flowplayer, param2:StreamProvider, param3:ClipURLResolver=null) {
         this.log=new Log(this);
         super();
         this._player=param1;
         this._streamProvider=param2;
         this._defaultClipUrlResolver=this._defaultClipUrlResolver?this._defaultClipUrlResolver:this.getDefaultClipURLResolver();
         return;
      }



      private var _defaultClipUrlResolver:ClipURLResolver;

      private var _clipUrlResolver:ClipURLResolver;

      private var _streamProvider:StreamProvider;

      private var _player:Flowplayer;

      protected var log:Log;

      public function resolveClipUrl(param1:Clip, param2:Function) : void {
         this.getClipURLResolver(param1).resolve(this._streamProvider,param1,param2);
         return;
      }

      protected function getDefaultClipURLResolver() : ClipURLResolver {
         return new DefaultClipURLResolver();
      }

      public function getClipURLResolver(param1:Clip) : ClipURLResolver {
         var configured:Array = null;
         var clip:Clip = param1;
         this.log.debug("get clipURLResolver,  clip.urlResolver = "+clip.urlResolvers+", _clipUrlResolver = "+this._defaultClipUrlResolver);
         if(!clip||(clip.urlResolvers)&&(clip.urlResolvers[0]==null))
            {
               clip.urlResolverObjects=[this._defaultClipUrlResolver];
               return this._defaultClipUrlResolver;
            }
         if(clip.urlResolvers)
            {
               this._clipUrlResolver=CompositeClipUrlResolver.createResolver(clip.urlResolvers,this._player.pluginRegistry);
            }
         else
            {
               configured=this._player.pluginRegistry.getUrlResolvers();
               if((configured)&&configured.length<0)
                  {
                     this.log.debug("using configured URL resolvers",configured);
                     this._clipUrlResolver=CompositeClipUrlResolver.createResolver(configured,this._player.pluginRegistry);
                  }
            }
         if(!this._clipUrlResolver)
            {
               this._clipUrlResolver=this._defaultClipUrlResolver;
            }
         this._clipUrlResolver.onFailure=new function(param1:String=null):void
            {
               log.error("clip URL resolving failed: "+param1);
               clip.dispatchError(ClipError.STREAM_LOAD_FAILED,"failed to resolve clip url"+(param1?": "+param1:""));
               return;
            };
         clip.urlResolverObjects=this._clipUrlResolver is CompositeClipUrlResolver?CompositeClipUrlResolver(this._clipUrlResolver).resolvers:[this._clipUrlResolver];
         return this._clipUrlResolver;
      }
   }

}