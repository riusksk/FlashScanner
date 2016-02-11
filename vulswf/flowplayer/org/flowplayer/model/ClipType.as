package org.flowplayer.model
{
   import org.flowplayer.util.URLUtil;


   public class ClipType extends Object
   {
         

      public function ClipType(param1:String) {
         super();
         if(enumCreated)
            {
               throw new Error("Cannot create ad-hoc ClipType instances");
            }
         this._type=param1;
         return;
      }

      private static const FLASH_VIDEO_EXTENSIONS:Array = ["f4b","f4p","f4v","flv"];

      private static const VIDEOAPI_PREFIX:String = "api:";

      private static const VIDEO_EXTENSIONS:Array = ["3g2","3gp","aac","m4a","m4v","mov","mp4","vp6","mpeg4","video"];

      private static const IMAGE_EXTENSIONS:Array = ["png","jpg","jpeg","gif","swf","image"];

      public static const VIDEO:ClipType = new (ClipType)("video");

      public static const AUDIO:ClipType = new (ClipType)("audio");

      public static const IMAGE:ClipType = new (ClipType)("image");

      public static const API:ClipType = new (ClipType)("api:");

      private static var MIME_TYPE_MAPPING:Object = {application/x-fcs:VIDEO,
application/x-shockwave-flash:IMAGE,
audio/aac:VIDEO,
audio/m4a:VIDEO,
audio/mp4:VIDEO,
audio/mp3:AUDIO,
audio/mpeg:AUDIO,
audio/x-3gpp:VIDEO,
audio/x-m4a:VIDEO,
image/gif:IMAGE,
image/jpeg:IMAGE,
image/jpg:IMAGE,
image/png:IMAGE,
video/flv:VIDEO,
video/3gpp:VIDEO,
video/h264:VIDEO,
video/mp4:VIDEO,
video/x-3gpp:VIDEO,
video/x-flv:VIDEO,
video/x-m4v:VIDEO,
video/x-mp4:VIDEO};

      private static var enumCreated:Boolean = true;

      public static function fromMimeType(param1:String) : ClipType {
         return MIME_TYPE_MAPPING[param1];
      }

      public static function getExtension(param1:String) : String {
         if(!param1)
            {
               return null;
            }
         var _loc2_:String = knownEndingExtension(param1);
         if(_loc2_)
            {
               return _loc2_;
            }
         var _loc3_:Array = URLUtil.baseUrlAndRest(param1);
         var _loc4_:String = _loc3_[1];
         var _loc5_:int = _loc4_.indexOf("?");
         if(_loc5_>0)
            {
               _loc4_=_loc4_.substr(0,_loc5_);
            }
         var _loc6_:Number = _loc4_.lastIndexOf(".");
         var _loc7_:String = _loc4_.toLowerCase();
         return _loc7_.substring(_loc6_+1,_loc7_.length);
      }

      private static function knownEndingExtension(param1:String) : String {
         var _loc4_:String = null;
         var _loc2_:Array = VIDEO_EXTENSIONS.concat(IMAGE_EXTENSIONS).concat(FLASH_VIDEO_EXTENSIONS);
         _loc2_.push("mp3");
         var _loc3_:* = 0;
         while(_loc3_<_loc2_.length)
            {
               _loc4_="."+_loc2_[_loc3_];
               if(param1.lastIndexOf(_loc4_)>=0&&param1.lastIndexOf(_loc4_)==param1.length-_loc4_.length)
                  {
                     return _loc2_[_loc3_];
                  }
               _loc3_++;
            }
         return null;
      }

      public static function fromFileExtension(param1:String) : ClipType {
         return resolveType(getExtension(param1));
      }

      public static function resolveType(param1:String) : ClipType {
         if(param1==ClipType.VIDEO.type)
            {
               return ClipType.VIDEO;
            }
         if(param1==ClipType.AUDIO.type)
            {
               return ClipType.AUDIO;
            }
         if(param1==ClipType.IMAGE.type)
            {
               return ClipType.IMAGE;
            }
         if(param1==ClipType.API.type)
            {
               return ClipType.API;
            }
         if(VIDEO_EXTENSIONS.concat(FLASH_VIDEO_EXTENSIONS).indexOf(param1)>=0)
            {
               return ClipType.VIDEO;
            }
         if(param1.indexOf(VIDEOAPI_PREFIX)>=0)
            {
               return ClipType.API;
            }
         if(IMAGE_EXTENSIONS.indexOf(param1)>=0)
            {
               return ClipType.IMAGE;
            }
         if(param1=="mp3")
            {
               return ClipType.AUDIO;
            }
         return ClipType.VIDEO;
      }

      public static function isFlashVideo(param1:String) : Boolean {
         if(!param1)
            {
               return true;
            }
         return FLASH_VIDEO_EXTENSIONS.indexOf(getExtension(param1))>=0;
      }

      private var _type:String;

      public function get type() : String {
         return this._type;
      }

      public function toString() : String {
         return "ClipType: \'"+this._type+"\'";
      }
   }

}