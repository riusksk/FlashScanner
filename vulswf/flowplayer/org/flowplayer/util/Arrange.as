package org.flowplayer.util
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import org.flowplayer.model.DisplayProperties;


   public class Arrange extends Object
   {
         

      public function Arrange() {
         super();
         return;
      }

      public static var parentHeight:Number = 0;

      public static var parentWidth:Number = 0;

      public static var hasParent:Boolean = false;

      public static var set:Boolean = false;

      public static var localWidth:Number = 0;

      public static var localHeight:Number = 0;

      public static function center(param1:DisplayObject, param2:Number=0, param3:Number=0) : void {
         if(param2>0)
            {
               param1.x=int(param2/2-param1.width/2);
            }
         if(param3>0)
            {
               param1.y=int(param3/2-param1.height/2);
            }
         return;
      }

      public static function sameSize(param1:DisplayObject, param2:DisplayObject) : void {
         if(!param1)
            {
               return;
            }
         if(!param2)
            {
               return;
            }
         if(param2 is Stage)
            {
               param1.width=Stage(param2).stageWidth;
               param1.height=Stage(param2).stageHeight;
            }
         else
            {
               param1.width=param2.width;
               param1.height=param2.height;
            }
         return;
      }

      public static function describeBounds(param1:DisplayObject) : String {
         return "x: "+param1.x+", y: "+param1.y+", width: "+param1.width+", height: "+param1.height;
      }

      public static function positionPercentage(param1:DisplayObject, param2:DisplayObject, param3:int) : int {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         if(param3==0||param3==2)
            {
               _loc4_=(param1.y+param1.height/2)/param2.height*100;
               return param3==0?_loc4_:100-_loc4_;
            }
         if(param3==1||param3==3)
            {
               _loc5_=(param1.x+param1.width/2)/param2.width*100;
               return param3==3?_loc5_:100-_loc5_;
            }
         return 0;
      }

      public static function getWidth(param1:DisplayObject) : Number {
         if(param1 is Stage)
            {
               return getStageWidth(param1 as Stage);
            }
         return param1.width;
      }

      public static function getHeight(param1:DisplayObject) : Number {
         if(param1 is Stage)
            {
               return getStageHeight(param1 as Stage);
            }
         return param1.height;
      }

      public static function getStageWidth(param1:Stage) : Number {
         return getStageDimension(param1,"width");
      }

      public static function getStageHeight(param1:Stage) : Number {
         return getStageDimension(param1,"height");
      }

      protected static function getStageDimension(param1:Stage, param2:String) : Number {
         if(param1.displayState==StageDisplayState.FULL_SCREEN)
            {
               return param2=="height"?param1.stageHeight:param1.stageWidth;
            }
         return param2=="height"?parentHeight:parentWidth;
      }

      public static function fixPositionSettings(param1:DisplayProperties, param2:Object) : void {
         clearOpposite("bottom","top",param1,param2);
         clearOpposite("left","right",param1,param2);
         return;
      }

      private static function clearOpposite(param1:String, param2:String, param3:DisplayProperties, param4:Object) : void {
         if((param3.position[param1].hasValue())&&(param4.hasOwnProperty(param2)))
            {
               delete param4[[param2]];
            }
         else
            {
               if((param3.position[param2].hasValue())&&(param4.hasOwnProperty(param1)))
                  {
                     delete param4[[param1]];
                  }
            }
         return;
      }


   }

}