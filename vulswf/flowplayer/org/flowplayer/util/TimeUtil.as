package org.flowplayer.util
{


   public class TimeUtil extends Object
   {
         

      public function TimeUtil() {
         super();
         return;
      }

      public static function formatSeconds(param1:Number) : String {
         if(isNaN(param1))
            {
               return "00:00";
            }
         var _loc2_:int = Math.round(param1 as Number);
         var _loc3_:* = "";
         var _loc4_:Number = Math.floor(_loc2_/60);
         var _loc5_:int = int(_loc2_)%60;
         _loc3_=two(_loc5_);
         var _loc6_:Number = Math.floor(_loc4_/60);
         _loc4_=_loc4_%60;
         _loc3_=two(_loc4_)+":"+_loc3_;
         if(_loc6_==0)
            {
               return _loc3_;
            }
         var _loc7_:Number = Math.floor(_loc6_/60);
         _loc6_=_loc6_%60;
         _loc3_=two(_loc6_)+":"+_loc3_;
         if(_loc7_==0)
            {
               return _loc3_;
            }
         _loc3_=_loc7_+":"+_loc3_;
         return _loc3_;
      }

      private static function two(param1:Number) : String {
         return (param1>9?"":"0")+param1;
      }

      public static function seconds(param1:String, param2:Number=1000) : Number {
         return Math.round(toSeconds(param1)*param2/100)*100;
      }

      private static function toSeconds(param1:String) : Number {
         var param1:String = param1.replace(",",".");
         var _loc2_:Array = param1.split(":");
         var _loc3_:Number = 0;
         if(param1.substr(-1)=="s")
            {
               return Number(param1.substr(0,param1.length-1));
            }
         if(param1.substr(-1)=="m")
            {
               return Number(param1.substr(0,param1.length-1))*60;
            }
         if(param1.substr(-1)=="h")
            {
               return Number(param1.substr(0,param1.length-1))*3600;
            }
         if(_loc2_.length>1)
            {
               _loc3_=Number(_loc2_[_loc2_.length-1]);
               _loc3_=_loc3_+Number(_loc2_[_loc2_.length-2])*60;
               if(_loc2_.length==3)
                  {
                     _loc3_=_loc3_+Number(_loc2_[_loc2_.length-3])*3600;
                  }
               return _loc3_;
            }
         return Number(param1);
      }


   }

}