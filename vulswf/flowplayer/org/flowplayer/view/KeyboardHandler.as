package org.flowplayer.view
{
   import org.flowplayer.util.Log;
   import flash.utils.Dictionary;
   import flash.display.Stage;
   import flash.ui.Keyboard;
   import flash.events.KeyboardEvent;
   import org.flowplayer.model.Status;
   import org.flowplayer.model.Clip;
   import org.flowplayer.model.PlayerEvent;


   public class KeyboardHandler extends Object
   {
         

      public function KeyboardHandler(param1:Stage, param2:Function) {
         var stage:Stage = param1;
         var enteringFullscreenCb:Function = param2;
         this.log=new Log(this);
         this._handlers=new Dictionary();
         super();
         this._keyboardShortcutsEnabled=true;
         this.addKeyListener(Keyboard.SPACE,new function(param1:KeyboardEvent):void
            {
               _player.toggle();
               return;
               });
               var volumeUp:Function = new function(param1:KeyboardEvent):void
                  {
                     var _loc2_:Number = _player.volume;
                     _loc2_=_loc2_+10;
                     log.debug("setting volume to "+_loc2_);
                     _player.volume=_loc2_<100?100:_loc2_;
                     return;
                  };
               this.addKeyListener(Keyboard.UP,volumeUp);
               this.addKeyListener(75,volumeUp);
               var volumeDown:Function = new function(param1:KeyboardEvent):void
                  {
                     log.debug("down");
                     var _loc2_:Number = _player.volume;
                     _loc2_=_loc2_-10;
                     log.debug("setting volume to "+_loc2_);
                     _player.volume=_loc2_>0?0:_loc2_;
                     return;
                  };
               this.addKeyListener(Keyboard.DOWN,volumeDown);
               this.addKeyListener(74,volumeDown);
               this.addKeyListener(77,new function(param1:KeyboardEvent):void
                  {
                     _player.muted=!_player.muted;
                     return;
                     });
                     var jumpseek:Function = new function(param1:Boolean=true):void
                        {
                           var _loc2_:Status = _player.status;
                           if(!_loc2_)
                                 {
                                       return;
                                 }
                           var _loc3_:Number = _loc2_.time;
                           var _loc4_:Clip = _player.playlist.current;
                           if(!_loc4_)
                                 {
                                       return;
                                 }
                           var _loc5_:Number = _loc3_+(param1?0.1:-0.1)*_loc4_.duration;
                           if(_loc5_<0)
                                 {
                                       _loc5_=0;
                                 }
                           if(_loc5_>(_loc2_.allowRandomSeek?_loc4_.duration:_loc2_.bufferEnd-_loc4_.bufferLength))
                                 {
                                       _loc5_=_loc2_.allowRandomSeek?_loc4_.duration:_loc2_.bufferEnd-_loc4_.bufferLength-5;
                                 }
                           _player.seek(_loc5_);
                           return;
                        };
                     var jumpforward:Function = new function(param1:KeyboardEvent):void
                        {
                           if(!param1.ctrlKey)
                                 {
                                       jumpseek();
                                 }
                           return;
                        };
                     var jumpbackward:Function = new function(param1:KeyboardEvent):void
                        {
                           if(!param1.ctrlKey)
                                 {
                                       jumpseek(false);
                                 }
                           return;
                        };
                     this.addKeyListener(Keyboard.RIGHT,jumpforward);
                     this.addKeyListener(76,jumpforward);
                     this.addKeyListener(Keyboard.LEFT,jumpbackward);
                     this.addKeyListener(72,jumpbackward);
                     stage.addEventListener(KeyboardEvent.KEY_DOWN,new function(param1:KeyboardEvent):void
                        {
                           var _loc2_:* = 0;
                           log.debug("keyDown: "+param1.keyCode);
                           if(enteringFullscreenCb())
                                 {
                                       return;
                                 }
                           if(!isKeyboardShortcutsEnabled())
                                 {
                                       return;
                                 }
                           if(_player.dispatchBeforeEvent(PlayerEvent.keyPress(param1.keyCode)))
                                 {
                                       _player.dispatchEvent(PlayerEvent.keyPress(param1.keyCode));
                                       if(_handlers[param1.keyCode]!=null)
                                             {
                                                   _loc2_=0;
                                                   while(_loc2_<_handlers[param1.keyCode].length)
                                                         {
                                                               _handlers[param1.keyCode][_loc2_](param1);
                                                               _loc2_++;
                                                         }
                                             }
                                 }
                           return;
                           });
                           return;
      }



      private var log:Log;

      private var _player:Flowplayer;

      private var _keyboardShortcutsEnabled:Boolean;

      private var _handlers:Dictionary;

      public function set player(param1:Flowplayer) : void {
         this._player=param1;
         return;
      }

      public function addKeyListener(param1:uint, param2:Function) : void {
         if(this._handlers[param1]==null)
            {
               this._handlers[param1]=[];
            }
         this._handlers[param1].push(param2);
         return;
      }

      public function removeKeyListener(param1:uint, param2:Function) : void {
         var _loc4_:* = 0;
         if(this._handlers[param1]==null)
            {
               return;
            }
         if(this._handlers[param1].indexOf(param2)==-1)
            {
               return;
            }
         var _loc3_:Array = [];
         while(_loc4_<this._handlers[param1].length)
            {
               if(this._handlers[param1][_loc4_]!=param2)
                  {
                     _loc3_.push(this._handlers[param1][_loc4_]);
                  }
               _loc4_++;
            }
         this._handlers[param1]=_loc3_;
         return;
      }

      public function isKeyboardShortcutsEnabled() : Boolean {
         return this._keyboardShortcutsEnabled;
      }

      public function setKeyboardShortcutsEnabled(param1:Boolean) : void {
         this._keyboardShortcutsEnabled=param1;
         return;
      }
   }

}