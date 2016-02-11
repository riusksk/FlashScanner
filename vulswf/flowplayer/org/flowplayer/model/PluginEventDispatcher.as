package org.flowplayer.model
{
   import org.flowplayer.flow_internal;
   import flash.utils.Dictionary;

   use namespace flow_internal;

   public class PluginEventDispatcher extends EventDispatcher
   {
         

      public function PluginEventDispatcher() {
         super();
         return;
      }



      public function dispatch(param1:PluginEventType, param2:Object=null, param3:Object=null, param4:Object=null, param5:Object=null) : void {
         doDispatchEvent(new PluginEvent(param1,this.name,param2,param3,param4,param5),true);
         return;
      }

      public function dispatchOnLoad() : void {
         this.dispatch(PluginEventType.LOAD);
         return;
      }

      public function dispatchError(param1:PluginError, param2:Object=null) : void {
         doDispatchErrorEvent(new PluginEvent(param1.eventType as PluginEventType,this.name,param1,param2),true);
         return;
      }

      public function dispatchBeforeEvent(param1:PluginEventType, param2:Object=null, param3:Object=null, param4:Object=null, param5:Object=null) : Boolean {
         return doDispatchBeforeEvent(new PluginEvent(param1,this.name,param2,param3,param4,param5),true);
      }

      public function dispatchEvent(param1:PluginEvent) : void {
         doDispatchEvent(param1,true);
         return;
      }

      public function onPluginEvent(param1:Function) : void {
         setListener(PluginEventType.PLUGIN_EVENT,param1);
         return;
      }

      public function onBeforePluginEvent(param1:Function) : void {
         setListener(PluginEventType.PLUGIN_EVENT,param1,null,true);
         return;
      }

      public function onLoad(param1:Function) : void {
         setListener(PluginEventType.LOAD,param1);
         return;
      }

      public function onError(param1:Function) : void {
         setListener(PluginEventType.ERROR,param1);
         return;
      }

      override  protected function get cancellableEvents() : Dictionary {
         return PluginEventType.cancellable;
      }

      override  protected function get allEvents() : Dictionary {
         return PluginEventType.all;
      }

      public function get name() : String {
         return null;
      }
   }

}