package org.flowplayer.layout
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;


   public interface Constraint
   {
         



      function getConstrainedView() : DisplayObject;

      function getBounds() : Rectangle;

      function getMarginConstraints() : Array;

      function setMarginConstraint(param1:Number, param2:Constraint) : void;

      function removeMarginConstraint(param1:Constraint) : void;
   }

}