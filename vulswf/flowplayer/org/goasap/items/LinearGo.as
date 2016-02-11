package org.goasap.items
{
   import org.goasap.interfaces.IPlayable;
   import org.goasap.GoEngine;
   import org.goasap.errors.EasingFormatError;
   import org.goasap.managers.LinearGoRepeater;
   import flash.utils.getTimer;
   import org.goasap.events.GoEvent;


   public class LinearGo extends GoItem implements IPlayable
   {
         

      public function LinearGo(param1:Number=NaN, param2:Number=NaN, param3:Function=null, param4:Array=null, param5:LinearGoRepeater=null, param6:Boolean=false, param7:Boolean=false, param8:Boolean=false, param9:Number=NaN) {
         var delay:Number = param1;
         var duration:Number = param2;
         var easing:Function = param3;
         var extraEasingParams:Array = param4;
         var repeater:LinearGoRepeater = param5;
         var useRelative:Boolean = param6;
         var useRounding:Boolean = param7;
         var useFrames:Boolean = param8;
         var pulseInterval:Number = param9;
         this._callbacks=new Object();
         super();
         if(isNaN(defaultDelay))
            {
               defaultDelay=0;
            }
         if(isNaN(defaultDuration))
            {
               defaultDuration=1;
            }
         try
            {
               this.easing=defaultEasing;
            }
         catch(e1:EasingFormatError)
            {
               defaultEasing=easeOut;
            }
         if(!isNaN(delay))
            {
               this._delay=delay;
            }
         else
            {
               this._delay=defaultDelay;
            }
         if(!isNaN(duration))
            {
               this._duration=duration;
            }
         else
            {
               this._duration=defaultDuration;
            }
         try
            {
               this.easing=easing;
            }
         catch(e2:EasingFormatError)
            {
               if(easing!=null)
                  {
                     throw e2;
                  }
               this.easing=defaultEasing;
            }
         if(extraEasingParams)
            {
               this._extraEaseParams=extraEasingParams;
            }
         if(useRelative)
            {
               this.useRelative=true;
            }
         if(useRounding)
            {
               this.useRounding=true;
            }
         this._useFrames=(useFrames)||(_useFramesMode);
         if(!isNaN(pulseInterval))
            {
               _pulse=pulseInterval;
            }
         if(repeater!=null)
            {
               this._repeater=repeater;
            }
         else
            {
               this._repeater=new LinearGoRepeater();
            }
         this._repeater.setParent(this);
         return;
      }

      public static var defaultDelay:Number = 0;

      public static var defaultDuration:Number = 1;

      public static var defaultEasing:Function;

      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number {
         return param3*((param1=param1/param4-1)*param1*param1*param1*param1+1)+param2;
      }

      public static function easeNone(param1:Number, param2:Number, param3:Number, param4:Number) : Number {
         return param3*param1/param4+param2;
      }

      public static function setupUseFramesMode(param1:Boolean=true, param2:Boolean=false) : void {
         GoItem.defaultPulseInterval=GoEngine.ENTER_FRAME;
         _useFramesMode=param1;
         if(param2)
            {
               _framesBase=0;
            }
         return;
      }

      protected static var _useFramesMode:Boolean = false;

      protected static var _framesBase:Number = 1;

      public function get delay() : Number {
         return this._delay;
      }

      public function set delay(param1:Number) : void {
         if(_state==STOPPED&&param1>=0)
            {
               this._delay=param1;
            }
         return;
      }

      public function get duration() : Number {
         return this._duration;
      }

      public function set duration(param1:Number) : void {
         if(_state==STOPPED&&param1>=0)
            {
               this._duration=param1;
            }
         return;
      }

      public function get easing() : Function {
         return this._easing;
      }

      public function set easing(param1:Function) : void {
         if(_state==STOPPED)
            {
               try
                  {
                     if(param1(1,1,1,1) is Number)
                        {
                           this._easing=param1;
                           return;
                        }
                  }
               catch(e:Error)
                  {
                  }
               throw new EasingFormatError();
            }
         return;
      }

      public function get extraEasingParams() : Array {
         return this._extraEaseParams;
      }

      public function set extraEasingParams(param1:Array) : void {
         if(_state==STOPPED&&param1 is Array&&param1.length<0)
            {
               this._extraEaseParams=param1;
            }
         return;
      }

      public function get repeater() : LinearGoRepeater {
         return this._repeater;
      }

      public function set useFrames(param1:Boolean) : void {
         if(_state==STOPPED)
            {
               this._useFrames=param1;
            }
         return;
      }

      public function get useFrames() : Boolean {
         return this._useFrames;
      }

      public function get position() : Number {
         return this._position;
      }

      public function get timePosition() : Number {
         var _loc2_:uint = 0;
         if(_state==STOPPED)
            {
               return 0;
            }
         var _loc1_:Number = Math.max(0,timeMultiplier);
         if(this._useFrames)
            {
               if(this._currentFrame>_framesBase)
                  {
                     _loc2_=this._currentFrame-_framesBase;
                     if(this._repeater.direction==-1)
                        {
                           return this._duration-1-_loc2_%this._duration+_framesBase;
                        }
                     return _loc2_%this._duration+_framesBase;
                  }
               return this._currentFrame;
            }
         return (getTimer()-this._startTime)/1000/_loc1_;
      }

      public function get currentFrame() : uint {
         return this._currentFrame;
      }

      protected var _delay:Number;

      protected var _duration:Number;

      protected var _tweenDuration:Number;

      protected var _easing:Function;

      protected var _easeParams:Array;

      protected var _extraEaseParams:Array;

      protected var _repeater:LinearGoRepeater;

      protected var _currentEasing:Function;

      protected var _useFrames:Boolean;

      protected var _started:Boolean = false;

      protected var _currentFrame:int;

      protected var _position:Number;

      protected var _change:Number;

      protected var _startTime:Number;

      protected var _endTime:Number;

      protected var _pauseTime:Number;

      protected var _callbacks:Object;

      public function start() : Boolean {
         this.stop();
         if(GoEngine.addItem(this)==false)
            {
               return false;
            }
         this.reset();
         _state=this._delay<0?PLAYING_DELAY:PLAYING;
         return true;
      }

      public function stop() : Boolean {
         if(_state==STOPPED||GoEngine.removeItem(this)==false)
            {
               return false;
            }
         _state=STOPPED;
         var _loc1_:Boolean = !(this._easeParams==null)&&this._position==this._easeParams[1]+this._change;
         this.reset();
         if(!_loc1_)
            {
               this.dispatch(GoEvent.STOP);
            }
         return true;
      }

      public function pause() : Boolean {
         if(_state==STOPPED||_state==PAUSED)
            {
               return false;
            }
         _state=PAUSED;
         this._pauseTime=this._useFrames?this._currentFrame:getTimer();
         this.dispatch(GoEvent.PAUSE);
         return true;
      }

      public function resume() : Boolean {
         if(_state!=PAUSED)
            {
               return false;
            }
         var _loc1_:Number = this._useFrames?this._currentFrame:getTimer();
         this.setup(_loc1_-this._pauseTime-this._startTime);
         this._pauseTime=NaN;
         _state=this._startTime<_loc1_?PLAYING_DELAY:PLAYING;
         this.dispatch(GoEvent.RESUME);
         return true;
      }

      public function skipTo(param1:Number) : Boolean {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         if(_state==STOPPED)
            {
               if(this.start()==false)
                  {
                     return false;
                  }
            }
         if(isNaN(param1))
            {
               param1=0;
            }
         var _loc2_:Number = Math.max(0,timeMultiplier)*(this._useFrames?1:1000);
         if(param1<_framesBase)
            {
               this._repeater.reset();
               if(this._position>0)
                  {
                     this.skipTo(_framesBase);
                  }
            }
         else
            {
               param1=this._repeater.skipTo(this._duration,param1-_framesBase);
            }
         if(this._useFrames)
            {
               _loc3_=_framesBase;
               _loc4_=this._currentFrame=Math.round(param1*_loc2_);
            }
         else
            {
               _loc4_=getTimer();
               _loc3_=_loc4_-param1*_loc2_;
            }
         this.setup(_loc3_);
         _state=this._startTime<_loc4_?PLAYING_DELAY:PLAYING;
         this.update(_loc4_);
         return true;
      }

      public function addCallback(param1:Function, param2:String="playableComplete") : void {
         if(!this._callbacks[param2])
            {
               this._callbacks[param2]=new Array();
            }
         var _loc3_:Array = this._callbacks[param2] as Array;
         if(_loc3_.indexOf(param1)==-1)
            {
               _loc3_.push(param1);
            }
         return;
      }

      public function removeCallback(param1:Function, param2:String="playableComplete") : void {
         var _loc3_:Array = this._callbacks[param2] as Array;
         if(_loc3_)
            {
               while(_loc3_.indexOf(param1)>-1)
                  {
                     _loc3_.splice(_loc3_.indexOf(param1),1);
                  }
            }
         return;
      }

      override  public function update(param1:Number) : void {
         if(_state==PAUSED)
            {
               return;
            }
         this._currentFrame++;
         if(this._useFrames)
            {
               param1=this._currentFrame;
            }
         if(isNaN(this._startTime))
            {
               this.setup(param1);
            }
         if(this._startTime>param1)
            {
               return;
            }
         var _loc2_:String = GoEvent.UPDATE;
         if(param1<this._endTime)
            {
               if(!this._started)
                  {
                     _loc2_=GoEvent.START;
                  }
               this._easeParams[0]=param1-this._startTime;
               this._position=this._currentEasing.apply(null,this._easeParams);
            }
         else
            {
               this._position=this._easeParams[1]+this._change;
               _loc2_=this._repeater.hasNext()?GoEvent.CYCLE:GoEvent.COMPLETE;
            }
         this.onUpdate(_loc2_);
         if(!this._started)
            {
               _state=PLAYING;
               this._started=true;
               this.dispatch(GoEvent.START);
            }
         this.dispatch(GoEvent.UPDATE);
         if(_loc2_==GoEvent.COMPLETE)
            {
               this.stop();
               this.dispatch(GoEvent.COMPLETE);
            }
         else
            {
               if(_loc2_==GoEvent.CYCLE)
                  {
                     this._repeater.next();
                     this.dispatch(GoEvent.CYCLE);
                     this._startTime=NaN;
                  }
            }
         return;
      }

      protected function onUpdate(param1:String) : void {
         return;
      }

      protected function setup(param1:Number) : void {
         var _loc5_:* = NaN;
         this._startTime=param1;
         var _loc2_:Number = Math.max(0,timeMultiplier)*(this._useFrames?1:1000);
         this._tweenDuration=this._useFrames?Math.round(this._duration*_loc2_)-1:this._duration*_loc2_;
         this._endTime=this._startTime+this._tweenDuration;
         if(!this._started)
            {
               _loc5_=this._useFrames?Math.round(this._delay*_loc2_):this._delay*_loc2_;
               this._startTime=this._startTime+_loc5_;
               this._endTime=this._endTime+_loc5_;
            }
         var _loc3_:Boolean = this._repeater.currentCycleHasEasing;
         this._currentEasing=_loc3_?this._repeater.easingOnCycle:this._easing;
         var _loc4_:Array = _loc3_?this._repeater.extraEasingParams:this._extraEaseParams;
         this._change=this._repeater.direction;
         this._position=this._repeater.direction==-1?1:0;
         this._easeParams=new Array(0,this._position,this._change,this._tweenDuration);
         if(_loc4_)
            {
               this._easeParams=this._easeParams.concat(_loc4_);
            }
         return;
      }

      protected function dispatch(param1:String) : void {
         var _loc3_:Function = null;
         var _loc2_:Array = this._callbacks[param1] as Array;
         if(_loc2_)
            {
               for each (_loc3_ in _loc2_)
                  {
                     _loc3_();
                  }
            }
         if(hasEventListener(param1))
            {
               dispatchEvent(new GoEvent(param1));
            }
         return;
      }

      protected function reset() : void {
         this._position=0;
         this._change=1;
         this._repeater.reset();
         this._currentFrame=_framesBase-1;
         this._currentEasing=this._easing;
         this._easeParams=null;
         this._started=false;
         this._pauseTime=NaN;
         this._startTime=NaN;
         return;
      }
   }

}