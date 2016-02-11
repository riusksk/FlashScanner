package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Playlist;
   import flash.utils.Dictionary;
   import org.flowplayer.config.Config;
   import org.flowplayer.flow_internal;
   import org.flowplayer.view.PlayerEventDispatcher;
   import org.flowplayer.model.State;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.ClipType;
   import org.flowplayer.model.Status;
   import org.flowplayer.model.ProviderModel;

   use namespace flow_internal;

   public class PlayListController extends Object
   {
         

      public function PlayListController(param1:Playlist, param2:Dictionary, param3:Config, param4:ResourceLoader) {
         super();
         this.log=new Log(this);
         this._playList=param1;
         this._providers=param2;
         this._config=param3;
         this._loader=param4;
         return;
      }



      private var log:Log;

      private var _playList:Playlist;

      private var _state:PlayState;

      private var _providers:Dictionary;

      private var _config:Config;

      private var _loader:ResourceLoader;

      flow_internal function get streamProvider() : StreamProvider {
         return this._state.streamProvider;
      }

      flow_internal function set playerEventDispatcher(param1:PlayerEventDispatcher) : void {
         PlayState.initStates(this._playList,this,this._providers,param1,this._config,this._loader);
         return;
      }

      flow_internal function setPlaylist(param1:Array) : void {
         if(this.getState()!=State.WAITING)
            {
               this.close(false);
            }
         this._playList.replaceClips2(param1);
         return;
      }

      flow_internal function get playlist() : Playlist {
         return this._playList;
      }

      flow_internal function rewind() : Clip {
         this.log.info("rewind()");
         this.setPlayState(PlayState.waitingState);
         this._playList.toIndex(this.firstNonSplashClip());
         this._state.play();
         return this._playList.current;
      }

      private function firstNonSplashClip() : Number {
         var _loc3_:Clip = null;
         var _loc4_:Clip = null;
         var _loc1_:Array = this._playList.clips;
         var _loc2_:Number = 0;
         while(_loc2_<_loc1_.length)
            {
               _loc3_=_loc1_[_loc2_];
               if(_loc3_.type==ClipType.IMAGE&&_loc3_.duration<0)
                  {
                     return _loc2_;
                  }
               if(_loc3_.type==ClipType.IMAGE&&_loc2_>_loc1_.length-1)
                  {
                     _loc4_=_loc1_[_loc2_+1] as Clip;
                     if(_loc4_.type==ClipType.AUDIO&&(_loc4_.image))
                        {
                           _loc4_.autoPlayNext=true;
                           return _loc2_;
                        }
                  }
               if(_loc3_.type==ClipType.VIDEO||_loc3_.type==ClipType.AUDIO)
                  {
                     return _loc2_;
                  }
               _loc2_++;
            }
         return 0;
      }

      flow_internal function playClips(param1:Array) : void {
         this.replacePlaylistAndPlay(param1);
         return;
      }

      flow_internal function playInstream(param1:Clip) : void {
         this._state.pause();
         this.playlist.setInStreamClip(param1);
         this.setPlayState(PlayState.waitingState);
         this._state.play();
         return;
      }

      flow_internal function switchStream(param1:Clip, param2:Object=null) : void {
         this._state.switchStream(param2);
         return;
      }

      flow_internal function play(param1:Clip=null, param2:Number=-1) : Clip {
         this.log.debug("play() "+param1+", "+param2);
         if((param1)||param2>=0)
            {
               return this.playClip(param1,param2);
            }
         if(!this._playList.hasNext()&&(this.status.ended))
            {
               return this.rewind();
            }
         this._state.play();
         return this._playList.current;
      }

      private function playClip(param1:Clip=null, param2:Number=undefined) : Clip {
         if(param1)
            {
               this.replacePlaylistAndPlay(param1);
               return param1;
            }
         if(param2>=0)
            {
               this._state.stop();
               if(this._playList.toIndex(param2)==null)
                  {
                     this.log.error("There is no clip at index "+param2+", cannot play");
                     return this._playList.current;
                  }
               this._state.play();
            }
         return this._playList.current;
      }

      flow_internal function startBuffering() : Clip {
         this._state.startBuffering();
         return this._playList.current;
      }

      flow_internal function stopBuffering() : Clip {
         this._state.stopBuffering();
         return this._playList.current;
      }

      flow_internal function next(param1:Boolean, param2:Boolean=false, param3:Boolean=true) : Clip {
         if(!this._playList.hasNext(param3))
            {
               return this._playList.current;
            }
         return this.moveTo(this._playList.next,param1,param2,param3);
      }

      flow_internal function previous(param1:Boolean=true) : Clip {
         if(!this._playList.hasPrevious(param1))
            {
               return this._playList.current;
            }
         if((this.currentIsAudioWithSplash())&&this._playList.currentIndex>=3)
            {
               this._state.stop();
               this._playList.toIndex(this._playList.currentIndex-2);
               this._state.play();
               return this._playList.current;
            }
         return this.moveTo(this._playList.previous,false,false,param1);
      }

      private function currentIsAudioWithSplash() : Boolean {
         return (this._playList.current.type==ClipType.AUDIO&&this._playList.current.image)&&(this._playList.previousClip)&&this._playList.previousClip.type==ClipType.IMAGE;
      }

      flow_internal function moveTo(param1:Function, param2:Boolean, param3:Boolean, param4:Boolean=true) : Clip {
         var _loc5_:State = this.getState();
         this.log.debug("moveTo() current state is "+this._state);
         if(param3)
            {
               this._state.stop(true,true);
               this.setPlayState(PlayState.waitingState);
            }
         else
            {
               this._state.stop();
            }
         var _loc6_:Clip = param1(param4) as Clip;
         this.log.info("moved in playlist, current clip is "+this._playList.current+", next clip is "+_loc6_);
         this.log.debug("moved in playlist, next clip autoPlay "+_loc6_.autoPlay+", autoBuffering "+_loc6_.autoBuffering);
         if(param2)
            {
               this.log.debug("obeying clip autoPlay & autoBuffeing");
               this.log.debug("autoPlayNext? "+_loc6_.autoPlayNext+", autoPlay? "+_loc6_.autoPlay+", autoBuffering? "+_loc6_.autoBuffering);
               if(_loc6_.autoPlayNext)
                  {
                     _loc6_.autoPlayNext=false;
                     this._state.play();
                  }
               else
                  {
                     if(_loc6_.autoPlay)
                        {
                           this._state.play();
                        }
                     else
                        {
                           if(_loc6_.autoBuffering)
                              {
                                 if(_loc6_.type==ClipType.IMAGE&&(_loc6_.autoBuffering))
                                    {
                                       this._state.play();
                                    }
                                 else
                                    {
                                       this._state.startBuffering();
                                    }
                              }
                        }
                  }
            }
         else
            {
               this.log.debug("not obeying playlist settings");
               if(_loc5_==State.PAUSED||_loc5_==State.WAITING)
                  {
                     this._state.startBuffering();
                  }
               else
                  {
                     this._state.play();
                  }
            }
         return _loc6_;
      }

      flow_internal function pause(param1:Boolean=false) : Clip {
         this.log.debug("pause(), silent? "+param1);
         this._state.pause(param1);
         return this._playList.current;
      }

      flow_internal function resume(param1:Boolean=false) : Clip {
         this.log.debug("resume(), silent? "+param1);
         this._state.resume(param1);
         return this._playList.current;
      }

      flow_internal function stop(param1:Boolean=false) : Clip {
         if(param1)
            {
               this.setPlayState(PlayState.waitingState);
            }
         else
            {
               if(this._state)
                  {
                     this._state.stop();
                  }
            }
         if(!this._playList)
            {
               return null;
            }
         return this._playList.current;
      }

      flow_internal function close(param1:Boolean) : void {
         this._state.close(param1);
         return;
      }

      flow_internal function seekTo(param1:Number, param2:Boolean=false) : Clip {
         this.log.debug("seekTo "+param1+", silent? "+param2);
         if(param1>=0)
            {
               this._state.seekTo(param1,param2);
            }
         else
            {
               this.log.warn("seekTo was called with seconds value "+param1);
            }
         return this._playList.current;
      }

      flow_internal function getState() : State {
         if(!this._state)
            {
               return null;
            }
         return this._state.state;
      }

      flow_internal function getPlayState() : PlayState {
         return this._state;
      }

      flow_internal function setPlayState(param1:PlayState) : void {
         this.log.debug("moving to state "+param1);
         if(this._state)
            {
               this._state.active=false;
            }
         this._state=param1;
         this._state.active=true;
         return;
      }

      flow_internal function isInState(param1:PlayState) : Boolean {
         return this._state==param1;
      }

      flow_internal function get muted() : Boolean {
         return this._state.muted;
      }

      flow_internal function set muted(param1:Boolean) : void {
         this._state.muted=param1;
         return;
      }

      flow_internal function set volume(param1:Number) : void {
         this._state.volume=param1;
         return;
      }

      flow_internal function get volume() : Number {
         if(!this._state)
            {
               return 0;
            }
         return this._state.volume;
      }

      flow_internal function get status() : Status {
         return this._state.status;
      }

      flow_internal function addConnectionCallback(param1:String, param2:Function) : void {
         this.addCallback(param1,param2,"addConnectionCallback");
         return;
      }

      flow_internal function addStreamCallback(param1:String, param2:Function) : void {
         this.addCallback(param1,param2,"addStreamCallback");
         return;
      }

      private function addCallback(param1:String, param2:Function, param3:String) : void {
         var _loc4_:Object = null;
         var _loc5_:StreamProvider = null;
         for each (_loc4_ in this._providers)
            {
               this.log.debug("provider"+_loc4_);
               _loc5_=_loc4_ as StreamProvider;
               _loc5_[param3](param1,param2);
            }
         return;
      }

      private function replacePlaylistAndPlay(param1:Object) : void {
         this.stop();
         if(param1 is Clip)
            {
               this._playList.replaceClips(param1 as Clip);
            }
         else
            {
               this._playList.replaceClips2(param1 as Array);
            }
         this.play();
         return;
      }

      flow_internal function addProvider(param1:ProviderModel) : void {
         PlayState.addProvider(param1);
         return;
      }
   }

}