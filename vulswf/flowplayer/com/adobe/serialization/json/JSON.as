package com.adobe.serialization.json
{


   public class JSON extends Object
   {
         

      public function JSON() {
         super();
         return;
      }

      public static function encode(param1:Object) : String {
         var _loc2_:JSONEncoder = new JSONEncoder(param1);
         return _loc2_.getString();
      }

      public static function decode(param1:String) : * {
         var _loc2_:JSONDecoder = new JSONDecoder(param1);
         return _loc2_.getValue();
      }


   }

}