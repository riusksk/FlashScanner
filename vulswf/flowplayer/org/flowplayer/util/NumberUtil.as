package org.flowplayer.util
{


   public class NumberUtil extends Object
   {
         

      public function NumberUtil() {
         super();
         return;
      }

      public static function decodeNonNumbers(param1:Number, param2:Number=0) : Number {
         if(isNaN(param1))
            {
               return param2;
            }
         return param1;
      }

      public static function decodePercentage(param1:String) : Number {
         var _loc2_:Number = evaluate("pct",param1);
         if(!isNaN(_loc2_))
            {
               return _loc2_;
            }
         return evaluate("%",param1);
      }

      public static function decodePixels(param1:String) : Number {
         if(param1.indexOf("px")<0)
            {
               param1=param1+"px";
            }
         var _loc2_:Number = evaluate("px",param1);
         if(!isNaN(_loc2_))
            {
               return _loc2_;
            }
         _loc2_=decodePercentage(param1);
         if(!isNaN(_loc2_))
            {
               return NaN;
            }
         return param1.substr(0) as Number;
      }

      private static function evaluate(param1:String, param2:String) : Number {
         if(param2.indexOf(param1)<=0)
            {
               return NaN;
            }
         return Number(param2.substring(0,param2.indexOf(param1)));
      }


   }

}