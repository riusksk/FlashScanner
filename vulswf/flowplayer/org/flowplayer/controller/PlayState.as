package org.flowplayer.controller
{
   import org.flowplayer.model.Playlist;
   import flash.utils.Dictionary;
   import org.flowplayer.view.PlayerEventDispatcher;
   import org.flowplayer.config.Config;
   import org.flowplayer.model.State;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.ProviderModel;
   import org.flowplayer.util.Log;
   import org.flowplayer.model.ClipEventSupport;
   import org.flowplayer.model.ClipEventType;
   import org.flowplayer.model.Status;
   import org.flowplayer.util.Assert;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.Clip;

   use namespace flow_internal;

   class PlayState extends Object
   {
         

      function PlayState(param1:State, param2:Playlist, param3:PlayListController, param4:Dictionary) {
         this.log=new Log(this);
         super();
         this._stateCode=param1;
         this.playList=param2;
         param2.onPlaylistReplace(this.onPlaylistChanged);
         param2.onClipAdd(this.onClipAdded);
         this.playListController=param3;
         return;
      }

      static var waitingState:PlayState;

      static var endedState:EndedState;

      static var playingState:PlayingState;

      static var pausedState:PausedState;

      static var bufferingState:BufferingState;

      private static var _controllerFactory:MediaControllerFactory;

      static function initStates(param1:Playlist, param2:PlayListController, param3:Dictionary, param4:PlayerEventDispatcher, param5:Config, param6:ResourceLoader) : void {
         waitingState=new WaitingState(State.WAITING,param1,param2,param3);
         endedState=new EndedState(State.ENDED,param1,param2,param3);
         playingState=new PlayingState(State.PLAYING,param1,param2,param3);
         pausedState=new PausedState(State.PAUSED,param1,param2,param3);
         bufferingState=new BufferingState(State.BUFFERING,param1,param2,param3);
         param2.setPlayState(waitingState);
         if(!_controllerFactory)
            {
               _controllerFactory=new MediaControllerFactory(param3,param4,param5,param6);
            }
         return;
      }

      static function addProvider(param1:ProviderModel) : void {
         _controllerFactory.addProvider(param1);
         return;
      }

      protected var log:Log;

      protected var playListController:PlayListController;

      protected var playList:Playlist;

      private var _stateCode:State;

      private var _active:Boolean;

      final function set active(param1:Boolean) : void {
         this.log.debug(" is active: "+param1);
         this._active=param1;
         this.setEventListeners(this.playList,param1);
         return;
      }

      protected function setEventListeners(param1:ClipEventSupport, param2:Boolean=true) : void {
         return;
      }

      function get streamProvider() : StreamProvider {
         return _controllerFactory.getProvider(this.playList.current);
      }

      function get state() : State {
         return this._stateCode;
      }

      function startBuffering() : void {
         this.log.debug("cannot start buffering in this state");
         return;
      }

      function stopBuffering() : void {
         this.log.debug("cannot stop buffering in this state");
         return;
      }

      function play() : void {
         this.log.debug("cannot start playing in this state");
         return;
      }

      function switchStream(param1:Object=null) : void {
         this.log.debug("cannot start playing in this state");
         return;
      }

      function stop(param1:Boolean=false, param2:Boolean=false) : void {
         this.log.debug("stop() called");
         if(param2)
            {
               this.getMediaController().onEvent(null,[param1]);
               if((param1)&&!(this.playList.current.parent==null))
                  {
                     this.playList.setInStreamClip(null);
                     this.getMediaController().onEvent(null,[true]);
                  }
            }
         else
            {
               if(this.dispatchBeforeEvent(ClipEventType.STOP,[param1]))
                  {
                     this.onEvent(ClipEventType.STOP,[param1]);
                  }
               if((param1)&&!(this.playList.current.parent==null))
                  {
                     this.playList.setInStreamClip(null);
                     this.onEvent(ClipEventType.STOP,[true]);
                  }
            }
         return;
      }

      function close(param1:Boolean) : void {
         if(this.dispatchBeforeEvent(ClipEventType.STOP,[true,param1]))
            {
               this.changeState(waitingState);
               this.onEvent(ClipEventType.STOP,[true,param1]);
            }
         return;
      }

      function pause(param1:Boolean=false) : void {
         this.log.debug("cannot pause in this state");
         return;
      }

      function resume(param1:Boolean=false) : void {
         this.log.debug("cannot resume in this state");
         return;
      }

      function seekTo(param1:Number, param2:Boolean=false) : void {
         this.log.debug("cannot seek in this state");
         return;
      }

      function get muted() : Boolean {
         return _controllerFactory.getVolumeController().muted;
      }

      function set muted(param1:Boolean) : void {
         _controllerFactory.getVolumeController().muted=param1;
         return;
      }

      function set volume(param1:Number) : void {
         _controllerFactory.getVolumeController().volume=param1;
         return;
      }

      function get volume() : Number {
         return _controllerFactory.getVolumeController().volume;
      }

      function get status() : Status {
         var _loc1_:Status = this.getMediaController().getStatus(this._stateCode);
         return _loc1_;
      }

      protected function dispatchBeforeEvent(param1:ClipEventType, param2:Array=null, param3:Object=null) : Boolean {
         this.log.debug("dispatchBeforeEvent() "+param1.name+", current clip "+this.playList.current);
         Assert.notNull(param1,"eventType must be non-null");
         if(this.playList.current.isNullClip)
            {
               return false;
            }
         if(param1.isCancellable)
            {
               this.log.debug("canOnEvent(): dispatching before event for "+param1.name);
               if(!this.playList.current.dispatchBeforeEvent(new ClipEvent(param1,param3)))
                  {
                     this.log.info("event default was prevented, will not execute a state change");
                     return false;
                  }
            }
         this.log.debug("event is not cancellable, will not dispatch before event");
         return true;
      }

      protected function onEvent(param1:ClipEventType, param2:Array=null) : void {
         this.log.debug("calling onEvent("+param1.name+") on media controller ");
         this.getMediaController().onEvent(param1,param2);
         return;
      }

      protected function changeState(param1:PlayState) : void {
         if(this.playListController.getPlayState()!=param1)
            {
               this.playListController.setPlayState(param1);
            }
         return;
      }

      function getMediaController() : MediaController {
         var _loc1_:Clip = this.playList.current;
         return _controllerFactory.getMediaController(_loc1_,this.playList);
      }

      protected function removeOneShotClip(param1:Clip) : void {
         if(param1.isOneShot)
            {
               this.log.debug("removing one shot child clip from the playlist");
               this.playList.removeChildClip(param1);
            }
         return;
      }

      protected function onClipDone(param1:ClipEvent) : void {
         var _loc2_:* = !param1.isDefaultPrevented();
         var _loc3_:Clip = param1.target as Clip;
         this.log.info(this+" onClipDone "+_loc3_);
         _loc3_.dispatchEvent(param1);
         if(!this._active)
            {
               this.log.debug("I\'m not the active state any more, returning.");
               return;
            }
         if(_loc3_.isMidroll)
            {
               this.log.debug("midroll clip finished");
               this.stop(false,true);
               this.playList.setInStreamClip(null);
               this.changeState(pausedState);
               this.playListController.resume();
               this.removeOneShotClip(_loc3_);
               return;
            }
         if(this.playList.hasNext(false))
            {
               if(_loc2_)
                  {
                     this.log.debug("onClipDone, moving to next clip");
                     this.playListController.next(true,true,false);
                  }
               else
                  {
                     this.stop(false,true);
                     this.changeState(waitingState);
                  }
            }
         else
            {
               if(_loc2_)
                  {
                     this.log.debug("onClipDone(), calling stop(closeStream = false, silent = true)");
                     this.stop(false,true);
                     this.changeState(waitingState);
                  }
               else
                  {
                     this.playListController.rewind();
                  }
            }
         return;
      }

      protected function onClipStop(param1:ClipEvent) : void {
         this.log.debug("onClipStop");
         if(param1.isDefaultPrevented())
            {
               this.log.debug("default was prevented");
               return;
            }
         var _loc2_:Clip = Clip(param1.target);
         if(_loc2_.isMidroll)
            {
               this.log.debug("midroll clip finished");
               this.playList.setInStreamClip(null);
               this.changeState(pausedState);
               this.playListController.resume();
            }
         else
            {
               this.changeState(waitingState);
            }
         this.removeOneShotClip(_loc2_);
         return;
      }

      private function onPlaylistChanged(param1:ClipEvent) : void {
         this.setEventListeners(ClipEventSupport(param1.info),false);
         if(this._active)
            {
               this.setEventListeners(ClipEventSupport(param1.target));
            }
         return;
      }

      private function onClipAdded(param1:ClipEvent) : void {
         if(this._active)
            {
               this.setEventListeners(ClipEventSupport(param1.target));
            }
         return;
      }

      protected function get playListReady() : Boolean {
         if(!this.playList.current||(this.playList.current.isNullClip))
            {
               this.log.debug("playlist has nos clips to play, returning");
               return false;
            }
         return true;
      }
   }

}