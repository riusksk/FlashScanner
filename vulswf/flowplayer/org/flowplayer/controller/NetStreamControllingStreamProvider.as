package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.Playlist;
   import flash.utils.Timer;
   import org.flowplayer.model.ProviderModel;
   import org.flowplayer.view.Flowplayer;
   import flash.utils.Dictionary;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.util.Assert;
   import org.flowplayer.model.ClipEventType;
   import flash.display.DisplayObject;
   import flash.media.Video;
   import org.flowplayer.view.StageVideoWrapper;
   import flash.net.NetStreamPlayOptions;
   import flash.events.NetStatusEvent;
   import org.flowplayer.model.PluginModel;
   import org.flowplayer.model.ClipError;
   import flash.events.TimerEvent;
   import flash.errors.IOError;


   public class NetStreamControllingStreamProvider extends Object implements StreamProvider
   {
         

      public function NetStreamControllingStreamProvider() {
         this.log=new Log(this);
         this._streamCallbacks=new Dictionary();
         super();
         this._connectionClient=new NetConnectionClient();
         return;
      }



      private var _ParrallelRTMPConnectionProviderDummyRef:ParallelRTMPConnectionProvider;

      protected var log:Log;

      private var _connection:NetConnection;

      private var _connectionArgs:Array;

      private var _netStream:NetStream;

      private var _startedClip:Clip;

      private var _playlist:Playlist;

      private var _pauseAfterStart:Boolean;

      private var _volumeController:VolumeController;

      private var _seekTargetWaitTimer:Timer;

      private var _seekTarget:Number;

      private var _model:ProviderModel;

      private var _connectionProvider:ConnectionProvider;

      private var _clipUrlResolverHelper:ClipURLResolverHelper;

      private var _player:Flowplayer;

      private var _silentSeek:Boolean;

      private var _paused:Boolean;

      private var _stopping:Boolean;

      private var _started:Boolean;

      private var _connectionClient:NetConnectionClient;

      private var _streamCallbacks:Dictionary;

      private var _timeProvider:TimeProvider;

      private var _seeking:Boolean;

      private var _switching:Boolean;

      private var _attempts:int;

      public function set model(param1:ProviderModel) : void {
         this._model=param1;
         this.onConfig(param1);
         return;
      }

      public function get model() : ProviderModel {
         return this._model;
      }

      public function set player(param1:Flowplayer) : void {
         this._player=param1;
         this.createConnectionProvider();
         this.createClipUrlResolver();
         this.onLoad(param1);
         return;
      }

      public final function load(param1:ClipEvent, param2:Clip, param3:Boolean=false) : void {
         this._load(param2,param3);
         return;
      }

      private function _load(param1:Clip, param2:Boolean, param3:int=3) : void {
         var clip:Clip = param1;
         var pauseAfterStart:Boolean = param2;
         var attempts:int = param3;
         Assert.notNull(clip,"load(clip): clip cannot be null");
         this._paused=false;
         this._stopping=false;
         this._attempts=attempts;
         if(pauseAfterStart)
            {
               this.log.info("this clip will pause after start");
            }
         this._pauseAfterStart=pauseAfterStart;
         if(this._pauseAfterStart)
            {
               this._volumeController.muted=true;
            }
         clip.onMetaData(this.onMetaData,new function(param1:Clip):Boolean
            {
               return param1.provider==(_model?_model.name:param1.parent?"httpInstream":"http");
               });
               clip.startDispatched=false;
               this.log.debug("previously started clip "+this._startedClip);
               if((((attempts==3)&&(this._startedClip))&&(this._startedClip==clip))&&(this._connection)&&(this._netStream))
                  {
                     this.log.info("playing previous clip again, reusing existing connection and resuming");
                     this._started=false;
                     this.replay(clip);
                  }
               else
                  {
                     this.log.debug("will create a new connection");
                     this._startedClip=clip;
                     this.connect(clip);
                  }
               return;
      }

      private function replay(param1:Clip) : void {
         var clip:Clip = param1;
         try
            {
               this.seek(new ClipEvent(ClipEventType.SEEK,0),0);
               this.netStream.resume();
               this._started=true;
               clip.dispatchEvent(new ClipEvent(ClipEventType.BEGIN,this._pauseAfterStart));
               clip.dispatchEvent(new ClipEvent(ClipEventType.START));
            }
         catch(e:Error)
            {
               if(e.errorID==2154)
                  {
                     log.debug("error when reusing existing netStream "+e);
                     connect(clip);
                  }
               else
                  {
                     throw e;
                  }
            }
         return;
      }

      public function get allowRandomSeek() : Boolean {
         return false;
      }

      public final function resume(param1:ClipEvent) : void {
         this._paused=false;
         this._stopping=false;
         this.doResume(this._netStream,param1);
         return;
      }

      public final function pause(param1:ClipEvent) : void {
         this._paused=true;
         this.doPause(this._netStream,param1);
         return;
      }

      public final function seek(param1:ClipEvent, param2:Number) : void {
         this.silentSeek=param1==null;
         this.log.debug("seekTo "+param2);
         this._seekTarget=param2;
         this.doSeek(param1,this._netStream,param2);
         return;
      }

      public final function stop(param1:ClipEvent, param2:Boolean=false) : void {
         this.log.debug("stop called");
         if(!this._netStream)
            {
               return;
            }
         this.doStop(param1,this._netStream,param2);
         return;
      }

      public final function switchStream(param1:ClipEvent, param2:Clip, param3:Object=null) : void {
         this.log.debug("switchStream called");
         if(!this._netStream)
            {
               return;
            }
         this._switching=true;
         this.doSwitchStream(param1,this._netStream,param2,param3);
         return;
      }

      public function get time() : Number {
         if(!this._netStream)
            {
               return 0;
            }
         return this.getCurrentPlayheadTime(this.netStream);
      }

      public function get bufferStart() : Number {
         return 0;
      }

      public function get bufferEnd() : Number {
         if(!this._netStream)
            {
               return 0;
            }
         if(!this.currentClipStarted())
            {
               return 0;
            }
         return Math.min(this._netStream.bytesLoaded/this._netStream.bytesTotal*this.clip.durationFromMetadata,this.clip.duration);
      }

      public function get fileSize() : Number {
         if(!this._netStream)
            {
               return 0;
            }
         if(!this.currentClipStarted())
            {
               return 0;
            }
         return this._netStream.bytesTotal;
      }

      public function set volumeController(param1:VolumeController) : void {
         this._volumeController=param1;
         return;
      }

      public function get stopping() : Boolean {
         return this._stopping;
      }

      public function getVideo(param1:Clip) : DisplayObject {
         var _loc2_:Video = null;
         if(param1.useStageVideo)
            {
               _loc2_=new StageVideoWrapper(param1);
            }
         else
            {
               _loc2_=new Video();
               _loc2_.smoothing=param1.smoothing;
            }
         return _loc2_;
      }

      public function attachStream(param1:DisplayObject) : void {
         Object(param1).attachNetStream(this._netStream);
         return;
      }

      public function get playlist() : Playlist {
         return this._playlist;
      }

      public function set playlist(param1:Playlist) : void {
         this._playlist=param1;
         return;
      }

      public function addConnectionCallback(param1:String, param2:Function) : void {
         this.log.debug("addConnectionCallback "+param1);
         this._connectionClient.addConnectionCallback(param1,param2);
         return;
      }

      public function addStreamCallback(param1:String, param2:Function) : void {
         this.log.debug("addStreamCallback "+param1);
         this._streamCallbacks[param1]=param2;
         return;
      }

      public final function get netStream() : NetStream {
         return this._netStream;
      }

      public function get netConnection() : NetConnection {
         return this._connection;
      }

      public function get streamCallbacks() : Dictionary {
         return this._streamCallbacks;
      }

      protected function connect(param1:Clip, ... rest) : void {
         if(this._netStream)
            {
               this._netStream.close();
               this._netStream=null;
            }
         this._connectionArgs=rest;
         this.resolveClipUrl(param1,this.onClipUrlResolved);
         return;
      }

      protected function doLoad(param1:ClipEvent, param2:NetStream, param3:Clip) : void {
         param2.client=new NetStreamClient(param3,this._player.config,this._streamCallbacks);
         this.netStreamPlay(this.getClipUrl(param3));
         return;
      }

      protected function getClipUrl(param1:Clip) : String {
         return param1.completeUrl;
      }

      protected function doPause(param1:NetStream, param2:ClipEvent=null) : void {
         if(!param1)
            {
               return;
            }
         param1.pause();
         if(param2)
            {
               this.dispatchEvent(param2);
            }
         return;
      }

      protected function doResume(param1:NetStream, param2:ClipEvent) : void {
         var netStream:NetStream = param1;
         var event:ClipEvent = param2;
         this.log.debug("doResume");
         try
            {
               this._volumeController.netStream=netStream;
               netStream.resume();
               this.dispatchEvent(event);
            }
         catch(e:Error)
            {
               log.debug("doResume(): error catched "+e+", will connect again. All resolved URLs are discarded.");
               clip.clearResolvedUrls();
               dispatchEvent(event);
               clip.startDispatched=false;
               _started=false;
               _paused=false;
               connect(clip);
            }
         return;
      }

      protected final function set silentSeek(param1:Boolean) : void {
         this._silentSeek=param1;
         this.log.info("silentSeek was set to "+this._silentSeek);
         return;
      }

      protected final function get silentSeek() : Boolean {
         this.log.debug("silentSeek == "+this._silentSeek);
         return this._silentSeek;
      }

      protected final function get switching() : Boolean {
         return this._switching;
      }

      protected final function set switching(param1:Boolean) : void {
         this._switching=param1;
         return;
      }

      protected final function get paused() : Boolean {
         return this._paused;
      }

      protected final function get seeking() : Boolean {
         return this._seeking;
      }

      protected final function set seeking(param1:Boolean) : void {
         this._seeking=param1;
         return;
      }

      protected function doSeek(param1:ClipEvent, param2:NetStream, param3:Number) : void {
         this.log.debug("doSeek(), event == "+param1);
         if(Math.abs(param3-this.time)<0.2)
            {
               this.log.debug("current time within 0.2 range from the seek target --> will not seek");
               this.dispatchPlayEvent(ClipEventType.SEEK,param3);
               return;
            }
         this.log.debug("calling netStream.seek("+param3+")");
         this._seeking=true;
         param2.seek(param3);
         return;
      }

      protected function doSwitchStream(param1:ClipEvent, param2:NetStream, param3:Clip, param4:Object=null) : void {
         if(param4)
            {
               this.pauseAfterStart=this.paused;
               if(param4 is NetStreamPlayOptions)
                  {
                     this.log.debug("doSwitchStream() calling play2()");
                     param4.streamName=param3.completeUrl;
                     param2.play2(param4 as NetStreamPlayOptions);
                  }
            }
         else
            {
               this.load(param1,param3,this._paused);
            }
         this.dispatchEvent(param1);
         return;
      }

      protected function canDispatchBegin() : Boolean {
         return true;
      }

      protected function canDispatchStreamNotFound() : Boolean {
         return true;
      }

      protected final function dispatchEvent(param1:ClipEvent) : void {
         if(!param1)
            {
               return;
            }
         if((this.silentSeek)&&param1.eventType.name==ClipEventType.SEEK.name)
            {
               this.log.debug("dispatchEvent(), in silentSeek mode --> will not dispatch SEEK");
               return;
            }
         this.log.debug("dispatching "+param1+" on clip "+this.clip);
         this.clip.dispatchEvent(param1);
         return;
      }

      protected function onNetStatus(param1:NetStatusEvent) : void {
         return;
      }

      protected function isDurationReached() : Boolean {
         return Math.abs(this.getCurrentPlayheadTime(this.netStream)-this.clip.duration)<=0.5;
      }

      protected function getCurrentPlayheadTime(param1:NetStream) : Number {
         if(this._timeProvider)
            {
               return this._timeProvider.getTime(param1);
            }
         return param1.time;
      }

      protected final function get clip() : Clip {
         return this._playlist.current;
      }

      protected final function get pauseAfterStart() : Boolean {
         return this._pauseAfterStart;
      }

      protected final function set pauseAfterStart(param1:Boolean) : void {
         this._pauseAfterStart=param1;
         return;
      }

      protected function currentClipStarted() : Boolean {
         return this._startedClip==this.clip;
      }

      protected function get started() : Boolean {
         return this._started;
      }

      protected final function resolveClipUrl(param1:Clip, param2:Function) : void {
         this._clipUrlResolverHelper.resolveClipUrl(param1,param2);
         return;
      }

      public function get seekTarget() : Number {
         return this._seekTarget;
      }

      public function onConfig(param1:PluginModel) : void {
         return;
      }

      public function onLoad(param1:Flowplayer) : void {
         return;
      }

      protected function getDefaultClipURLResolver() : ClipURLResolver {
         return new DefaultClipURLResolver();
      }

      protected function netStreamPlay(param1:String) : void {
         this.log.debug("netStreamPlay(): starting playback with resolved url "+param1);
         this._netStream.play(param1);
         return;
      }

      protected function onClipUrlResolved(param1:Clip) : void {
         this._connectionClient.clip=param1;
         this.connectionProvider.connectionClient=this._connectionClient;
         this.log.debug("about to call connectionProvider.connect, objectEncoding "+this._model.objectEncoding);
         this.connectionProvider.connect(this,param1,this.onConnectionSuccess,this._model.objectEncoding,(this._connectionArgs)||([]));
         return;
      }

      protected function getConnectionProvider(param1:Clip) : ConnectionProvider {
         return this._connectionProvider;
      }

      private function createClipUrlResolver() : void {
         var _loc1_:ClipURLResolver = null;
         if(this._model.urlResolver)
            {
               _loc1_=PluginModel(this._player.pluginRegistry.getPlugin(this._model.urlResolver)).pluginObject as ClipURLResolver;
            }
         this._clipUrlResolverHelper=new ClipURLResolverHelper(this._player,this,_loc1_);
         return;
      }

      private function createConnectionProvider() : void {
         if(this._model.connectionProvider)
            {
               this.log.debug("getting connection provider "+this._model.connectionProvider+" from registry");
               this._connectionProvider=PluginModel(this._player.pluginRegistry.getPlugin(this._model.connectionProvider)).pluginObject as ConnectionProvider;
               if(!this._connectionProvider)
                  {
                     throw new Error("connection provider "+this._model.connectionProvider+" not loaded");
                  }
            }
         this._connectionProvider=new DefaultRTMPConnectionProvider();
         return;
      }

      private function dispatchError(param1:ClipError, param2:String) : void {
         this.clip.dispatchError(param1,param2);
         return;
      }

      private function _onNetStatus(param1:NetStatusEvent) : void {
         this.log.info("_onNetStatus, code: "+param1.info.code);
         if(!this._clipUrlResolverHelper.getClipURLResolver(this.clip).handeNetStatusEvent(param1))
            {
               this.log.debug("clipURLResolver.handeNetStatusEvent returned false, ignoring this event");
               return;
            }
         if(!this.connectionProvider.handeNetStatusEvent(param1))
            {
               this.log.debug("connectionProvider.handeNetStatusEvent returned false, ignoring this event");
               return;
            }
         if(this._stopping)
            {
               this.log.info("_onNetStatus(), _stopping == true and will not process the event any further");
               return;
            }
         if(param1.info.code=="NetStream.Buffer.Empty")
            {
               this.dispatchPlayEvent(ClipEventType.BUFFER_EMPTY);
            }
         else
            {
               if(param1.info.code=="NetStream.Buffer.Full")
                  {
                     this.dispatchPlayEvent(ClipEventType.BUFFER_FULL);
                  }
               else
                  {
                     if(param1.info.code=="NetStream.Play.Start")
                        {
                           if(!this._paused&&(this.canDispatchBegin()))
                              {
                                 this.log.debug("dispatching onBegin");
                                 this.clip.dispatchEvent(new ClipEvent(ClipEventType.BEGIN,this._pauseAfterStart));
                              }
                        }
                     else
                        {
                           if(param1.info.code=="NetStream.Play.Stop")
                              {
                                 if(this.clip.duration-this._player.status.time<1)
                                    {
                                       this.clip.dispatchEvent(new ClipEvent(ClipEventType.BUFFER_FULL));
                                    }
                              }
                           else
                              {
                                 if(param1.info.code=="NetStream.Seek.Notify")
                                    {
                                       if(!this.silentSeek)
                                          {
                                             this.startSeekTargetWait();
                                          }
                                       else
                                          {
                                             this._seeking=false;
                                          }
                                    }
                                 else
                                    {
                                       if(param1.info.code=="NetStream.Seek.InvalidTime")
                                          {
                                             this._seekTarget=int(param1.info.details-1);
                                             this.log.debug("Buffer seek failed, setting seek time to "+this._seekTarget);
                                             this.silentSeek=false;
                                             this._seeking=true;
                                             this.netStream.seek(this._seekTarget);
                                          }
                                       else
                                          {
                                             if(param1.info.code=="NetStream.Play.StreamNotFound"||param1.info.code=="NetConnection.Connect.Rejected"||param1.info.code=="NetConnection.Connect.Failed")
                                                {
                                                   this.log.info("load attempts left "+(this._attempts-1));
                                                   if(--this._attempts>0)
                                                      {
                                                         this.log.info("retrying _load()");
                                                         this._load(this.clip,this._pauseAfterStart,this._attempts);
                                                      }
                                                   else
                                                      {
                                                         if(this.canDispatchStreamNotFound())
                                                            {
                                                               this.dispatchPlayEvent(ClipEventType.BUFFER_STOP);
                                                               this.clip.dispatchError(ClipError.STREAM_NOT_FOUND,param1.info.code);
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
         this.onNetStatus(param1);
         return;
      }

      private function onConnectionSuccess(param1:NetConnection) : void {
         this._connection=param1;
         param1.addEventListener(NetStatusEvent.NET_STATUS,this._onNetStatus);
         this._createNetStream();
         this.start(null,this.clip,this._pauseAfterStart);
         this.dispatchPlayEvent(ClipEventType.CONNECT);
         return;
      }

      private function startSeekTargetWait() : void {
         if(this._seekTarget<0)
            {
               return;
            }
         if((this._seekTargetWaitTimer)&&(this._seekTargetWaitTimer.running))
            {
               return;
            }
         this.log.debug("starting seek target wait timer");
         this._seekTargetWaitTimer=new Timer(200);
         this._seekTargetWaitTimer.addEventListener(TimerEvent.TIMER,this.onSeekTargetWait);
         this._seekTargetWaitTimer.start();
         return;
      }

      private function onSeekTargetWait(param1:TimerEvent) : void {
         if(this.time>=this._seekTarget)
            {
               this._seekTargetWaitTimer.stop();
               this.log.debug("dispatching onSeek");
               this.dispatchPlayEvent(ClipEventType.SEEK,this._seekTarget);
               this._seekTarget=-1;
               this._seeking=false;
            }
         return;
      }

      private function dispatchPlayEvent(param1:ClipEventType, param2:Object=null) : void {
         this.dispatchEvent(new ClipEvent(param1,param2));
         return;
      }

      protected function doStop(param1:ClipEvent, param2:NetStream, param3:Boolean=false) : void {
         this.log.debug("doStop");
         this._stopping=true;
         if(this.clip.live)
            {
               this._netStream.close();
               this._netStream=null;
            }
         else
            {
               if(param3)
                  {
                     this._startedClip=null;
                     this.log.debug("doStop(), closing netStream and connection");
                     if(this.clip.getContent() is Video)
                        {
                           Video(this.clip.getContent()).clear();
                        }
                     try
                        {
                           param2.close();
                           this._netStream=null;
                        }
                     catch(e:Error)
                        {
                        }
                     if(this._connection)
                        {
                           this._connection.close();
                           this._connection=null;
                        }
                     this.dispatchPlayEvent(ClipEventType.BUFFER_STOP);
                  }
               else
                  {
                     this.silentSeek=true;
                     param2.client=new NullNetStreamClient();
                     param2.pause();
                     param2.seek(0);
                  }
            }
         this.dispatchEvent(param1);
         return;
      }

      private function _createNetStream() : void {
         this._netStream=(this.createNetStream(this._connection))||(new NetStream(this._connection));
         this.netStream.client=new NetStreamClient(this.clip,this._player.config,this._streamCallbacks);
         this._netStream.bufferTime=this.clip.bufferLength;
         this._volumeController.netStream=this._netStream;
         this.clip.setNetStream(this._netStream);
         this._netStream.addEventListener(NetStatusEvent.NET_STATUS,this._onNetStatus);
         this.onNetStreamCreated(this._netStream);
         return;
      }

      protected function onNetStreamCreated(param1:NetStream) : void {
         return;
      }

      protected function createNetStream(param1:NetConnection) : NetStream {
         return null;
      }

      protected function pauseToFrame() : void {
         this.log.debug("seeking to frame zero");
         this.pause(new ClipEvent(ClipEventType.PAUSE));
         this.silentSeek=true;
         this.netStream.seek(0);
         this._volumeController.muted=false;
         this._pauseAfterStart=false;
         return;
      }

      protected function onMetaData(param1:ClipEvent) : void {
         this.log.info("in NetStreamControllingStremProvider.onMetaData: "+param1.target);
         if(!this.clip.startDispatched)
            {
               this.clip.dispatch(ClipEventType.START,this._pauseAfterStart);
               this.clip.startDispatched=true;
            }
         if(this._pauseAfterStart)
            {
               this.pauseToFrame();
            }
         this._switching=false;
         return;
      }

      private function start(param1:ClipEvent, param2:Clip, param3:Boolean=false) : void {
         var event:ClipEvent = param1;
         var clip:Clip = param2;
         var pauseAfterStart:Boolean = param3;
         this.log.debug("start called with clip "+clip+", pauseAfterStart "+pauseAfterStart);
         try
            {
               this.doLoad(event,this._netStream,clip);
               this._started=true;
            }
         catch(e:SecurityError)
            {
               dispatchError(ClipError.STREAM_LOAD_FAILED,"cannot access the video file (try loosening Flash security settings): "+e.message);
            }
         catch(e:IOError)
            {
               dispatchError(ClipError.STREAM_LOAD_FAILED,"cannot load the video file, incorrect URL?: "+e.message);
            }
         catch(e:Error)
            {
               dispatchError(ClipError.STREAM_LOAD_FAILED,"cannot play video: "+e.message);
            }
         return;
      }

      private function get connectionProvider() : ConnectionProvider {
         var provider:ConnectionProvider = null;
         if(this.clip.connectionProvider)
            {
               provider=PluginModel(this._player.pluginRegistry.getPlugin(this.clip.connectionProvider)).pluginObject as ConnectionProvider;
               if(!provider)
                  {
                     throw new Error("connectionProvider "+this.clip.connectionProvider+" not loaded");
                  }
            }
         provider=this.getConnectionProvider(this.clip);
         provider.onFailure=new function(param1:String=null):void
            {
               dispatchPlayEvent(ClipEventType.BUFFER_STOP);
               clip.dispatchError(ClipError.STREAM_LOAD_FAILED,"connection failed"+(param1?": "+param1:""));
               return;
            };
         return provider;
      }

      public function set timeProvider(param1:TimeProvider) : void {
         this.log.debug("set timeprovider() "+param1);
         this._timeProvider=param1;
         return;
      }

      public function get type() : String {
         return "http";
      }
   }

}