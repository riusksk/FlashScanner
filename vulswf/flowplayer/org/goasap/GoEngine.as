package org.goasap
{
   import flash.utils.Dictionary;
   import flash.display.Sprite;
   import org.goasap.interfaces.IManager;
   import flash.utils.getQualifiedClassName;
   import org.goasap.errors.DuplicateManagerError;
   import org.goasap.interfaces.ILiveManager;
   import org.goasap.interfaces.IUpdatable;
   import org.goasap.interfaces.IManageable;
   import flash.events.Event;
   import flash.utils.getTimer;
   import flash.events.TimerEvent;
   import flash.utils.Timer;


   public class GoEngine extends Object
   {
         

      public function GoEngine() {
         super();
         return;
      }

      public static const INFO:String = "GoASAP 0.4.9 (c) Moses Gunesch, MIT Licensed.";

      public static const ENTER_FRAME:int = -1;

      private static var managerTable:Object = new Object();

      private static var managers:Array = new Array();

      private static var liveManagers:uint = 0;

      private static var timers:Dictionary = new Dictionary(false);

      private static var items:Dictionary = new Dictionary(false);

      private static var itemCounts:Dictionary = new Dictionary(false);

      private static var pulseSprite:Sprite;

      private static var paused:Boolean = false;

      private static var lockedPulses:Dictionary = new Dictionary(false);

      private static var delayedPulses:Dictionary = new Dictionary(false);

      private static var addQueue:Dictionary = new Dictionary(false);

      public static function getManager(param1:String) : IManager {
         return managerTable[param1];
      }

      public static function addManager(param1:IManager) : void {
         var _loc2_:String = getQualifiedClassName(param1);
         _loc2_=_loc2_.slice(_loc2_.lastIndexOf("::")+2);
         if(managerTable[_loc2_])
            {
               throw new DuplicateManagerError(_loc2_);
            }
         managerTable[_loc2_]=param1;
         managers.push(param1);
         if(param1 is ILiveManager)
            {
               liveManagers++;
            }
         return;
      }

      public static function removeManager(param1:String) : void {
         managers.splice(managers.indexOf(managerTable[param1]),1);
         if(managerTable[param1] is ILiveManager)
            {
               liveManagers--;
            }
         delete managerTable[[param1]];
         return;
      }

      public static function hasItem(param1:IUpdatable) : Boolean {
         return !(items[param1]==null);
      }

      public static function addItem(param1:IUpdatable) : Boolean {
         var _loc3_:IManager = null;
         var _loc2_:int = param1.pulseInterval;
         if(items[param1])
            {
               if(items[param1]==param1.pulseInterval)
                  {
                     return false;
                  }
               removeItem(param1);
            }
         if(lockedPulses[_loc2_]==true)
            {
               delayedPulses[_loc2_]=true;
               addQueue[param1]=true;
            }
         items[param1]=_loc2_;
         if(!timers[_loc2_])
            {
               addPulse(_loc2_);
               itemCounts[_loc2_]=1;
            }
         else
            {
               itemCounts[_loc2_]++;
            }
         if(param1 is IManageable)
            {
               for each (_loc3_ in managers)
                  {
                     _loc3_.reserve(param1 as IManageable);
                  }
            }
         return true;
      }

      public static function removeItem(param1:IUpdatable) : Boolean {
         var _loc3_:IManager = null;
         if(items[param1]==null)
            {
               return false;
            }
         var _loc2_:int = items[param1];
         if(--itemCounts[_loc2_]==0)
            {
               removePulse(_loc2_);
               delete itemCounts[[_loc2_]];
            }
         delete items[[param1]];
         delete addQueue[[param1]];
         if(param1 is IManageable)
            {
               for each (_loc3_ in managers)
                  {
                     _loc3_.release(param1 as IManageable);
                  }
            }
         return true;
      }

      public static function clear(param1:Number=NaN) : uint {
         var _loc4_:Object = null;
         var _loc2_:Boolean = isNaN(param1);
         var _loc3_:Number = 0;
         for (_loc4_ in items)
            {
               if((_loc2_)||items[_loc4_]==param1)
                  {
                     if(removeItem(_loc4_ as IUpdatable)==true)
                        {
                           _loc3_++;
                        }
                  }
            }
         return _loc3_;
      }

      public static function getCount(param1:Number=NaN) : uint {
         var _loc3_:* = 0;
         if(!isNaN(param1))
            {
               return itemCounts[param1];
            }
         var _loc2_:Number = 0;
         for each (_loc3_ in itemCounts)
            {
               _loc2_=_loc2_+_loc3_;
            }
         return _loc2_;
      }

      public static function getPaused() : Boolean {
         return paused;
      }

      public static function setPaused(param1:Boolean=true, param2:Number=NaN) : uint {
         var _loc7_:Object = null;
         var _loc8_:* = 0;
         if(paused==param1)
            {
               return 0;
            }
         var _loc3_:Number = 0;
         var _loc4_:* = false;
         var _loc5_:Boolean = isNaN(param2);
         var _loc6_:String = param1?"pause":"resume";
         for (_loc7_ in items)
            {
               _loc8_=items[_loc7_] as int;
               if((_loc5_)||_loc8_==param2)
                  {
                     _loc4_=(_loc4_)||(param1?removePulse(_loc8_):addPulse(_loc8_));
                     if(_loc7_.hasOwnProperty(_loc6_))
                        {
                           if(_loc7_[_loc6_] is Function)
                              {
                                 _loc7_[_loc6_].apply(_loc7_);
                                 _loc3_++;
                              }
                        }
                  }
            }
         if(_loc4_)
            {
               paused=param1;
            }
         return _loc3_;
      }

      private static function update(param1:Event) : void {
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc2_:Number = getTimer();
         var _loc3_:int = param1 is TimerEvent?(param1.target as Timer).delay:ENTER_FRAME;
         lockedPulses[_loc3_]=true;
         var _loc4_:* = liveManagers<0;
         if(_loc4_)
            {
               _loc5_=[];
            }
         for (_loc6_ in items)
            {
               if(items[_loc6_]==_loc3_&&!addQueue[_loc6_])
                  {
                     (_loc6_ as IUpdatable).update(_loc2_);
                     if(_loc4_)
                        {
                           _loc5_.push(_loc6_);
                        }
                  }
            }
         lockedPulses[_loc3_]=false;
         if(delayedPulses[_loc3_])
            {
               for (_loc6_ in addQueue)
                  {
                     delete addQueue[[_loc6_]];
                  }
               delete delayedPulses[[_loc3_]];
            }
         if(_loc4_)
            {
               for each (_loc7_ in managers)
                  {
                     if(_loc7_ is ILiveManager)
                        {
                           (_loc7_ as ILiveManager).onUpdate(_loc3_,_loc5_,_loc2_);
                        }
                  }
            }
         return;
      }

      private static function addPulse(param1:int) : Boolean {
         if(param1==ENTER_FRAME)
            {
               if(!pulseSprite)
                  {
                     timers[ENTER_FRAME]=pulseSprite=new Sprite();
                     pulseSprite.addEventListener(Event.ENTER_FRAME,update);
                  }
               return true;
            }
         var _loc2_:Timer = timers[param1] as Timer;
         if(!_loc2_)
            {
               _loc2_=timers[param1]=new Timer(param1);
               (timers[param1] as Timer).addEventListener(TimerEvent.TIMER,update);
               _loc2_.start();
               return true;
            }
         return false;
      }

      private static function removePulse(param1:int) : Boolean {
         if(param1==ENTER_FRAME)
            {
               if(pulseSprite)
                  {
                     pulseSprite.removeEventListener(Event.ENTER_FRAME,update);
                     delete timers[[ENTER_FRAME]];
                     pulseSprite=null;
                     return true;
                  }
            }
         var _loc2_:Timer = timers[param1] as Timer;
         if(_loc2_)
            {
               _loc2_.stop();
               _loc2_.removeEventListener(TimerEvent.TIMER,update);
               delete timers[[param1]];
               return true;
            }
         return false;
      }


   }

}