package org.flowplayer.layout
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.DisplayProperties;
   import flash.display.DisplayObject;
   import org.flowplayer.util.Arrange;
   import com.adobe.utils.StringUtil;


   public class LengthMath extends Object
   {
         

      public function LengthMath() {
         super();
         return;
      }

      private static const log:Log = new Log("org.flowplayer.layout::LengthMath");

      public static function sum(param1:DisplayProperties, param2:Object, param3:DisplayObject) : DisplayProperties {
         var _loc4_:Number = Arrange.getWidth(param3);
         var _loc5_:Number = Arrange.getHeight(param3);
         addValue(param1,param2,"alpha");
         addValue(param1,param2,"opacity");
         addValue(param1,param2,"display");
         addValue(param1,param2,"visible");
         addValue(param1,param2,"zIndex");
         addDimension("width",param1,param2,dimToPx(_loc4_),dimToPct(_loc4_));
         addDimension("height",param1,param2,dimToPx(_loc5_),dimToPct(_loc5_));
         log.debug("sum(): result dimensions "+param1.dimensions);
         log.debug("sum(), current position "+param1.position);
         var _loc6_:Number = param1.dimensions.height.toPx(_loc5_);
         if(hasValue(param2,"top"))
            {
               param1.position.toTop(_loc5_,_loc6_);
               addPosition("top",param1,param2,_loc6_,posToPx(_loc6_,_loc5_),posToPct(_loc6_,_loc5_));
            }
         else
            {
               if(hasValue(param2,"bottom"))
                  {
                     param1.position.toBottom(_loc5_,_loc6_);
                     addPosition("bottom",param1,param2,_loc6_,posToPx(_loc6_,_loc5_),posToPct(_loc6_,_loc5_));
                  }
            }
         var _loc7_:Number = param1.dimensions.width.toPx(_loc4_);
         if(hasValue(param2,"left"))
            {
               log.debug("adding to left");
               param1.position.toLeft(_loc4_,_loc7_);
               addPosition("left",param1,param2,_loc7_,posToPx(_loc7_,_loc4_),posToPct(_loc7_,_loc4_));
            }
         if(hasValue(param2,"right"))
            {
               param1.position.toRight(_loc4_,_loc7_);
               addPosition("right",param1,param2,_loc7_,posToPx(_loc7_,_loc4_),posToPct(_loc7_,_loc4_));
            }
         log.debug("sum(): result position "+param1.position);
         return param1;
      }

      private static function addValue(param1:DisplayProperties, param2:Object, param3:String) : void {
         if(!param2)
            {
               return;
            }
         if(!param1)
            {
               return;
            }
         if(!containsValue(param2[param3]))
            {
               return;
            }
         param1[param3]=param2[param3];
         return;
      }

      private static function addDimension(param1:String, param2:DisplayProperties, param3:Object, param4:Function, param5:Function) : void {
         var _loc6_:Object = param3[param1];
         if(!containsValue(_loc6_))
            {
               return;
            }
         if(incremental(_loc6_))
            {
               param2[param1]=param2.dimensions[param1].plus(new Length(_loc6_),param4,param5);
               log.debug("new dimension is "+param2.dimensions[param1]);
            }
         else
            {
               param2[param1]=_loc6_;
            }
         return;
      }

      private static function addPosition(param1:String, param2:DisplayProperties, param3:Object, param4:Number, param5:Function, param6:Function) : void {
         var _loc8_:Length = null;
         var _loc7_:Object = param3[param1];
         if(incremental(_loc7_))
            {
               log.debug("adding incremental position value "+_loc7_);
               _loc8_=param2.position[param1].plus(new Length(_loc7_),param5,param6);
               if(_loc8_.px<0)
                  {
                     _loc8_.px=0;
                  }
               param2[param1]=_loc8_;
            }
         else
            {
               param2[param1]=_loc7_;
            }
         return;
      }

      private static function posToPct(param1:Number, param2:Number) : Function {
         var dim:Number = param1;
         var containerDim:Number = param2;
         return new function(param1:Number):Number
            {
               return (param1+dim/2)/containerDim*100;
            };
      }

      private static function posToPx(param1:Number, param2:Number) : Function {
         var dim:Number = param1;
         var containerDim:Number = param2;
         return new function(param1:Number):Number
            {
               return param1/100*containerDim-dim/2;
            };
      }

      private static function dimToPct(param1:Number) : Function {
         var containerDim:Number = param1;
         return new function(param1:Number):Number
            {
               return param1/containerDim*100;
            };
      }

      private static function dimToPx(param1:Number) : Function {
         var containerDim:Number = param1;
         return new function(param1:Number):Number
            {
               return containerDim*param1/100;
            };
      }

      private static function incremental(param1:Object) : Boolean {
         if(!param1 is String)
            {
               return false;
            }
         var _loc2_:Boolean = (StringUtil.beginsWith(String(param1),"+"))||(StringUtil.beginsWith(String(param1),"-"));
         log.debug("incremental? "+param1+", "+_loc2_);
         return _loc2_;
      }

      private static function hasValue(param1:Object, param2:String) : Boolean {
         return containsValue(param1[param2]);
      }

      private static function containsValue(param1:Object) : Boolean {
         if(param1 is String)
            {
               return true;
            }
         if(param1 is Boolean)
            {
               return true;
            }
         var _loc2_:Boolean = param1 is Number&&!isNaN(param1 as Number);
         log.debug("hasValue? "+param1+", "+_loc2_);
         return _loc2_;
      }


   }

}