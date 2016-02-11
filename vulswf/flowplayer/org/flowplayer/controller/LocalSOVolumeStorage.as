package org.flowplayer.controller
{
   import flash.net.SharedObject;
   import org.flowplayer.util.Log;


   class LocalSOVolumeStorage extends Object implements VolumeStorage
   {
         

      function LocalSOVolumeStorage(param1:SharedObject) {
         this.log=new Log(this);
         super();
         this.log.debug("in constructor");
         this._storedVolume=param1;
         return;
      }

      public static function create() : VolumeStorage {
         try
            {
               return new (LocalSOVolumeStorage)(SharedObject.getLocal("org.flowplayer"));
            }
         catch(e:Error)
            {
               return new NullVolumeStorage();
            }
         return null;
      }

      private var _storedVolume:SharedObject;

      private var log:Log;

      public function persist() : void {
         this.log.debug("persisting volume "+this._storedVolume.data.volume);
         try
            {
               this._storedVolume.flush();
            }
         catch(e:Error)
            {
               log.error("unable to persist volume");
            }
         return;
      }

      public function get volume() : Number {
         this.log.debug("get volume "+this._storedVolume.data.volume);
         if(this._storedVolume.size==0)
            {
               return 0.5;
            }
         return this.getVolume(this._storedVolume.data.volume);
      }

      public function get muted() : Boolean {
         return this._storedVolume.data.volumeMuted;
      }

      public function set volume(param1:Number) : void {
         this._storedVolume.data.volume=param1;
         return;
      }

      public function set muted(param1:Boolean) : void {
         this._storedVolume.data.volumeMuted=param1;
         return;
      }

      private function getVolume(param1:Object) : Number {
         if(param1==0)
            {
               return 0;
            }
         if(!param1 is Number)
            {
               return 0.5;
            }
         if(isNaN(param1 as Number))
            {
               return 0.5;
            }
         if(param1 as Number>1)
            {
               return 1;
            }
         if(param1 as Number<0)
            {
               return 0;
            }
         return param1 as Number;
      }
   }

}