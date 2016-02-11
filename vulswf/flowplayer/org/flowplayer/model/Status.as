package org.flowplayer.model
{


   public class Status extends Object
   {
         

      public function Status(param1:State, param2:Clip, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean, param8:Number, param9:Boolean=false) {
         super();
         this._state=param1;
         this._clip=param2;
         this._time=(param3)||(0);
         this._bufferStart=(param4)||(0);
         this._bufferEnd=(param5)||(0);
         this._bytesTotal=(param6)||(0);
         this._allowRandomSeek=param9;
         this._muted=param7;
         this._volume=param8;
         return;
      }



      private var _state:State;

      private var _clip:Clip;

      private var _time:Number;

      private var _bufferStart:Number;

      private var _bufferEnd:Number;

      private var _bytesTotal:Number;

      private var _allowRandomSeek:Boolean;

      private var _muted:Boolean;

      private var _volume:Number;

      public function get ended() : Boolean {
         return this._clip.type==ClipType.IMAGE&&this._clip.duration==0||(this._clip.played)&&this._clip.duration-this._time<=1;
      }

      public function get clip() : Clip {
         return this._clip;
      }

      public function get time() : Number {
         return this._time;
      }

      public function get bufferStart() : Number {
         return this._bufferStart;
      }

      public function get bufferEnd() : Number {
         return this._bufferEnd;
      }

      public function get bytesTotal() : Number {
         return this._bytesTotal;
      }

      public function toString() : String {
         return "[PlayStatus] time "+this._time+", buffer: ["+this._bufferStart+", "+this._bufferEnd+"]";
      }

      public function get allowRandomSeek() : Boolean {
         return this._allowRandomSeek;
      }

      public function get muted() : Boolean {
         return this._muted;
      }

      public function get volume() : Number {
         return this._volume;
      }

      public function get state() : int {
         return this._state.code;
      }

      public function getState() : State {
         return this._state;
      }

      public function set clip(param1:Clip) : void {
         this._clip=param1;
         return;
      }
   }

}