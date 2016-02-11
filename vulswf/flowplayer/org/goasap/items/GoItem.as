package org.goasap.items
{
   import org.goasap.PlayableBase;
   import org.goasap.interfaces.IUpdatable;
   import org.goasap.GoEngine;


   public class GoItem extends PlayableBase implements IUpdatable
   {
         

      public function GoItem() {
         this.useRounding=defaultUseRounding;
         this.useRelative=defaultUseRelative;
         this._pulse=defaultPulseInterval;
         super();
         return;
      }

      public static var defaultPulseInterval:Number = GoEngine.ENTER_FRAME;

      public static var defaultUseRounding:Boolean = false;

      public static var defaultUseRelative:Boolean = false;

      public static var timeMultiplier:Number = 1;

      public function get pulseInterval() : int {
         return this._pulse;
      }

      public function set pulseInterval(param1:int) : void {
         if(_state==STOPPED&&(param1>=0||param1==GoEngine.ENTER_FRAME))
            {
               this._pulse=param1;
            }
         return;
      }

      public var useRounding:Boolean;

      public var useRelative:Boolean;

      protected var _pulse:int;

      public function correctValue(param1:Number) : Number {
         if(isNaN(param1))
            {
               return 0;
            }
         if(this.useRounding)
            {
               return param1=param1%1==0?param1:param1%1>=0.5?int(param1)+1:int(param1);
            }
         return param1;
      }

      public function update(param1:Number) : void {
         return;
      }
   }

}