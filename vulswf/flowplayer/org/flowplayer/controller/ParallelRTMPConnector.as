package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import flash.net.NetConnection;
   import flash.events.NetStatusEvent;
   import flash.utils.setTimeout;


   public class ParallelRTMPConnector extends Object
   {
         

      public function ParallelRTMPConnector(param1:String, param2:Object, param3:Function, param4:Function) {
         this.log=new Log(this);
         super();
         this._url=param1;
         this._connectionClient=param2;
         this._successListener=param3;
         this._failureListener=param4;
         this._failed=false;
         this.log.debug("created with connection client "+this._connectionClient);
         return;
      }



      protected var log:Log;

      protected var _url:String;

      protected var _successListener:Function;

      protected var _connectionClient:Object;

      protected var _connection:NetConnection;

      protected var _failureListener:Function;

      protected var _failed:Boolean;

      private var _proxyType:String;

      private var _objectEncoding:uint;

      private var _connectionArgs:Array;

      private var _attempts:int;

      public function connect(param1:String, param2:uint, param3:Array, param4:int=3) : void {
         this._proxyType=param1;
         this._objectEncoding=param2;
         this._connectionArgs=param3;
         this._attempts=param4;
         this.log.debug(this+"::connect() using proxy type \'"+param1+"\'"+", object encoding "+param2);
         if(this._successListener==null)
            {
               this.log.debug(this+", this connector has been stopped, will not proceed with connect()");
               return;
            }
         this._connection=new NetConnection();
         this._connection.proxyType=param1;
         this._connection.objectEncoding=param2;
         this.log.debug("using connection client "+this._connectionClient);
         if(this._connectionClient)
            {
               this._connection.client=this._connectionClient;
            }
         this._connection.addEventListener(NetStatusEvent.NET_STATUS,this._onConnectionStatus);
         this.log.debug("netConnectionUrl is "+this._url);
         if((param3)&&param3.length<0)
            {
               this._connection.connect.apply(this._connection,[this._url].concat(param3));
            }
         else
            {
               this._connection.connect(this._url);
            }
         return;
      }

      protected function onConnectionStatus(param1:NetStatusEvent) : void {
         return;
      }

      private function _onConnectionStatus(param1:NetStatusEvent) : void {
         var event:NetStatusEvent = param1;
         this.onConnectionStatus(event);
         this.log.debug(this+"::_onConnectionStatus() "+event.info.code);
         if(event.info.code=="NetConnection.Connect.Success")
            {
               if(this._successListener!=null)
                  {
                     this.log.debug("established connection to URL "+this._connection.uri);
                     this._successListener(this,this._connection);
                  }
               else
                  {
                     this.log.debug("this connector is stopped, will not call successListener");
                     this._connection.close();
                  }
               return;
            }
         if((event.info.code=="NetConnection.Connect.Rejected")&&(event.info.ex)&&event.info.ex.code==302)
            {
               this.log.debug("starting a timeout to connect to a redirected URL "+event.info.ex.redirect);
               setTimeout(new function():void
                  {
                     log.debug("connecting to a redirected URL "+event.info.ex.redirect);
                     _connection.connect(event.info.ex.redirect);
                     return;
                     },100);
                     return;
                  }
               if("NetConnection.Connect.Failed"==event.info.code)
                  {
                     this.log.debug("connection attempts left "+(this._attempts-1));
                     if(--this._attempts>0)
                        {
                           this.log.debug("retrying connection");
                           this.connect(this._proxyType,this._objectEncoding,this._connectionArgs,this._attempts);
                           return;
                        }
                     this.fail();
                  }
               if(["NetConnection.Connect.Rejected","NetConnection.Connect.AppShutdown","NetConnection.Connect.InvalidApp"].indexOf(event.info.code)>=0)
                  {
                     this.fail();
                  }
               return;
      }

      private function fail() : void {
         this._failed=true;
         if(this._failureListener!=null)
            {
               this._failureListener();
            }
         return;
      }

      public function stop() : void {
         this.log.debug("stop()");
         if(this._connection)
            {
               this._connection.close();
            }
         this._successListener=null;
         return;
      }

      public function toString() : String {
         return "Connector, ["+this._url+"]";
      }

      public function get failed() : Boolean {
         return this._failed;
      }

      public function get connectionArgs() : Array {
         return this._connectionArgs;
      }
   }

}