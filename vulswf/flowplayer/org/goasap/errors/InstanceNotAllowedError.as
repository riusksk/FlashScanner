package org.goasap.errors
{


   public class InstanceNotAllowedError extends Error
   {
         

      public function InstanceNotAllowedError(param1:String) {
         super("Direct use of "+param1+" is not allowed, use subclasses only.");
         return;
      }




   }

}