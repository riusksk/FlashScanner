package org.flowplayer.model
{


   public class Canvas extends Object
   {
         

      public function Canvas() {
         super();
         return;
      }



      private var _style:Object;

      private var _linkUrl:String;

      private var _linkWindow:String = "_self";

      public function get linkUrl() : String {
         return this._linkUrl;
      }

      public function set linkUrl(param1:String) : void {
         this._linkUrl=param1;
         return;
      }

      public function get linkWindow() : String {
         return this._linkWindow;
      }

      public function set linkWindow(param1:String) : void {
         this._linkWindow=param1;
         return;
      }

      public function get style() : Object {
         return this._style;
      }

      public function set style(param1:Object) : void {
         this._style=param1;
         return;
      }
   }

}