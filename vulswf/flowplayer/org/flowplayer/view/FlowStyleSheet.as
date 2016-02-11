package org.flowplayer.view
{
   import org.flowplayer.util.Log;
   import flash.text.StyleSheet;
   import org.flowplayer.util.StyleSheetUtil;
   import org.flowplayer.util.NumberUtil;
   import org.flowplayer.layout.Length;


   public class FlowStyleSheet extends Object
   {
         

      public function FlowStyleSheet(param1:String, param2:String=null) {
         this.log=new Log(this);
         super();
         this._styleName=param1;
         this._styleSheet=new StyleSheet();
         if(param2)
            {
               this.parseCSS(param2);
            }
         return;
      }

      static const ROOT_STYLE_PROPS:Array = ["padding","backgroundColor","backgroundGradient","border","borderColor","borderRadius","borderWidth","backgroundImage","backgroundRepeat","background","linkUrl","linkWindow","textDecoration"];

      public static function isRootStyleProperty(param1:String) : Boolean {
         return ROOT_STYLE_PROPS.indexOf(param1)>=0;
      }

      public static function decodeGradient(param1:String) : Array {
         if(param1=="none")
            {
               return null;
            }
         if(param1=="high")
            {
               return [1,0.5,0,0.1,0.3];
            }
         if(param1=="medium")
            {
               return [0.6,0.21,0.21];
            }
         return [0.4,0.15,0.15];
      }

      private var log:Log;

      private var _styleSheet:StyleSheet;

      private var _styleName:String;

      public function get rootStyleName() : String {
         return this._styleName;
      }

      public function get rootStyle() : Object {
         return this._styleSheet.getStyle(this._styleName);
      }

      public function set rootStyle(param1:Object) : void {
         this.setStyle(this._styleName,param1);
         return;
      }

      public function setStyle(param1:String, param2:Object) : void {
         this._styleSheet.setStyle(param1,param2);
         return;
      }

      public function getStyle(param1:String) : Object {
         return this._styleSheet.getStyle(param1);
      }

      public function addToRootStyle(param1:Object) : void {
         this.addStyleRules(this._styleName,param1);
         return;
      }

      public function addStyleRules(param1:String, param2:Object) : void {
         var _loc4_:String = null;
         var _loc3_:Object = this._styleSheet.getStyle(param1);
         for (_loc4_ in param2)
            {
               _loc3_[_loc4_]=param2[_loc4_];
            }
         this._styleSheet.setStyle(param1,null);
         this._styleSheet.setStyle(param1,_loc3_);
         return;
      }

      public function get styleSheet() : StyleSheet {
         return this._styleSheet;
      }

      public function get padding() : Array {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = NaN;
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc7_:Array = null;
         if(!StyleSheetUtil.hasProperty("padding",this.rootStyle))
            {
               return [5,5,5,5];
            }
         var _loc1_:String = this.rootStyle["padding"];
         if(_loc1_.indexOf(" ")>0)
            {
               _loc2_=new Array();
               _loc3_=_loc1_.split(" ");
               _loc4_=0;
               while(_loc4_<_loc3_.length)
                  {
                     _loc5_=_loc3_[_loc4_];
                     _loc2_[_loc4_]=NumberUtil.decodePixels(_loc5_);
                     _loc4_++;
                  }
               return _loc2_;
            }
         _loc6_=NumberUtil.decodePixels(_loc1_);
         _loc7_=new Array();
         _loc7_.push(_loc6_);
         _loc7_.push(_loc6_);
         _loc7_.push(_loc6_);
         _loc7_.push(_loc6_);
         return _loc7_;
      }

      public function get backgroundColor() : uint {
         if(StyleSheetUtil.hasProperty("background",this.rootStyle))
            {
               return StyleSheetUtil.colorValue(StyleSheetUtil.parseShorthand("background",this.rootStyle)[0]);
            }
         if(StyleSheetUtil.hasProperty("backgroundColor",this.rootStyle))
            {
               return this.parseColorValue("backgroundColor");
            }
         return 3355443;
      }

      public function get backgroundAlpha() : Number {
         if(StyleSheetUtil.hasProperty("background",this.rootStyle))
            {
               return StyleSheetUtil.colorAlpha(StyleSheetUtil.parseShorthand("background",this.rootStyle)[0]);
            }
         if(StyleSheetUtil.hasProperty("backgroundColor",this.rootStyle))
            {
               return this.parseColorAlpha("backgroundColor");
            }
         return 1;
      }

      public function get backgroundGradient() : Array {
         if(!StyleSheetUtil.hasProperty("backgroundGradient",this.rootStyle))
            {
               return null;
            }
         if(this.rootStyle["backgroundGradient"] is String)
            {
               return decodeGradient(this.rootStyle["backgroundGradient"] as String);
            }
         return this.rootStyle["backgroundGradient"];
      }

      public function get backgroundTransparent() : Boolean {
         if(!StyleSheetUtil.hasProperty("backgroundColor",this.rootStyle))
            {
               return false;
            }
         return this.rootStyle["backgroundColor"]=="transparent"||this.backgroundAlpha==0;
      }

      public function get borderWidth() : Number {
         return StyleSheetUtil.borderWidth("border",this.rootStyle);
      }

      public function get borderColor() : uint {
         return StyleSheetUtil.borderColor("border",this.rootStyle);
      }

      public function get borderAlpha() : Number {
         return StyleSheetUtil.borderAlpha("border",this.rootStyle);
      }

      public function get borderRadius() : int {
         if(!StyleSheetUtil.hasProperty("borderRadius",this.rootStyle))
            {
               return 5;
            }
         return NumberUtil.decodePixels(this.rootStyle["borderRadius"]);
      }

      public function get backgroundImage() : String {
         var _loc1_:String = null;
         if(StyleSheetUtil.hasProperty("backgroundImage",this.rootStyle))
            {
               _loc1_=this.rootStyle["backgroundImage"];
               if(_loc1_.indexOf("url(")==0)
                  {
                     return _loc1_.substring(4,_loc1_.indexOf(")"));
                  }
               return this.rootStyle["backgroundImage"] as String;
            }
         if(StyleSheetUtil.hasProperty("background",this.rootStyle))
            {
               return this.find(StyleSheetUtil.parseShorthand("background",this.rootStyle),"url(");
            }
         return null;
      }

      public function get linkUrl() : String {
         return this.rootStyle["linkUrl"] as String;
      }

      public function get linkWindow() : String {
         if(!StyleSheetUtil.hasProperty("linkWindow",this.rootStyle))
            {
               return "_self";
            }
         return this.rootStyle["linkWindow"] as String;
      }

      private function find(param1:Array, param2:String) : String {
         var _loc3_:Number = 0;
         while(_loc3_<param1.length)
            {
               if(param1[_loc3_] is String&&String(param1[_loc3_]).indexOf(param2)==0)
                  {
                     return param1[_loc3_] as String;
                  }
               _loc3_++;
            }
         return null;
      }

      public function get backgroundImageX() : Length {
         if(!StyleSheetUtil.hasProperty("background",this.rootStyle))
            {
               return new Length(0);
            }
         var _loc1_:Array = StyleSheetUtil.parseShorthand("background",this.rootStyle);
         if(_loc1_.length<2)
            {
               return null;
            }
         return new Length(_loc1_[_loc1_.length-2]);
      }

      public function get backgroundImageY() : Length {
         if(!StyleSheetUtil.hasProperty("background",this.rootStyle))
            {
               return new Length(0);
            }
         var _loc1_:Array = StyleSheetUtil.parseShorthand("background",this.rootStyle);
         if(_loc1_.length<1)
            {
               return null;
            }
         return new Length(_loc1_[_loc1_.length-1]);
      }

      public function get backgroundRepeat() : Boolean {
         if(StyleSheetUtil.hasProperty("backgroundRepeat",this.rootStyle))
            {
               return this.rootStyle["backgroundRepeat"]=="repeat";
            }
         if(StyleSheetUtil.hasProperty("background",this.rootStyle))
            {
               return StyleSheetUtil.parseShorthand("background",this.rootStyle).indexOf("no-repeat")>0;
            }
         return false;
      }

      public function get textDecoration() : String {
         return this.rootStyle["textDecoration"];
      }

      private function parseCSS(param1:String) : void {
         this._styleSheet.parseCSS(param1);
         this.rootStyle=this._styleSheet.getStyle(this._styleName);
         return;
      }

      private function parseColorValue(param1:String) : uint {
         return StyleSheetUtil.colorValue(this.rootStyle[param1]);
      }

      private function parseColorAlpha(param1:String) : Number {
         return StyleSheetUtil.colorAlpha(this.rootStyle[param1]);
      }

      public function set rootStyleName(param1:String) : void {
         this._styleName=param1;
         return;
      }
   }

}