package com.adobe.utils
{


   public class StringUtil extends Object
   {
         

      public function StringUtil() {
         super();
         return;
      }

      public static function stringsAreEqual(param1:String, param2:String, param3:Boolean) : Boolean {
         if(param3)
            {
               return param1==param2;
            }
         return param1.toUpperCase()==param2.toUpperCase();
      }

      public static function trim(param1:String) : String {
         return StringUtil.ltrim(StringUtil.rtrim(param1));
      }

      public static function ltrim(param1:String) : String {
         var _loc2_:Number = param1.length;
         var _loc3_:Number = 0;
         while(_loc3_<_loc2_)
            {
               if(param1.charCodeAt(_loc3_)>32)
                  {
                     return param1.substring(_loc3_);
                  }
               _loc3_++;
            }
         return "";
      }

      public static function rtrim(param1:String) : String {
         var _loc2_:Number = param1.length;
         var _loc3_:Number = _loc2_;
         while(_loc3_>0)
            {
               if(param1.charCodeAt(_loc3_-1)>32)
                  {
                     return param1.substring(0,_loc3_);
                  }
               _loc3_--;
            }
         return "";
      }

      public static function beginsWith(param1:String, param2:String) : Boolean {
         return param2==param1.substring(0,param2.length);
      }

      public static function endsWith(param1:String, param2:String) : Boolean {
         return param2==param1.substring(param1.length-param2.length);
      }

      public static function remove(param1:String, param2:String) : String {
         return StringUtil.replace(param1,param2,"");
      }

      public static function replace(param1:String, param2:String, param3:String) : String {
         var _loc9_:* = NaN;
         var _loc4_:String = new String();
         var _loc5_:* = false;
         var _loc6_:Number = param1.length;
         var _loc7_:Number = param2.length;
         var _loc8_:Number = 0;
         for(;_loc8_<_loc6_;_loc8_++)
            {
               if(param1.charAt(_loc8_)==param2.charAt(0))
                  {
                     _loc5_=true;
                     _loc9_=0;
                     while(_loc9_<_loc7_)
                        {
                           if(param1.charAt(_loc8_+_loc9_)!=param2.charAt(_loc9_))
                              {
                                 _loc5_=false;
                                 break;
                              }
                           _loc9_++;
                        }
                     if(_loc5_)
                        {
                           _loc4_=_loc4_+param3;
                           _loc8_=_loc8_+(_loc7_-1);
                           continue;
                        }
                  }
               else
                  {
                     _loc4_=_loc4_+param1.charAt(_loc8_);
                  }
            }
         return _loc4_;
      }

      public static function stringHasValue(param1:String) : Boolean {
         return !(param1==null)&&param1.length<0;
      }


   }

}