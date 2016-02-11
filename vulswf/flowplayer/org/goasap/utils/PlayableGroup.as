package org.goasap.utils
{
   import org.goasap.PlayableBase;
   import org.goasap.interfaces.IPlayable;
   import org.goasap.managers.Repeater;
   import flash.utils.Dictionary;
   import org.goasap.events.GoEvent;


   public class PlayableGroup extends PlayableBase implements IPlayable
   {
         

      public function PlayableGroup(... rest) {
         this._children=new Dictionary();
         super();
         if(rest.length>0)
            {
               this.children=rest[0] is Array?rest[0]:rest;
            }
         this._repeater=new Repeater();
         this._repeater.setParent(this);
         return;
      }



      public function get children() : Array {
         var _loc2_:Object = null;
         var _loc1_:Array = [];
         for (_loc2_ in this._children)
            {
               _loc1_.push(_loc2_);
            }
         return _loc1_;
      }

      public function set children(param1:Array) : void {
         var _loc2_:Object = null;
         if(this._listeners>0)
            {
               this.stop();
            }
         for each (_loc2_ in param1)
            {
               if(_loc2_ is IPlayable)
                  {
                     this.addChild(_loc2_ as IPlayable);
                  }
            }
         return;
      }

      public function get repeater() : Repeater {
         return this._repeater;
      }

      public function get listenerCount() : uint {
         return this._listeners;
      }

      protected var _children:Dictionary;

      protected var _listeners:uint = 0;

      protected var _repeater:Repeater;

      public function getChildByID(param1:*, param2:Boolean=true) : IPlayable {
         var _loc3_:Object = null;
         var _loc4_:IPlayable = null;
         for (_loc3_ in this._children)
            {
               if((_loc3_ as IPlayable).playableID===param1)
                  {
                     return _loc3_ as IPlayable;
                  }
            }
         if(param2)
            {
               for (_loc3_ in this._children)
                  {
                     if(_loc3_ is PlayableGroup)
                        {
                           _loc4_=(_loc3_ as PlayableGroup).getChildByID(param1,true);
                           if(_loc4_)
                              {
                                 return _loc4_ as IPlayable;
                              }
                        }
                  }
            }
         return null;
      }

      public function addChild(param1:IPlayable, param2:Boolean=false) : Boolean {
         var _loc3_:IPlayable = null;
         var _loc4_:* = false;
         var _loc5_:IPlayable = null;
         var _loc6_:* = false;
         if(this._children[param1])
            {
               return false;
            }
         if(param1.state!=_state)
            {
               _loc3_=param2?param1:this;
               _loc4_=_loc3_.state==PLAYING||_loc3_.state==PLAYING_DELAY;
               _loc5_=param2?this:param1;
               _loc6_=_loc5_.state==PLAYING||_loc5_.state==PLAYING_DELAY;
               if(!((_loc4_)&&(_loc6_)))
                  {
                     switch(_loc3_.state)
                        {
                           case STOPPED:
                              _loc5_.stop();
                              break;
                           case PAUSED:
                              if(_loc5_.state==STOPPED)
                                 {
                                    _loc5_.start();
                                 }
                              _loc5_.pause();
                              break;
                           case PLAYING:
                           case PLAYING_DELAY:
                              if(_loc5_.state==PAUSED)
                                 {
                                    _loc5_.resume();
                                 }
                              else
                                 {
                                    if(_loc5_.state==STOPPED)
                                       {
                                          if(param2)
                                             {
                                                _state=PLAYING;
                                                dispatchEvent(new GoEvent(GoEvent.START));
                                             }
                                          else
                                             {
                                                _loc5_.start();
                                             }
                                       }
                                 }
                              break;
                        }
                  }
            }
         this._children[param1]=false;
         if(_state!=STOPPED)
            {
               this.listenTo(param1);
            }
         return true;
      }

      public function removeChild(param1:IPlayable) : Boolean {
         var _loc2_:* = this._children[param1];
         if(_loc2_===null)
            {
               return false;
            }
         if(_loc2_===true)
            {
               this.unListenTo(param1);
            }
         delete this._children[[param1]];
         return true;
      }

      public function anyChildHasState(param1:String) : Boolean {
         var _loc2_:Object = null;
         for (_loc2_ in this._children)
            {
               if((_loc2_ as IPlayable).state==param1)
                  {
                     return true;
                  }
            }
         return false;
      }

      public function start() : Boolean {
         var _loc2_:Object = null;
         var _loc3_:* = false;
         this.stop();
         var _loc1_:* = false;
         for (_loc2_ in this._children)
            {
               _loc3_=(_loc2_ as IPlayable).start();
               if(_loc3_)
                  {
                     this.listenTo(_loc2_ as IPlayable);
                  }
               _loc1_=(_loc3_)||(_loc1_);
            }
         if(!_loc1_)
            {
               return false;
            }
         _state=PLAYING;
         dispatchEvent(new GoEvent(GoEvent.START));
         _playRetainer[this]=1;
         return true;
      }

      public function stop() : Boolean {
         var _loc2_:Object = null;
         if(_state==STOPPED)
            {
               return false;
            }
         _state=STOPPED;
         this._repeater.reset();
         delete _playRetainer[[this]];
         if(this._listeners==0)
            {
               dispatchEvent(new GoEvent(GoEvent.COMPLETE));
               return true;
            }
         var _loc1_:* = true;
         for (_loc2_ in this._children)
            {
               this.unListenTo(_loc2_ as IPlayable);
               _loc1_=((_loc2_ as IPlayable).stop())&&(_loc1_);
            }
         dispatchEvent(new GoEvent(GoEvent.STOP));
         return _loc1_;
      }

      public function pause() : Boolean {
         var _loc3_:Object = null;
         var _loc4_:* = false;
         if(_state!=PLAYING)
            {
               return false;
            }
         var _loc1_:* = true;
         var _loc2_:uint = 0;
         for (_loc3_ in this._children)
            {
               _loc4_=(_loc3_ as IPlayable).pause();
               if(_loc4_)
                  {
                     _loc2_++;
                  }
               _loc1_=(_loc1_)&&(_loc4_);
            }
         if(_loc2_>0)
            {
               _state=PAUSED;
               dispatchEvent(new GoEvent(GoEvent.PAUSE));
            }
         return _loc2_<0&&(_loc1_);
      }

      public function resume() : Boolean {
         var _loc3_:Object = null;
         var _loc4_:* = false;
         if(_state!=PAUSED)
            {
               return false;
            }
         var _loc1_:* = true;
         var _loc2_:uint = 0;
         for (_loc3_ in this._children)
            {
               _loc4_=(_loc3_ as IPlayable).resume();
               if(_loc4_)
                  {
                     _loc2_++;
                  }
               _loc1_=(_loc1_)&&(_loc4_);
            }
         if(_loc2_>0)
            {
               _state=PLAYING;
               dispatchEvent(new GoEvent(GoEvent.RESUME));
            }
         return _loc2_<0&&(_loc1_);
      }

      public function skipTo(param1:Number) : Boolean {
         var _loc4_:Object = null;
         var _loc2_:* = true;
         var _loc3_:uint = 0;
         var param1:Number = this._repeater.skipTo(this._repeater.cycles,param1);
         for (_loc4_ in this._children)
            {
               _loc2_=((_loc4_ as IPlayable).skipTo(param1))&&(_loc2_);
               this.listenTo(_loc4_ as IPlayable);
               _loc3_++;
            }
         _state=_loc2_?PLAYING:STOPPED;
         return _loc3_<0&&(_loc2_);
      }

      protected function onItemEnd(param1:GoEvent) : void {
         this.unListenTo(param1.target as IPlayable);
         if(this._listeners==0)
            {
               this.complete();
            }
         return;
      }

      protected function complete() : void {
         var _loc1_:Object = null;
         var _loc2_:* = false;
         if(this._repeater.next())
            {
               dispatchEvent(new GoEvent(GoEvent.CYCLE));
               for (_loc1_ in this._children)
                  {
                     _loc2_=(_loc1_ as IPlayable).start();
                     if(_loc2_)
                        {
                           this.listenTo(_loc1_ as IPlayable);
                        }
                  }
            }
         else
            {
               this.stop();
            }
         return;
      }

      protected function listenTo(param1:IPlayable) : void {
         if(this._children[param1]===false)
            {
               param1.addEventListener(GoEvent.STOP,this.onItemEnd,false,0,true);
               param1.addEventListener(GoEvent.COMPLETE,this.onItemEnd,false,0,true);
               this._children[param1]=true;
               this._listeners++;
            }
         return;
      }

      protected function unListenTo(param1:IPlayable) : void {
         if(this._children[param1]===true)
            {
               param1.removeEventListener(GoEvent.STOP,this.onItemEnd);
               param1.removeEventListener(GoEvent.COMPLETE,this.onItemEnd);
               this._children[param1]=false;
               this._listeners--;
            }
         return;
      }
   }

}