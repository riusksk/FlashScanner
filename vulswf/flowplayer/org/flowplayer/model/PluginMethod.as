package org.flowplayer.model
{


   public class PluginMethod extends Object
   {
         

      public function PluginMethod(param1:String, param2:String, param3:Boolean=false, param4:Boolean=false, param5:Boolean=false, param6:Boolean=false) {
         super();
         this._externalName=param1;
         this._internalName=param2;
         if((this._isGetter)&&(param4))
            {
               throw new Error("PluginMethod cannot be a setter and a getter at the same time");
            }
         this._isGetter=param3;
         this._isSetter=param4;
         this._hasReturnValue=param5;
         this._convertResult=param6;
         return;
      }

      public static function method(param1:String, param2:String, param3:Boolean, param4:Boolean) : PluginMethod {
         return new (PluginMethod)(param1,param2,false,false,param3,param4);
      }

      public static function setter(param1:String, param2:String) : PluginMethod {
         return new (PluginMethod)(param1,param2,false,true);
      }

      public static function getter(param1:String, param2:String, param3:Boolean) : PluginMethod {
         return new (PluginMethod)(param1,param2,true,false,true,param3);
      }

      private var _externalName:String;

      private var _internalName:String;

      private var _isGetter:Boolean;

      private var _isSetter:Boolean;

      private var _hasReturnValue:Boolean;

      private var _convertResult:Boolean;

      public function get externalName() : String {
         return this._externalName;
      }

      public function get internalName() : String {
         return this._internalName;
      }

      public function get isGetter() : Boolean {
         return this._isGetter;
      }

      public function get isSetter() : Boolean {
         return this._isSetter;
      }

      public function get hasReturnValue() : Boolean {
         return this._hasReturnValue;
      }

      public function set hasReturnValue(param1:Boolean) : void {
         this._hasReturnValue=param1;
         return;
      }

      public function get convertResult() : Boolean {
         return this._convertResult;
      }
   }

}