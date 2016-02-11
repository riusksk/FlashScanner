package org.flowplayer.model
{
   import org.flowplayer.util.Log;


   public class Cuepoint extends Object implements Cloneable
   {
         

      public function Cuepoint(param1:int, param2:String) {
         this.log=new Log(this);
         this._parameters=new Object();
         super();
         this._time=param1;
         this._callbackId=param2;
         return;
      }

      public static function createDynamic(param1:int, param2:String) : Cuepoint {
         return new DynamicCuepoint(param1,param2);
      }

      protected var log:Log;

      private var _time:int;

      private var _callbackId:String;

      private var _lastFireTime:int = -1;

      private var _name:String;

      private var _parameters:Object;

      public function get name() : String {
         return this._name;
      }

      public function set name(param1:String) : void {
         this._name=param1;
         return;
      }

      public function get time() : int {
         return this._time;
      }

      public function set time(param1:int) : void {
         this._time=param1;
         return;
      }

      public function toString() : String {
         return "[Cuepoint] time "+this._time;
      }

      public function get callbackId() : String {
         return this._callbackId;
      }

      public final function clone() : Cloneable {
         var _loc1_:Cuepoint = new Cuepoint(this._time,this.callbackId);
         this.onClone(_loc1_);
         return _loc1_;
      }

      protected function onClone(param1:Cuepoint) : void {
         return;
      }

      public function get lastFireTime() : int {
         return this._lastFireTime;
      }

      public function set lastFireTime(param1:int) : void {
         this._lastFireTime=param1;
         return;
      }

      public function addParameter(param1:String, param2:Object) : void {
         this._parameters[param1]=param2;
         return;
      }

      public function get parameters() : Object {
         return this._parameters;
      }

      public function set parameters(param1:Object) : void {
         this._parameters=param1;
         return;
      }
   }

}