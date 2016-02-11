package org.flowplayer.model
{
   import flash.display.DisplayObject;


   public class DisplayPluginModelImpl extends DisplayPropertiesImpl implements DisplayPluginModel
   {
         

      public function DisplayPluginModelImpl(param1:DisplayObject, param2:String, param3:Boolean=true) {
         this._methods=new Array();
         super(param1,param2,param3);
         return;
      }



      private var _config:Object;

      private var _methods:Array;

      private var _builtIn:Boolean;

      private var _url:String;

      public function addMethod(param1:PluginMethod) : void {
         this._methods.push(param1);
         return;
      }

      public function getMethod(param1:String) : PluginMethod {
         return PluginMethodHelper.getMethod(this._methods,param1);
      }

      public function invokeMethod(param1:String, param2:Array=null) : Object {
         return PluginMethodHelper.invokePlugin(this,getDisplayObject(),param1,param2);
      }

      public function get config() : Object {
         return this._config;
      }

      public function set config(param1:Object) : void {
         this._config=param1;
         return;
      }

      public function set visible(param1:Boolean) : void {
         super.display=param1?"block":"none";
         return;
      }

      override  protected function copyFields(param1:DisplayProperties, param2:DisplayPropertiesImpl) : void {
         super.copyFields(param1,param2);
         DisplayPluginModelImpl(param2).config=DisplayPluginModelImpl(param1).config;
         DisplayPluginModelImpl(param2).methods=DisplayPluginModelImpl(param1).methods;
         DisplayPluginModelImpl(param2).isBuiltIn=DisplayPluginModelImpl(param1).isBuiltIn;
         return;
      }

      override  public function clone() : Cloneable {
         var _loc1_:DisplayPluginModelImpl = new DisplayPluginModelImpl(getDisplayObject(),name);
         this.copyFields(this,_loc1_);
         return _loc1_;
      }

      public function get methods() : Array {
         return this._methods;
      }

      public function set methods(param1:Array) : void {
         this._methods=param1;
         return;
      }

      public function get methodNames() : Array {
         return PluginMethodHelper.methodNames(this._methods);
      }

      public function get pluginObject() : Object {
         return getDisplayObject();
      }

      public function set pluginObject(param1:Object) : void {
         setDisplayObject(param1 as DisplayObject);
         return;
      }

      public function get isBuiltIn() : Boolean {
         return this._builtIn;
      }

      public function set isBuiltIn(param1:Boolean) : void {
         this._builtIn=param1;
         return;
      }

      public function get url() : String {
         return this._url;
      }

      public function set url(param1:String) : void {
         this._url=param1;
         return;
      }
   }

}