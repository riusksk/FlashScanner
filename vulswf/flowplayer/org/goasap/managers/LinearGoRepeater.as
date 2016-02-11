package org.goasap.managers
{


   public class LinearGoRepeater extends Repeater
   {
         

      public function LinearGoRepeater(param1:uint=1, param2:Boolean=true, param3:Function=null, param4:Array=null) {
         super(param1);
         this._reverseOnCycle=param2;
         this._easingOnCycle=param3;
         this._extraEasingParams=param4;
         return;
      }



      public function get reverseOnCycle() : Boolean {
         return this._reverseOnCycle;
      }

      public function set reverseOnCycle(param1:Boolean) : void {
         if(unlocked())
            {
               this._reverseOnCycle=param1;
            }
         return;
      }

      public function get direction() : int {
         if((this._reverseOnCycle)&&_currentCycle%2==1)
            {
               return -1;
            }
         return 1;
      }

      public function get easingOnCycle() : Function {
         return this._easingOnCycle;
      }

      public function set easingOnCycle(param1:Function) : void {
         if(unlocked())
            {
               this._easingOnCycle=param1;
            }
         return;
      }

      public function get extraEasingParams() : Array {
         return this._extraEasingParams;
      }

      public function set extraEasingParams(param1:Array) : void {
         if(unlocked())
            {
               this._extraEasingParams=param1;
            }
         return;
      }

      public function get currentCycleHasEasing() : Boolean {
         return (this._reverseOnCycle)&&_currentCycle%2==1&&!(this._easingOnCycle==null);
      }

      protected var _reverseOnCycle:Boolean = false;

      protected var _easingOnCycle:Function;

      protected var _extraEasingParams:Array;
   }

}