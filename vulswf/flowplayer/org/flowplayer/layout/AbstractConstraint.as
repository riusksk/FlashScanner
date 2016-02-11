package org.flowplayer.layout
{
   import flash.events.EventDispatcher;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import org.flowplayer.util.Arrange;


   class AbstractConstraint extends EventDispatcher
   {
         

      function AbstractConstraint(param1:DisplayObject, param2:Layout, param3:Array) {
         super();
         this.layout=param2;
         this.view=param1;
         this.margins=param3;
         if(!this.margins)
            {
               this.margins=new Array();
            }
         return;
      }



      private var layout:Layout;

      private var margins:Array;

      private var view:DisplayObject;

      public function setMarginConstraint(param1:Number, param2:Constraint) : void {
         this.margins[param1]=param2;
         return;
      }

      public function removeMarginConstraint(param1:Constraint) : void {
         var _loc2_:Number = 0;
         while(_loc2_<this.margins.length)
            {
               if(this.margins[_loc2_]==param1)
                  {
                     this.margins[_loc2_]=null;
                  }
               _loc2_++;
            }
         return;
      }

      public function getConstrainedView() : DisplayObject {
         return this.view;
      }

      public function getMarginConstraints() : Array {
         return this.margins;
      }

      protected function getContainer() : DisplayObject {
         return this.layout.getContainer();
      }

      protected function getContainerWidth() : Number {
         return this.getContainer() is Stage?Arrange.getStageWidth(this.getContainer() as Stage):this.getContainer().width;
      }

      protected function getContainerHeight() : Number {
         return this.getContainer() is Stage?Arrange.getStageHeight(this.getContainer() as Stage):this.getContainer().height;
      }
   }

}