package org.flowplayer.layout
{
   import org.flowplayer.util.Log;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import org.flowplayer.util.Arrange;


   class RelativeConstraint extends Object implements Constraint
   {
         

      function RelativeConstraint(param1:DisplayObject, param2:Length, param3:DisplayObject, param4:Number, param5:String) {
         this.log=new Log(this);
         super();
         this._view=param1;
         this._length=param2;
         this._reference=param3;
         this._marginPercentage=param4;
         this._viewProperty=param5;
         return;
      }



      private var log:Log;

      private var _view:DisplayObject;

      private var _reference:DisplayObject;

      private var _marginPercentage:Number;

      private var _viewProperty:String;

      private var _length:Length;

      public function getConstrainedView() : DisplayObject {
         return null;
      }

      public function getBounds() : Rectangle {
         var _loc1_:Number = this.getViewLength();
         var _loc2_:Number = this.getReferenceLength()*this._marginPercentage/100-_loc1_/2;
         return new Rectangle(0,0,_loc2_,_loc2_);
      }

      private function getReferenceLength() : Number {
         return this._viewProperty=="width"?Arrange.getWidth(this._reference):Arrange.getHeight(this._reference);
      }

      private function getViewLength() : Number {
         var _loc1_:* = NaN;
         if(this._length.pct>=0)
            {
               _loc1_=this.getReferenceLength()*this._length.pct/100;
               this.log.debug("relative length "+this._length.pct+"% out of "+this.getReferenceLength()+" is "+_loc1_);
               return _loc1_;
            }
         if(this._length.px>=0)
            {
               return this._length.px;
            }
         return this._view[this._viewProperty];
      }

      public function getMarginConstraints() : Array {
         return null;
      }

      public function setMarginConstraint(param1:Number, param2:Constraint) : void {
         return;
      }

      public function removeMarginConstraint(param1:Constraint) : void {
         return;
      }
   }

}