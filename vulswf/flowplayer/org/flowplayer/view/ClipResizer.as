package org.flowplayer.view
{
   import org.flowplayer.util.Log;
   import flash.utils.Dictionary;
   import org.flowplayer.model.Playlist;
   import flash.utils.Timer;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.MediaSize;
   import flash.events.TimerEvent;
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.ClipType;
   import org.flowplayer.model.ClipEventSupport;


   class ClipResizer extends Object
   {
         

      function ClipResizer(param1:Playlist, param2:Screen) {
         this.log=new Log(this);
         super();
         this.resizers=new Dictionary();
         this._playlist=param1;
         this.screen=param2;
         this.createResizers(param1.clips.concat(param1.childClips));
         this.addListeners(param1);
         return;
      }



      private var log:Log;

      private var resizers:Dictionary;

      private var screen:Screen;

      private var _playlist:Playlist;

      private var _resizerTimer:Timer;

      private function createResizers(param1:Array) : void {
         var clips:Array = param1;
         clips.forEach(new function(param1:Clip, param2:int, param3:Array):void
            {
               log.debug("creating resizer for clip "+param1);
               resizers[param1]=new MediaResizer(param1,screen.width,screen.height);
               return;
               });
               return;
      }

      public function setMaxSize(param1:int, param2:int) : void {
         var _loc3_:MediaResizer = null;
         this.log.debug("setMaxSize: "+param1+" x "+param2);
         for each (_loc3_ in this.resizers)
            {
               _loc3_.setMaxSize(param1,param2);
            }
         this.resizeClip(this._playlist.current);
         return;
      }

      public function resizeClip(param1:Clip, param2:Boolean=false) : void {
         this.resizeClipTo(param1,param1.scaling,param2);
         return;
      }

      public function resizeClipTo(param1:Clip, param2:MediaSize, param3:Boolean=false) : void {
         var resizer:MediaResizer = null;
         var clip:Clip = param1;
         var mediaSize:MediaSize = param2;
         var force:Boolean = param3;
         this.log.debug("resizeClipTo, clip "+clip);
         if(this._resizerTimer)
            {
               this.log.debug("Killing old resize timer");
               this._resizerTimer.reset();
               this._resizerTimer=null;
            }
         resizer=this.resizers[clip];
         if(!resizer)
            {
               this.log.warn("no resizer defined for "+clip);
               return;
            }
         var resizingFunc:Function = new function(param1:TimerEvent=null):void
            {
               if((param1)&&(!resizer.hasOrigSize())&&Timer(param1.target).currentCount>Timer(param1.target).repeatCount)
                     {
                           log.debug("we don\'t have a size yet.. waiting for the video object to have a size");
                           return;
                     }
               if(resizer.resizeTo(mediaSize,force))
                     {
                           screen.resized(clip);
                     }
               return;
            };
         if(resizer.hasOrigSize())
            {
               this.log.debug("we have a size, resizing now !");
               resizingFunc();
            }
         else
            {
               this.log.warn("we don\'t have a size now, delaying the resize");
               this._resizerTimer=new Timer(500,5);
               this._resizerTimer.addEventListener(TimerEvent.TIMER,resizingFunc);
               this._resizerTimer.start();
            }
         return;
      }

      private function error(param1:String) : void {
         this.log.error(param1);
         throw new Error(param1);
      }

      private function onResize(param1:ClipEvent=null) : void {
         this.log.debug("received event "+param1.target);
         var _loc2_:Clip = Clip(param1.target);
         if(_loc2_.type==ClipType.IMAGE&&_loc2_.getContent()==null)
            {
               this.log.warn("image content not available yet, will not resize: "+_loc2_);
               return;
            }
         this.resizeClip(_loc2_);
         return;
      }

      private function addListeners(param1:ClipEventSupport) : void {
         param1.onStart(this.onResize);
         param1.onBufferFull(this.onResize);
         param1.onPlaylistReplace(this.onPlaylistChange);
         param1.onClipAdd(this.onPlaylistChange);
         return;
      }

      private function onPlaylistChange(param1:ClipEvent) : void {
         this.log.info("Received onPlaylistChanged");
         this.createResizers(ClipEventSupport(param1.target).clips.concat(ClipEventSupport(param1.target).childClips));
         return;
      }
   }

}