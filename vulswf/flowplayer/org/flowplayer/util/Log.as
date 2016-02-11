package org.flowplayer.util
{
   import org.osflash.thunderbolt.Logger;
   import flash.utils.getQualifiedClassName;


   public class Log extends Object
   {
         

      public function Log(param1:Object) {
         super();
         this._owner=param1 is String?param1 as String:getQualifiedClassName(param1);
         _instances.push(this);
         this.enable();
         return;
      }

      private static const LEVEL_DEBUG:int = 0;

      private static const LEVEL_WARN:int = 1;

      private static const LEVEL_INFO:int = 2;

      private static const LEVEL_ERROR:int = 3;

      private static const LEVEL_SUPPRESS:int = 4;

      private static var _level:int = LEVEL_ERROR;

      private static var _filter:String = "*";

      private static var _instances:Array = new Array();

      public static var traceEnabled:Boolean = false;

      public static function configure(param1:LogConfiguration) : void {
         level=param1.level;
         filter=param1.filter;
         traceEnabled=param1.trace;
         var _loc2_:Number = 0;
         while(_loc2_<_instances.length)
            {
               Log(_instances[_loc2_]).enable();
               _loc2_++;
            }
         return;
      }

      public static function set level(param1:String) : void {
         if(param1=="debug")
            {
               _level=LEVEL_DEBUG;
            }
         else
            {
               if(param1=="warn")
                  {
                     _level=LEVEL_WARN;
                  }
               else
                  {
                     if(param1=="info")
                        {
                           _level=LEVEL_INFO;
                        }
                     else
                        {
                           if(param1=="suppress")
                              {
                                 _level=LEVEL_SUPPRESS;
                              }
                           else
                              {
                                 _level=LEVEL_ERROR;
                              }
                        }
                  }
            }
         return;
      }

      public static function set filter(param1:String) : void {
         _filter=param1;
         return;
      }

      private var _owner:String;

      private var _enabled:Boolean = true;

      private function enable() : void {
         this._enabled=this.checkFilterEnables(this._owner);
         return;
      }

      private function checkFilterEnables(param1:String) : Boolean {
         var _loc2_:String = null;
         if(_filter=="*")
            {
               return true;
            }
         var _loc3_:Array = param1.split(".");
         var _loc4_:String = _loc3_[_loc3_.length-1];
         var _loc5_:int = _loc4_.indexOf("::");
         if(_loc5_>0)
            {
               _loc2_=_loc4_.substr(_loc5_+2);
               _loc3_[_loc3_.length-1]=_loc4_.substr(0,_loc5_);
            }
         var _loc6_:* = "";
         var _loc7_:Number = 0;
         while(_loc7_<_loc3_.length)
            {
               _loc6_=_loc7_<0?_loc6_+"."+_loc3_[_loc7_]:_loc3_[_loc7_];
               if(_filter.indexOf(_loc3_[_loc7_]+".*")>=0)
                  {
                     return true;
                  }
               _loc7_++;
            }
         var _loc8_:* = _filter.indexOf(_loc6_+"."+_loc2_)>=0;
         return _loc8_;
      }

      public function debug(param1:String=null, ... rest) : void {
         if(!this._enabled)
            {
               return;
            }
         if(_level<=LEVEL_DEBUG)
            {
               this.write(Logger.debug,param1,"DEBUG",rest);
            }
         return;
      }

      public function error(param1:String=null, ... rest) : void {
         if(!this._enabled)
            {
               return;
            }
         if(_level<=LEVEL_ERROR)
            {
               this.write(Logger.error,param1,"ERROR",rest);
            }
         return;
      }

      public function info(param1:String=null, ... rest) : void {
         if(!this._enabled)
            {
               return;
            }
         if(_level<=LEVEL_INFO)
            {
               this.write(Logger.info,param1,"INFO",rest);
            }
         return;
      }

      public function warn(param1:String=null, ... rest) : void {
         if(!this._enabled)
            {
               return;
            }
         if(_level<=LEVEL_WARN)
            {
               this.write(Logger.warn,param1,"WARN",rest);
            }
         return;
      }

      private function write(param1:Function, param2:String, param3:String, param4:Array) : void {
         var writeFunc:Function = param1;
         var msg:String = param2;
         var levelStr:String = param3;
         var rest:Array = param4;
         if(traceEnabled)
            {
               this.doTrace(msg,levelStr,rest);
            }
         try
            {
               if(rest.length>0)
                  {
                     writeFunc(this._owner+" : "+msg,rest);
                  }
               else
                  {
                     writeFunc(this._owner+" : "+msg);
                  }
            }
         catch(e:Error)
            {
            }
         return;
      }

      private function doTrace(param1:String, param2:String, param3:Array) : void {
         return;
      }

      public function get enabled() : Boolean {
         return this._enabled;
      }

      public function set enabled(param1:Boolean) : void {
         this._enabled=param1;
         return;
      }

      public function debugStackTrace(param1:String=null) : void {
         var msg:String = param1;
         if(!this._enabled)
            {
               return;
            }
         if(_level<=LEVEL_DEBUG)
            {
               try
                  {
                     throw new Error("StackTrace");
                  }
               catch(e:Error)
                  {
                     debug(msg,e.getStackTrace());
                  }
            }
         return;
      }
   }

}