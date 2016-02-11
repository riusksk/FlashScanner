package org.flowplayer.util
{
   import flash.utils.describeType;
   import org.flowplayer.model.Extendable;


   public class ObjectConverter extends Object
   {
         

      public function ObjectConverter(param1:*) {
         this.log=new Log(this);
         super();
         this._input=param1;
         return;
      }

      public static function copyProps(param1:Object, param2:Object) : Object {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         for (_loc4_ in param1)
            {
               _loc3_=param1[_loc4_];
               if(!(_loc3_==null)&&!(_loc3_ is Function))
                  {
                     param2[_loc4_]=_loc3_;
                  }
            }
         return param2;
      }

      private var _input:Object;

      protected var log:Log;

      public function convert() : Object {
         return this.process(this._input);
      }

      private function process(param1:*) : Object {
         if(param1 is String)
            {
               return param1;
            }
         if(param1 is Number)
            {
               return param1;
            }
         if(param1 is Boolean)
            {
               return param1;
            }
         if(param1 is Array)
            {
               return this.convertArray(param1 as Array);
            }
         if(param1 is Object&&!(param1==null))
            {
               return this.convertObject(param1);
            }
         return param1;
      }

      private function convertArray(param1:Array) : Array {
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_<param1.length)
            {
               _loc2_.push(this.process(param1[_loc3_]));
               _loc3_++;
            }
         return _loc2_;
      }

      private function convertObject(param1:Object) : Object {
         var exposed:XMLList = null;
         var v:XML = null;
         var key2:String = null;
         var o:Object = param1;
         var obj:Object = new Object();
         var classInfo:XML = describeType(o);
         this.log.debug("classInfo : "+classInfo.@name.toString());
         if(classInfo.@name.toString()=="Object")
            {
               copyProps(o,obj);
            }
         else
            {
               exposed=classInfo.*.((hasOwnProperty("metadata"))&&metadata.@name=="Value");
               for each (v in exposed)
                  {
                     if(o[v.@name]!=null)
                        {
                           key2=v.metadata.arg.@key=="name"?v.metadata.arg.@value:v.@name.toString();
                           obj[key2]=this.process(o[v.@name]);
                        }
                  }
               if(o is Extendable)
                  {
                     copyProps(Extendable(o).customProperties,obj);
                  }
            }
         return obj;
      }

      public function convertKey() : String {
         var _loc1_:RegExp = new (RegExp)("-","g");
         return this._input.replace(_loc1_,"_");
      }
   }

}