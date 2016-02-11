package org.flowplayer.model
{
   import org.flowplayer.flow_internal;
   import flash.external.ExternalInterface;

   use namespace flow_internal;

   public class PluginEvent extends AbstractEvent
   {
         

      public function PluginEvent(param1:PluginEventType, param2:String, param3:Object=null, param4:Object=null, param5:Object=null, param6:Object=null) {
         super(param1,param2,param4,param5,param6);
         this._id=param3;
         return;
      }

      public static const PLUGIN_EVENT:String = "onPluginEvent";

      private var _id:Object;

      override flow_internal function fireErrorExternal(param1:String) : void {
         var playerId:String = param1;
         try
            {
               ExternalInterface.call("flowplayer.fireEvent",(playerId)||(ExternalInterface.objectID),getExternalName(eventType.name,false),this.error.code,this.error.message+info2?": "+info2:"");
            }
         catch(e:Error)
            {
               log.error("Error in fireErrorExternal() "+e);
            }
         return;
      }

      override  public function get error() : ErrorCode {
         return this._id as ErrorCode;
      }

      override  public function toString() : String {
         return formatToString("PluginEvent","id","info","info2","info3","info4","info5");
      }

      public function get id() : Object {
         return this._id;
      }

      override  protected function get externalEventArgument() : Object {
         return info;
      }

      override  protected function get externalEventArgument2() : Object {
         return this._id;
      }

      override  protected function get externalEventArgument3() : Object {
         return info2;
      }

      override  protected function get externalEventArgument4() : Object {
         return info3;
      }

      override  protected function get externalEventArgument5() : Object {
         return info4;
      }
   }

}