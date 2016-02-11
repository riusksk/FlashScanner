package org.flowplayer.view
{
   import flash.media.Video;
   import flash.media.StageVideo;
   import flash.display.Stage;
   import org.flowplayer.model.Clip;
   import flash.net.NetStream;
   import org.flowplayer.util.Log;
   import flash.events.Event;
   import flash.events.StageVideoAvailabilityEvent;
   import flash.media.StageVideoAvailability;
   import flash.events.StageVideoEvent;
   import org.flowplayer.model.ClipEventType;
   import flash.geom.Point;
   import flash.geom.Rectangle;


   public class StageVideoWrapper extends Video
   {
         

      public function StageVideoWrapper(param1:Clip) {
         this.log=new Log(this);
         super();
         this._clip=param1;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         return;
      }



      private var _stageVideo:StageVideo;

      private var _stage:Stage;

      private var _clip:Clip;

      private var _netStream:NetStream = null;

      private var _hasStageVideo:Boolean = false;

      private var _visible:Boolean = true;

      private var log:Log;

      private function onAddedToStage(param1:Event) : void {
         this._stage=stage;
         this._stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,this.onAvailabilityChanged);
         return;
      }

      private function onRemovedFromStage(param1:Event) : void {
         this._stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,this.onAvailabilityChanged);
         this._stage=null;
         return;
      }

      public function get stageVideo() : StageVideo {
         return this.hasStageVideo?this._stageVideo:null;
      }

      public function get hasStageVideo() : Boolean {
         return this._hasStageVideo;
      }

      private function onAvailabilityChanged(param1:StageVideoAvailabilityEvent) : void {
         this.log.debug("StageVideo Availability changed: "+param1.availability);
         var _loc2_:* = param1.availability==StageVideoAvailability.AVAILABLE;
         this.useStageVideo(_loc2_);
         return;
      }

      private function useStageVideo(param1:Boolean) : void {
         this.log.debug("useStageVideo : "+param1);
         this._hasStageVideo=param1;
         if((this._hasStageVideo)&&(this._stage.stageVideos.length))
            {
               this._stageVideo=this._stage.stageVideos[0];
               super.visible=false;
            }
         else
            {
               super.visible=true;
               this._hasStageVideo=false;
            }
         this.attachNetStream(this._netStream);
         return;
      }

      override  public function attachNetStream(param1:NetStream) : void {
         this._netStream=param1;
         if(this.hasStageVideo)
            {
               this.log.info("Attaching netstream to stageVideo");
               this.stageVideo.attachNetStream(this._netStream);
               this.stageVideo.addEventListener(StageVideoEvent.RENDER_STATE,this._displayStageVideo);
            }
         else
            {
               this.log.info("Attaching netstream to video");
               super.attachNetStream(this._netStream);
               if(this._stageVideo!=null)
                  {
                     this._stageVideo.attachNetStream(null);
                  }
               this.visible=this._visible;
               this._clip.dispatch(ClipEventType.STAGE_VIDEO_STATE_CHANGE,this.stageVideo);
            }
         return;
      }

      private function _displayStageVideo(param1:StageVideoEvent) : void {
         if(param1.status!="software")
            {
               return;
            }
         this.stageVideo.removeEventListener(StageVideoEvent.RENDER_STATE,this._displayStageVideo);
         super.attachNetStream(null);
         this.visible=this._visible;
         this._clip.dispatch(ClipEventType.STAGE_VIDEO_STATE_CHANGE,this.stageVideo);
         return;
      }

      override  public function get videoWidth() : int {
         return this.hasStageVideo?this.stageVideo.videoWidth:super.videoWidth;
      }

      override  public function get videoHeight() : int {
         return this.hasStageVideo?this.stageVideo.videoHeight:super.videoHeight;
      }

      override  public function set visible(param1:Boolean) : void {
         this.log.debug("set visible "+param1);
         this._visible=param1;
         if(this.hasStageVideo)
            {
               this._updateStageVideo();
               super.visible=false;
            }
         else
            {
               super.visible=this._visible;
            }
         return;
      }

      override  public function get visible() : Boolean {
         return this._visible;
      }

      private function _updateStageVideo() : void {
         if(!this.hasStageVideo)
            {
               return;
            }
         var _loc1_:Point = localToGlobal(new Point(x,y));
         var _loc2_:Rectangle = this._visible?new Rectangle(_loc1_.x,_loc1_.y,width,height):new Rectangle(0,0,0,0);
         this.log.debug("Resizing view port to "+_loc2_.width+"x"+_loc2_.height+" - "+_loc2_.x+";"+_loc2_.y);
         this._stageVideo.viewPort=_loc2_;
         this._clip.dispatch(ClipEventType.STAGE_VIDEO_STATE_CHANGE,this.stageVideo);
         return;
      }

      override  public function set width(param1:Number) : void {
         super.width=param1;
         this._updateStageVideo();
         return;
      }

      override  public function set height(param1:Number) : void {
         super.height=param1;
         this._updateStageVideo();
         return;
      }

      override  public function set x(param1:Number) : void {
         super.x=param1;
         this._updateStageVideo();
         return;
      }

      override  public function set y(param1:Number) : void {
         super.y=param1;
         this._updateStageVideo();
         return;
      }
   }

}