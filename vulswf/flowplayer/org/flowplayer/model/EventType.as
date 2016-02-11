package org.flowplayer.model
{


   public class EventType extends Object
   {
         

      public function EventType(param1:String, param2:Boolean=false) {
         super();
         this._name=param1;
         this._custom=param2;
         return;
      }



      private var _name:String;

      private var _custom:Boolean;

      public function get isCancellable() : Boolean {
         throw new Error("isCancellable() not overridden");
      }

      public function get name() : String {
         return this._name;
      }

      public function get custom() : Boolean {
         return this._custom;
      }
   }

}