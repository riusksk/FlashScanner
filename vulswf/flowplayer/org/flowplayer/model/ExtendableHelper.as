package org.flowplayer.model
{
   import org.flowplayer.util.Assert;


   public class ExtendableHelper extends Object
   {
         

      public function ExtendableHelper() {
         super();
         return;
      }



      private var _customProperties:Object;

      public function set props(param1:Object) : void {
         this._customProperties=param1;
         return;
      }

      public function setProp(param1:String, param2:Object) : void {
         Assert.notNull(param1,"the name of the property cannot be null");
         if(!this._customProperties)
            {
               this._customProperties=new Object();
            }
         this._customProperties[param1]=param2;
         return;
      }

      public function get props() : Object {
         return this._customProperties;
      }

      public function getProp(param1:String) : Object {
         if(!this._customProperties)
            {
               return null;
            }
         return this._customProperties[param1];
      }

      public function deleteProp(param1:String) : void {
         if(!this._customProperties)
            {
               return;
            }
         delete this._customProperties[[param1]];
         return;
      }
   }

}