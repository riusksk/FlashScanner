package org.flowplayer.layout
{
   import org.flowplayer.util.Log;


   public class Position extends Object
   {
         

      public function Position() {
         this.log=new Log(this);
         this._top=new Length();
         this._right=new Length();
         this._bottom=new Length();
         this._left=new Length();
         super();
         return;
      }



      private var log:Log;

      private var _top:Length;

      private var _right:Length;

      private var _bottom:Length;

      private var _left:Length;

      public function set topValue(param1:Object) : void {
         this.setValue("_top",param1);
         return;
      }

      public function get top() : Length {
         return this._top;
      }

      private function setValue(param1:String, param2:Object) : void {
         if(param2 is Length)
            {
               this[param1]=param2;
               this.log.debug(param1+" set to "+param2);
            }
         else
            {
               Length(this[param1]).value=param2;
            }
         Length(this[this.getOtherProperty(param1)]).clear();
         return;
      }

      private function getOtherProperty(param1:String) : String {
         if(param1=="_top")
            {
               return "_bottom";
            }
         if(param1=="_bottom")
            {
               return "_top";
            }
         if(param1=="_left")
            {
               return "_right";
            }
         if(param1=="_right")
            {
               return "_left";
            }
         throw new Error("Trying to set unknown property "+param1);
      }

      public function set rightValue(param1:Object) : void {
         this.setValue("_right",param1);
         return;
      }

      public function get right() : Length {
         return this._right;
      }

      public function set bottomValue(param1:Object) : void {
         this.setValue("_bottom",param1);
         return;
      }

      public function get bottom() : Length {
         return this._bottom;
      }

      public function set leftValue(param1:Object) : void {
         this.setValue("_left",param1);
         return;
      }

      public function get left() : Length {
         return this._left;
      }

      public function set values(param1:Array) : void {
         this.setValue("_top",param1[0]);
         this.setValue("_right",param1[1]);
         this.setValue("_bottom",param1[2]);
         this.setValue("_left",param1[3]);
         return;
      }

      public function get values() : Array {
         return [this._top.asObject(),this._right.asObject(),this._bottom.asObject(),this._left.asObject()];
      }

      public function clone() : Position {
         var _loc1_:Position = new Position();
         _loc1_._top=this._top.clone() as Length;
         _loc1_._right=this._right.clone() as Length;
         _loc1_._bottom=this._bottom.clone() as Length;
         _loc1_._left=this._left.clone() as Length;
         return _loc1_;
      }

      public function toString() : String {
         return "[Margins] left: "+this._left+", righ "+this._right+", top "+this._top+", bottom "+this._bottom;
      }

      public function hasValue(param1:String) : Boolean {
         if(param1=="top")
            {
               return this._top.hasValue();
            }
         if(param1=="right")
            {
               return this._right.hasValue();
            }
         if(param1=="bottom")
            {
               return this._bottom.hasValue();
            }
         if(param1=="left")
            {
               return this._left.hasValue();
            }
         return false;
      }

      public function toLeft(param1:Number, param2:Number) : void {
         if(this._left.hasValue())
            {
               return;
            }
         if(this._right.pct>=0)
            {
               this._left.pct=100-this._right.pct;
            }
         if(this._right.px>0)
            {
               this._left.px=param1-param2-this._right.px;
            }
         this._right.clear();
         return;
      }

      public function toRight(param1:Number, param2:Number) : void {
         if(this._right.hasValue())
            {
               return;
            }
         if(this._left.pct>=0)
            {
               this._right.pct=100-this._left.pct;
            }
         if(this._left.px>0)
            {
               this._right.px=param1-param2-this._left.px;
            }
         this._left.clear();
         return;
      }

      public function toTop(param1:Number, param2:Number) : void {
         if(this._top.hasValue())
            {
               return;
            }
         if(this._bottom.pct>=0)
            {
               this._top.pct=100-this._bottom.pct;
            }
         if(this._bottom.px>0)
            {
               this._top.px=param1-param2-this._bottom.px;
            }
         this._bottom.clear();
         return;
      }

      public function toBottom(param1:Number, param2:Number) : void {
         if(this._bottom.hasValue())
            {
               return;
            }
         if(this._top.pct>=0)
            {
               this._bottom.pct=100-this._top.pct;
            }
         if(this._top.px>0)
            {
               this._bottom.px=param1-param2-this._top.px;
            }
         this._top.clear();
         return;
      }
   }

}