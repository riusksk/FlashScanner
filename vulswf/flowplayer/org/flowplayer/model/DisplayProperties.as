package org.flowplayer.model
{
   import flash.display.DisplayObject;
   import org.flowplayer.layout.Dimensions;
   import org.flowplayer.layout.Position;


   public interface DisplayProperties extends Identifiable, Cloneable
   {
         



      function getDisplayObject() : DisplayObject;

      function setDisplayObject(param1:DisplayObject) : void;

      function set width(param1:Object) : void;

      function get widthPx() : Number;

      function get widthPct() : Number;

      function set height(param1:Object) : void;

      function get heightPx() : Number;

      function get heightPct() : Number;

      function get dimensions() : Dimensions;

      function set alpha(param1:Number) : void;

      function get alpha() : Number;

      function set opacity(param1:Number) : void;

      function get opacity() : Number;

      function set zIndex(param1:Number) : void;

      function get zIndex() : Number;

      function get display() : String;

      function set display(param1:String) : void;

      function get visible() : Boolean;

      function set top(param1:Object) : void;

      function set right(param1:Object) : void;

      function set bottom(param1:Object) : void;

      function set left(param1:Object) : void;

      function get position() : Position;
   }

}