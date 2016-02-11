package org.flowplayer.layout
{
   import org.flowplayer.model.Cloneable;
   import org.flowplayer.util.Log;
   import org.flowplayer.util.NumberUtil;


   public class Length extends Object implements Cloneable
   {
         

      public function Length(param1:Object=null) {
         this.log=new Log(this);
         super();
         this._px=NaN;
         this._pct=NaN;
         if((param1)||param1 is Number&&Number(param1)==0)
            {
               this.setValue(param1);
            }
         return;
      }



      private var log:Log;

      private var _px:Number;

      private var _pct:Number;

      private var _clearPct:Boolean;

      public function clone() : Cloneable {
         var _loc1_:Length = new Length();
         _loc1_._pct=this._pct;
         _loc1_._px=this._px;
         return _loc1_;
      }

      public function set value(param1:Object) : void {
         this.setValue(param1);
         return;
      }

      public function clear() : void {
         this._px=NaN;
         this._pct=NaN;
         return;
      }

      public function setValue(param1:Object) : void {
         var _loc2_:String = null;
         if((param1)&&param1 is String)
            {
               _loc2_=param1 as String;
               this._pct=NumberUtil.decodePercentage(_loc2_);
               this._px=NumberUtil.decodePixels(_loc2_);
            }
         else
            {
               this._px=param1 as Number;
               this._pct=NaN;
            }
         return;
      }

      public function plus(param1:Length, param2:Function, param3:Function) : Length {
         this.log.debug(this+" plus() "+param1);
         var _loc4_:Length = new Length();
         if(this._px>=0&&!isNaN(param1.px))
            {
               _loc4_.px=this._px+param1.px;
            }
         if(this._pct>=0&&!isNaN(param1.pct))
            {
               _loc4_.pct=this._pct+param1._pct;
            }
         if(this._px>=0&&!isNaN(param1.pct))
            {
               _loc4_.px=param2(param3(this._px)+param1.pct);
            }
         if(this._pct>=0&&!isNaN(param1.px))
            {
               _loc4_.pct=param3(param2(this._pct)+param1.px);
            }
         this.log.debug("plus(), result is "+_loc4_);
         return _loc4_;
      }

      public function hasValue() : Boolean {
         return this._px>=0||this._pct>=0;
      }

      public function get px() : Number {
         return this._px;
      }

      public function set px(param1:Number) : void {
         this._px=param1;
         return;
      }

      public function get pct() : Number {
         return this._pct;
      }

      public function set pct(param1:Number) : void {
         this._pct=param1;
         return;
      }

      public function asObject() : Object {
         if(this._px>=0)
            {
               return this._px;
            }
         if(this._pct>=0)
            {
               return this._pct+"%";
            }
         return undefined;
      }

      public function toString() : String {
         return "[Dimension] "+this._px+"px -- "+this._pct+"%";
      }

      public function toPx(param1:Number) : Number {
         if(this._pct>=0)
            {
               return param1*this._pct/100;
            }
         if(this._px>=0)
            {
               return this._px;
            }
         return undefined;
      }
   }

}