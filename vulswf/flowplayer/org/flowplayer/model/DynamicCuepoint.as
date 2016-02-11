package org.flowplayer.model
{


   dynamic class DynamicCuepoint extends Cuepoint
   {
         

      function DynamicCuepoint(param1:int, param2:String) {
         super(param1,param2);
         return;
      }



      override  protected function onClone(param1:Cuepoint) : void {
         var prop:String = null;
         var clone:Cuepoint = param1;
         for (prop in this)
            {
               try
                  {
                     clone[prop]=this[prop];
                  }
               catch(e:Error)
                  {
                     log.error("Error when cloning cuepoint "+e);
                  }
            }
         return;
      }
   }

}