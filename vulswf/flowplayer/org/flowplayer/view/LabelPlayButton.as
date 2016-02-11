package org.flowplayer.view
{
   import flash.text.TextField;
   import flash.display.Sprite;
   import org.flowplayer.LabelHolderLeft;
   import flash.text.TextFieldAutoSize;
   import flash.filters.GlowFilter;
   import flash.text.TextFormat;
   import org.flowplayer.util.Arrange;


   class LabelPlayButton extends AbstractSprite
   {
         

      function LabelPlayButton(param1:Flowplayer, param2:String, param3:Boolean=true) {
         super();
         this._player=param1;
         this._resizeToTextWidth=param3;
         this.createChildren(param2);
         return;
      }



      private var _label:TextField;

      private var _labelHolder:Sprite;

      private var _labelHolderLeft:Sprite;

      private var _labelHolderRight:Sprite;

      private var _player:Flowplayer;

      private var _resizeToTextWidth:Boolean;

      public function setLabel(param1:String, param2:Boolean=true) : void {
         log.debug("setLabel, changeWidth "+param2);
         if(this._label.text==param1)
            {
               return;
            }
         this._resizeToTextWidth=param2;
         this._label.text=param1;
         this.onResize();
         return;
      }

      private function createChildren(param1:String) : void {
         this._labelHolderLeft=new LabelHolderLeft();
         addChild(this._labelHolderLeft);
         this._labelHolder=new LabelHolder();
         addChild(this._labelHolder);
         this._labelHolderRight=new LabelHolderRight();
         addChild(this._labelHolderRight);
         this._label=this._player.createTextField();
         this._label.textColor=16777215;
         this._label.selectable=false;
         this._label.autoSize=TextFieldAutoSize.RIGHT;
         this._label.multiline=false;
         this._label.text=param1;
         this._label.width=this._label.textWidth;
         var _loc2_:GlowFilter = new GlowFilter(16777215,0.3,4,4,3,3);
         var _loc3_:Array = [_loc2_];
         this._label.filters=_loc3_;
         addChild(this._label);
         return;
      }

      override  protected function onResize() : void {
         log.debug("arranging label");
         this._labelHolderRight.height=height;
         this._labelHolderRight.scaleX=this._labelHolderRight.scaleY;
         this._labelHolderLeft.height=height;
         this._labelHolderLeft.scaleX=this._labelHolderLeft.scaleY;
         var _loc1_:TextFormat = this._label.defaultTextFormat;
         _loc1_.size=this._labelHolder.height/3;
         this._label.setTextFormat(_loc1_);
         this._labelHolder.width=int(this._resizeToTextWidth?this._label.textWidth+10:width-this._labelHolderRight.width-this._labelHolderLeft.width);
         this._labelHolder.height=height;
         Arrange.center(this._labelHolder,width,height);
         this._labelHolderLeft.x=this._labelHolder.x-this._labelHolderLeft.width;
         this._labelHolderRight.x=this._labelHolder.x+this._labelHolder.width;
         Arrange.center(this._labelHolderLeft,0,height);
         Arrange.center(this._labelHolderRight,0,height);
         Arrange.center(this._label,0,height);
         this._label.x=this._labelHolder.x+this._labelHolder.width/2-this._label.width/2;
         return;
      }
   }

}