package org.flowplayer.model
{
   import flash.utils.Dictionary;
   import org.flowplayer.util.Assert;


   class TimedPlaylist extends Object
   {
         

      function TimedPlaylist() {
         super();
         this._clips=[];
         this._clipsByTime=new Dictionary();
         return;
      }



      private var _clips:Array;

      private var _clipsByTime:Dictionary;

      public function addClip(param1:Clip) : void {
         Assert.notNull(param1,"addClip(), clip cannot be null");
         if(param1.position>0&&!param1.isOneShot)
            {
               throw new Error("clip\'s childStart time must be greater than zero!");
            }
         this._clips.push(param1);
         this._clipsByTime[param1.position]=param1;
         return;
      }

      public function indexOf(param1:Clip) : int {
         return this._clips.indexOf(param1);
      }

      public function getClipAt(param1:Number) : Clip {
         return this._clipsByTime[Math.round(param1)];
      }

      public function get length() : int {
         return this._clips.length;
      }

      public function get clips() : Array {
         return this._clips.concat();
      }

      public function removeClip(param1:Clip) : void {
         this._clips.splice(this._clips.indexOf(param1),1);
         delete this._clipsByTime[[param1.position]];
         return;
      }
   }

}