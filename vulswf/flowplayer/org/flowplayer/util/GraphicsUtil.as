package org.flowplayer.util
{
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.display.GradientType;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;


   public class GraphicsUtil extends Object
   {
         

      public function GraphicsUtil() {
         super();
         return;
      }

      public static function beginGradientFill(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number=1) : void {
         var _loc7_:Array = [param4,param5,param4];
         var _loc8_:Matrix = new Matrix();
         _loc8_.createGradientBox(param2,param3,Math.PI/2);
         param1.beginGradientFill(GradientType.LINEAR,_loc7_,[param6,param6,param6],[0,127,255],_loc8_);
         return;
      }

      public static function beginLinearGradientFill(param1:Graphics, param2:Number, param3:Number, param4:Array, param5:Array, param6:int, param7:int) : void {
         var _loc8_:Matrix = new Matrix();
         _loc8_.createGradientBox(param2,param3,Math.PI/2,param6,param7);
         var _loc9_:Array = new Array();
         var _loc10_:Number = 255/(param4.length-1);
         var _loc11_:Number = 0;
         while(_loc11_<param4.length)
            {
               _loc9_.push(_loc11_*_loc10_);
               _loc11_++;
            }
         param1.beginGradientFill(GradientType.LINEAR,param4,param5,_loc9_,_loc8_);
         return;
      }

      public static function drawRoundRectangle(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void {
         if(param6>0)
            {
               param1.drawRoundRect(param2,param3,param4,param5,param6,param6);
            }
         else
            {
               param1.drawRect(param2,param3,param4,param5);
            }
         return;
      }

      public static function addGradient(param1:DisplayObjectContainer, param2:int, param3:Array, param4:Number, param5:Number=0, param6:Number=0, param7:Number=0) : void {
         removeGradient(param1);
         var _loc8_:Shape = new Shape();
         _loc8_.name="_gradient";
         param1.addChildAt(_loc8_,param2);
         _loc8_.graphics.clear();
         beginFill(_loc8_.graphics,param3,param1.width,param7!=0?param7:param1.height,param5,param6);
         GraphicsUtil.drawRoundRectangle(_loc8_.graphics,param5,param6,param1.width,param7!=0?param7:param1.height,param4);
         _loc8_.graphics.endFill();
         return;
      }

      public static function removeGradient(param1:DisplayObjectContainer) : void {
         var _loc2_:DisplayObject = param1.getChildByName("_gradient");
         if(_loc2_)
            {
               param1.removeChild(_loc2_);
            }
         return;
      }

      private static function beginFill(param1:Graphics, param2:Array, param3:Number, param4:Number, param5:int, param6:int) : void {
         var _loc7_:Array = new Array();
         var _loc8_:Number = 0;
         while(_loc8_<param2.length)
            {
               _loc7_.push(16777215);
               _loc8_++;
            }
         beginLinearGradientFill(param1,param3,param4,_loc7_,param2,param5,param6);
         return;
      }

      public static function transformColor(param1:DisplayObject, param2:Array) : void {
         if(!param1)
            {
               return;
            }
         var _loc3_:ColorTransform = new ColorTransform(0,0,0,param2[3],param2[0],param2[1],param2[2]);
         param1.transform.colorTransform=_loc3_;
         return;
      }


   }

}