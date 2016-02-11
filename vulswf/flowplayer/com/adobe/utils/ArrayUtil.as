package com.adobe.utils
{


   public class ArrayUtil extends Object
   {
         

      public function ArrayUtil() {
         super();
         return;
      }

      public static function arrayContainsValue(param1:Array, param2:Object) : Boolean {
         return !(param1.indexOf(param2)==-1);
      }

      public static function removeValueFromArray(param1:Array, param2:Object) : void {
         var _loc3_:uint = param1.length;
         var _loc4_:Number = _loc3_;
         while(_loc4_>-1)
            {
               if(param1[_loc4_]===param2)
                  {
                     param1.splice(_loc4_,1);
                  }
               _loc4_--;
            }
         return;
      }

      public static function createUniqueCopy(param1:Array) : Array {
         var _loc4_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:Number = param1.length;
         var _loc5_:uint = 0;
         while(_loc5_<_loc3_)
            {
               _loc4_=param1[_loc5_];
               if(ArrayUtil.arrayContainsValue(_loc2_,_loc4_))
                  {
                  }
               else
                  {
                     _loc2_.push(_loc4_);
                  }
               _loc5_++;
            }
         return _loc2_;
      }

      public static function copyArray(param1:Array) : Array {
         return param1.slice();
      }

      public static function arraysAreEqual(param1:Array, param2:Array) : Boolean {
         if(param1.length!=param2.length)
            {
               return false;
            }
         var _loc3_:Number = param1.length;
         var _loc4_:Number = 0;
         while(_loc4_<_loc3_)
            {
               if(param1[_loc4_]!==param2[_loc4_])
                  {
                     return false;
                  }
               _loc4_++;
            }
         return true;
      }


   }

}