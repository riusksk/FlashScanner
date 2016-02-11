package org.flowplayer.model
{
   import flash.utils.Dictionary;
   import flash.display.DisplayObject;
   import flash.net.NetStream;
   import org.flowplayer.util.ArrayUtil;
   import org.flowplayer.controller.ClipURLResolver;
   import org.flowplayer.util.URLUtil;
   import flash.media.Video;
   import org.flowplayer.util.VersionUtil;
   import org.flowplayer.flow_internal;

   use namespace flow_internal;

   public class Clip extends ClipEventDispatcher implements Extendable
   {
         

      public function Clip() {
         this._extension=new ExtendableHelper();
         super();
         this._childPlaylist=new TimedPlaylist();
         this._cuepoints=new Dictionary();
         this._cuepointsInNegative=[];
         this._urlsByResolver=[];
         this._start=0;
         this._bufferLength=3;
         this._backBufferLength=30;
         this._scaling=MediaSize.FILLED_TO_AVAILABLE_SPACE;
         this._provider="http";
         this._smoothing=true;
         this._fadeInSpeed=1000;
         this._fadeOutSpeed=1000;
         this._linkWindow="_self";
         this._image=true;
         this._cuepointMultiplier=1000;
         this._seekableOnBegin=true;
         this._accelerated=false;
         return;
      }

      public static function create(param1:Object, param2:String, param3:String=null) : Clip {
         return init(new (Clip)(),param1,param2,param3);
      }

      private static function init(param1:Clip, param2:Object, param3:String, param4:String=null) : Clip {
         param1._clipObject=param2;
         param1._url=param3;
         param1._baseUrl=param4;
         param1._autoPlay=true;
         return param1;
      }

      private var _playlist:Playlist;

      private var _childPlaylist:TimedPlaylist;

      private var _preroll:Clip;

      private var _postroll:Clip;

      private var _parent:Clip;

      private var _cuepoints:Dictionary;

      private var _cuepointsInNegative:Array;

      private var _baseUrl:String;

      private var _url:String;

      private var _urlsByResolver:Array;

      private var _urlResolverObjects:Array;

      private var _type:ClipType;

      private var _start:Number;

      private var _position:Number = -100;

      private var _duration:Number = 0;

      private var _metaData:Object;

      private var _autoPlay:Boolean = true;

      private var _autoPlayNext:Boolean = false;

      private var _autoBuffering:Boolean;

      private var _scaling:MediaSize;

      private var _accelerated:Boolean;

      private var _smoothing:Boolean;

      private var _content:DisplayObject;

      private var _originalWidth:int;

      private var _originalHeight:int;

      private var _bufferLength:int;

      private var _backBufferLength:int;

      private var _played:Boolean;

      private var _provider:String;

      private var _extension:ExtendableHelper;

      private var _fadeInSpeed:int;

      private var _fadeOutSpeed:int;

      private var _live:Boolean;

      private var _linkUrl:String;

      private var _linkWindow:String;

      private var _image:Boolean;

      private var _cuepointMultiplier:Number;

      private var _urlResolvers:Array;

      private var _connectionProvider:String;

      private var _seekableOnBegin:Object;

      private var _clipObject:Object;

      private var _netStream:NetStream;

      private var _startDispatched:Boolean;

      private var _currentTime:Number = 0;

      private var _endLimit:Number = 0;

      private var _encoding:Boolean = false;

      private var _stopLiveOnPause:Boolean = true;

      public function addChild(param1:Clip) : void {
         param1.parent=this;
         if(param1.isPreroll)
            {
               this._preroll=param1;
            }
         if(param1.isPostroll)
            {
               this._postroll=param1;
            }
         if(param1.isMidroll)
            {
               log.info("adding midstream clip "+param1+", position "+param1.position+" to parent clip "+this);
               this._childPlaylist.addClip(param1);
            }
         return;
      }

      public function getParentPlaylist() : Playlist {
         return this._playlist;
      }

      public function setParentPlaylist(param1:Playlist) : void {
         var _loc4_:Clip = null;
         this._playlist=param1;
         var _loc2_:Array = this._childPlaylist.clips;
         if(this._preroll)
            {
               _loc2_.push(this._preroll);
            }
         if(this._postroll)
            {
               _loc2_.push(this._postroll);
            }
         var _loc3_:* = 0;
         while(_loc3_<_loc2_.length)
            {
               _loc4_=Clip(_loc2_[_loc3_]);
               _loc4_.setParentPlaylist(param1);
               _loc4_.setEventListeners(param1);
               _loc3_++;
            }
         return;
      }

      function setEventListeners(param1:Playlist) : void {
         this.unbindEventListeners();
         onAll(param1.commonClip.onClipEvent);
         onBeforeAll(param1.commonClip.onBeforeClipEvent);
         return;
      }

      function unbindEventListeners() : void {
         unbind(this._playlist.commonClip.onClipEvent);
         unbind(this._playlist.commonClip.onBeforeClipEvent,null,true);
         return;
      }

      public function get index() : int {
         return this._playlist.indexOf((this._parent)||(this));
      }

      public function get isCommon() : Boolean {
         if(!this._playlist)
            {
               return false;
            }
         return this==this._playlist.commonClip;
      }

      public function addCuepoints(param1:Array) : void {
         var _loc2_:Number = 0;
         while(_loc2_<param1.length)
            {
               this.addCuepoint(param1[_loc2_]);
               _loc2_++;
            }
         return;
      }

      public function removeCuepoints(param1:Function=null) : void {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         if(param1==null)
            {
               this._cuepoints=new Dictionary();
               return;
            }
         for (_loc2_ in this._cuepoints)
            {
               _loc3_=this._cuepoints[_loc2_];
               _loc4_=0;
               while(_loc4_<_loc3_.length)
                  {
                     if(param1(_loc3_[_loc4_] as Cuepoint))
                        {
                           delete this._cuepoints[[_loc2_]];
                        }
                     _loc4_++;
                  }
            }
         return;
      }

      public function addCuepoint(param1:Cuepoint) : void {
         if(!param1)
            {
               return;
            }
         if(param1.time>=0)
            {
               log.info(this+": adding cuepoint to time "+param1.time);
               if(!this._cuepoints[param1.time])
                  {
                     this._cuepoints[param1.time]=new Array();
                  }
               if((this._cuepoints[param1.time] as Array).indexOf(param1)>=0)
                  {
                     return;
                  }
               (this._cuepoints[param1.time] as Array).push(param1);
            }
         else
            {
               log.info("storing negative cuepoint "+(this==this.commonClip?"to common clip":""));
               this._cuepointsInNegative.push(param1);
            }
         return;
      }

      private function removeCuepoint(param1:Cuepoint) : void {
         var _loc2_:Array = this._cuepoints[param1.time];
         if(!_loc2_)
            {
               return;
            }
         var _loc3_:int = _loc2_.indexOf(param1);
         if(_loc3_>=0)
            {
               log.debug("removing previous negative cuepoint at timeline time "+param1.time);
               _loc2_.splice(_loc3_,1);
            }
         return;
      }

      public function getCuepoints(param1:int, param2:Number=-1) : Array {
         var _loc3_:Array = new Array();
         _loc3_=ArrayUtil.concat(_loc3_,this._cuepoints[param1]);
         _loc3_=ArrayUtil.concat(_loc3_,this.getNegativeCuepoints(param1,this==this.commonClip?param2:this.duration));
         if(this==this.commonClip)
            {
               return _loc3_;
            }
         _loc3_=ArrayUtil.concat(_loc3_,this.commonClip.getCuepoints(param1,this.duration));
         if(_loc3_.length>0)
            {
               log.info("found "+_loc3_.length+" cuepoints for time "+param1);
            }
         return _loc3_;
      }

      private function getNegativeCuepoints(param1:int, param2:Number) : Array {
         var _loc5_:Cuepoint = null;
         if(param2<=0)
            {
               return [];
            }
         var _loc3_:Array = new Array();
         var _loc4_:* = 0;
         while(_loc4_<this._cuepointsInNegative.length)
            {
               _loc5_=this.convertToPositive(this._cuepointsInNegative[_loc4_],param2);
               if(_loc5_.time==param1)
                  {
                     log.info("found negative cuepoint corresponding to time "+param1);
                     _loc3_.push(_loc5_);
                  }
               _loc4_++;
            }
         return _loc3_;
      }

      private function convertToPositive(param1:Cuepoint, param2:Number) : Cuepoint {
         var _loc3_:Cuepoint = param1.clone() as Cuepoint;
         _loc3_.time=Math.round((param2*1000-Math.abs(Cuepoint(param1).time))/100)*100;
         return _loc3_;
      }

      public function get baseUrl() : String {
         return this._baseUrl;
      }

      public function set baseUrl(param1:String) : void {
         this._baseUrl=param1;
         return;
      }

      public function get url() : String {
         return (this.getResolvedUrl())||(this._url);
      }

      public function get originalUrl() : String {
         return this._url;
      }

      public function set url(param1:String) : void {
         if(this._url!=param1)
            {
               this._metaData=null;
               this._content=null;
            }
         this._url=param1;
         return;
      }

      public function setResolvedUrl(param1:ClipURLResolver, param2:String) : void {
         var _loc4_:Array = null;
         var _loc3_:* = 0;
         while(_loc3_<this._urlsByResolver.length)
            {
               _loc4_=this._urlsByResolver[_loc3_];
               if(param1==_loc4_[0])
                  {
                     _loc4_[1]=param2;
                     return;
                  }
               _loc3_++;
            }
         this._urlsByResolver.push([param1,param2]);
         return;
      }

      public function getResolvedUrl(param1:ClipURLResolver=null) : String {
         var _loc2_:Array = null;
         if(param1)
            {
               return this.findResolvedUrl(param1);
            }
         if(this._urlsByResolver.length>0)
            {
               _loc2_=this._urlsByResolver[this._urlsByResolver.length-1];
               return _loc2_?_loc2_[1] as String:null;
            }
         return null;
      }

      public function get resolvedUrl() : String {
         return this.getResolvedUrl();
      }

      private function findResolvedUrl(param1:ClipURLResolver) : String {
         var _loc3_:Array = null;
         var _loc2_:* = 0;
         while(_loc2_<this._urlsByResolver.length)
            {
               _loc3_=this._urlsByResolver[_loc2_];
               if(param1==_loc3_[0])
                  {
                     return _loc3_[1] as String;
                  }
               _loc2_++;
            }
         return null;
      }

      public function getPreviousResolvedUrl(param1:ClipURLResolver) : String {
         if(!this._urlResolverObjects)
            {
               throw new Error("Clip.urlResolverObjects is null");
            }
         var _loc2_:int = this._urlResolverObjects.indexOf(param1);
         if(_loc2_>0)
            {
               return this.findResolvedUrl(this._urlResolverObjects[_loc2_-1]);
            }
         if(_loc2_<0)
            {
               throw new Error("Resolver "+param1+" is not a registered URL Resolver in clip "+this);
            }
         return this._url;
      }

      public function clearResolvedUrls() : void {
         this._urlsByResolver=[];
         return;
      }

      public function get completeUrl() : String {
         return encodeURI(this._baseUrl?URLUtil.completeURL(this._baseUrl,this.url):this.url);
      }

      private function encodeUrl(param1:String) : String {
         if(!this.urlEncoding)
            {
               return param1;
            }
         return encodeURI(param1);
      }

      public function get type() : ClipType {
         if(this._type)
            {
               return this._type;
            }
         if((this._url)&&this._url.indexOf("mp3:")>=0)
            {
               return ClipType.AUDIO;
            }
         if(!this._type&&(this._url))
            {
               this._type=ClipType.fromFileExtension(this.url);
            }
         if(this._type)
            {
               return this._type;
            }
         return ClipType.VIDEO;
      }

      public function get isFlashVideo() : Boolean {
         return ClipType.isFlashVideo(this._url);
      }

      public function get extension() : String {
         return ClipType.getExtension(this._url);
      }

      public function get typeStr() : String {
         return this.type?this.type.type:ClipType.VIDEO.type;
      }

      public function setType(param1:String) : void {
         this._type=ClipType.resolveType(param1);
         return;
      }

      public function set type(param1:ClipType) : void {
         this._type=param1;
         return;
      }

      public function get start() : Number {
         return this._start;
      }

      public function set start(param1:Number) : void {
         this._start=param1;
         return;
      }

      public function set duration(param1:Number) : void {
         this._duration=param1;
         log.info("clip duration set to "+param1);
         return;
      }

      public function get duration() : Number {
         if(this._duration>0)
            {
               return this._duration;
            }
         var _loc1_:Number = this.durationFromMetadata;
         if(this._start<0&&_loc1_<this._start)
            {
               return _loc1_-this._start;
            }
         return (_loc1_)||(0);
      }

      public function get durationFromMetadata() : Number {
         if(this._metaData)
            {
               return this.decodeDuration(this._metaData.duration);
            }
         return 0;
      }

      private function decodeDuration(param1:Object) : Number {
         if(!param1)
            {
               return 0;
            }
         if(param1 is Number)
            {
               return param1 as Number;
            }
         if(!param1 is String)
            {
               return 0;
            }
         var _loc2_:Array = param1.split(".");
         if(_loc2_.length>=3)
            {
               return Number(_loc2_[0]+"."+_loc2_[1]);
            }
         return param1 as Number;
      }

      public function set durationFromMetadata(param1:Number) : void {
         if(this._metaData is Boolean&&!this._metaData)
            {
               return;
            }
         if(!this._metaData)
            {
               this._metaData=new Object();
            }
         this._metaData.duration=param1;
         return;
      }

      public function get metaData() : Object {
         return this._metaData;
      }

      public function set metaData(param1:Object) : void {
         this._metaData=param1;
         return;
      }

      public function get autoPlay() : Boolean {
         if(this.isPreroll)
            {
               return this._parent._autoPlay;
            }
         if(!this._parent&&(this.preroll))
            {
               return true;
            }
         if(this.isPostroll)
            {
               return true;
            }
         return this._autoPlay;
      }

      public function set autoPlay(param1:Boolean) : void {
         this._autoPlay=param1;
         return;
      }

      public function get autoBuffering() : Boolean {
         return this._autoBuffering;
      }

      public function set autoBuffering(param1:Boolean) : void {
         this._autoBuffering=param1;
         return;
      }

      public function setContent(param1:DisplayObject) : void {
         if((this._content)&&(this._content is Video)&&!param1)
            {
               log.debug("clearing video content");
               Video(this._content).clear();
            }
         this._content=param1;
         return;
      }

      public function getContent() : DisplayObject {
         return this._content;
      }

      public function setScaling(param1:String) : void {
         this.scaling=MediaSize.forName(param1);
         return;
      }

      public function set scaling(param1:MediaSize) : void {
         this._scaling=param1;
         log.debug("scaling : "+param1+", disptching update");
         if(this._playlist)
            {
               this._playlist.dispatch(ClipEventType.UPDATE);
            }
         return;
      }

      public function get scaling() : MediaSize {
         return this._scaling;
      }

      public function get scalingStr() : String {
         if(!this._scaling)
            {
               return MediaSize.FILLED_TO_AVAILABLE_SPACE.value;
            }
         return this._scaling.value;
      }

      public function toString() : String {
         return "[Clip] \'"+(this.provider=="http"?this.completeUrl:this.url)+"\'";
      }

      public function set originalWidth(param1:int) : void {
         this._originalWidth=param1;
         return;
      }

      public function get originalWidth() : int {
         if(this.type==ClipType.VIDEO)
            {
               if((this._metaData)&&this._metaData.width>=0)
                  {
                     return this._metaData.width;
                  }
               if(!this._content)
                  {
                     return 0;
                  }
               return this._content is Video?(this._content as Video).videoWidth:this._originalWidth;
            }
         return this._originalWidth;
      }

      public function set originalHeight(param1:int) : void {
         this._originalHeight=param1;
         return;
      }

      public function get originalHeight() : int {
         if(this.type==ClipType.VIDEO)
            {
               if((this._metaData)&&this._metaData.height>=0)
                  {
                     return this._metaData.height;
                  }
               if(!this._content)
                  {
                     return 0;
                  }
               return this._content is Video?(this._content as Video).videoHeight:this._originalHeight;
            }
         return this._originalHeight;
      }

      public function set width(param1:int) : void {
         if(!this._content)
            {
               log.warn("Trying to change width of a clip that does not have media content loaded yet");
               return;
            }
         this._content.width=param1;
         return;
      }

      public function get width() : int {
         return this.getWidth();
      }

      private function getWidth() : int {
         if(!this._content)
            {
               return 0;
            }
         return this._content.width;
      }

      public function set height(param1:int) : void {
         if(!this._content)
            {
               log.warn("Trying to change height of a clip that does not have media content loaded yet");
               return;
            }
         this._content.height=param1;
         return;
      }

      public function get height() : int {
         return this.getHeight();
      }

      private function getHeight() : int {
         if(!this._content)
            {
               return 0;
            }
         return this._content.height;
      }

      public function get bufferLength() : int {
         return this._bufferLength;
      }

      public function set bufferLength(param1:int) : void {
         this._bufferLength=param1;
         return;
      }

      public function get backBufferLength() : int {
         return this._backBufferLength;
      }

      public function set backBufferLength(param1:int) : void {
         this._backBufferLength=param1;
         return;
      }

      public function get played() : Boolean {
         return this._played;
      }

      public function set played(param1:Boolean) : void {
         this._played=param1;
         return;
      }

      public function get provider() : String {
         if(this.type==ClipType.AUDIO&&this._provider=="http")
            {
               return "audio";
            }
         if((this._url)&&(this._url.toLowerCase().indexOf("rtmp")==0)&&this._provider=="http")
            {
               return "rtmp";
            }
         if(this.parent)
            {
               return this._provider+"Instream";
            }
         return this._provider;
      }

      public function get configuredProviderName() : String {
         return this._provider;
      }

      public function set provider(param1:String) : void {
         this._provider=param1;
         return;
      }

      public function get cuepoints() : Array {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc1_:Array = new Array();
         for each (_loc2_ in this._cuepoints)
            {
               _loc3_=_loc2_ as Array;
               for each (_loc4_ in _loc3_)
                  {
                     _loc1_.push(_loc4_);
                  }
            }
         return _loc1_;
      }

      public function set accelerated(param1:Boolean) : void {
         this._accelerated=param1;
         return;
      }

      public function get accelerated() : Boolean {
         return this._accelerated;
      }

      public function get useHWScaling() : Boolean {
         return (this._accelerated)&&!VersionUtil.hasStageVideo();
      }

      public function get useStageVideo() : Boolean {
         return (this._accelerated)&&(VersionUtil.hasStageVideo());
      }

      public function get isNullClip() : Boolean {
         return false;
      }

      public function onClipEvent(param1:ClipEvent) : void {
         log.info("received onClipEvent, I am commmon clip: "+(this==this._playlist.commonClip));
         doDispatchEvent(param1,true);
         log.debug(this+": dispatched play event with target "+param1.target);
         return;
      }

      public function onBeforeClipEvent(param1:ClipEvent) : void {
         log.info("received onBeforeClipEvent, I am commmon clip: "+(this==this._playlist.commonClip));
         doDispatchBeforeEvent(param1,true);
         log.debug(this+": dispatched before event with target "+param1.target);
         return;
      }

      private function get commonClip() : Clip {
         if(!this._playlist)
            {
               return null;
            }
         return this._playlist.commonClip;
      }

      public function get customProperties() : Object {
         return this._extension.props;
      }

      public function set customProperties(param1:Object) : void {
         this._extension.props=param1;
         this._extension.deleteProp("cuepoints");
         this._extension.deleteProp("playlist");
         return;
      }

      public function get smoothing() : Boolean {
         return this._smoothing;
      }

      public function set smoothing(param1:Boolean) : void {
         this._smoothing=param1;
         return;
      }

      public function getCustomProperty(param1:String) : Object {
         return this._extension.getProp(param1);
      }

      public function setCustomProperty(param1:String, param2:Object) : void {
         if(param1=="playlist")
            {
               return;
            }
         this._extension.setProp(param1,param2);
         return;
      }

      public function get fadeInSpeed() : int {
         return this._fadeInSpeed;
      }

      public function set fadeInSpeed(param1:int) : void {
         this._fadeInSpeed=param1;
         return;
      }

      public function get fadeOutSpeed() : int {
         return this._fadeOutSpeed;
      }

      public function set fadeOutSpeed(param1:int) : void {
         this._fadeOutSpeed=param1;
         return;
      }

      public function get live() : Boolean {
         return this._live;
      }

      public function set live(param1:Boolean) : void {
         this._live=param1;
         return;
      }

      public function get linkUrl() : String {
         return this._linkUrl;
      }

      public function set linkUrl(param1:String) : void {
         if(URLUtil.isValid(param1))
            {
               this._linkUrl=param1;
            }
         return;
      }

      public function get linkWindow() : String {
         return this._linkWindow;
      }

      public function set linkWindow(param1:String) : void {
         this._linkWindow=param1;
         return;
      }

      protected function get cuepointsInNegative() : Array {
         return this._cuepointsInNegative;
      }

      public function get image() : Boolean {
         return this._image;
      }

      public function set image(param1:Boolean) : void {
         this._image=param1;
         return;
      }

      public function get autoPlayNext() : Boolean {
         return this._autoPlayNext;
      }

      public function set autoPlayNext(param1:Boolean) : void {
         this._autoPlayNext=param1;
         return;
      }

      public function get cuepointMultiplier() : Number {
         return this._cuepointMultiplier;
      }

      public function set cuepointMultiplier(param1:Number) : void {
         this._cuepointMultiplier=param1;
         return;
      }

      public function dispatchNetStreamEvent(param1:String, param2:Object) : void {
         dispatch(ClipEventType.NETSTREAM_EVENT,param1,param2);
         return;
      }

      public function get connectionProvider() : String {
         return this._connectionProvider;
      }

      public function set connectionProvider(param1:String) : void {
         this._connectionProvider=param1;
         return;
      }

      public function get urlResolvers() : Array {
         return this._urlResolvers;
      }

      public function setUrlResolvers(param1:Object) : void {
         this._urlResolvers=param1 is Array?param1 as Array:[param1];
         return;
      }

      public function get seekableOnBegin() : Boolean {
         if(this._seekableOnBegin==null)
            {
               return this.isFlashVideo;
            }
         return this._seekableOnBegin as Boolean;
      }

      public function set seekableOnBegin(param1:Boolean) : void {
         this._seekableOnBegin=param1;
         return;
      }

      public function get hasChildren() : Boolean {
         return this._childPlaylist.length<0;
      }

      public function get playlist() : Array {
         var _loc1_:Array = this._childPlaylist.clips;
         if(this._preroll)
            {
               _loc1_=[this._preroll].concat(_loc1_);
            }
         if(this._postroll)
            {
               _loc1_.push(this._postroll);
            }
         return _loc1_;
      }

      public function removeChild(param1:Clip) : void {
         if(param1==this._preroll)
            {
               this._preroll=null;
               return;
            }
         if(param1==this._postroll)
            {
               this._postroll=null;
               return;
            }
         this._childPlaylist.removeClip(param1);
         return;
      }

      public function getMidroll(param1:int) : Clip {
         return this._childPlaylist.getClipAt(param1);
      }

      public function get preroll() : Clip {
         return this._preroll;
      }

      public function get postroll() : Clip {
         return this._postroll;
      }

      public function get isInStream() : Boolean {
         return !(this._parent==null);
      }

      public function get isMidroll() : Boolean {
         if(this.isOneShot)
            {
               return true;
            }
         return (this._parent)&&this._position<0;
      }

      public function get isPreroll() : Boolean {
         return (this._parent)&&this._position==0;
      }

      public function get isPostroll() : Boolean {
         return (this._parent)&&this._position==-1;
      }

      public function get parent() : Clip {
         return this._parent;
      }

      public function get parentUrl() : String {
         return this._parent?this._parent.url:null;
      }

      public function set parent(param1:Clip) : void {
         this._parent=param1;
         return;
      }

      public function get position() : Number {
         return this._position;
      }

      public function set position(param1:Number) : void {
         this._position=param1;
         return;
      }

      public function get isOneShot() : Boolean {
         return (this._parent)&&this.position==-2;
      }

      flow_internal function get clipObject() : Object {
         return this._clipObject;
      }

      public function getNetStream() : NetStream {
         return this._netStream;
      }

      public function setNetStream(param1:NetStream) : void {
         this._netStream=param1;
         return;
      }

      public function set urlResolverObjects(param1:Array) : void {
         this._urlResolverObjects=param1;
         return;
      }

      public function get startDispatched() : Boolean {
         return this._startDispatched;
      }

      public function set startDispatched(param1:Boolean) : void {
         this._startDispatched=param1;
         return;
      }

      public function get currentTime() : Number {
         return this._currentTime;
      }

      public function set currentTime(param1:Number) : void {
         this._currentTime=this._currentTime==0?param1+this._start:param1;
         return;
      }

      public function get endLimit() : Number {
         return this._endLimit;
      }

      public function set endLimit(param1:Number) : void {
         this._endLimit=param1;
         return;
      }

      public function set urlEncoding(param1:Boolean) : void {
         this._encoding=param1;
         return;
      }

      public function get urlEncoding() : Boolean {
         return this._encoding;
      }

      public function deleteCustomProperty(param1:String) : void {
         this._extension.deleteProp(param1);
         return;
      }

      public function get stopLiveOnPause() : Boolean {
         return this._stopLiveOnPause;
      }

      public function set stopLiveOnPause(param1:Boolean) : void {
         this._stopLiveOnPause=param1;
         return;
      }
   }

}