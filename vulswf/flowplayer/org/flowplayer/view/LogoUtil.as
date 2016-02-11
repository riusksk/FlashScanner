package org.flowplayer.view
{
   import flash.text.TextField;
   import org.flowplayer.util.TextUtil;


   class LogoUtil extends Object
   {
         

      function LogoUtil() {
         super();
         return;
      }

      public static function createCopyrightNotice(param1:int) : TextField {
         var _loc2_:TextField = TextUtil.createTextField(false,null,param1,false);
         _loc2_.text="? 2008-2011 Flowplayer Ltd";
         _loc2_.textColor=8947848;
         _loc2_.height=15;
         return _loc2_;
      }


   }

}