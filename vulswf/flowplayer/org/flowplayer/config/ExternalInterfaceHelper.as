package org.flowplayer.config
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Callable;
   import flash.external.ExternalInterface;
   import flash.utils.describeType;
   import org.flowplayer.model.PluginMethod;


   public class ExternalInterfaceHelper extends Object
   {
         

      public function ExternalInterfaceHelper() {
         super();
         return;
      }

      private static var log:Log = new Log("org.flowplayer.config::ExternalInterfaceHelper");

      public static function initializeInterface(param1:Callable, param2:Object) : void {
         var xml:XML = null;
         var exposedNode:XML = null;
         var callable:Callable = param1;
         var plugin:Object = param2;
         if(!ExternalInterface.available)
            {
               return;
            }
         xml=describeType(plugin);
         var exposed:XMLList = xml.*.((hasOwnProperty("metadata"))&&metadata.@name=="External");
         log.info("Number of exposed methods and accessors: "+exposed.length());
         for each (exposedNode in exposed)
            {
               log.debug("processing exposed method or accessor "+exposedNode);
               addMethods(callable,exposedNode,plugin);
            }
         return;
      }

      private static function addMethods(param1:Callable, param2:XML, param3:Object) : void {
         var _loc6_:String = null;
         var _loc4_:String = param2.@name;
         var _loc5_:Boolean = param2.metadata.arg.@key=="convert"?param2.metadata.arg.@value=="true":false;
         log.debug("------------"+_loc4_+", has return value "+!(param2.@returnType=="void")+", convertResult "+_loc5_);
         if(param2.name()=="method")
            {
               param1.addMethod(PluginMethod.method(_loc4_,_loc4_,!(param2.@returnType=="void"),_loc5_));
            }
         else
            {
               if(param2.name()=="accessor")
                  {
                     _loc6_=_loc4_.charAt(0).toUpperCase()+_loc4_.substring(1);
                     if(param2.@access=="readwrite")
                        {
                           param1.addMethod(PluginMethod.getter("get"+_loc6_,_loc4_,_loc5_));
                           param1.addMethod(PluginMethod.setter("set"+_loc6_,_loc4_));
                        }
                     else
                        {
                           if(param2.@access=="readonly")
                              {
                                 param1.addMethod(PluginMethod.getter("get"+_loc6_,_loc4_,_loc5_));
                              }
                           else
                              {
                                 param1.addMethod(PluginMethod.setter("set"+_loc6_,_loc4_));
                              }
                        }
                  }
            }
         return;
      }

      public static function addCallback(param1:String, param2:Function) : void {
         var methodName:String = param1;
         var func:Function = param2;
         try
            {
               ExternalInterface.addCallback(methodName,func);
            }
         catch(error:Error)
            {
               log.error("Unable to register callback for "+error);
            }
         return;
      }


   }

}