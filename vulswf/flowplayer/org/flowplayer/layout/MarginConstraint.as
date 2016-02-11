package org.flowplayer.layout
{
   import org.flowplayer.util.Log;
   import flash.geom.Rectangle;
   import flash.display.DisplayObject;


   class MarginConstraint extends AbstractConstraint implements Constraint
   {
         

      function MarginConstraint(param1:DisplayObject, param2:Layout, param3:Array, param4:Dimensions) {
         this.log=new Log(this);
         super(param1,param2,param3);
         this._dimensions=param4;
         return;
      }



      private var log:Log;

      private var _dimensions:Dimensions;

      public function getBounds() : Rectangle {
         return new Rectangle(this.getLeftMargin(),this.getTopMargin(),this.getWidth(),this.getHeight());
      }

      private function getWidth() : Number {
         return (this._dimensions.width.toPx(getContainerWidth()))||(getContainerWidth()-this.getLeftMargin()-this.getRightMargin());
      }

      private function getHeight() : Number {
         return (this._dimensions.height.toPx(getContainerHeight()))||(getContainerHeight()-this.getTopMargin()-this.getBottomMargin());
      }

      protected function getTopMargin() : Number {
         return this.getMargin(0,2,"height",getContainerHeight());
      }

      protected function getRightMargin() : Number {
         return this.getMargin(1,3,"width",getContainerWidth());
      }

      protected function getBottomMargin() : Number {
         return this.getMargin(2,0,"height",getContainerHeight());
      }

      protected function getLeftMargin() : Number {
         return this.getMargin(3,1,"width",getContainerWidth());
      }

      private function getMargin(param1:Number, param2:Number, param3:String, param4:Number) : Number {
         var _loc6_:Constraint = null;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         this.log.debug(getConstrainedView()+", getMargin() "+param1);
         var _loc5_:Constraint = getMarginConstraints()[param1];
         if(!_loc5_)
            {
               _loc6_=getMarginConstraints()[param2];
               _loc7_=this._dimensions[param3].toPx(param4);
               if(!_loc6_)
                  {
                     throw new Error(getConstrainedView()+": not enough info to place object on Panel. Need top|bottom and left|right display properties.");
                  }
               _loc8_=_loc6_?param4-_loc7_-_loc6_.getBounds()[param3]:0;
               return _loc8_;
            }
         this.log.debug(getConstrainedView()+": getMargin(), constraint at margin "+param1+": "+_loc5_+", returns value "+_loc5_.getBounds()[param3]);
         return _loc5_.getBounds()[param3];
      }
   }

}