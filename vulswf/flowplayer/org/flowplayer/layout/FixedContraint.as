package org.flowplayer.layout
{
   import flash.geom.Rectangle;
   import flash.display.DisplayObject;


   class FixedContraint extends Object implements Constraint
   {
         

      function FixedContraint(param1:Number) {
         super();
         this.length=param1;
         return;
      }



      private var length:Number;

      public function getBounds() : Rectangle {
         return new Rectangle(0,0,this.length,this.length);
      }

      public function getConstrainedView() : DisplayObject {
         return null;
      }

      public function getMarginConstraints() : Array {
         return null;
      }

      public function setMarginConstraint(param1:Number, param2:Constraint) : void {
         return;
      }

      public function removeMarginConstraint(param1:Constraint) : void {
         return;
      }
   }

}