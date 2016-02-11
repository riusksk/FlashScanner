package org.goasap
{
   import flash.events.EventDispatcher;
   import org.goasap.interfaces.IPlayableBase;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import org.goasap.errors.InstanceNotAllowedError;


   public class PlayableBase extends EventDispatcher implements IPlayableBase
   {
         

      public function PlayableBase() {
         super();
         var _loc1_:String = getQualifiedClassName(this);
         if(_loc1_.slice(_loc1_.lastIndexOf("::")+2)=="PlayableBase")
            {
               throw new InstanceNotAllowedError("PlayableBase");
            }
         this.playableID=++_idCounter;
         return;
      }

      public static const STOPPED:String = "STOPPED";

      public static const PAUSED:String = "PAUSED";

      public static const PLAYING_DELAY:String = "PLAYING_DELAY";

      public static const PLAYING:String = "PLAYING";

      private static var _idCounter:int = -1;

      protected static var _playRetainer:Dictionary = new Dictionary(false);

      public function get playableID() : * {
         return this._id;
      }

      public function set playableID(param1:*) : void {
         this._id=param1;
         return;
      }

      public function get state() : String {
         return this._state;
      }

      protected var _state:String = "STOPPED";

      protected var _id;

      override  public function toString() : String {
         var _loc1_:String = super.toString();
         var _loc2_:* = _loc1_.charAt(_loc1_.length-1)=="]";
         if(_loc2_)
            {
               _loc1_=_loc1_.slice(0,-1);
            }
         if(this.playableID is String)
            {
               _loc1_=_loc1_+(" playableID:\""+this.playableID+"\"");
            }
         else
            {
               _loc1_=_loc1_+(" playableID:"+this.playableID);
            }
         if(_loc2_)
            {
               _loc1_=_loc1_+"]";
            }
         return _loc1_;
      }
   }

}