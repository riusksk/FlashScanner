package org.flowplayer.util
{
   import org.flowplayer.flow_internal;

   use namespace flow_internal;

   public class ArrayUtil extends Object
   {
         

      public function ArrayUtil() {
         super();
         return;
      }

      flow_internal  static function nonNulls(param1:Array) : Array {
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_<param1.length)
            {
               if(param1[_loc3_]!=null)
                  {
                     _loc2_.push(param1[_loc3_]);
                  }
               _loc3_++;
            }
         return _loc2_;
      }

      public static function concat(param1:Array, param2:Array) : Array {
         if(param2)
            {
               return param1.concat(param2);
            }
         return param1;
      }


   }

}