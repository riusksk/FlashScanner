package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import flash.utils.Dictionary;
   import org.flowplayer.view.PlayerEventDispatcher;
   import org.flowplayer.config.Config;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.ClipType;
   import org.flowplayer.model.ProviderModel;
   import org.flowplayer.model.ClipError;

   use namespace flow_internal;

   class MediaControllerFactory extends Object
   {
         

      function MediaControllerFactory(param1:Dictionary, param2:PlayerEventDispatcher, param3:Config, param4:ResourceLoader) {
         this.log=new Log(this);
         super();
         this._providers=param1;
         _instance=this;
         this._playerEventDispatcher=param2;
         this._volumeController=new VolumeController(this._playerEventDispatcher);
         this._config=param3;
         this._loader=param4;
         return;
      }

      private static var _instance:MediaControllerFactory;

      private var log:Log;

      private var _streamProviderController:MediaController;

      private var _inStreamController:MediaController;

      private var _imageController:ImageController;

      private var _inStreamImageController:ImageController;

      private var _volumeController:VolumeController;

      private var _providers:Dictionary;

      private var _playerEventDispatcher:PlayerEventDispatcher;

      private var _config:Config;

      private var _loader:ResourceLoader;

      flow_internal function getMediaController(param1:Clip, param2:Playlist) : MediaController {
         var _loc3_:ClipType = param1.type;
         if(_loc3_==ClipType.VIDEO||_loc3_==ClipType.AUDIO||_loc3_==ClipType.API)
            {
               return this.getStreamProviderController(param2,param1.isInStream);
            }
         if(_loc3_==ClipType.IMAGE)
            {
               return this.getImageController(param2,param1.isInStream);
            }
         throw new Error("No media controller found for clip type "+_loc3_);
      }

      flow_internal function getVolumeController() : VolumeController {
         return this._volumeController;
      }

      private function getStreamProviderController(param1:Playlist, param2:Boolean=false) : MediaController {
         if(param2)
            {
               if(!this._inStreamController)
                  {
                     this._inStreamController=new StreamProviderController(this,this.getVolumeController(),this._config,param1);
                  }
               return this._inStreamController;
            }
         if(!this._streamProviderController)
            {
               this._streamProviderController=new StreamProviderController(this,this.getVolumeController(),this._config,param1);
            }
         return this._streamProviderController;
      }

      private function getImageController(param1:Playlist, param2:Boolean=false) : MediaController {
         if(param2)
            {
               if(!this._inStreamImageController)
                  {
                     this._inStreamImageController=new ImageController(this._loader,this.getVolumeController(),param1);
                  }
               return this._inStreamImageController;
            }
         if(!this._imageController)
            {
               this._imageController=new ImageController(this._loader,this.getVolumeController(),param1);
            }
         return this._imageController;
      }

      function addProvider(param1:ProviderModel) : void {
         this._providers[param1.name]=param1.pluginObject;
         return;
      }

      public function getProvider(param1:Clip) : StreamProvider {
         var _loc3_:String = null;
         var _loc2_:StreamProvider = this._providers[param1.provider];
         if(!_loc2_)
            {
               for (_loc3_ in this._providers)
                  {
                     this.log.debug("found provider "+_loc3_);
                  }
               param1.dispatchError(ClipError.PROVIDER_NOT_LOADED,"Provider \'"+param1.provider+"\' "+this.getInstreamProviderErrorMsg(param1));
               return null;
            }
         _loc2_.volumeController=this.getVolumeController();
         return _loc2_;
      }

      private function getInstreamProviderErrorMsg(param1:Clip) : String {
         if(!param1.isInStream)
            {
               return "";
            }
         return "(if this instream clip was started using play() you need to explicitly load/configure provider \'"+param1.provider+"\' before calling play())";
      }
   }

}