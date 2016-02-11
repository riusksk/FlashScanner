package org.flowplayer.controller
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.ClipEventType;


   public dynamic class NetConnectionClient extends Object implements ConnectionCallbacks
   {
         

      public function NetConnectionClient() {
         this.log=new Log(this);
         super();
         return;
      }



      private var log:Log;

      private var _clip:Clip;

      public function onFCSubscribe(param1:Object) : void {
         this._clip.dispatch(ClipEventType.CONNECTION_EVENT,"onFCSubscribe",param1);
         return;
      }

      public function get clip() : Clip {
         return this._clip;
      }

      public function set clip(param1:Clip) : void {
         this._clip=param1;
         return;
      }

      public function addConnectionCallback(param1:String, param2:Function) : void {
         this.log.debug("registering callback "+param1);
         this[param1]=param2;
         return;
      }

      public function registerCallback(param1:String) : void {
         this._clip.dispatch(ClipEventType.CONNECTION_EVENT,"registerCallback",param1);
         return;
      }
   }

}