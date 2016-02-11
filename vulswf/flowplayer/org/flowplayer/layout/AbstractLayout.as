package org.flowplayer.layout
{
   import flash.events.EventDispatcher;
   import org.flowplayer.util.Log;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import org.flowplayer.model.DisplayProperties;
   import flash.display.Stage;


   class AbstractLayout extends EventDispatcher implements Layout
   {
         

      function AbstractLayout(param1:DisplayObjectContainer) {
         this.log=new Log(this);
         this._constraints=new Dictionary();
         this._listeners=new Dictionary();
         super();
         this._container=param1;
         if(param1 is Stage)
            {
               param1.addEventListener(Event.RESIZE,this.onContainerResize);
            }
         return;
      }



      private var log:Log;

      private var _container:DisplayObjectContainer;

      private var _constraints:Dictionary;

      private var _listeners:Dictionary;

      private function onContainerResize(param1:Event) : void {
         this.draw();
         return;
      }

      public function draw(param1:DisplayObject=null) : void {
         var _loc2_:Function = null;
         this.log.info("redrawing layout");
         if(param1)
            {
               _loc2_=this._listeners[param1];
               if(_loc2_!=null)
                  {
                     _loc2_(new LayoutEvent(LayoutEvent.RESIZE,this));
                  }
            }
         else
            {
               dispatchEvent(new LayoutEvent(LayoutEvent.RESIZE,this));
            }
         return;
      }

      public function addConstraint(param1:Constraint, param2:Function=null) : void {
         this._constraints[param1.getConstrainedView()]=param1;
         if(param2!=null)
            {
               this._listeners[param1.getConstrainedView()]=param2;
               this.addEventListener(LayoutEvent.RESIZE,param2);
            }
         return;
      }

      public function getConstraint(param1:DisplayObject) : Constraint {
         return this._constraints[param1];
      }

      public function removeView(param1:DisplayObject) : void {
         if(this._listeners[param1])
            {
               this.removeEventListener(LayoutEvent.RESIZE,this._listeners[param1]);
            }
         delete this._listeners[[param1]];
         delete this._constraints[[param1]];
         return;
      }

      public function getContainer() : DisplayObject {
         return this._container;
      }

      public function getBounds(param1:Object) : Rectangle {
         var _loc2_:Constraint = this._constraints[param1];
         if(!_loc2_)
            {
               return null;
            }
         return _loc2_.getBounds();
      }

      protected function get constraints() : Dictionary {
         return this._constraints;
      }

      protected function get listeners() : Dictionary {
         return this._listeners;
      }

      public function addView(param1:DisplayObject, param2:Function, param3:DisplayProperties) : void {
         return;
      }

      public function update(param1:DisplayObject, param2:DisplayProperties) : Rectangle {
         return null;
      }
   }

}