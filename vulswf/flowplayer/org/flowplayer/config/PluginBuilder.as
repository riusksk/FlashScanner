package org.flowplayer.config
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Playlist;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.ClipType;
   import org.flowplayer.flow_internal;
   import org.flowplayer.model.Loadable;
   import org.flowplayer.util.PropertyBinder;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.model.DisplayPropertiesImpl;
   import org.flowplayer.model.PluginModel;
   import flash.display.DisplayObject;
   import org.flowplayer.model.DisplayPluginModelImpl;
   import org.flowplayer.model.DisplayPluginModel;
   import org.flowplayer.model.Plugin;

   use namespace flow_internal;

   class PluginBuilder extends Object
   {
         

      function PluginBuilder(param1:String, param2:String, param3:String, param4:Config, param5:Object, param6:Object) {
         this.log=new Log(this);
         super();
         this._playerURL=param1;
         this._config=param4;
         this._pluginObjects=(param5)||(new Object());
         this._skinObjects=(param6)||(new Object());
         this._controlsVersion=param2;
         this._audioVersion=param3;
         this._loadables=[];
         this.updatePrototypedLoadableUrls();
         if(new RegExp("config={").exec(param1))
            {
               this._callType="URL";
            }
         else
            {
               this._callType="default";
            }
         this.log.debug("pluginObject ",this._pluginObjects);
         return;
      }



      private var log:Log;

      private var _pluginObjects:Object;

      private var _skinObjects:Object;

      private var _config:Config;

      private var _playerURL:String;

      private var _controlsVersion:String;

      private var _audioVersion:String;

      private var _loadables:Array;

      private var _callType:String;

      public function createLoadables(param1:Playlist) : Array {
         var _loc2_:String = null;
         var _loc3_:* = false;
         for (_loc2_ in this._pluginObjects)
            {
               if(!this.isObjectDisabled(_loc2_,this._pluginObjects)&&(((this._pluginObjects[_loc2_].hasOwnProperty("url"))||(_loc2_=="controls"))||(_loc2_=="audio")))
                  {
                     this.log.debug("creating loadable for \'"+_loc2_+"\', "+this._pluginObjects[_loc2_]);
                     this._pluginObjects[_loc2_].callType=this._callType;
                     this._loadables.push(this.newLoadable(this._pluginObjects,_loc2_));
                  }
            }
         this.log.debug("initializing default loadables: controls and audio if needed");
         _loc3_=this.isBuiltIn("controls");
         this.log.debug("controls is builtin? "+_loc3_);
         if(!_loc3_)
            {
               this.initLoadable("controls",this._controlsVersion);
            }
         if((this.hasAudioClipsWithoutProvider(param1))&&!this.isBuiltIn("audio"))
            {
               this.initLoadable("audio",this._audioVersion);
            }
         this.createInStreamProviders(param1,this._loadables);
         return this._loadables;
      }

      private function hasAudioClipsWithoutProvider(param1:Playlist) : Boolean {
         var _loc3_:* = 0;
         var _loc4_:Clip = null;
         var _loc2_:Array = param1.clips;
         while(_loc3_<_loc2_.length)
            {
               _loc4_=_loc2_[_loc3_] as Clip;
               if(ClipType.AUDIO==_loc4_.type)
                  {
                     return !_loc4_.clipObject||!_loc4_.clipObject.hasOwnProperty("provider");
                  }
               _loc3_++;
            }
         return false;
      }

      private function isBuiltIn(param1:String) : Boolean {
         return (this._pluginObjects[param1])&&(this._pluginObjects[param1].hasOwnProperty("url"))&&String(this._pluginObjects[param1]["url"]).toLocaleLowerCase().indexOf(".swf")>0;
      }

      private function updatePrototypedLoadableUrls() : void {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for (_loc1_ in this._pluginObjects)
            {
               _loc2_=this._pluginObjects[_loc1_];
               if((_loc2_)&&(_loc2_.hasOwnProperty("prototype")))
                  {
                     _loc3_=this._pluginObjects[_loc2_["prototype"]];
                     if(!_loc3_)
                        {
                           throw new Error("Prototype "+_loc2_["prototype"]+" not available");
                        }
                     this.log.debug("found a prototype reference \'"+_loc2_["prototype"]+"\', resolved to class name "+_loc3_.url);
                     _loc2_.url=_loc3_.url;
                  }
            }
         return;
      }

      private function newLoadable(param1:Object, param2:String, param3:String=null, param4:String=null) : Loadable {
         var _loc5_:Loadable = new PropertyBinder(new Loadable(param2,this._config),"config").copyProperties(param1[param3||param2]) as Loadable;
         if(param4)
            {
               _loc5_.url=param4;
            }
         return _loc5_;
      }

      private function createInStreamProviders(param1:Playlist, param2:Array) : void {
         var _loc5_:Clip = null;
         var _loc6_:Loadable = null;
         var _loc3_:Array = param1.childClips;
         var _loc4_:* = 0;
         while(_loc4_<_loc3_.length)
            {
               _loc5_=_loc3_[_loc4_];
               if(_loc5_.configuredProviderName!="http")
                  {
                     _loc6_=this.findLoadable(_loc5_.configuredProviderName);
                     if((_loc6_)&&!this.findLoadable(_loc5_.provider))
                        {
                           _loc6_=this.newLoadable(this._pluginObjects,_loc5_.provider,_loc5_.configuredProviderName);
                           param2.push(_loc6_);
                        }
                  }
               _loc4_++;
            }
         return;
      }

      private function isObjectDisabled(param1:String, param2:Object) : Boolean {
         if(!param2.hasOwnProperty(param1))
            {
               return false;
            }
         var _loc3_:Object = param2[param1];
         return _loc3_==null;
      }

      private function initLoadable(param1:String, param2:String) : Loadable {
         this.log.debug("createLoadable() \'"+param1+"\' version "+param2);
         if(this.isObjectDisabled(param1,this._pluginObjects))
            {
               this.log.debug(param1+" is disabled");
               return null;
            }
         var _loc3_:Loadable = this.findLoadable(param1);
         if(!_loc3_)
            {
               _loc3_=new Loadable(param1,this._config);
               this._loadables.push(_loc3_);
            }
         else
            {
               this.log.debug(param1+" was found in configuration, will not automatically add it into loadables");
            }
         if(!_loc3_.url)
            {
               _loc3_.url=this.getLoadableUrl(param1,param2);
            }
         this.log.debug("createLoadable(), created loadable with url "+_loc3_.url);
         return _loc3_;
      }

      private function findLoadable(param1:String) : Loadable {
         var _loc3_:Loadable = null;
         var _loc2_:Number = 0;
         while(_loc2_<this._loadables.length)
            {
               _loc3_=this._loadables[_loc2_];
               if(_loc3_.name==param1)
                  {
                     return _loc3_;
                  }
               _loc2_++;
            }
         return null;
      }

      private function getLoadableUrl(param1:String, param2:String) : String {
         var _loc3_:String = this.getPlayerVersion();
         this.log.debug("player version detected from SWF name is "+_loc3_);
         if(_loc3_)
            {
               return "flowplayer."+param1+"-"+param2+".swf";
            }
         return "flowplayer."+param1+".swf";
      }

      private function getPlayerVersion() : String {
         var _loc1_:String = this.getVersionFromSwfName("flowplayer");
         if(_loc1_)
            {
               return _loc1_;
            }
         _loc1_=this.getVersionFromSwfName("flowplayer.commercial");
         if(_loc1_)
            {
               return _loc1_;
            }
         return this.getVersionFromSwfName("flowplayer.unlimited");
      }

      private function getVersionFromSwfName(param1:String) : String {
         this.log.debug("getVersionFromSwfName() "+this.playerSwfName);
         if(this.playerSwfName.indexOf(param1+"-")<0)
            {
               return null;
            }
         if(this.playerSwfName.indexOf(".swf")<(param1+"-").length)
            {
               return null;
            }
         return this.playerSwfName.substring(this.playerSwfName.indexOf("-")+1,this.playerSwfName.indexOf(".swf"));
      }

      private function get playerSwfName() : String {
         var _loc1_:Number = this._playerURL.lastIndexOf("/");
         return this._playerURL.substring(_loc1_+1,this._playerURL.indexOf(".swf")+4);
      }

      public function getDisplayProperties(param1:Object, param2:String, param3:Class=null) : DisplayProperties {
         if(this.isObjectDisabled(param2,this._skinObjects))
            {
               this.log.debug(param2+" is disabled");
               return null;
            }
         var _loc4_:DisplayProperties = param3?new (param3)() as DisplayProperties:new DisplayPropertiesImpl();
         if(param1)
            {
               new PropertyBinder(_loc4_,null).copyProperties(param1);
            }
         _loc4_.name=param2;
         return _loc4_;
      }

      public function getScreen(param1:Object) : DisplayProperties {
         this.log.warn("getScreen "+param1);
         var _loc2_:DisplayProperties = new DisplayPropertiesImpl(null,"screen",false);
         new PropertyBinder(_loc2_,null).copyProperties(this.getScreenDefaults());
         if(param1)
            {
               this.log.info("setting screen properties specified in configuration");
               new PropertyBinder(_loc2_,null).copyProperties(param1);
            }
         _loc2_.zIndex=0;
         return _loc2_;
      }

      private function getScreenDefaults() : Object {
         var _loc1_:Object = new Object();
         _loc1_.left="50%";
         _loc1_.bottom="50%";
         _loc1_.width="100%";
         _loc1_.height="100%";
         _loc1_.name="screen";
         _loc1_.zIndex=0;
         return _loc1_;
      }

      public function getPlugin(param1:DisplayObject, param2:String, param3:Object) : PluginModel {
         var _loc5_:Object = null;
         var _loc4_:DisplayPluginModel = new PropertyBinder(new DisplayPluginModelImpl(param1,param2,false),"config").copyProperties(param3,true) as DisplayPluginModel;
         this.log.debug(param2+" position specified in config "+_loc4_.position);
         if(param1 is Plugin)
            {
               this.log.debug(param2+" implements Plugin, querying defaultConfig");
               _loc5_=Plugin(param1).getDefaultConfig();
               if(_loc5_)
                  {
                     this.fixPositionSettings(_loc4_,_loc5_);
                     if(!((param3)&&(param3.hasOwnProperty("opacity")))&&(_loc5_.hasOwnProperty("opacity")))
                        {
                           _loc4_.opacity=_loc5_["opacity"];
                        }
                     _loc4_=new PropertyBinder(_loc4_,"config").copyProperties(_loc5_,false) as DisplayPluginModel;
                     this.log.debug(param2+" position after applying defaults "+_loc4_.position+", zIndex "+_loc4_.zIndex);
                  }
            }
         return _loc4_;
      }

      private function fixPositionSettings(param1:DisplayProperties, param2:Object) : void {
         this.clearOpposite("bottom","top",param1,param2);
         this.clearOpposite("left","right",param1,param2);
         return;
      }

      private function clearOpposite(param1:String, param2:String, param3:DisplayProperties, param4:Object) : void {
         if((param3.position[param1].hasValue())&&(param4.hasOwnProperty(param2)))
            {
               delete param4[[param2]];
            }
         else
            {
               if((param3.position[param2].hasValue())&&(param4.hasOwnProperty(param1)))
                  {
                     delete param4[[param1]];
                  }
            }
         return;
      }
   }

}