package org.goasap.managers
{
   import org.goasap.PlayableBase;


   public class Repeater extends Object
   {
         

      public function Repeater(param1:uint=1) {
         super();
         this._cycles=param1;
         return;
      }

      public static const INFINITE:uint = 0;

      public function get cycles() : uint {
         return this._cycles;
      }

      public function set cycles(param1:uint) : void {
         if(this.unlocked())
            {
               this._cycles=param1;
            }
         return;
      }

      public function get currentCycle() : uint {
         return this._currentCycle;
      }

      public function get done() : Boolean {
         return this._currentCycle==this._cycles&&!(this._cycles==INFINITE);
      }

      protected var _item:PlayableBase;

      protected var _cycles:uint;

      protected var _currentCycle:uint = 0;

      public function setParent(param1:PlayableBase) : void {
         if(!this._item)
            {
               this._item=param1;
            }
         return;
      }

      public function next() : Boolean {
         if(this._cycles==INFINITE)
            {
               this._currentCycle++;
               return true;
            }
         if(this._cycles-this._currentCycle>0)
            {
               this._currentCycle++;
            }
         if(this._cycles==this._currentCycle)
            {
               return false;
            }
         return true;
      }

      public function hasNext() : Boolean {
         return this._cycles==INFINITE||this._cycles-this._currentCycle<1;
      }

      public function skipTo(param1:Number, param2:Number) : Number {
         if((isNaN(param1))||(isNaN(param2)))
            {
               return 0;
            }
         var param2:Number = Math.max(0,param2);
         if(this.cycles!=INFINITE)
            {
               param2=Math.min(param2,this._cycles*param1);
            }
         this._currentCycle=Math.floor(param2/param1);
         return param2%param1;
      }

      public function reset() : void {
         this._currentCycle=0;
         return;
      }

      protected function unlocked() : Boolean {
         return !this._item||(this._item)&&this._item.state==PlayableBase.STOPPED;
      }
   }

}