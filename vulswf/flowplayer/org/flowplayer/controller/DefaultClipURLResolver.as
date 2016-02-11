package org.flowplayer.controller
{
   import org.flowplayer.model.Clip;
   import flash.events.NetStatusEvent;


   public class DefaultClipURLResolver extends Object implements ClipURLResolver
   {
         

      public function DefaultClipURLResolver() {
         super();
         return;
      }



      private var _clip:Clip;

      private var _failureListener:Function;

      public function resolve(param1:StreamProvider, param2:Clip, param3:Function) : void {
         this._clip=param2;
         if(param3!=null)
            {
               param3(param2);
            }
         return;
      }

      public function set onFailure(param1:Function) : void {
         this._failureListener=param1;
         return;
      }

      public function handeNetStatusEvent(param1:NetStatusEvent) : Boolean {
         return true;
      }
   }

}