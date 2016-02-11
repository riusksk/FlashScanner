package org.flowplayer.layout
{
   import org.flowplayer.model.Cloneable;
   import flash.display.DisplayObject;
   import org.flowplayer.util.Arrange;


   public class Dimensions extends Object implements Cloneable
   {
         

      public function Dimensions() {
         this._width=new Length();
         this._height=new Length();
         super();
         return;
      }



      private var _width:Length;

      private var _height:Length;

      public function clone() : Cloneable {
         var _loc1_:Dimensions = new Dimensions();
         _loc1_._width=this._width.clone() as Length;
         _loc1_._height=this._height.clone() as Length;
         return _loc1_;
      }

      public function get width() : Length {
         return this._width;
      }

      public function set widthValue(param1:Object) : void {
         if(param1 is Length)
            {
               this._width=param1 as Length;
            }
         else
            {
               this._width.value=param1;
            }
         return;
      }

      public function get height() : Length {
         return this._height;
      }

      public function set heightValue(param1:Object) : void {
         if(param1 is Length)
            {
               this._height=param1 as Length;
            }
         else
            {
               this._height.value=param1;
            }
         return;
      }

      public function fillValues(param1:DisplayObject) : void {
         if(this._width.px>=0)
            {
               this._width.pct=this._width.px/Arrange.getWidth(param1)*100;
            }
         else
            {
               if(this._width.pct>=0)
                  {
                     this._width.px=this.width.pct/100*Arrange.getWidth(param1);
                  }
            }
         if(this._height.px>=0)
            {
               this._height.pct=this._height.px/Arrange.getHeight(param1)*100;
            }
         else
            {
               if(this._height.pct>=0)
                  {
                     this._height.px=this.height.pct/100*Arrange.getHeight(param1);
                  }
            }
         return;
      }

      public function toString() : String {
         return "("+this._width+") x ("+this._height+")";
      }

      public function hasValue(param1:String) : Boolean {
         if(param1=="width")
            {
               return this._width.hasValue();
            }
         if(param1=="height")
            {
               return this._height.hasValue();
            }
         return false;
      }
   }

}