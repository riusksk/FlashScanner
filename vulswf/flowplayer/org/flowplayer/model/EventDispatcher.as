package org.flowplayer.model
{
   import org.flowplayer.util.Log;
   import flash.utils.Dictionary;
   import org.flowplayer.flow_internal;

   use namespace flow_internal;

   public class EventDispatcher extends Object
   {
         

      public function EventDispatcher() {
         this.log=new Log(this);
         this._beforeListeners=new Dictionary();
         this._listeners=new Dictionary();
         super();
         return;
      }

      protected static var _playerId:String;

      public static function set playerId(param1:String) : void {
         _playerId=param1;
         return;
      }

      protected var log:Log;

      private var _beforeListeners:Dictionary;

      private var _listeners:Dictionary;

      public final function unbind(param1:Function, param2:EventType=null, param3:Boolean=false) : void {
         if(param2)
            {
               this.removeListener(param2,param1,param3);
            }
         else
            {
               this.removeAllEventsListener(param1,param3);
            }
         return;
      }

      flow_internal function setListener(param1:EventType, param2:Function, param3:Function=null, param4:Boolean=false, param5:Boolean=false) : void {
         if(param1)
            {
               this.addListener(param1,new EventListener(param2,param3),param4,param5);
            }
         else
            {
               this.log.debug("adding listeners, beforePhase "+param4);
               this.addAllEventsListener(param4?this.cancellableEvents:this.allEvents,new EventListener(param2,param3),param4,param5);
            }
         return;
      }

      protected function get cancellableEvents() : Dictionary {
         throw new Error("cancellableEvents should be overridden the subclass");
      }

      protected function get allEvents() : Dictionary {
         throw new Error("allEvents should be overridden the subclass");
      }

      private function removeAllEventsListener(param1:Function, param2:Boolean) : void {
         var _loc3_:Object = null;
         for each (_loc3_ in param2?this.cancellableEvents:this.allEvents)
            {
               this.removeListener(_loc3_ as ClipEventType,param1,param2);
            }
         return;
      }

      private function addAllEventsListener(param1:Dictionary, param2:EventListener, param3:Boolean, param4:Boolean=false) : void {
         var _loc5_:Object = null;
         this.log.debug("addAllEventsListener, beforePhase "+param3);
         for each (_loc5_ in param1)
            {
               this.addListener(_loc5_ as ClipEventType,param2,param3,param4);
            }
         return;
      }

      private function dispatchExternalEvent(param1:AbstractEvent, param2:Boolean=false) : void {
         if(!_playerId)
            {
               return;
            }
         var _loc3_:Boolean = param1.fireExternal(_playerId,param2);
         if(!_loc3_)
            {
               this.log.debug("preventing default");
               param1.preventDefault();
            }
         return;
      }

      flow_internal  final function doDispatchBeforeEvent(param1:AbstractEvent, param2:Boolean) : Boolean {
         this.log.debug("doDispatchBeforeEvent, fireExternal "+param2);
         if(!param1.isCancellable())
            {
               this.log.debug("event is not cancellable, will not fire event, propagation is allowed");
               return true;
            }
         if(param1.target==null)
            {
               param1.target=this;
            }
         if(param2)
            {
               this.dispatchExternalEvent(param1,true);
            }
         this._dispatchEvent(param1,this._beforeListeners);
         return !param1.isDefaultPrevented();
      }

      flow_internal  final function doDispatchEvent(param1:AbstractEvent, param2:Boolean) : void {
         if(param1.info is ErrorCode)
            {
               this.doDispatchErrorEvent(param1,param2);
               return;
            }
         if(param1.target==null)
            {
               param1.target=this;
            }
         this._dispatchEvent(param1,this._listeners);
         if(param2)
            {
               this.dispatchExternalEvent(param1);
            }
         return;
      }

      flow_internal  final function doDispatchErrorEvent(param1:AbstractEvent, param2:Boolean) : void {
         if(param1.target==null)
            {
               param1.target=this;
            }
         if(param2)
            {
               param1.fireErrorExternal(_playerId);
            }
         this._dispatchEvent(param1,this._listeners);
         return;
      }

      private function _dispatchEvent(param1:AbstractEvent, param2:Dictionary) : void {
         var _loc6_:EventListener = null;
         this.log.info(this+" dispatchEvent(), event "+param1);
         var _loc3_:Array = param2[param1.eventType];
         var _loc4_:Array = [];
         if(!_loc3_)
            {
               this.log.debug(this+": dispatchEvent(): no listeners for event "+param1.eventType+(param2==this._beforeListeners?" in before phase":""));
               return;
            }
         var _loc5_:Number = 0;
         while(_loc5_<_loc3_.length)
            {
               _loc6_=_loc3_[_loc5_];
               if(_loc4_.indexOf(_loc6_)<0)
                  {
                     if(_loc6_==null)
                        {
                           this.log.error("found null listener");
                        }
                     _loc6_.notify(param1);
                     _loc4_.push(_loc6_);
                     if(param1.isPropagationStopped())
                        {
                           return;
                        }
                  }
               _loc5_++;
            }
         return;
      }

      private function addListener(param1:EventType, param2:EventListener, param3:Boolean, param4:Boolean=false) : void {
         this.log.debug(this+": adding listener for event "+param1+(param3?" to before phase":""));
         var _loc5_:Dictionary = param3?this._beforeListeners:this._listeners;
         var _loc6_:Array = _loc5_[param1];
         if(!_loc6_)
            {
               _loc6_=new Array();
               _loc5_[param1]=_loc6_;
            }
         if(!this.hasListener(param1,param2))
            {
               if(param4)
                  {
                     _loc6_.splice(0,0,param2);
                  }
               else
                  {
                     _loc6_.push(param2);
                  }
            }
         return;
      }

      function removeListener(param1:EventType, param2:Function, param3:Boolean=false) : void {
         this.doRemoveListener(param3?this._beforeListeners:this._listeners,param1,param2);
         return;
      }

      private function doRemoveListener(param1:Dictionary, param2:EventType, param3:Function) : void {
         var _loc6_:EventListener = null;
         var _loc4_:Array = param1[param2];
         if(!_loc4_)
            {
               return;
            }
         var _loc5_:Number = 0;
         while(_loc5_<_loc4_.length)
            {
               _loc6_=_loc4_[_loc5_];
               if(_loc6_.listener==param3)
                  {
                     _loc4_.splice(_loc5_,1);
                  }
               _loc5_++;
            }
         return;
      }

      private function hasListener(param1:EventType, param2:EventListener) : Boolean {
         var _loc5_:EventListener = null;
         var _loc3_:Array = this._listeners[param1];
         if(!_loc3_)
            {
               return false;
            }
         var _loc4_:Number = 0;
         while(_loc4_<_loc3_.length)
            {
               _loc5_=_loc3_[_loc4_];
               if(_loc5_.listener==param2.listener)
                  {
                     return true;
                  }
               _loc4_++;
            }
         return false;
      }
   }

}