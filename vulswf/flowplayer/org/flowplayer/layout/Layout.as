package org.flowplayer.layout
{
   import flash.display.DisplayObject;
   import org.flowplayer.model.DisplayProperties;
   import flash.geom.Rectangle;


   public interface Layout
   {
         



      function addView(param1:DisplayObject, param2:Function, param3:DisplayProperties) : void;

      function update(param1:DisplayObject, param2:DisplayProperties) : Rectangle;

      function removeView(param1:DisplayObject) : void;

      function getContainer() : DisplayObject;

      function getBounds(param1:Object) : Rectangle;

      function draw(param1:DisplayObject=null) : void;
   }

}