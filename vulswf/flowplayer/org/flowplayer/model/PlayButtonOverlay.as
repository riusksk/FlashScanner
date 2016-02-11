package org.flowplayer.model
{


   public class PlayButtonOverlay extends DisplayPluginModelImpl
   {
         

      public function PlayButtonOverlay() {
         super(null,"play",false);
         top="50%";
         left="50%";
         width="22%";
         height="22%";
         display="block";
         this._buffering=true;
         this._rotateSpeed=50;
         this._fadeSpeed=500;
         this._replayLabel="Play again";
         return;
      }



      private var _fadeSpeed:int;

      private var _rotateSpeed:int;

      private var _label:String;

      private var _replayLabel:String;

      private var _buffering:Boolean;

      override  public function clone() : Cloneable {
         var _loc1_:PlayButtonOverlay = new PlayButtonOverlay();
         copyFields(this,_loc1_);
         _loc1_.fadeSpeed=this.fadeSpeed;
         _loc1_.rotateSpeed=this.rotateSpeed;
         _loc1_.url=this.url;
         _loc1_.label=this.label;
         _loc1_.replayLabel=this.replayLabel;
         _loc1_.buffering=this.buffering;
         return _loc1_;
      }

      public function get fadeSpeed() : int {
         return this._fadeSpeed;
      }

      public function set fadeSpeed(param1:int) : void {
         this._fadeSpeed=param1;
         return;
      }

      public function get rotateSpeed() : int {
         if(this._rotateSpeed>100)
            {
               return 100;
            }
         return this._rotateSpeed;
      }

      public function set rotateSpeed(param1:int) : void {
         this._rotateSpeed=param1;
         return;
      }

      public function get label() : String {
         return this._label;
      }

      public function set label(param1:String) : void {
         this._label=param1;
         return;
      }

      public function get replayLabel() : String {
         return this._replayLabel;
      }

      public function set replayLabel(param1:String) : void {
         this._replayLabel=param1;
         return;
      }

      public function get buffering() : Boolean {
         return this._buffering;
      }

      public function set buffering(param1:Boolean) : void {
         this._buffering=param1;
         return;
      }
   }

}