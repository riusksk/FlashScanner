package org.flowplayer.view
{
   import org.flowplayer.util.Log;
   import flash.utils.Dictionary;
   import org.flowplayer.model.DisplayProperties;
   import flash.display.DisplayObject;
   import org.flowplayer.layout.LengthMath;
   import org.flowplayer.flow_internal;
   import org.flowplayer.util.Assert;
   import org.goasap.events.GoEvent;
   import flash.geom.Rectangle;
   import org.goasap.utils.PlayableGroup;
   import org.goasap.interfaces.IPlayable;

   use namespace flow_internal;

   public class AnimationEngine extends Object
   {
         

      public function AnimationEngine(param1:Panel, param2:PluginRegistry) {
         this.log=new Log(this);
         this._runningPlayablesByView=new Dictionary();
         this._canceledByPlayable=new Dictionary();
         super();
         this._panel=param1;
         this._pluginRegistry=param2;
         return;
      }



      private var log:Log;

      private var _panel:Panel;

      private var _pluginRegistry:PluginRegistry;

      private var _runningPlayablesByView:Dictionary;

      private var _canceledByPlayable:Dictionary;

      public function animate(param1:DisplayObject, param2:Object, param3:int=400, param4:Function=null, param5:Function=null, param6:Function=null) : DisplayProperties {
         var _loc9_:DisplayProperties = null;
         var _loc7_:DisplayProperties = this._pluginRegistry.getPluginByDisplay(param1);
         var _loc8_:* = !(_loc7_==null);
         if(_loc8_)
            {
               this.log.debug("animating plugin "+_loc7_);
            }
         else
            {
               this.log.debug("animating non-plugin displayObject "+param1);
            }
         if(_loc8_)
            {
               _loc9_=param2 is DisplayProperties?param2 as DisplayProperties:LengthMath.sum(_loc7_,param2,this._panel.stage);
               this.log.debug("current dimensions "+_loc7_.dimensions);
               param1.visible=_loc9_.visible;
               if(param1.visible)
                  {
                     this.panelAnimate(_loc7_.getDisplayObject(),_loc9_,param3,param4,param6);
                  }
               else
                  {
                     this.log.info("removing from panel "+param1);
                     this._panel.removeChild(param1);
                  }
               this._pluginRegistry.updateDisplayProperties(_loc9_);
            }
         else
            {
               this.startTweens(param1,this.alpha(param2),param2.width,param2.height,param2.x,param2.y,param3,param4,param5,param6);
            }
         return _loc9_;
      }

      flow_internal function animateNonPanel(param1:DisplayObject, param2:DisplayObject, param3:Object, param4:int=400, param5:Function=null, param6:Function=null) : DisplayProperties {
         this.log.debug("animateNonPanel",param3);
         var _loc7_:DisplayProperties = this._pluginRegistry.getPluginByDisplay(param2);
         var _loc8_:DisplayProperties = param3 is DisplayProperties?param3 as DisplayProperties:LengthMath.sum(_loc7_,param3,param1);
         this.startTweens(param2,this.alpha(param3),param3.width,param3.height,param3.x,param3.y,param4,param5,param6);
         return _loc8_;
      }

      private function alpha(param1:Object) : Number {
         if(param1.hasOwnProperty("alpha"))
            {
               return param1["alpha"];
            }
         if(param1.hasOwnProperty("opacity"))
            {
               return param1["opacity"];
            }
         return NaN;
      }

      public function animateProperty(param1:DisplayObject, param2:String, param3:Number, param4:int=500, param5:Function=null, param6:Function=null, param7:Function=null) : void {
         var _loc8_:Object = new Object();
         _loc8_[param2]=param3;
         this.animate(param1,_loc8_,param4,param5,param6,param7);
         return;
      }

      public function fadeIn(param1:DisplayObject, param2:Number=500, param3:Function=null, param4:Boolean=true) : Animation {
         param1.visible=true;
         return this.animateAlpha(param1,1,param2,param3,param4);
      }

      public function fadeTo(param1:DisplayObject, param2:Number, param3:Number=500, param4:Function=null, param5:Boolean=true) : Animation {
         return this.animateAlpha(param1,param2,param3,param4,param5);
      }

      public function fadeOut(param1:DisplayObject, param2:Number=500, param3:Function=null, param4:Boolean=true) : Animation {
         return this.animateAlpha(param1,0,param2,param3,param4);
      }

      public function cancel(param1:DisplayObject, param2:Animation=null) : void {
         var view:DisplayObject = param1;
         var currentAnimation:Animation = param2;
         this.log.debug("cancel() cancelling animation for "+view);
         var action:Function = new function(param1:Animation):void
            {
               _canceledByPlayable[param1]=true;
               delete _runningPlayablesByView[[view]];
               param1.stop();
               log.info("tween for property "+param1.tweenProperty+" was canceled on view "+view);
               return;
            };
         this.processAction(action,view,currentAnimation);
         return;
      }

      public function pause(param1:DisplayObject, param2:Animation=null) : void {
         var view:DisplayObject = param1;
         var currentAnimation:Animation = param2;
         this.log.debug("pause() pausing animation for "+view);
         var action:Function = new function(param1:Animation):void
            {
               param1.pause();
               log.info("tween for property "+param1.tweenProperty+" was paused on view "+view);
               return;
            };
         this.processAction(action,view,currentAnimation);
         return;
      }

      public function resume(param1:DisplayObject, param2:Animation=null) : void {
         var view:DisplayObject = param1;
         var currentAnimation:Animation = param2;
         this.log.debug("resume() resuming animation for "+view);
         var action:Function = new function(param1:Animation):void
            {
               param1.resume();
               log.info("tween for property "+param1.tweenProperty+" was resumed on view "+view);
               return;
            };
         this.processAction(action,view,currentAnimation);
         return;
      }

      private function processAction(param1:Function, param2:DisplayObject, param3:Animation=null) : void {
         var _loc4_:Object = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:Animation = null;
         for (_loc4_ in this._runningPlayablesByView)
            {
               this.log.debug("cancel(), currently running animation for "+_loc4_);
               _loc5_=_loc4_ as DisplayObject;
               if(_loc5_==param2)
                  {
                     _loc6_=this._runningPlayablesByView[_loc5_] as Animation;
                     if((_loc6_)&&(((param3)&&(!(_loc6_==param3)))||(!param3)))
                        {
                           if((param3)&&(param3.tweenProperty==_loc6_.tweenProperty)||!param3)
                              {
                                 param1(_loc6_);
                              }
                        }
                  }
            }
         return;
      }

      public function hasAnimationRunning(param1:DisplayObject) : Boolean {
         var _loc2_:Object = null;
         var _loc3_:DisplayObject = null;
         for (_loc2_ in this._runningPlayablesByView)
            {
               this.log.debug("cancel(), currently running animation for "+_loc2_);
               _loc3_=_loc2_ as DisplayObject;
               if(_loc3_==param1)
                  {
                     return true;
                  }
            }
         return false;
      }

      private function logRunningAnimations(param1:String, param2:DisplayObject) : void {
         var _loc3_:Object = null;
         for (_loc3_ in this._runningPlayablesByView)
            {
               this.log.debug(param1+": found running animation for "+param2+", "+this._runningPlayablesByView[_loc3_]);
            }
         return;
      }

      private function animateAlpha(param1:DisplayObject, param2:Number, param3:Number=500, param4:Function=null, param5:Boolean=true) : Animation {
         var playable:Animation = null;
         var plugin:DisplayProperties = null;
         var view:DisplayObject = param1;
         var target:Number = param2;
         var durationMillis:Number = param3;
         var completeCallback:Function = param4;
         var updatePanel:Boolean = param5;
         Assert.notNull(view,"animateAlpha: view cannot be null");
         playable=this.createTween("alpha",view,target,durationMillis);
         if(!playable)
            {
               if(completeCallback!=null)
                  {
                     completeCallback();
                  }
               if(target==0)
                  {
                     this._panel.removeChild(view);
                  }
               else
                  {
                     if(view.parent!=this._panel)
                        {
                           this._panel.addView(view,null,plugin);
                        }
                  }
               return null;
            }
         this.cancel(view,playable);
         plugin=this._pluginRegistry.getPluginByDisplay(view);
         if((updatePanel)&&(plugin))
            {
               this.log.debug("animateAlpha(): will add/remove from panel");
               if(target==0)
                  {
                     playable.addEventListener(GoEvent.COMPLETE,new function(param1:GoEvent):void
                        {
                           if(!_canceledByPlayable[playable])
                                 {
                                       log.info("removing "+view+" from panel");
                                       view.parent.removeChild(view);
                                 }
                           else
                                 {
                                       log.info("previous fadeout was canceled, will not remove "+view+" from panel");
                                 }
                           return;
                           });
                        }
                     else
                        {
                           if(view.parent!=this._panel)
                              {
                                 this._panel.addView(view,null,plugin);
                              }
                        }
                  }
               else
                  {
                     this.log.info("animateAlpha, view is not added/removed from panel: "+view);
                  }
               var tween:Animation = this.start(view,playable,completeCallback) as Animation;
               if(tween)
                  {
                     this._pluginRegistry.updateDisplayPropertiesForDisplay(view,{alpha:target,
                     display:target==0?"none":"block"});
                  }
               return tween;
      }

      private function panelAnimate(param1:DisplayObject, param2:DisplayProperties, param3:int=500, param4:Function=null, param5:Function=null) : void {
         Assert.notNull(param2.name,"displayProperties.name must be specified");
         this.log.debug("animate "+param1);
         if(param1.parent!=this._panel)
            {
               this._panel.addView(param1);
            }
         var _loc6_:Rectangle = this._panel.update(param1,param2);
         this.startTweens(param1,param2.alpha,_loc6_.width,_loc6_.height,int(_loc6_.x),int(_loc6_.y),param3,param4,param5);
         if(param3==0)
            {
               if(param2.alpha>=0)
                  {
                     param1.alpha=param2.alpha;
                  }
               this._panel.draw(param1);
            }
         return;
      }

      private function startTweens(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:int, param8:Function, param9:Function, param10:Function=null) : Array {
         var _loc11_:Array = new Array();
         var _loc12_:Animation = this.createTween("alpha",param1,param2,param7);
         if(_loc12_)
            {
               this.cancel(param1,_loc12_);
               this.addTween(_loc11_,_loc12_);
            }
         this.addTween(_loc11_,this.createTween("width",param1,param3,param7,param10));
         this.addTween(_loc11_,this.createTween("height",param1,param4,param7,param10));
         this.addTween(_loc11_,this.createTween("x",param1,param5,param7,param10));
         this.addTween(_loc11_,this.createTween("y",param1,param6,param7,param10));
         if(_loc11_.length==0)
            {
               if(param8!=null)
                  {
                     param8();
                  }
               return _loc11_;
            }
         var _loc13_:IPlayable = _loc11_.length<1?new PlayableGroup(_loc11_):_loc11_[0];
         this.start(param1,_loc13_,param8,param9);
         return _loc11_;
      }

      private function addTween(param1:Array, param2:IPlayable) : void {
         if(!param2)
            {
               return;
            }
         this.log.debug("will animate "+param2);
         param1.push(param2);
         return;
      }

      private function start(param1:DisplayObject, param2:IPlayable, param3:Function=null, param4:Function=null) : IPlayable {
         var view:DisplayObject = param1;
         var playable:IPlayable = param2;
         var completeCallback:Function = param3;
         var updateCallback:Function = param4;
         if(playable==null)
            {
               return null;
            }
         this.logRunningAnimations("start",view);
         this._runningPlayablesByView[view]=playable;
         this.log.debug("start() staring animation for view "+view);
         playable.addEventListener(GoEvent.COMPLETE,new function(param1:GoEvent):void
            {
               onComplete(view,playable,completeCallback);
               return;
               });
               if(updateCallback!=null)
                  {
                     playable.addEventListener(GoEvent.UPDATE,new function(param1:GoEvent):void
                        {
                           updateCallback(view);
                           return;
                           });
                        }
                     playable.start();
                     return playable;
      }

      private function onComplete(param1:DisplayObject, param2:IPlayable, param3:Function=null) : void {
         this.log.debug("onComplete, view "+param1);
         delete this._canceledByPlayable[[param2]];
         delete this._runningPlayablesByView[[param1]];
         if(!(param3==null)&&!this._canceledByPlayable[param2])
            {
               param3();
            }
         return;
      }

      private function createTween(param1:String, param2:DisplayObject, param3:Number, param4:int, param5:Function=null) : Animation {
         if(isNaN(param3))
            {
               return null;
            }
         if(param2[param1]==param3)
            {
               this.log.debug("view property "+param1+" already in target value "+param3+", will not animate");
               return null;
            }
         this.log.debug("creating tween for property "+param1+", target value is "+param3+", current value is "+param2[param1]);
         var _loc6_:Animation = new Animation(param2,param1,param3,param4);
         if(param5!=null)
            {
               _loc6_.easing=param5;
            }
         return _loc6_;
      }
   }

}