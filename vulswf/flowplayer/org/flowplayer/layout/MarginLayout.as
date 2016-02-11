package org.flowplayer.layout
{
   import org.flowplayer.util.Log;
   import flash.display.DisplayObject;
   import org.flowplayer.model.DisplayProperties;
   import flash.geom.Rectangle;
   import flash.display.DisplayObjectContainer;


   public class MarginLayout extends AbstractLayout implements Layout
   {
         

      public function MarginLayout(param1:DisplayObjectContainer) {
         this.log=new Log(this);
         super(param1);
         return;
      }



      private var log:Log;

      override  public function addView(param1:DisplayObject, param2:Function, param3:DisplayProperties) : void {
         this.log.debug("addView, name "+param3.name+", position "+param3.position);
         var _loc4_:MarginConstraint = new MarginConstraint(param1,this,null,param3.dimensions);
         this.initConstraint(param1,_loc4_,param3);
         addConstraint(_loc4_,param2);
         draw(param1);
         return;
      }

      override  public function update(param1:DisplayObject, param2:DisplayProperties) : Rectangle {
         var _loc3_:MarginConstraint = new MarginConstraint(param1,this,null,param2.dimensions);
         this.initConstraint(param1,_loc3_,param2);
         addConstraint(_loc3_);
         return _loc3_.getBounds();
      }

      private function initConstraint(param1:DisplayObject, param2:MarginConstraint, param3:DisplayProperties) : void {
         var _loc4_:* = NaN;
         var _loc5_:Constraint = null;
         if(param3.position)
            {
               _loc4_=0;
               while(_loc4_<4)
                  {
                     _loc5_=this.getMarginConstraint(param1,_loc4_,param3);
                     if(_loc5_)
                        {
                           param2.setMarginConstraint(_loc4_,_loc5_);
                        }
                     _loc4_++;
                  }
            }
         return;
      }

      private function getMarginConstraint(param1:DisplayObject, param2:Number, param3:DisplayProperties) : Constraint {
         var _loc4_:Position = param3.position;
         if(param2==0)
            {
               if(_loc4_.top.pct>=0)
                  {
                     return new RelativeConstraint(param1,param3.dimensions.height,getContainer(),_loc4_.top.pct,"height");
                  }
               if(_loc4_.top.px>=0)
                  {
                     return new FixedContraint(_loc4_.top.px);
                  }
            }
         if(param2==1)
            {
               if(_loc4_.right.pct>=0)
                  {
                     return new RelativeConstraint(param1,param3.dimensions.width,getContainer(),_loc4_.right.pct,"width");
                  }
               if(_loc4_.right.px>=0)
                  {
                     return new FixedContraint(_loc4_.right.px);
                  }
            }
         if(param2==2)
            {
               if(_loc4_.bottom.pct>=0)
                  {
                     return new RelativeConstraint(param1,param3.dimensions.height,getContainer(),_loc4_.bottom.pct,"height");
                  }
               if(_loc4_.bottom.px>=0)
                  {
                     return new FixedContraint(_loc4_.bottom.px);
                  }
            }
         if(param2==3)
            {
               if(_loc4_.left.pct>=0)
                  {
                     return new RelativeConstraint(param1,param3.dimensions.width,getContainer(),_loc4_.left.pct,"width");
                  }
               if(_loc4_.left.px>=0)
                  {
                     return new FixedContraint(_loc4_.left.px);
                  }
            }
         return null;
      }
   }

}