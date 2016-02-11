package org.flowplayer.config
{
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.Canvas;
   import flash.utils.ByteArray;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.Loadable;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.model.PlayButtonOverlay;
   import org.flowplayer.model.Logo;
   import flash.display.DisplayObject;
   import org.flowplayer.util.PropertyBinder;
   import org.flowplayer.util.LogConfiguration;
   import org.flowplayer.model.PluginModel;
   import org.flowplayer.model.ProviderModel;
   import org.flowplayer.controller.NetStreamControllingStreamProvider;
   import org.flowplayer.util.Assert;

   use namespace flow_internal;

   public class Config extends Object
   {
         

      public function Config(param1:Object, param2:Object, param3:String, param4:String, param5:String) {
         super();
         Assert.notNull(param1,"No configuration provided.");
         this._configObject=this.createConfigObject(param1,param2);
         this._playerSwfUrl=param3;
         this._playlistBuilder=new PlaylistBuilder(this.playerId,this._configObject.playlist,this._configObject.clip);
         this._controlsVersion=param4;
         this._audioVersion=param5;
         return;
      }



      private var playList:Playlist;

      private var _configObject:Object;

      private var _pluginBuilder:PluginBuilder;

      private var _playlistBuilder:PlaylistBuilder;

      public var logFilter:String;

      private var _playerSwfUrl:String;

      private var _controlsVersion:String;

      private var _audioVersion:String;

      private var _loadables:Array;

      private var _canvas:Canvas;

      private function createConfigObject(param1:Object, param2:Object) : Object {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeObject(param2);
         _loc3_.position=0;
         var _loc4_:Object = _loc3_.readObject();
         return this.copyProps(_loc4_,param1);
      }

      private function copyProps(param1:Object, param2:Object, param3:String=null) : Object {
         var _loc4_:String = null;
         var _loc5_:* = 0;
         if(param2 is Number||param2 is String||param2 is Boolean)
            {
               param1=param2;
               return param1;
            }
         if(param2 is Array)
            {
               if(param1.hasOwnProperty(param3))
                  {
                     _loc5_=0;
                     while(_loc5_<param2.length)
                        {
                           (param1[param3] as Array).push(param2[_loc5_]);
                           _loc5_++;
                        }
                  }
               return param1;
            }
         for (_loc4_ in param2)
            {
               if(param1.hasOwnProperty(_loc4_))
                  {
                     param1[_loc4_]=this.copyProps(param1[_loc4_],param2[_loc4_],_loc4_);
                     continue;
                  }
               param1[_loc4_]=param2[_loc4_];
            }
         return param1;
      }

      flow_internal function set playlistDocument(param1:String) : void {
         this._playlistBuilder.playlistFeed=param1;
         return;
      }

      public function get playerId() : String {
         return this._configObject.playerId;
      }

      public function createClip(param1:Object) : Clip {
         return this._playlistBuilder.createClip(param1);
      }

      public function createCuepoints(param1:Array, param2:String, param3:Number) : Array {
         return this._playlistBuilder.createCuepointGroup(param1,param2,param3);
      }

      public function createClips(param1:Object=null) : Array {
         return this._playlistBuilder.createClips(param1);
      }

      public function getPlaylist() : Playlist {
         if(this._configObject.playlist is String&&!this._playlistBuilder.playlistFeed)
            {
               throw new Error("playlist queried but the playlist feed file has not been received yet");
            }
         if(!this.playList)
            {
               this.playList=this._playlistBuilder.createPlaylist();
            }
         return this.playList;
      }

      public function getLoadables() : Array {
         if(!this._loadables)
            {
               this._loadables=this.viewObjectBuilder.createLoadables(this.getPlaylist());
            }
         return this._loadables;
      }

      private function getLoadable(param1:String) : Loadable {
         var _loc4_:Loadable = null;
         var _loc2_:Array = this.getLoadables();
         var _loc3_:Number = 0;
         while(_loc3_<_loc2_.length)
            {
               _loc4_=_loc2_[_loc3_];
               if(_loc4_.name==param1)
                  {
                     return _loc4_;
                  }
               _loc3_++;
            }
         return null;
      }

      private function get viewObjectBuilder() : PluginBuilder {
         if(this._pluginBuilder==null)
            {
               this._pluginBuilder=new PluginBuilder(this._playerSwfUrl,this._controlsVersion,this._audioVersion,this,this._configObject.plugins,this._configObject);
            }
         return this._pluginBuilder;
      }

      public function getScreenProperties() : DisplayProperties {
         return this.viewObjectBuilder.getScreen(this.getObject("screen"));
      }

      public function getPlayButtonOverlay() : PlayButtonOverlay {
         var _loc1_:PlayButtonOverlay = this.viewObjectBuilder.getDisplayProperties(this.getObject("play"),"play",PlayButtonOverlay) as PlayButtonOverlay;
         if(_loc1_)
            {
               _loc1_.buffering=this.useBufferingAnimation;
            }
         return _loc1_;
      }

      public function getLogo(param1:DisplayObject) : Logo {
         return new PropertyBinder(new Logo(param1,"logo"),null).copyProperties(this.getObject("logo"),true) as Logo;
      }

      public function getObject(param1:String) : Object {
         return this._configObject[param1];
      }

      public function getLogConfiguration() : LogConfiguration {
         if(!this._configObject.log)
            {
               return new LogConfiguration();
            }
         return new PropertyBinder(new LogConfiguration(),null).copyProperties(this._configObject.log) as LogConfiguration;
      }

      public function get licenseKey() : Object {
         return (this._configObject.key)||(this._configObject.keys);
      }

      public function get canvas() : Canvas {
         var _loc1_:Object = null;
         var _loc2_:Canvas = null;
         if(!this._canvas)
            {
               _loc1_=this.getObject("canvas");
               if(!_loc1_)
                  {
                     _loc1_=new Object();
                  }
               this.setProperty("backgroundGradient",_loc1_,[0.3,0]);
               this.setProperty("border",_loc1_,"0px");
               this.setProperty("backgroundColor",_loc1_,"transparent");
               this.setProperty("borderRadius",_loc1_,"0");
               _loc2_=new Canvas();
               _loc2_.style=_loc1_;
               this._canvas=new PropertyBinder(_loc2_,"style").copyProperties(_loc1_) as Canvas;
            }
         return this._canvas;
      }

      private function setProperty(param1:String, param2:Object, param3:Object) : void {
         if(!param2[param1])
            {
               param2[param1]=param3;
            }
         return;
      }

      public function get contextMenu() : Array {
         return this.getObject("contextMenu") as Array;
      }

      public function getPlugin(param1:DisplayObject, param2:String, param3:Object) : PluginModel {
         return this.viewObjectBuilder.getPlugin(param1,param2,param3);
      }

      public function get showErrors() : Boolean {
         if(!this._configObject.hasOwnProperty("showErrors"))
            {
               return true;
            }
         return this._configObject["showErrors"];
      }

      public function get useBufferingAnimation() : Boolean {
         if(!this._configObject.hasOwnProperty("buffering"))
            {
               return true;
            }
         return this._configObject["buffering"];
      }

      public function createHttpProvider(param1:String) : ProviderModel {
         var _loc2_:NetStreamControllingStreamProvider = new NetStreamControllingStreamProvider();
         var _loc3_:ProviderModel = new ProviderModel(_loc2_,param1);
         _loc2_.model=_loc3_;
         return _loc3_;
      }

      public function get streamCallbacks() : Array {
         return this._configObject["streamCallbacks"];
      }

      public function get connectionCallbacks() : Array {
         return this._configObject["connectionCallbacks"];
      }

      public function get playlistFeed() : String {
         return this._configObject.playlist is String?this._configObject.playlist:null;
      }

      public function get playerSwfUrl() : String {
         return this._playerSwfUrl;
      }

      public function get configObject() : Object {
         return this._configObject;
      }
   }

}