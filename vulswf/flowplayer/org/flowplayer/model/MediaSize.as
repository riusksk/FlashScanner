package org.flowplayer.model
{
   import flash.utils.Dictionary;


   public class MediaSize extends Object
   {
         

      public function MediaSize(param1:String) {
         super();
         if(enumCreated)
            {
               throw new Error("Cannot create ad-hoc MediaSize instances");
            }
         this._value=param1;
         return;
      }

      public static const FITTED_PRESERVING_ASPECT_RATIO:MediaSize = new (MediaSize)("fit");

      public static const HALF_FROM_ORIGINAL:MediaSize = new (MediaSize)("half");

      public static const ORIGINAL:MediaSize = new (MediaSize)("orig");

      public static const FILLED_TO_AVAILABLE_SPACE:MediaSize = new (MediaSize)("scale");

      public static const CROP_TO_AVAILABLE_SPACE:MediaSize = new (MediaSize)("crop");

      public static var ALL_VALUES:Dictionary = new Dictionary();

      private static var enumCreated:Boolean = true;

      public static function forName(param1:String) : MediaSize {
         return ALL_VALUES[param1];
      }

      private var _value:String;

      public function toString() : String {
         return "[MediaSize] \'"+this._value+"\'";
      }

      public function get value() : String {
         return this._value;
      }
   }

}