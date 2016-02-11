package org.flowplayer.util
{
   import com.adobe.utils.StringUtil;


   public class StyleSheetUtil extends Object
   {
         

      public function StyleSheetUtil() {
         super();
         return;
      }

      public static function colorValue(param1:Object, param2:Number=16777215) : Number {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:* = 0;
         var _loc6_:Array = null;
         if(!param1)
            {
               return param2;
            }
         if(param1 is Number)
            {
               return param1 as Number;
            }
         if(param1 is String)
            {
               _loc3_=StringUtil.trim(param1 as String);
               if(_loc3_.indexOf("#")==0)
                  {
                     return parseInt("0x"+_loc3_.substr(1));
                  }
               if(_loc3_.indexOf("0x")==0)
                  {
                     return parseInt(_loc3_);
                  }
               if(_loc3_=="transparent")
                  {
                     return -1;
                  }
               if(param1.indexOf("rgb")==0)
                  {
                     _loc4_=stripSpaces(param1 as String);
                     _loc5_=_loc4_.indexOf("(")+1;
                     _loc4_=_loc4_.substr(_loc5_,_loc4_.indexOf(")")-_loc5_);
                     _loc6_=_loc4_.split(",");
                     return _loc6_[0]<<16^_loc6_[1]<<8^_loc6_[2];
                  }
            }
         return param2;
      }

      public static function rgbValue(param1:Number) : Array {
         return [param1>>16&255,param1>>8&255,param1&255];
      }

      public static function colorAlpha(param1:Object, param2:Number=1) : Number {
         var _loc3_:Array = null;
         if(!param1)
            {
               return param2;
            }
         if(param1 is String&&param1.indexOf("rgb")==0)
            {
               _loc3_=parseRGBAValues(param1 as String);
               if(_loc3_.length==4)
                  {
                     return _loc3_[3];
                  }
            }
         if(param1 is String&&param1=="transparent")
            {
               return 0;
            }
         return param2;
      }

      public static function parseRGBAValues(param1:String) : Array {
         var _loc2_:String = stripSpaces(param1);
         var _loc3_:int = _loc2_.indexOf("(")+1;
         _loc2_=_loc2_.substr(_loc3_,_loc2_.indexOf(")")-_loc3_);
         return _loc2_.split(",");
      }

      public static function stripSpaces(param1:String) : String {
         var _loc2_:* = "";
         var _loc3_:* = 0;
         while(_loc3_<param1.length)
            {
               if(param1.charAt(_loc3_)!=" ")
                  {
                     _loc2_=_loc2_+param1.charAt(_loc3_);
                  }
               _loc3_++;
            }
         return _loc2_;
      }

      public static function borderWidth(param1:String, param2:Object, param3:Number=1) : Number {
         if(!hasProperty(param1,param2))
            {
               return param3;
            }
         if(hasProperty(param1+"Width",param2))
            {
               return NumberUtil.decodePixels(param2[param1+"Width"]);
            }
         return NumberUtil.decodePixels(parseShorthand(param1,param2)[0]);
      }

      public static function borderColor(param1:String, param2:Object, param3:Number=16777215) : uint {
         if(hasProperty(param1+"Color",param2))
            {
               return colorValue(param2[param1+"Color"]);
            }
         if(hasProperty(param1,param2))
            {
               return StyleSheetUtil.colorValue(parseShorthand(param1,param2)[2]);
            }
         return param3;
      }

      public static function borderAlpha(param1:String, param2:Object, param3:Number=1) : Number {
         if(hasProperty(param1+"Color",param2))
            {
               return colorAlpha(param2[param1+"Color"]);
            }
         if(hasProperty(param1,param2))
            {
               return StyleSheetUtil.colorAlpha(parseShorthand(param1,param2)[2]);
            }
         return param3;
      }

      public static function parseShorthand(param1:String, param2:Object) : Array {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc3_:String = param2[param1];
         if(_loc3_.indexOf("(")!=-1)
            {
               _loc4_=_loc3_.substr(0,_loc3_.indexOf("(")+1);
               _loc5_=_loc3_.substr(_loc3_.indexOf("(")+1,_loc3_.indexOf(")")-_loc3_.indexOf("(")-1);
               _loc6_=_loc3_.substr(_loc3_.indexOf(")"));
               _loc5_=_loc5_.split(" ").join("");
               _loc3_=_loc4_+_loc5_+_loc6_;
            }
         return _loc3_.split(" ");
      }

      public static function hasProperty(param1:String, param2:Object) : Boolean {
         return (param2)&&!(param2[param1]==undefined);
      }


   }

}