package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import flash.media.SoundTransform;
   import flash.net.NetStream;
   import flash.utils.Timer;
   import org.flowplayer.view.PlayerEventDispatcher;
   import flash.media.SoundChannel;
   import org.flowplayer.model.PlayerEvent;
   import flash.events.TimerEvent;


   public class VolumeController extends Object
   {
         

      public function VolumeController(param1:PlayerEventDispatcher) {
         this.log=new Log(this);
         super();
         this._playerEventDispatcher=param1;
         this._soundTransform=new SoundTransform();
         this.restoreVolume();
         this._storeDelayTimer=new Timer(2000,1);
         this._storeDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerDelayComplete);
         return;
      }



      private var log:Log;

      private var _soundTransform:SoundTransform;

      private var _netStream:NetStream;

      private var _storedVolume:VolumeStorage;

      private var _storeDelayTimer:Timer;

      private var _muted:Boolean;

      private var _playerEventDispatcher:PlayerEventDispatcher;

      private var _soundChannel:SoundChannel;

      public function set netStream(param1:NetStream) : void {
         this._netStream=param1;
         this.setTransform(this._muted?new SoundTransform(0):this._soundTransform);
         return;
      }

      private function setTransform(param1:SoundTransform) : void {
         if(this._netStream)
            {
               this._netStream.soundTransform=param1;
            }
         if(this._soundChannel)
            {
               this._soundChannel.soundTransform=param1;
            }
         return;
      }

      private function doMute(param1:Boolean) : void {
         this.log.debug("muting volume");
         if(this.dispatchBeforeEvent(PlayerEvent.mute()))
            {
               this._muted=true;
               this.setTransform(new SoundTransform(0));
               this.dispatchEvent(PlayerEvent.mute());
               if(param1)
                  {
                     this.storeVolume(true);
                  }
            }
         return;
      }

      private function unMute() : Number {
         this.log.debug("unmuting volume to level "+this._soundTransform.volume);
         if(this.dispatchBeforeEvent(PlayerEvent.unMute()))
            {
               this._muted=false;
               this.setTransform(this._soundTransform);
               this.dispatchEvent(PlayerEvent.unMute());
               this.storeVolume(false);
            }
         return this.volume;
      }

      public function set volume(param1:Number) : void {
         if(this.volume==param1)
            {
               return;
            }
         if(this.dispatchBeforeEvent(PlayerEvent.volume(param1)))
            {
               if(param1>100)
                  {
                     param1=100;
                  }
               if(param1<0)
                  {
                     this.volume=0;
                  }
               this._soundTransform.volume=param1/100;
               if(!this._muted)
                  {
                     this.setTransform(this._soundTransform);
                  }
               this.dispatchEvent(PlayerEvent.volume(this.volume));
               if(!this._storeDelayTimer.running)
                  {
                     this.log.info("starting delay timer");
                     this._storeDelayTimer.start();
                  }
            }
         return;
      }

      public function get volume() : Number {
         return this._soundTransform.volume*100;
      }

      private function onTimerDelayComplete(param1:TimerEvent) : void {
         this.storeVolume();
         return;
      }

      private function storeVolume(param1:Boolean=false) : void {
         this.log.info("persisting volume level");
         this._storeDelayTimer.stop();
         this._storedVolume.volume=this._soundTransform.volume;
         this._storedVolume.muted=param1;
         this._storedVolume.persist();
         return;
      }

      private function restoreVolume() : void {
         this._storedVolume=LocalSOVolumeStorage.create();
         this._soundTransform.volume=this._storedVolume.volume;
         if(this._storedVolume.muted)
            {
               this.doMute(false);
            }
         return;
      }

      private function dispatchBeforeEvent(param1:PlayerEvent) : Boolean {
         return this._playerEventDispatcher.dispatchBeforeEvent(param1);
      }

      private function dispatchEvent(param1:PlayerEvent) : void {
         this._playerEventDispatcher.dispatchEvent(param1);
         return;
      }

      public function get muted() : Boolean {
         return this._muted;
      }

      public function set muted(param1:Boolean) : void {
         if(param1)
            {
               this.doMute(true);
            }
         else
            {
               this.unMute();
            }
         return;
      }

      public function set soundChannel(param1:SoundChannel) : void {
         this._soundChannel=param1;
         this.setTransform(this._muted?new SoundTransform(0):this._soundTransform);
         return;
      }
   }

}