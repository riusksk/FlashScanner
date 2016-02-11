package org.flowplayer.view
{
   import flash.display.MovieClip;
   import org.flowplayer.util.Log;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.display.StageDisplayState;
   import org.flowplayer.util.Arrange;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getDefinitionByName;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import org.flowplayer.util.LogConfiguration;


   public class Preloader extends MovieClip
   {
         

      public function Preloader() {
         this._log=new Log(this);
         super();
         var _loc1_:LogConfiguration = new LogConfiguration();
         _loc1_.level="error";
         _loc1_.filter="org.flowplayer.view.Preloader";
         Log.configure(_loc1_);
         this._log.debug("Preloader");
         stop();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         return;
      }



      private var _log:Log;

      private var _app:DisplayObject;

      public var injectedConfig:String;

      private function onStageResize(param1:Event) : void {
         this.setParentDimensions();
         return;
      }

      private function setParentDimensions() : void {
         if(stage.displayState==StageDisplayState.FULL_SCREEN||(Arrange.set)&&!Arrange.hasParent)
            {
               Arrange.parentWidth=stage.stageWidth;
               Arrange.parentHeight=stage.stageHeight;
               return;
            }
         if((Arrange.set)&&(Arrange.hasParent))
            {
               Arrange.parentWidth=Arrange.localWidth;
               Arrange.parentHeight=Arrange.localHeight;
               return;
            }
         var _loc1_:Object = parent;
         while(_loc1_)
            {
               if(!(_loc1_.width==0)&&!(_loc1_.height==0)&&!(getQualifiedClassName(_loc1_)=="mx.controls::SWFLoader"))
                  {
                     Arrange.parentWidth=Arrange.localWidth=_loc1_.width;
                     Arrange.parentHeight=Arrange.localHeight=_loc1_.height;
                     Arrange.hasParent=true;
                     break;
                  }
               _loc1_=_loc1_.parent;
            }
         if(Arrange.parentWidth==0&&Arrange.parentHeight==0)
            {
               Arrange.parentWidth=stage.stageWidth;
               Arrange.parentHeight=stage.stageHeight;
            }
         Arrange.set=true;
         return;
      }

      private function onAddedToStage(param1:Event) : void {
         this.log("onAddedToStage(): stage size is "+Arrange.parentWidth+" x "+Arrange.parentHeight);
         this.log("onAddedToStage(), bytes loaded "+loaderInfo.bytesLoaded);
         stage.addEventListener(Event.RESIZE,this.onStageResize,false,1);
         this.setParentDimensions();
         addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         return;
      }

      private function enterFrameHandler(param1:Event) : void {
         this.log("enterFrameHandler() "+loaderInfo.bytesLoaded);
         if(loaderInfo.bytesLoaded==loaderInfo.bytesTotal)
            {
               this.log("bytesLoaded == bytesTotal, stageWidth = "+Arrange.parentWidth+" , stageHeight = "+Arrange.parentHeight);
               if(!(Arrange.parentWidth==0)&&!(Arrange.parentHeight==0))
                  {
                     this.initialize();
                     removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
                  }
            }
         return;
      }

      private function initialize() : void {
         var mainClass:Class = null;
         this.log("initialize()");
         nextFrame();
         if(this._app)
            {
               this.log("initialize(), _app already instantiated returning");
               return;
            }
         this.prepareStage();
         try
            {
               mainClass=this.getAppClass();
               this._app=new (mainClass)() as DisplayObject;
               addChild(this._app as DisplayObject);
               this.log("Launcher instantiated "+this._app);
               removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            }
         catch(e:Error)
            {
               log("error instantiating Launcher "+e+": "+e.message);
               _app=null;
            }
         return;
      }

      private function getAppClass() : Class {
         try
            {
               return Class(getDefinitionByName("org.flowplayer.view.Launcher"));
            }
         catch(e:Error)
            {
            }
         return null;
      }

      private function prepareStage() : void {
         if(!stage)
            {
               return;
            }
         stage.align=StageAlign.TOP_LEFT;
         stage.scaleMode=StageScaleMode.NO_SCALE;
         return;
      }

      private function log(param1:Object) : void {
         this._log.debug(param1+"");
         return;
      }

      private function get rotationEnabled() : Boolean {
         var _loc1_:Object = stage.loaderInfo.parameters["config"];
         if(!_loc1_)
            {
               return true;
            }
         if(_loc1_.replace(new (RegExp)("\\s","g"),"").indexOf("buffering:null")>0)
            {
               return false;
            }
         return true;
      }
   }

}