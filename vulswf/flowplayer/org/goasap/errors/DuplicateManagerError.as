package org.goasap.errors
{


   public class DuplicateManagerError extends Error
   {
         

      public function DuplicateManagerError(param1:String) {
         super("An instance of "+param1+" was already added to GoEngine.");
         return;
      }




   }

}