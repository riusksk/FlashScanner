package org.flowplayer.model
{


   public class ErrorCode extends Object
   {
         

      public function ErrorCode(param1:EventType, param2:int, param3:String) {
         super();
         this._eventType=param1;
         this._code=param2;
         this._message=param3;
         return;
      }



      private var _eventType:EventType;

      private var _code:int;

      private var _message:String;

      public function get eventType() : EventType {
         return this._eventType;
      }

      public function get message() : String {
         return this._message;
      }

      public function get code() : int {
         return this._code;
      }
   }

}