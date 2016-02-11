package org.flowplayer.model
{


   public class PluginModelImpl extends PluginEventDispatcher implements PluginModel
   {
         

      public function PluginModelImpl(param1:Object, param2:String) {
         this._methods=new Array();
         super();
         this._pluginObject=param1;
         this._name=param2;
         return;
      }



      private var _methods:Array;

      private var _pluginObject:Object;

      private var _name:String;

      private var _config:Object;

      private var _builtIn:Boolean;

      private var _url:String;

      public function clone() : Cloneable {
         var _loc1_:PluginModelImpl = new PluginModelImpl(this._pluginObject,this.name);
         _loc1_.config=this.config;
         _loc1_.methods=this._methods;
         return _loc1_;
      }

      public function get pluginObject() : Object {
         return this._pluginObject;
      }

      public function set pluginObject(param1:Object) : void {
         this._pluginObject=param1;
         return;
      }

      override  public function get name() : String {
         return this._name;
      }

      public function set name(param1:String) : void {
         this._name=param1;
         return;
      }

      public function get config() : Object {
         return this._config;
      }

      public function set config(param1:Object) : void {
         this._config=param1;
         return;
      }

      public function addMethod(param1:PluginMethod) : void {
         this._methods.push(param1);
         return;
      }

      public function getMethod(param1:String) : PluginMethod {
         return PluginMethodHelper.getMethod(this._methods,param1);
      }

      public function invokeMethod(param1:String, param2:Array=null) : Object {
         return PluginMethodHelper.invokePlugin(this,this._pluginObject,param1,param2);
      }

      public function get methodNames() : Array {
         return PluginMethodHelper.methodNames(this._methods);
      }

      public function set methods(param1:Array) : void {
         this._methods=param1;
         return;
      }

      public function toString() : String {
         return "[PluginModelImpl] \'"+this.name+"\'";
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