package org.flowplayer.model
{
   import flash.events.Event;
   import org.flowplayer.util.Log;
   import org.flowplayer.flow_internal;
   import flash.external.ExternalInterface;
   import org.flowplayer.util.ObjectConverter;

   use namespace flow_internal;

   public class AbstractEvent extends Event
   {
         

      public function AbstractEvent(param1:EventType, param2:Object=null, param3:Object=null, param4:Object=null, param5:Object=null, param6:Object=null) {
         this.log=new Log(this);
         super(param1.name);
         this._eventType=param1;
         this._info=param2;
         this._info2=param3;
         this._info3=param4;
         this._info4=param5;
         this._info5=param6;
         this._target=this.target;
         this.log.debug(this._info+", "+this._info2+", "+this._info3+", "+this._info4+", "+this._info5);
         return;
      }



      protected var log:Log;

      private var _info:Object;

      private var _info2:Object;

      private var _info3:Object;

      private var _info4:Object;

      private var _info5:Object;

      private var _eventType:EventType;

      private var _target:Object;

      private var _propagationStopped:Boolean;

      private var _isDefaultPrevented:Boolean;

      public function get error() : ErrorCode {
         return this._info as ErrorCode;
      }

      public function isCancellable() : Boolean {
         return this._eventType.isCancellable;
      }

      override  public function clone() : Event {
         return new AbstractEvent(this._eventType,this._info);
      }

      override  public function toString() : String {
         return formatToString("AbstractEvent","type","target","info","info2","info3","info4","info5");
      }

      public function get info() : Object {
         return this._info;
      }

      override  public function get target() : Object {
         if(this._target)
            {
               return this._target;
            }
         return super.target;
      }

      public function set target(param1:Object) : void {
         this._target=param1;
         return;
      }

      public function get eventType() : EventType {
         return this._eventType;
      }

      override  public function stopPropagation() : void {
         this._propagationStopped=true;
         return;
      }

      override  public function stopImmediatePropagation() : void {
         this._propagationStopped=true;
         return;
      }

      public function isPropagationStopped() : Boolean {
         return this._propagationStopped;
      }

      flow_internal function fireErrorExternal(param1:String) : void {
         var playerId:String = param1;
         try
            {
               ExternalInterface.call("flowplayer.fireEvent",(playerId)||(ExternalInterface.objectID),this.getExternalName(this.eventType.name,false),ErrorCode(this._info).code,ErrorCode(this._info).message+this.info2?": "+this.info2:"");
            }
         catch(e:Error)
            {
               log.error("Error in fireErrorExternal() "+e);
            }
         return;
      }

      flow_internal function fireExternal(param1:String, param2:Boolean=false) : Boolean {
         var returnVal:Object = null;
         var playerId:String = param1;
         var beforePhase:Boolean = param2;
         this.log.debug("fireExternal "+this.getExternalName(this.eventType.name,beforePhase)+", "+this.externalEventArgument+", "+this.externalEventArgument2+", "+this.externalEventArgument3+","+this.externalEventArgument4+", "+this.externalEventArgument5);
         if(!ExternalInterface.available)
            {
               return true;
            }
         try
            {
               returnVal=ExternalInterface.call("flowplayer.fireEvent",(playerId)||(ExternalInterface.objectID),this.getExternalName(this.eventType.name,beforePhase),this.convert(this.externalEventArgument),this.convert(this.externalEventArgument2),this.externalEventArgument3,this.externalEventArgument4,this.externalEventArgument5);
            }
         catch(e:Error)
            {
               log.error("Error in fireExternal() "+e);
            }
         if(returnVal+""=="false")
            {
               return false;
            }
         return true;
      }

      private function convert(param1:Object) : Object {
         if(this._eventType.custom)
            {
               return param1;
            }
         return new ObjectConverter(param1).convert();
      }

      protected function getExternalName(param1:String, param2:Boolean) : String {
         if(!param2)
            {
               return param1;
            }
         if(!param1.indexOf("on")==0)
            {
               return "onBefore"+param1;
            }
         return "onBefore"+param1.substr(2);
      }

      protected function get externalEventArgument() : Object {
         return this.target;
      }

      protected function get externalEventArgument2() : Object {
         return this._info;
      }

      protected function get externalEventArgument3() : Object {
         return this._info2;
      }

      protected function get externalEventArgument4() : Object {
         return this._info3;
      }

      protected function get externalEventArgument5() : Object {
         return this._info4;
      }

      override  public function isDefaultPrevented() : Boolean {
         return this._isDefaultPrevented;
      }

      override  public function preventDefault() : void {
         this._isDefaultPrevented=true;
         return;
      }

      public function get info2() : Object {
         return this._info2;
      }

      public function get info3() : Object {
         return this._info3;
      }

      public function get info4() : Object {
         return this._info4;
      }

      public function get info5() : Object {
         return this._info5;
      }
   }

}