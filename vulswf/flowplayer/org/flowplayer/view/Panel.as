package org.flowplayer.view
{
   import flash.display.Sprite;
   import org.flowplayer.util.Log;
   import org.flowplayer.layout.Layout;
   import flash.display.DisplayObject;
   import org.flowplayer.model.DisplayProperties;
   import org.flowplayer.model.DisplayPropertiesImpl;
   import org.flowplayer.layout.DrawWrapper;
   import org.flowplayer.util.Assert;
   import flash.geom.Rectangle;
   import flash.events.Event;
   import org.flowplayer.layout.MarginLayout;


   class Panel extends Sprite
   {
         

      function Panel() {
         this.log=new Log(this);
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.createLayout);
         this.childProps=new Array();
         return;
      }



      private var log:Log;

      private var layout:Layout;

      private var childProps:Array;

      public function addView(param1:DisplayObject, param2:Object=null, param3:DisplayProperties=null) : void {
         var _loc4_:Function = null;
         if(!param3)
            {
               param3=new DisplayPropertiesImpl();
               param3.left=0;
               param3.top=0;
               param3.width=(param1.width)||("50%");
               param3.height=(param1.height)||("50%");
            }
         else
            {
               if(!param3.dimensions.height.hasValue())
                  {
                     param3.height=param1.height;
                  }
               if(!param3.dimensions.width.hasValue())
                  {
                     param3.width=param1.width;
                  }
               if(!((param3.position.left.hasValue())||(param3.position.right.hasValue())))
                  {
                     param3.left="50%";
                  }
               if(!((param3.position.top.hasValue())||(param3.position.bottom.hasValue())))
                  {
                     param3.top="50%";
                  }
            }
         if(param3.zIndex<0)
            {
               param3.zIndex=1;
            }
         if(param2)
            {
               _loc4_=param2 is Function?param2 as Function:param1[param2];
            }
         else
            {
               _loc4_=new DrawWrapper(param1).draw;
            }
         param1.alpha=param3.alpha;
         param3.setDisplayObject(param1);
         this.addChildView(param3);
         this.layout.addView(param1,_loc4_,param3);
         return;
      }

      override  public function swapChildren(param1:DisplayObject, param2:DisplayObject) : void {
         this.log.warn("swapChildren on Panel called, overridden here and does nothing");
         return;
      }

      private function addChildView(param1:DisplayProperties) : void {
         var index:Number = NaN;
         var properties:DisplayProperties = param1;
         this.log.info("addChildView() updating Z index of "+properties+", target Z index is "+properties.zIndex+", numChildren "+numChildren);
         Assert.notNull(properties.getDisplayObject(),"displayObject cannot be null");
         var i:int = 0;
         while(i<numChildren)
            {
               this.log.debug("addChildView(), "+getChildAt(i)+" at "+i);
               i++;
            }
         if(numChildren<0&&this.childProps.length<0&&properties.zIndex<=this.childProps[this.childProps.length-1].zIndex)
            {
               index=this.getPositionToAddByZIndex(properties.zIndex);
               this.log.debug("addChildView() adding child at "+index);
               try
                  {
                     addChildAt(properties.getDisplayObject(),index);
                  }
               catch(e:Error)
                  {
                     log.info("addChildView(), error "+e);
                     addChild(properties.getDisplayObject());
                  }
            }
         else
            {
               index=numChildren;
               this.log.debug("addChildView() adding to top "+properties.getDisplayObject());
               addChild(properties.getDisplayObject());
            }
         if(this.childProps.length==0)
            {
               this.childProps.push(properties);
            }
         else
            {
               this.childProps.splice(index,0,properties);
            }
         this.log.debug("addChildView() child indexes are now: ");
         var j:int = 0;
         while(j<numChildren)
            {
               this.log.debug("addChildView(), "+getChildAt(j)+" at "+j);
               j++;
            }
         return;
      }

      private function getPositionToAddByZIndex(param1:int) : int {
         var _loc2_:* = 0;
         while(_loc2_<this.childProps.length)
            {
               if(this.childProps[_loc2_].zIndex>=param1)
                  {
                     return _loc2_;
                  }
               _loc2_++;
            }
         return this.childProps.length-1;
      }

      public function getZIndex(param1:DisplayObject) : int {
         try
            {
               return getChildIndex(param1);
            }
         catch(e:Error)
            {
            }
         return -1;
      }

      public function update(param1:DisplayObject, param2:DisplayProperties) : Rectangle {
         return this.layout.update(param1,param2);
      }

      private function removeView(param1:DisplayObject) : void {
         var _loc3_:DisplayProperties = null;
         this.log.debug("removeView "+param1);
         if(!getChildByName(param1.name))
            {
               return;
            }
         var _loc2_:* = 0;
         while(_loc2_<this.childProps.length)
            {
               _loc3_=this.childProps[_loc2_];
               if(_loc3_.getDisplayObject()==param1)
                  {
                     this.childProps.splice(_loc2_,1);
                     break;
                  }
               _loc2_++;
            }
         super.removeChild(param1);
         this.layout.removeView(param1);
         return;
      }

      override  public function removeChild(param1:DisplayObject) : DisplayObject {
         this.removeView(param1);
         return param1;
      }

      private function createLayout(param1:Event) : void {
         this.layout=new MarginLayout(stage);
         return;
      }

      public function draw(param1:DisplayObject=null) : void {
         this.layout.draw(param1);
         return;
      }
   }

}