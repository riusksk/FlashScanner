package org.flowplayer.view
{


   class WrapperForIE extends Object
   {
         

      function WrapperForIE(param1:Flowplayer) {
         super();
         this._player=param1;
         return;
      }



      private var _player:Flowplayer;

      public function fp_stop() : void {
         this._player.stop();
         return;
      }

      public function fp_pause() : void {
         this._player.pause();
         return;
      }

      public function fp_resume() : void {
         this._player.resume();
         return;
      }

      public function fp_close() : void {
         this._player.close();
         return;
      }
   }

}