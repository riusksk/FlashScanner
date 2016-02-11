package org.flowplayer.controller
{
   import org.flowplayer.model.ClipEvent;
   import org.flowplayer.model.Clip;
   import flash.display.DisplayObject;
   import org.flowplayer.model.Playlist;
   import flash.utils.Dictionary;
   import flash.net.NetStream;
   import flash.net.NetConnection;


   public interface StreamProvider
   {
         



      function load(param1:ClipEvent, param2:Clip, param3:Boolean=true) : void;

      function getVideo(param1:Clip) : DisplayObject;

      function attachStream(param1:DisplayObject) : void;

      function pause(param1:ClipEvent) : void;

      function resume(param1:ClipEvent) : void;

      function stop(param1:ClipEvent, param2:Boolean=false) : void;

      function seek(param1:ClipEvent, param2:Number) : void;

      function get fileSize() : Number;

      function get time() : Number;

      function get bufferStart() : Number;

      function get bufferEnd() : Number;

      function get allowRandomSeek() : Boolean;

      function set volumeController(param1:VolumeController) : void;

      function get stopping() : Boolean;

      function set playlist(param1:Playlist) : void;

      function get playlist() : Playlist;

      function addConnectionCallback(param1:String, param2:Function) : void;

      function addStreamCallback(param1:String, param2:Function) : void;

      function get streamCallbacks() : Dictionary;

      function get netStream() : NetStream;

      function get netConnection() : NetConnection;

      function set timeProvider(param1:TimeProvider) : void;

      function get type() : String;

      function switchStream(param1:ClipEvent, param2:Clip, param3:Object=null) : void;
   }

}