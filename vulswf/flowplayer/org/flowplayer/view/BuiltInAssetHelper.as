package org.flowplayer.view
{
   import flash.display.DisplayObject;


   public class BuiltInAssetHelper extends Object
   {
         

      public function BuiltInAssetHelper() {
         super();
         return;
      }

      private static var _config:BuiltInConfig = new BuiltInConfig();

      private static const PLAY:String = "PlayButton";

      private static const LOGO:String = "Logo";

      public static function get hasPlayButton() : Boolean {
         return _config.hasOwnProperty(PLAY);
      }

      public static function createPlayButton() : DisplayObject {
         return createAsset(PLAY);
      }

      public static function get hasLogo() : Boolean {
         return _config.hasOwnProperty(LOGO);
      }

      public static function createLogo() : DisplayObject {
         return createAsset(LOGO);
      }

      private static function createAsset(param1:String) : * {
         var _loc2_:Class = null;
         if(_config.hasOwnProperty(param1))
            {
               _loc2_=_config[param1] as Class;
               return new (_loc2_)();
            }
         return null;
      }


   }

}