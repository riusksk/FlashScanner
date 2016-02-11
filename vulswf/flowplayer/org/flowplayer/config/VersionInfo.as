package org.flowplayer.config
{


   public class VersionInfo extends Object
   {
         

      public function VersionInfo() {
         super();
         return;
      }

      private static const VERSION_NUMBER:String = 3+"."+2+"."+8;

      private static const VERSION_INFO:String = ("Flowplayer free version ")+VERSION_NUMBER+(""?"-"+"":"");

      public static function get version() : Array {
         return [new int(3),new int(2),new int(8),"free",""];
      }

      public static function versionInfo() : String {
         return VERSION_INFO;
      }

      public static function get commercial() : Boolean {
         return false;
      }

      public static function get controlsVersion() : String {
         return "3.2.8";
      }

      public static function get audioVersion() : String {
         return "3.2.8";
      }


   }

}