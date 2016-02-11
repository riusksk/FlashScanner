package org.flowplayer.layout
{
   import flash.display.DisplayObject;
   import org.flowplayer.util.Log;
   import flash.geom.Rectangle;
   import org.flowplayer.view.AbstractSprite;


   public class DrawWrapper extends Object
   {
         

      public function DrawWrapper(param1:DisplayObject) {
         this.log=new Log(this);
         super();
         this.view=param1;
         return;
      }



      private var view:DisplayObject;

      private var log:Log;

      public function draw(param1:LayoutEvent) : void {
         var _loc2_:Rectangle = param1.layout.getBounds(this.view);
         if(_loc2_==null)
            {
               this.log.warn("Did not get bounds for view "+this.view);
               return;
            }
         this.log.debug("got bounds "+_loc2_+" for view "+this.view);
         this.view.x=_loc2_.x;
         this.view.y=_loc2_.y;
         if(this.view is AbstractSprite)
            {
               AbstractSprite(this.view).setSize(_loc2_.width,_loc2_.height);
            }
         else
            {
               this.view.width=_loc2_.width;
               this.view.height=_loc2_.height;
            }
         return;
      }
   }

}