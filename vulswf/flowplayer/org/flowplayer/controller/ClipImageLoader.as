package org.flowplayer.controller
{
   import org.flowplayer.model.Clip;
   import org.flowplayer.view.ErrorHandler;


   class ClipImageLoader extends Object implements ResourceLoader
   {
         

      function ClipImageLoader(param1:ResourceLoader, param2:Clip) {
         super();
         this._loader=param1;
         this._clip=param2;
         return;
      }



      private var _clip:Clip;

      private var _loader:ResourceLoader;

      public function addTextResourceUrl(param1:String) : void {
         this._loader.addTextResourceUrl(param1);
         return;
      }

      public function addBinaryResourceUrl(param1:String) : void {
         this._loader.addBinaryResourceUrl(param1);
         return;
      }

      public function load(param1:String=null, param2:Function=null, param3:Boolean=false) : void {
         this._loader.load(param1,param2,false);
         return;
      }

      public function set completeListener(param1:Function) : void {
         this._loader.completeListener=param1;
         return;
      }

      public function loadClip(param1:Clip, param2:Function) : void {
         var imageLoader:ClipImageLoader = null;
         var clip:Clip = param1;
         var onLoadComplete:Function = param2;
         this._clip=clip;
         imageLoader=this;
         this.load(clip.completeUrl,new function(param1:ResourceLoader):void
            {
               onLoadComplete(imageLoader);
               return;
               });
               return;
      }

      public function getContent(param1:String=null) : Object {
         return this._loader.getContent(this._clip.completeUrl);
      }

      public function clear() : void {
         this._loader.clear();
         return;
      }

      public function get loadComplete() : Boolean {
         return this._loader.loadComplete;
      }

      public function set errorHandler(param1:ErrorHandler) : void {
         this._loader.errorHandler=param1;
         return;
      }
   }

}