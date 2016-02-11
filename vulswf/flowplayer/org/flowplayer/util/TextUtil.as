package org.flowplayer.util
{
   import flash.text.TextField;
   import flash.display.BlendMode;
   import flash.text.TextFormat;
   import flash.text.AntiAliasType;
   import flash.system.Capabilities;
   import flash.text.Font;


   public class TextUtil extends Object
   {
         

      public function TextUtil() {
         super();
         return;
      }

      private static var log:Log = new Log("org.flowplayer.util::TextUtil");

      public static function createTextField(param1:Boolean, param2:String=null, param3:int=12, param4:Boolean=false) : TextField {
         var _loc5_:TextField = new TextField();
         _loc5_.blendMode=BlendMode.LAYER;
         _loc5_.embedFonts=param1;
         var _loc6_:TextFormat = new TextFormat();
         if(param2)
            {
               log.debug("Creating text field with font: "+param2);
               _loc6_.font=param2;
               _loc5_.antiAliasType=AntiAliasType.ADVANCED;
            }
         else
            {
               if(Capabilities.os.indexOf("Windows")==0)
                  {
                     _loc6_.font=getFont(["Lucida Grande","Lucida Sans Unicode","Bitstream Vera","Verdana","Arial","_sans","_serif"]);
                     _loc6_.font="_sans";
                  }
               else
                  {
                     _loc6_.font="Lucida Grande, Lucida Sans Unicode, Bitstream Vera, Verdana, Arial, _sans, _serif";
                     _loc5_.antiAliasType=AntiAliasType.ADVANCED;
                  }
            }
         _loc6_.size=param3;
         _loc6_.bold=param4;
         _loc6_.color=16777215;
         _loc5_.defaultTextFormat=_loc6_;
         return _loc5_;
      }

      private static function getFont(param1:Array) : String {
         var _loc4_:* = NaN;
         var _loc2_:Array = Font.enumerateFonts(true);
         var _loc3_:Number = 0;
         while(_loc3_<param1.length)
            {
               _loc4_=0;
               while(_loc4_<_loc2_.length)
                  {
                     if(param1[_loc3_]==Font(_loc2_[_loc4_]).fontName)
                        {
                           return param1[_loc3_];
                        }
                     _loc4_++;
                  }
               _loc3_++;
            }
         return null;
      }


   }

}