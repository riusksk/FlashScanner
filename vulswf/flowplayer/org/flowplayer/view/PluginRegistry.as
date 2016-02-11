package org.flowplayer.view
{
   import org.flowplayer.util.Log;
   import flash.utils.Dictionary;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.model.Cloneable;
   import flash.display.DisplayObject;
   import org.flowplayer.model.ProviderModel;
   import org.flowplayer.model.PluginModel;
   import org.flowplayer.model.DisplayPluginModel;
   import org.flowplayer.util.Assert;
   import org.flowplayer.util.PropertyBinder;
   import org.flowplayer.controller.NetStreamControllingStreamProvider;
   import org.flowplayer.model.Plugin;
   import org.flowplayer.controller.StreamProvider;
   import org.flowplayer.controller.ClipURLResolver;
   import org.flowplayer.controller.ConnectionProvider;


   public class PluginRegistry extends Object
   {
         

      public function PluginRegistry(param1:Panel) {
         this.log=new Log(this);
         this._plugins=new Dictionary();
         this._originalProps=new Dictionary();
         this._providers=new Dictionary();
         this._genericPlugins=new Dictionary();
         this._fonts=new Array();
         super();
         this._panel=param1;
         return;
      }



      private var log:Log;

      private var _plugins:Dictionary;

      private var _originalProps:Dictionary;

      private var _providers:Dictionary;

      private var _genericPlugins:Dictionary;

      private var _fonts:Array;

      private var _panel:Panel;

      private var _flowPlayer:FlowplayerBase;

      public function get plugins() : Dictionary {
         return this._plugins;
      }

      public function get providers() : Dictionary {
         return this._providers;
      }

      public function getPlugin(param1:String) : Object {
         var _loc2_:Object = (this._plugins[param1])||(this._providers[param1])||(this._genericPlugins[param1]);
         this.log.debug("found plugin "+_loc2_);
         if(_loc2_ is DisplayProperties)
            {
               this.updateZIndex(_loc2_ as DisplayProperties);
            }
         return _loc2_;
      }

      private function updateZIndex(param1:DisplayProperties) : void {
         var _loc2_:int = this._panel.getZIndex(param1.getDisplayObject());
         if(_loc2_>=0)
            {
               param1.zIndex=_loc2_;
            }
         return;
      }

      private function clone(param1:Object) : Object {
         return (param1)&&param1 is Cloneable?Cloneable(param1).clone():param1;
      }

      public function getPluginByDisplay(param1:DisplayObject) : DisplayProperties {
         var _loc2_:DisplayProperties = null;
         for each (_loc2_ in this._plugins)
            {
               if(_loc2_.getDisplayObject()==param1)
                  {
                     this.updateZIndex(_loc2_);
                     return _loc2_;
                  }
            }
         return null;
      }

      public function get fonts() : Array {
         return this._fonts;
      }

      public function getOriginalProperties(param1:String) : DisplayProperties {
         return this.clone(this._originalProps[param1]) as DisplayProperties;
      }

      function registerFont(param1:String) : void {
         this._fonts.push(param1);
         return;
      }

      public function registerDisplayPlugin(param1:DisplayProperties, param2:DisplayObject) : void {
         this.log.debug("registerDisplayPlugin() "+param1.name);
         param1.setDisplayObject(param2);
         this._plugins[param1.name]=param1;
         this._originalProps[param1.name]=param1.clone();
         return;
      }

      function registerProvider(param1:ProviderModel) : void {
         this.log.info("registering provider "+param1);
         this._providers[param1.name]=param1;
         return;
      }

      function registerGenericPlugin(param1:PluginModel) : void {
         this.log.info("registering generic plugin "+param1.name);
         this._genericPlugins[param1.name]=param1;
         return;
      }

      function removePlugin(param1:PluginModel) : void {
         if(!param1)
            {
               return;
            }
         delete this._plugins[[param1.name]];
         delete this._originalProps[[param1.name]];
         delete this._providers[[param1.name]];
         if(param1 is DisplayPluginModel)
            {
               this._panel.removeChild(DisplayPluginModel(param1).getDisplayObject());
            }
         return;
      }

      public function updateDisplayProperties(param1:DisplayProperties, param2:Boolean=false) : void {
         Assert.notNull(param1.name,"displayProperties.name cannot be null");
         var _loc3_:DisplayObject = DisplayProperties(this._plugins[param1.name]).getDisplayObject();
         if(_loc3_)
            {
               param1.setDisplayObject(_loc3_);
            }
         this._plugins[param1.name]=param1.clone();
         if(param2)
            {
               this._originalProps[param1.name]=param1.clone();
            }
         return;
      }

      public function update(param1:PluginModel) : void {
         this._plugins[param1.name]=param1.clone();
         return;
      }

      function updateDisplayPropertiesForDisplay(param1:DisplayObject, param2:Object) : void {
         var _loc3_:DisplayProperties = this.getPluginByDisplay(param1);
         if(_loc3_)
            {
               new PropertyBinder(_loc3_).copyProperties(param2);
               this.updateDisplayProperties(_loc3_);
            }
         return;
      }

      function onLoad(param1:FlowplayerBase) : void {
         this.log.debug("onLoad");
         this._flowPlayer=param1;
         this.setPlayerToPlugins(this._providers);
         this.setPlayerToPlugins(this._plugins);
         this.setPlayerToPlugins(this._genericPlugins);
         return;
      }

      private function setPlayerToPlugins(param1:Dictionary) : void {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc2_:Dictionary = new Dictionary();
         for (_loc3_ in param1)
            {
               _loc2_[_loc3_]=param1[_loc3_];
            }
         for each (_loc4_ in _loc2_)
            {
               this.setPlayerToPlugin(_loc4_);
            }
         return;
      }

      function setPlayerToPlugin(param1:Object) : void {
         var pluginObj:Object = null;
         var plugin:Object = param1;
         try
            {
               this.log.debug("setPlayerToPlugin "+plugin);
               if(plugin is DisplayProperties)
                  {
                     pluginObj=DisplayProperties(plugin).getDisplayObject();
                  }
               else
                  {
                     if(plugin is PluginModel)
                        {
                           pluginObj=PluginModel(plugin).pluginObject;
                        }
                  }
               if(pluginObj is NetStreamControllingStreamProvider)
                  {
                     this.log.debug("setting player to "+pluginObj);
                     NetStreamControllingStreamProvider(pluginObj).player=this._flowPlayer as Flowplayer;
                  }
               else
                  {
                     pluginObj["onLoad"](this._flowPlayer);
                  }
               this.log.debug("onLoad() successfully executed for plugin "+plugin);
            }
         catch(e:Error)
            {
               if(pluginObj is Plugin||pluginObj is StreamProvider)
                  {
                     throw e;
                  }
               log.warn("was not able to initialize player to plugin "+plugin+": "+e.message);
            }
         return;
      }

      function addPluginEventListener(param1:Function) : void {
         var _loc2_:Object = null;
         for each (_loc2_ in this._plugins)
            {
               if(_loc2_ is PluginModel)
                  {
                     PluginModel(_loc2_).onPluginEvent(param1);
                  }
            }
         return;
      }

      public function getUrlResolvers() : Array {
         var _loc2_:String = null;
         var _loc3_:PluginModel = null;
         var _loc4_:Object = null;
         var _loc1_:Array = [];
         for (_loc2_ in this._genericPlugins)
            {
               _loc3_=this._genericPlugins[_loc2_] as PluginModel;
               _loc4_=_loc3_.pluginObject;
               if(_loc4_ is ClipURLResolver&&!(_loc4_ is ConnectionProvider))
                  {
                     _loc1_.push(_loc2_);
                  }
            }
         _loc1_.sort();
         return _loc1_;
      }
   }

}