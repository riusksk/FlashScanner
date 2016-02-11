package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import flash.net.NetConnection;
   import org.flowplayer.model.Clip;
   import flash.events.NetStatusEvent;
   import flash.utils.setTimeout;


   public class DefaultRTMPConnectionProvider extends Object implements ConnectionProvider
   {
         

      public function DefaultRTMPConnectionProvider() {
         this.log=new Log(this);
         super();
         return;
      }



      protected var log:Log;

      private var _connection:NetConnection;

      private var _successListener:Function;

      private var _failureListener:Function;

      private var _connectionClient:Object;

      private var _provider:NetStreamControllingStreamProvider;

      private var _connectionArgs:Array;

      private var _clip:Clip;

      private function doConnect(param1:Array, param2:String) : void {
         if(param1.length>0)
            {
               this._connection.connect.apply(this._connection,[param2].concat(param1));
            }
         else
            {
               this._connection.connect(param2);
            }
         return;
      }

      public function connect(param1:StreamProvider, param2:Clip, param3:Function, param4:uint, param5:Array) : void {
         this._provider=param1 as NetStreamControllingStreamProvider;
         this._successListener=param3;
         this._connection=new NetConnection();
         this._connection.proxyType="best";
         this._connection.objectEncoding=param4;
         this._connectionArgs=param5;
         this._clip=param2;
         if(this._connectionClient)
            {
               this._connection.client=this._connectionClient;
            }
         this._connection.addEventListener(NetStatusEvent.NET_STATUS,this._onConnectionStatus);
         var _loc6_:String = this.getNetConnectionUrl(param2);
         this.log.debug("netConnectionUrl is "+_loc6_);
         this.doConnect(param5,_loc6_);
         return;
      }

      protected function getNetConnectionUrl(param1:Clip) : String {
         return null;
      }

      private function _onConnectionStatus(param1:NetStatusEvent) : void {
         var _loc2_:String = null;
         this.onConnectionStatus(param1);
         if(param1.info.code=="NetConnection.Connect.Success"&&!(this._successListener==null))
            {
               this._successListener(this._connection);
            }
         else
            {
               if(param1.info.code=="NetConnection.Connect.Rejected")
                  {
                     if(param1.info.ex.code==302)
                        {
                           _loc2_=param1.info.ex.redirect;
                           this.log.debug("doing a redirect to "+_loc2_);
                           this._clip.setCustomProperty("netConnectionUrl",_loc2_);
                           setTimeout(this.connect,100,this._provider,this._clip,this._successListener,this._connection.objectEncoding,this._connectionArgs);
                        }
                  }
               else
                  {
                     if(["NetConnection.Connect.Failed","NetConnection.Connect.AppShutdown","NetConnection.Connect.InvalidApp"].indexOf(param1.info.code)>=0)
                        {
                           if(this._failureListener!=null)
                              {
                                 this._failureListener();
                              }
                        }
                  }
            }
         return;
      }

      protected function onConnectionStatus(param1:NetStatusEvent) : void {
         return;
      }

      public function set connectionClient(param1:Object) : void {
         if(this._connection)
            {
               this._connection.client=param1;
            }
         this._connectionClient=param1;
         return;
      }

      public function set onFailure(param1:Function) : void {
         this._failureListener=param1;
         return;
      }

      protected function get connection() : NetConnection {
         return this._connection;
      }

      public function handeNetStatusEvent(param1:NetStatusEvent) : Boolean {
         return true;
      }

      protected function get provider() : NetStreamControllingStreamProvider {
         return this._provider;
      }

      protected function get failureListener() : Function {
         return this._failureListener;
      }

      protected function get successListener() : Function {
         return this._successListener;
      }
   }

}