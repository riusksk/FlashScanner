package org.flowplayer.model
{
   import org.flowplayer.util.Log;
   import org.flowplayer.util.ObjectConverter;


   class PluginMethodHelper extends Object
   {
         

      function PluginMethodHelper() {
         super();
         return;
      }

      private static var log:Log = new Log("org.flowplayer.model::PluginMethodHelper");

      public static function getMethod(param1:Array, param2:String) : PluginMethod {
         var _loc4_:PluginMethod = null;
         var _loc3_:Number = 0;
         while(_loc3_<param1.length)
            {
               _loc4_=param1[_loc3_];
               if(_loc4_.externalName==param2)
                  {
                     return _loc4_;
                  }
               _loc3_++;
            }
         return null;
      }

      public static function invokePlugin(param1:Callable, param2:Object, param3:String, param4:Array) : Object {
         var _loc5_:PluginMethod = param1.getMethod(param3);
         if(!_loc5_)
            {
               throw new Error("Plugin does not have the specified method \'"+param3+"\'");
            }
         if(_loc5_.isGetter)
            {
               log.debug("calling getter \'"+_loc5_.internalName+"\', of callable object "+param1);
               return convert(_loc5_,param2[_loc5_.internalName]);
            }
         if(_loc5_.isSetter)
            {
               log.debug("calling setter \'"+_loc5_.internalName+"\', of callable object "+param1);
               param2[_loc5_.internalName]=param4[0];
               return undefined;
            }
         log.debug("calling method \'"+_loc5_.internalName+"\', of callable object "+param1);
         return convert(_loc5_,param2[_loc5_.internalName].apply(param2,param4));
      }

      private static function convert(param1:PluginMethod, param2:Object) : Object {
         log.debug(param1.internalName+", convertResult "+param1.convertResult);
         return param1.convertResult?new ObjectConverter(param2).convert():param2;
      }

      public static function methodNames(param1:Array) : Array {
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_<param1.length)
            {
               _loc2_.push(PluginMethod(param1[_loc3_]).externalName);
               _loc3_++;
            }
         return _loc2_;
      }


   }

}