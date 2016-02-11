package org.flowplayer.view
{
   import org.flowplayer.util.Log;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.MediaSize;


   class MediaResizer extends Object
   {
         

      function MediaResizer(param1:Clip, param2:int, param3:int) {
         this.log=new Log(this);
         super();
         this._clip=param1;
         this._maxWidth=param2;
         this._maxHeight=param3;
         this._currentSizingOption=MediaSize.FITTED_PRESERVING_ASPECT_RATIO;
         return;
      }



      private var log:Log;

      private var _clip:Clip;

      private var _maxWidth:int;

      private var _maxHeight:int;

      private var _currentSizingOption:MediaSize;

      public function setMaxSize(param1:int, param2:int) : void {
         this._maxWidth=param1;
         this._maxHeight=param2;
         return;
      }

      public function resizeTo(param1:MediaSize, param2:Boolean=false) : Boolean {
         this.log.debug("resizeTo() "+param1);
         if(param1==null)
            {
               param1=this._currentSizingOption;
            }
         var _loc3_:* = false;
         if(param1==MediaSize.FITTED_PRESERVING_ASPECT_RATIO)
            {
               _loc3_=this.resizeToFit();
            }
         else
            {
               if(param1==MediaSize.HALF_FROM_ORIGINAL)
                  {
                     _loc3_=this.resizeToHalfAvailableSize();
                  }
               else
                  {
                     if(param1==MediaSize.ORIGINAL)
                        {
                           _loc3_=this.resizeToOrig(param2);
                        }
                     else
                        {
                           if(param1==MediaSize.FILLED_TO_AVAILABLE_SPACE)
                              {
                                 _loc3_=this.resizeToMax();
                              }
                           else
                              {
                                 if(param1==MediaSize.CROP_TO_AVAILABLE_SPACE)
                                    {
                                       _loc3_=this.resizeToFit(true);
                                    }
                              }
                        }
                  }
            }
         this._currentSizingOption=param1;
         return _loc3_;
      }

      private function resizeToFit(param1:Boolean=false) : Boolean {
         var _loc4_:* = NaN;
         if(this.origWidth==0||this.origHeight==0)
            {
               this.log.warn("resizeToFit: original sizes not available, will not resize");
               return false;
            }
         this.log.debug("resize to fit, original size "+this._clip.originalWidth+"x"+this._clip.originalHeight+", will crop? "+param1);
         var _loc2_:Number = this._maxWidth/this.origWidth;
         var _loc3_:Boolean = param1?_loc2_*this.origHeight<this._maxHeight:_loc2_*this.origHeight<=this._maxHeight;
         this.log.debug("using "+(_loc3_?"x-ratio":"y-ratio"));
         if(_loc3_)
            {
               this.resize(this._maxWidth,this.calculateFittedDimension(this._maxHeight,this.origHeight,_loc2_));
            }
         else
            {
               _loc4_=this._maxHeight/this.origHeight;
               this.resize(this.calculateFittedDimension(this._maxWidth,this.origWidth,_loc4_),this._maxHeight);
            }
         return true;
      }

      private function calculateFittedDimension(param1:int, param2:int, param3:Number) : int {
         var _loc4_:int = Math.ceil(param3*param2);
         return _loc4_<param1?param1:_loc4_;
      }

      public function scale(param1:Number) : void {
         this.resize(param1*this.origWidth,param1*this.origHeight);
         return;
      }

      private function resizeToOrig(param1:Boolean=false) : Boolean {
         if(param1)
            {
               this.resize(this.origWidth,this.origHeight);
               return true;
            }
         if(this.origHeight<this._maxHeight||this.origWidth<this._maxWidth)
            {
               this.log.warn("original size bigger that mas size! resizeToOrig() falls to resizeToFit()");
               return this.resizeToFit();
            }
         if((this.origWidth)&&(this.origHeight))
            {
               this.log.debug("resize to original size");
               this.resize(this.origWidth,this.origHeight);
               return true;
            }
         this.log.warn("resizeToOrig() cannot resize to original size because original size is not available");
         return false;
      }

      private function resizeToHalfAvailableSize() : Boolean {
         this.log.debug("resize to half");
         this.scale(this._maxWidth/2/this.origWidth);
         return true;
      }

      private function resizeToMax() : Boolean {
         this.log.debug("resizing to max size (filling available space)");
         this.resize(this._maxWidth,this._maxHeight);
         return true;
      }

      private function resize(param1:int, param2:int) : void {
         this.log.debug("resizing to "+param1+"x"+param2);
         this._clip.width=param1;
         this._clip.height=param2;
         this.log.debug("resized to "+this._clip.width+"x"+this._clip.height);
         return;
      }

      public function get currentSize() : MediaSize {
         return this._currentSizingOption;
      }

      public function hasOrigSize() : Boolean {
         return this.origHeight<0&&this.origWidth<0;
      }

      public function toString() : String {
         return "[MediaResizer] origWidth: "+this.origWidth+", origHeight: "+this.origHeight+", maxWidth: "+this._maxWidth+", maxHeight: "+this._maxHeight;
      }

      public function get origWidth() : int {
         return this._clip.originalWidth;
      }

      public function get origHeight() : int {
         return this._clip.originalHeight;
      }
   }

}