package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import flash.net.NetConnection;
   import org.flowplayer.model.Clip;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.adobe.utils.ArrayUtil;
   import flash.events.NetStatusEvent;


   public class ParallelRTMPConnectionProvider extends Object implements ConnectionProvider
   {
         

      public function ParallelRTMPConnectionProvider(param1:String, param2:String="best", param3:int=250) {
         this.log=new Log(this);
         super();
         this._netConnectionUrl=param1;
         this._proxyType=param2;
         this._failOverDelay=param3;
         this.log.debug("ParallelRTMPConnectionProvider created");
         return;
      }



      protected var log:Log;

      protected var _successListener:Function;

      protected var _failureListener:Function;

      protected var _connectionClient:Object;

      protected var _rtmpConnector:ParallelRTMPConnector;

      protected var _rtmptConnector:ParallelRTMPConnector;

      private var _succeededConnector:ParallelRTMPConnector;

      protected var _connection:NetConnection;

      protected var _netConnectionUrl:String;

      protected var _proxyType:String;

      protected var _failOverDelay:int;

      public function connect(param1:StreamProvider, param2:Clip, param3:Function, param4:uint, param5:Array) : void {
         var connArgs:Array = null;
         var delay:Timer = null;
         var ignored:StreamProvider = param1;
         var clip:Clip = param2;
         var successListener:Function = param3;
         var objectEncoding:uint = param4;
         var connectionArgs:Array = param5;
         this._successListener=successListener;
         var configuredUrl:String = this.getNetConnectionUrl(clip);
         if(!configuredUrl&&!(this._failureListener==null))
            {
               this._failureListener("netConnectionURL is not defined");
            }
         var parts:Array = this.getUrlParts(configuredUrl);
         connArgs=(clip.getCustomProperty("connectionArgs") as Array)||(connectionArgs);
         if(this.hasConnectionToSameServerWithSameArgs(parts[1],connArgs))
            {
               this.log.debug("already connected to server "+parts[1]+", with same connection arguments -> calling success listener");
               if(successListener!=null)
                  {
                     successListener(this._connection);
                  }
               return;
            }
         successListener=null;
         if(this._connection)
            {
               this.log.debug("doConnect(): closing previous connection");
               this._connection.close();
               this._connection=null;
            }
         if((parts)&&(parts[0]=="rtmp"||parts[0]=="rtmpe"))
            {
               this.log.debug("will connect using RTMP and RTMPT in parallel, connectionClient "+this._connectionClient);
               this._rtmpConnector=this.createConnector((parts[0]=="rtmp"?"rtmp":"rtmpe")+"://"+parts[1]);
               this._rtmptConnector=this.createConnector((parts[0]=="rtmp"?"rtmpt":"rtmpte")+"://"+parts[1]);
               this.doConnect(this._rtmpConnector,this._proxyType,objectEncoding,connArgs);
               delay=new Timer(this._failOverDelay,1);
               delay.addEventListener(TimerEvent.TIMER,new function(param1:TimerEvent):void
                  {
                     doConnect(_rtmptConnector,_proxyType,objectEncoding,connArgs);
                     return;
                     });
                     delay.start();
                  }
               else
                  {
                     this.log.debug("connecting to URL "+configuredUrl);
                     this._rtmpConnector=this.createConnector(configuredUrl);
                     this.doConnect(this._rtmpConnector,this._proxyType,objectEncoding,connArgs);
                  }
               return;
      }

      private function hasConnectionToSameServerWithSameArgs(param1:String, param2:Array) : Boolean {
         this.log.debug("hasConnectionToSameServerWithSameArgs ? previous URI == "+((this._connection)&&(this._connection.uri)));
         if(!this._succeededConnector)
            {
               return false;
            }
         if(!this._connection)
            {
               return false;
            }
         if(!this._connection.connected)
            {
               return false;
            }
         var _loc3_:Array = this.getUrlParts(this._connection.uri);
         this.log.debug("hasConnectionToSameServerWithSameArgs ? previous host == "+_loc3_[1]+" current host == "+param1);
         if(param1!=_loc3_[1])
            {
               return false;
            }
         this.log.debug("hasConnectionToSameServerWithSameArgs(), old connection args:",this._succeededConnector.connectionArgs);
         this.log.debug("hasConnectionToSameServerWithSameArgs(), new connection args:",param2);
         if((this.hasElements(param2))&&!this.hasElements(this._succeededConnector.connectionArgs)||!this.hasElements(param2)&&(this.hasElements(this._succeededConnector.connectionArgs)))
            {
               this.log.debug("connection args arrays are different (empty and non-empty)");
               return false;
            }
         if((param2)&&(this._succeededConnector.connectionArgs)&&!ArrayUtil.arraysAreEqual(this._succeededConnector.connectionArgs,param2))
            {
               this.log.debug("connection args arrays are nonequal");
               return false;
            }
         return true;
      }

      private function hasElements(param1:Array) : Boolean {
         return (param1)&&param1.length<0;
      }

      protected function createConnector(param1:String) : ParallelRTMPConnector {
         return new ParallelRTMPConnector(param1,this.connectionClient,this.onConnectorSuccess,this.onConnectorFailure);
      }

      private function doConnect(param1:ParallelRTMPConnector, param2:String, param3:uint, param4:Array) : void {
         if(param4.length>0)
            {
               param1.connect(this._proxyType,param3,param4);
            }
         else
            {
               param1.connect(this._proxyType,param3,null);
            }
         return;
      }

      protected function onConnectorSuccess(param1:ParallelRTMPConnector, param2:NetConnection) : void {
         this.log.debug(param1+" established a connection");
         if(this._connection)
            {
               return;
            }
         this._connection=param2;
         this._succeededConnector=param1;
         if(param1==this._rtmptConnector&&(this._rtmpConnector))
            {
               this._rtmpConnector.stop();
            }
         else
            {
               if(this._rtmptConnector)
                  {
                     this._rtmptConnector.stop();
                  }
            }
         this._successListener(param2);
         return;
      }

      protected function onConnectorFailure(param1:String=null) : void {
         if((this.isFailedOrNotUsed(this._rtmpConnector))&&(this.isFailedOrNotUsed(this._rtmptConnector))&&!(this._failureListener==null))
            {
               this._failureListener(param1);
            }
         return;
      }

      private function isFailedOrNotUsed(param1:ParallelRTMPConnector) : Boolean {
         if(!param1)
            {
               return true;
            }
         return param1.failed;
      }

      private function getUrlParts(param1:String) : Array {
         var _loc2_:int = param1.indexOf("://");
         if(_loc2_>0)
            {
               return [param1.substring(0,_loc2_),param1.substring(_loc2_+3)];
            }
         return null;
      }

      protected function getNetConnectionUrl(param1:Clip) : String {
         var _loc2_:String = null;
         var _loc3_:* = NaN;
         if((param1.customProperties)&&(param1.customProperties.netConnectionUrl))
            {
               this.log.debug("clip has netConnectionUrl as a property "+param1.customProperties.netConnectionUrl);
               return param1.customProperties.netConnectionUrl;
            }
         if(this.isRtmpUrl(param1.completeUrl))
            {
               this.log.debug("clip has complete rtmp url");
               _loc2_=param1.completeUrl;
               _loc3_=_loc2_.lastIndexOf("/");
               return _loc2_.substring(0,_loc3_);
            }
         this.log.debug("using netConnectionUrl from config"+this._netConnectionUrl);
         return this._netConnectionUrl;
      }

      protected function isRtmpUrl(param1:String) : Boolean {
         return (param1)&&param1.toLowerCase().indexOf("rtmp")==0;
      }

      public function set connectionClient(param1:Object) : void {
         this.log.debug("received connection client "+param1);
         this._connectionClient=param1;
         return;
      }

      public function get connectionClient() : Object {
         if(!this._connectionClient)
            {
               this._connectionClient=new NetConnectionClient();
            }
         this.log.debug("using connection client "+this._connectionClient);
         return this._connectionClient;
      }

      public function set onFailure(param1:Function) : void {
         this._failureListener=param1;
         return;
      }

      public function handeNetStatusEvent(param1:NetStatusEvent) : Boolean {
         return true;
      }

      public function get connection() : NetConnection {
         return this._connection;
      }
   }

}