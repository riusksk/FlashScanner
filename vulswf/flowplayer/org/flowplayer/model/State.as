package org.flowplayer.model
{


   public class State extends Object
   {
         

      public function State(param1:Number, param2:String) {
         super();
         if(enumCreated)
            {
               throw new Error("Cannot create ad-hoc State instances");
            }
         this._code=param1;
         this._name=param2;
         return;
      }

      public static const WAITING:State = new (State)(1,"Waiting");

      public static const BUFFERING:State = new (State)(2,"Buffering");

      public static const PLAYING:State = new (State)(3,"Playing");

      public static const PAUSED:State = new (State)(4,"Paused");

      public static const ENDED:State = new (State)(5,"Ended");

      private static var enumCreated:Boolean = true;

      private var _name:String;

      private var _code:Number;

      public function toString() : String {
         return "State: "+this._code+", \'"+this._name+"\'";
      }

      public function get code() : Number {
         return this._code;
      }
   }

}