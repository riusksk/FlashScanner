package org.flowplayer.view
{
   import org.goasap.items.LinearGo;
   import org.flowplayer.util.Log;
   import flash.display.DisplayObject;


   public class Animation extends LinearGo
   {
         

      public function Animation(param1:DisplayObject, param2:String, param3:Number, param4:Number=500) {
         this.log=new Log(this);
         super(0,param4/1000);
         this._target=param1;
         this._targetValue=param3;
         this._tweenProperty=param2;
         useRounding=true;
         return;
      }



      protected var log:Log;

      private var _target:DisplayObject;

      private var _targetValue:Number;

      private var _startValue:Number;

      private var _tweenProperty:String;

      private var _canceled:Boolean;

      public function cancel() : Boolean {
         this._canceled=true;
         return stop();
      }

      protected function startFrom(param1:Number) : Boolean {
         this.log.debug("starting with start value "+param1);
         this._startValue=param1;
         this._target[this._tweenProperty]=param1;
         _change=this._targetValue-this._startValue;
         return super.start();
      }

      override  public function start() : Boolean {
         this._startValue=this._target[this._tweenProperty];
         this.log.debug("starting with start value "+this._startValue);
         _change=this._targetValue-this._startValue;
         return super.start();
      }

      override  protected function onUpdate(param1:String) : void {
         var _loc2_:Number = this._startValue+(this._targetValue-this._startValue)*_position;
         this._target[this._tweenProperty]=this._tweenProperty=="alpha"?_loc2_:correctValue(_loc2_);
         if(this._target[this._tweenProperty]==this._targetValue)
            {
               this.log.debug("completed for target "+this.target+", property "+this._tweenProperty+", target value was "+this._targetValue);
            }
         return;
      }

      override  public function toString() : String {
         return "[Animation] of property \'"+this._tweenProperty+"\', start "+this._startValue+", target "+this._targetValue;
      }

      protected function get target() : DisplayObject {
         return this._target;
      }

      public function get canceled() : Boolean {
         return this._canceled;
      }

      public function get tweenProperty() : String {
         return this._tweenProperty;
      }
   }

}