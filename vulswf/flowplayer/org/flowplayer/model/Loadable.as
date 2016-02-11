package org.flowplayer.model
{
   import org.flowplayer.config.Config;
   import flash.display.DisplayObject;
   import org.flowplayer.util.PropertyBinder;
   import flash.utils.getDefinitionByName;


   public class Loadable extends PluginEventDispatcher
   {
         

      public function Loadable(param1:String, param2:Config, param3:String=null) {
         super();
         this._name=param1;
         this._playerConfig=param2;
         this._url=param3;
         return;
      }



      private var _name:String;

      private var _url:String;

      private var _type:String;

      private var _config:Object;

      private var _plugin:PluginModel;

      private var _playerConfig:Config;

      private var _loadFailed:Boolean;

      public function createDisplayPlugin(param1:DisplayObject) : DisplayPluginModel {
         if(!this._plugin)
            {
               this._plugin=this._playerConfig.getPlugin(param1,this._name,this._config);
               this._plugin.url=this._url;
            }
         return this._plugin as DisplayPluginModel;
      }

      public function createProvider(param1:Object) : ProviderModel {
         if(!this._plugin)
            {
               this._plugin=new PropertyBinder(new ProviderModel(param1,this._name),"config").copyProperties(this._config) as PluginModel;
               this._plugin.url=this._url;
            }
         return this._plugin as ProviderModel;
      }

      public function createPlugin(param1:Object) : PluginModel {
         if(!this._plugin)
            {
               this._plugin=new PropertyBinder(new PluginModelImpl(param1,this._name),"config").copyProperties(this._config) as PluginModel;
               this._plugin.url=this._url;
            }
         return this._plugin as PluginModel;
      }

      public function instantiate() : Object {
         var _loc1_:Class = Class(getDefinitionByName(this._url));
         return new (_loc1_)();
      }

      public function get url() : String {
         return this._url;
      }

      public function set url(param1:String) : void {
         this._url=param1;
         return;
      }

      public function get config() : Object {
         return this._config;
      }

      public function set config(param1:Object) : void {
         this._config=param1;
         return;
      }

      override  public function get name() : String {
         return this._name;
      }

      public function toString() : String {
         return "[Loadable] \'"+this._name+"\', builtIn "+this.isBuiltIn;
      }

      public function get plugin() : PluginModel {
         return this._plugin;
      }

      public function get loadFailed() : Boolean {
         return this._loadFailed;
      }

      public function set loadFailed(param1:Boolean) : void {
         this._loadFailed=param1;
         return;
      }

      public function get type() : String {
         return this._type;
      }

      public function set type(param1:String) : void {
         this._type=param1;
         return;
      }

      public function get isBuiltIn() : Boolean {
         return (this._url)&&this._url.toLowerCase().indexOf(".swf")>0;
      }
   }

}