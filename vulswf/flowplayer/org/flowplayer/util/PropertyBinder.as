package org.flowplayer.util
{
   import flash.utils.getQualifiedClassName;
   import flash.utils.describeType;


   public class PropertyBinder extends Object
   {
         

      public function PropertyBinder(param1:Object, param2:String=null) {
         this.log=new Log(this);
         super();
         this.log.info("created for "+getQualifiedClassName(param1));
         this._object=param1;
         this._extraProps=param2;
         this._objectDesc=describeType(this._object);
         return;
      }



      private var log:Log;

      private var _object:Object;

      private var _objectDesc:XML;

      private var _extraProps:String;

      public function copyProperties(param1:Object, param2:Boolean=true) : Object {
         var _loc3_:String = null;
         if(!param1)
            {
               return this._object;
            }
         this.log.debug("copyProperties, overwrite = "+param2+(this._extraProps?", extraprops will be set to "+this._extraProps:""));
         for (_loc3_ in param1)
            {
               if((param2)||!this.hasValue(this._object,_loc3_))
                  {
                     this.copyProperty(_loc3_,param1[_loc3_]);
                  }
            }
         this.log.debug("done with "+getQualifiedClassName(this._object));
         return this._object;
      }

      public function copyProperty(param1:String, param2:Object, param3:Boolean=false) : void {
         var setter:String = null;
         var method:XMLList = null;
         var property:XMLList = null;
         var prop:String = param1;
         var value:Object = param2;
         var convertType:Boolean = param3;
         this.log.debug("copyProperty() "+prop+": "+value);
         setter="set"+prop.charAt(0).toUpperCase()+prop.substring(1);
         method=this._objectDesc.method.(@name==setter);
         if(method.length()==1)
            {
               try
                  {
                     this._object[setter](convertType?this.toType(value,method.@type):value);
                     this.log.debug("successfully initialized property \'"+prop+"\' to value \'"+value+"\'");
                     return;
                  }
               catch(e:Error)
                  {
                     log.debug("unable to initialize using "+setter);
                  }
            }
         property=this._objectDesc.*.((hasOwnProperty("@name"))&&@name==prop);
         if(property.length()==1)
            {
               try
                  {
                     this.log.debug("trying to set property \'"+prop+"\' directly");
                     this._object[prop]=convertType?this.toType(value,property.@type):value;
                     this.log.debug("successfully initialized property \'"+prop+"\' to value \'"+value+"\'");
                     return;
                  }
               catch(e:Error)
                  {
                     log.debug("unable to set to field / using accessor");
                  }
            }
         if(this._extraProps)
            {
               this.log.debug("setting to extraprops "+this._extraProps+", prop "+prop+" value "+value);
               this.configure(this._object,(this._extraProps)||"customProperties",prop,value);
            }
         else
            {
               this.log.debug("skipping property \'"+prop+"\', value "+value);
            }
         return;
      }

      private function toType(param1:Object, param2:String) : Object {
         this.log.debug("toType() "+param2);
         if(param2=="Boolean")
            {
               return param1=="true";
            }
         if(param2=="Number")
            {
               return Number(param1);
            }
         return param1;
      }

      private function hasValue(param1:Object, param2:String) : Boolean {
         if(this.objHasValue(param1,param2))
            {
               return true;
            }
         if(this._extraProps)
            {
               return this.objHasValue(param1[this._extraProps],param2);
            }
         return false;
      }

      private function objHasValue(param1:Object, param2:String) : Boolean {
         var _loc3_:Object = null;
         if(param1==null)
            {
               return false;
            }
         try
            {
               _loc3_=param1[param2];
               if(_loc3_ is Number)
                  {
                     return _loc3_>=0;
                  }
               if(_loc3_ is Boolean)
                  {
                     return true;
                  }
               return !(_loc3_==null);
            }
         catch(ignore:Error)
            {
            }
         return param1.hasValue(param2);
      }

      private function configure(param1:Object, param2:String, param3:String, param4:Object) : void {
         var _loc5_:Object = (param1[param2])||(new Object());
         _loc5_[param3]=param4;
         param1[param2]=_loc5_;
         return;
      }
   }

}