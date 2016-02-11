package org.flowplayer.controller
{
   import org.flowplayer.config.Config;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.Clip;
   import flash.display.DisplayObject;
   import flash.media.Video;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.ClipType;


   class StreamProviderController extends AbstractDurationTrackingController implements MediaController
   {
         

      function StreamProviderController(param1:MediaControllerFactory, param2:VolumeController, param3:Config, param4:Playlist) {
         var controllerFactory:MediaControllerFactory = param1;
         var volumeController:VolumeController = param2;
         var config:Config = param3;
         var playlist:Playlist = param4;
         super(volumeController,playlist);
         this._controllerFactory=controllerFactory;
         this._config=config;
         var filter:Function = new function(param1:Clip):Boolean
            {
               return param1.type==ClipType.VIDEO||param1.type==ClipType.AUDIO||param1.type==ClipType.API;
            };
         playlist.onBegin(this.onBegin,filter,true);
         return;
      }



      private var _config:Config;

      private var _controllerFactory:MediaControllerFactory;

      private function onBegin(param1:ClipEvent) : void {
         var _loc2_:Clip = param1.target as Clip;
         log.info("onBegin, initializing content for clip "+_loc2_);
         var _loc3_:DisplayObject = _loc2_.getContent();
         if((_loc3_)&&_loc3_ is Video)
            {
               this.getProvider(_loc2_).attachStream(_loc3_);
            }
         else
            {
               _loc3_=this.getProvider(_loc2_).getVideo(_loc2_);
               if((_loc3_)&&_loc3_ is Video)
                  {
                     this.getProvider(_loc2_).attachStream(_loc3_);
                     if(!_loc3_)
                        {
                           throw new Error("No video object available for clip "+_loc2_);
                        }
                     _loc2_.setContent(_loc3_);
                  }
               else
                  {
                     if(_loc3_)
                        {
                           _loc2_.setContent(_loc3_);
                        }
                  }
            }
         return;
      }

      override  protected function doLoad(param1:ClipEvent, param2:Clip, param3:Boolean=false) : void {
         this.getProvider().load(param1,param2,param3);
         return;
      }

      override  protected function doPause(param1:ClipEvent) : void {
         this.getProvider().pause(param1);
         return;
      }

      override  protected function doResume(param1:ClipEvent) : void {
         this.getProvider().resume(param1);
         return;
      }

      override  protected function doStop(param1:ClipEvent, param2:Boolean) : void {
         this.getProvider().stop(param1,param2);
         return;
      }

      override  protected function doSeekTo(param1:ClipEvent, param2:Number) : void {
         durationTracker.time=param2;
         this.getProvider().seek(param1,param2);
         return;
      }

      override  protected function doSwitchStream(param1:ClipEvent, param2:Clip, param3:Object=null) : void {
         var _loc4_:StreamProvider = this.getProvider();
         _loc4_.switchStream(param1,param2,param3);
         return;
      }

      override  public function get time() : Number {
         return this.getProvider().time;
      }

      override  protected function get bufferStart() : Number {
         return this.getProvider().bufferStart;
      }

      override  protected function get bufferEnd() : Number {
         return this.getProvider().bufferEnd;
      }

      override  protected function get fileSize() : Number {
         return this.getProvider().fileSize;
      }

      override  protected function get allowRandomSeek() : Boolean {
         return this.getProvider().allowRandomSeek;
      }

      override  protected function onDurationReached() : void {
         if(clip.durationFromMetadata>clip.duration)
            {
               this.getProvider().pause(null);
            }
         return;
      }

      public function getProvider(param1:Clip=null) : StreamProvider {
         if(!((param1)||(clip)))
            {
               return null;
            }
         var _loc2_:StreamProvider = this._controllerFactory.getProvider((param1)||(clip));
         _loc2_.playlist=playlist;
         return _loc2_;
      }
   }

}