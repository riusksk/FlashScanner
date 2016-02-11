package org.flowplayer.util
{


   public class Assert extends Object
   {
         

      public function Assert() {
         super();
         return;
      }

      public static function notNull(param1:Object, param2:String="object cannot be null") : void {
         if(param1==null)
            {
               throw new Error(param2);
            }
         return;
      }


   }

}