package org.flowplayer.model
{
   import org.flowplayer.util.Log;
   import org.flowplayer.util.Assert;


   class EventListener extends Object
   {
         

      function EventListener(param1:Function, param2:Function) {
         this.log=new Log(this);
         super();
         this._listener=param1;
         this._clipFilter=param2;
         return;
      }



      private var log:Log;

      private var _listener:Function;

      private var _clipFilter:Function;

      public function notify(param1:AbstractEvent) : Boolean {
         Assert.notNull(param1.target,"event target cannot be null");
         if(this._clipFilter!=null)
            {
               this.log.debug("clip filter returns "+this._clipFilter(param1.target as Clip));
            }
         if((!(this._clipFilter==null))&&(param1.target)&&!this._clipFilter(param1.target as Clip))
            {
               this.log.debug(param1+" was filtered out for this listener");
               return false;
            }
         this.log.debug("notifying listener for event "+param1);
         this._listener(param1);
         return true;
      }

      public function get listener() : Function {
         return this._listener;
      }
   }

}