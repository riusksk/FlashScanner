package org.flowplayer.util
{
   import flash.system.Capabilities;


   public class VersionUtil extends Object
   {
         

      public function VersionUtil() {
         super();
         return;
      }

      public static function majorVersion() : Number {
         return getVersion().majorVersion;
      }

      public static function minorVersion() : Number {
         return getVersion().minorVersion;
      }

      public static function platform() : String {
         return getVersion().platform;
      }

      public static function buildNumber() : Number {
         return getVersion().buildNumber;
      }

      public static function getVersion() : Object {
         var _loc1_:String = Capabilities.version;
         var _loc2_:Array = _loc1_.split(",");
         var _loc3_:Object = {};
         var _loc4_:Array = _loc2_[0].split(" ");
         _loc3_.platform=_loc4_[0];
         _loc3_.majorVersion=parseInt(_loc4_[1]);
         _loc3_.minorVersion=parseInt(_loc2_[1]);
         _loc3_.buildNumber=parseInt(_loc2_[2]);
         return _loc3_;
      }

      public static function isFlash10() : Boolean {
         return VersionUtil.majorVersion()==10;
      }

      public static function isFlash9() : Boolean {
         return VersionUtil.majorVersion()==9;
      }

      public static function hasStageVideo() : Boolean {
         return VersionUtil.majorVersion()==10&&VersionUtil.minorVersion()>=2||VersionUtil.majorVersion()<10;
      }


   }

}