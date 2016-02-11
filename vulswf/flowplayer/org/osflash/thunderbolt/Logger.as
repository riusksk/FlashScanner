package org.osflash.thunderbolt
{
   import flash.external.ExternalInterface;
   import flash.system.System;
   import flash.utils.describeType;


   public class Logger extends Object
   {
         

      public function Logger() {
         super();
         return;
      }

      private static function primitiveType(param1:String) : Boolean {
         var _loc2_:* = false;
         switch(param1)
            {
               case "Boolean":
               case "void":
               case "int":
               case "uint":
               case "Number":
               case "String":
               case "undefined":
               case "null":
                  _loc2_=true;
                  break;
               default:
                  _loc2_=false;
            }
         return _loc2_;
      }

      private static var _depth:int;

      public static function trace(param1:String, param2:String="", ... rest) : void {
         var _loc4_:String = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(!_hide)
            {
               _depth=0;
               _logLevel=param1;
               _loc4_="["+_logLevel.toUpperCase()+"] ";
               if(includeTime)
                  {
                     _loc4_=_loc4_+getCurrentTime();
                  }
               _loc4_=_loc4_+param2;
               ExternalInterface.call("console."+_logLevel,_loc4_);
               _loc6_=rest.length;
               _loc5_=0;
               while(_loc5_<_loc6_)
                  {
                     Logger.logObject(rest[_loc5_]);
                     _loc5_++;
                  }
            }
         return;
      }

      public static const WARN:String = "warn";

      private static const AUTHOR:String = "Jens Krause [www.websector.de]";

      public static function debug(param1:String=null, ... rest) : void {
         Logger.trace(Logger.LOG,param1,rest);
         return;
      }

      public static function about() : void {
         var _loc1_:String = null;
         _loc1_="+++ Welcome to ThunderBolt AS3 | VERSION: "+Logger.VERSION+" | AUTHOR: "+Logger.AUTHOR+" | Happy logging ;-) +++";
         Logger.trace(Logger.INFO,_loc1_);
         return;
      }

      public static var includeTime:Boolean = true;

      private static const FIELD_SEPERATOR:String = " :: ";

      public static function warn(param1:String=null, ... rest) : void {
         Logger.trace(Logger.WARN,param1,rest);
         return;
      }

      public static function error(param1:String=null, ... rest) : void {
         Logger.trace(Logger.ERROR,param1,rest);
         return;
      }

      private static var _hide:Boolean = false;

      private static var _stopLog:Boolean = false;

      public static const LOG:String = "log";

      public static function memorySnapshot() : String {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         _loc1_=System.totalMemory;
         _loc2_="Memory Snapshot: "+Math.round(_loc1_/1024/1024*100)/100+" MB ("+Math.round(_loc1_/1024)+" kb)";
         return _loc2_;
      }

      public static function set hide(param1:Boolean) : void {
         _hide=param1;
         return;
      }

      public static const ERROR:String = "error";

      private static function timeToValidString(param1:Number) : String {
         return param1<9?param1.toString():"0"+param1.toString();
      }

      public static const INFO:String = "info";

      private static const MAX_DEPTH:int = 255;

      private static function logObject(param1:*, param2:String=null) : void {
         var _loc3_:String = null;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:XMLList = null;
         var _loc11_:XML = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:* = undefined;
         if(_depth<Logger.MAX_DEPTH)
            {
               _depth++;
               _loc3_=(param2)||"";
               _loc4_=describeType(param1);
               _loc5_=_loc4_.@name;
               if(primitiveType(_loc5_))
                  {
                     _loc6_=_loc3_.length?"["+_loc5_+"] "+_loc3_+" = "+param1:"["+_loc5_+"] "+param1;
                     ExternalInterface.call("console."+Logger.LOG,_loc6_);
                  }
               else
                  {
                     if(_loc5_=="Object")
                        {
                           ExternalInterface.call("console.group","[Object] "+_loc3_);
                           for (_loc7_ in param1)
                              {
                                 logObject(param1[_loc7_],_loc7_);
                              }
                           ExternalInterface.call("console.groupEnd");
                        }
                     else
                        {
                           if(_loc5_=="Array")
                              {
                                 if(_depth>1)
                                    {
                                       ExternalInterface.call("console.group","[Array] "+_loc3_);
                                    }
                                 _loc9_=param1.length;
                                 _loc8_=0;
                                 while(_loc8_<_loc9_)
                                    {
                                       logObject(param1[_loc8_]);
                                       _loc8_++;
                                    }
                                 ExternalInterface.call("console.groupEnd");
                              }
                           else
                              {
                                 _loc10_=_loc4_..accessor;
                                 if(_loc10_.length())
                                    {
                                       for each (_loc11_ in _loc10_)
                                          {
                                             _loc12_=_loc11_.@name;
                                             _loc13_=_loc11_.@type;
                                             _loc14_=_loc11_.@access;
                                             if((_loc14_)&&!(_loc14_=="writeonly"))
                                                {
                                                   _loc15_=param1[_loc12_];
                                                   logObject(_loc15_,_loc12_);
                                                }
                                          }
                                    }
                                 else
                                    {
                                       logObject(param1,_loc5_);
                                    }
                              }
                        }
                  }
            }
         else
            {
               if(!_stopLog)
                  {
                     ExternalInterface.call("console."+Logger.WARN,"STOP LOGGING: More than "+_depth+" nested objects or properties.");
                     _stopLog=true;
                  }
            }
         return;
      }

      public static function info(param1:String=null, ... rest) : void {
         Logger.trace(Logger.INFO,param1,rest);
         return;
      }

      private static function getCurrentTime() : String {
         var _loc1_:Date = null;
         var _loc2_:String = null;
         _loc1_=new Date();
         _loc2_="time "+timeToValidString(_loc1_.getHours())+":"+timeToValidString(_loc1_.getMinutes())+":"+timeToValidString(_loc1_.getSeconds())+"."+timeToValidString(_loc1_.getMilliseconds())+FIELD_SEPERATOR;
         return _loc2_;
      }

      private static const VERSION:String = "1.0";

      private static var _logLevel:String;


   }

}