package org.flowplayer.model
{
   import org.flowplayer.util.URLUtil;
   import flash.display.DisplayObject;


   public class Logo extends DisplayPluginModelImpl
   {
         

      public function Logo(param1:DisplayObject, param2:String) {
         super(param1,param2,false);
         var param2:* = "logo";
         top="20";
         right="20";
         alpha=1;
         this._linkWindow="_self";
         return;
      }



      private var _fullscreenOnly:Boolean = true;

      private var _fadeSpeed:Number;

      private var _displayTime:int = 0;

      private var _linkUrl:String;

      private var _linkWindow:String;

      override  public function clone() : Cloneable {
         var _loc1_:Logo = new Logo(getDisplayObject(),name);
         copyFields(this,_loc1_);
         _loc1_.url=url;
         _loc1_.fullscreenOnly=this._fullscreenOnly;
         _loc1_.fadeSpeed=this._fadeSpeed;
         _loc1_.displayTime=this._displayTime;
         _loc1_.linkUrl=this._linkUrl;
         _loc1_.linkWindow=this._linkWindow;
         return _loc1_;
      }

      public function get fullscreenOnly() : Boolean {
         return this._fullscreenOnly;
      }

      public function set fullscreenOnly(param1:Boolean) : void {
         this._fullscreenOnly=param1;
         return;
      }

      public function get fadeSpeed() : Number {
         return this._fadeSpeed;
      }

      public function set fadeSpeed(param1:Number) : void {
         this._fadeSpeed=param1;
         return;
      }

      public function get displayTime() : int {
         return this._displayTime;
      }

      public function set displayTime(param1:int) : void {
         this._displayTime=param1;
         return;
      }

      public function get linkUrl() : String {
         return this._linkUrl;
      }

      public function set linkUrl(param1:String) : void {
         if(URLUtil.isValid(param1))
            {
               this._linkUrl=param1;
            }
         return;
      }

      public function get linkWindow() : String {
         return this._linkWindow;
      }

      public function set linkWindow(param1:String) : void {
         this._linkWindow=param1;
         return;
      }
   }

}