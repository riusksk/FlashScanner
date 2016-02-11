package org.flowplayer.model
{
   import org.flowplayer.layout.Dimensions;
   import org.flowplayer.layout.Position;
   import flash.display.DisplayObject;


   public class DisplayPropertiesImpl extends PluginEventDispatcher implements DisplayProperties
   {
         

      public function DisplayPropertiesImpl(param1:DisplayObject=null, param2:String=null, param3:Boolean=true) {
         this._dimensions=new Dimensions();
         this._position=new Position();
         super();
         this._displayObject=param1;
         this._name=param2;
         if(!param3)
            {
               return;
            }
         this.alpha=1;
         this.display="block";
         this.left="50%";
         this.top="50%";
         if(param1)
            {
               this.width=(param1.width)||("50%");
               this.height=(param1.height)||("50%");
            }
         return;
      }

      public static function fullSize(param1:String) : DisplayPropertiesImpl {
         var _loc2_:DisplayPropertiesImpl = new (DisplayPropertiesImpl)();
         _loc2_.name=param1;
         _loc2_.left="50%";
         _loc2_.top="50%";
         _loc2_.width="100%";
         _loc2_.height="100%";
         return _loc2_;
      }

      private var _name:String;

      private var _display:String = "block";

      private var _dimensions:Dimensions;

      private var _alpha:Number = 1;

      private var _zIndex:Number = -1;

      private var _position:Position;

      private var _displayObject:DisplayObject;

      public function clone() : Cloneable {
         var _loc1_:DisplayPropertiesImpl = new DisplayPropertiesImpl();
         this.copyFields(this,_loc1_);
         return _loc1_;
      }

      protected function copyFields(param1:DisplayProperties, param2:DisplayPropertiesImpl) : void {
         param2._dimensions=param1.dimensions.clone() as Dimensions;
         param2._alpha=param1.alpha;
         param2._zIndex=param1.zIndex;
         param2._name=param1.name;
         param2._display=param1.display;
         param2._displayObject=param1.getDisplayObject();
         param2._position=param1.position.clone();
         return;
      }

      public function getDisplayObject() : DisplayObject {
         return this._displayObject;
      }

      public function setDisplayObject(param1:DisplayObject) : void {
         this._displayObject=param1;
         return;
      }

      public function set width(param1:Object) : void {
         this._dimensions.widthValue=param1;
         return;
      }

      public function get widthPx() : Number {
         return this._dimensions.width.px;
      }

      public function get widthPct() : Number {
         return this._dimensions.width.pct;
      }

      public function set height(param1:Object) : void {
         this._dimensions.heightValue=param1;
         return;
      }

      public function get heightPx() : Number {
         return this._dimensions.height.px;
      }

      public function get heightPct() : Number {
         return this._dimensions.height.pct;
      }

      public function set alpha(param1:Number) : void {
         this._alpha=param1;
         return;
      }

      public function get alpha() : Number {
         return this._alpha;
      }

      public function set zIndex(param1:Number) : void {
         this._zIndex=param1;
         return;
      }

      public function get zIndex() : Number {
         return this._zIndex;
      }

      public function get display() : String {
         return this._display;
      }

      public function set display(param1:String) : void {
         this._display=param1;
         return;
      }

      public function get visible() : Boolean {
         return this._display=="block";
      }

      public function toString() : String {
         return "[DisplayPropertiesImpl] \'"+this._name+"\'";
      }

      override  public function get name() : String {
         return this._name;
      }

      public function set name(param1:String) : void {
         this._name=param1;
         return;
      }

      public function get position() : Position {
         return this._position;
      }

      public function set top(param1:Object) : void {
         this._position.topValue=param1;
         return;
      }

      public function set right(param1:Object) : void {
         this._position.rightValue=param1;
         return;
      }

      public function set bottom(param1:Object) : void {
         this._position.bottomValue=param1;
         return;
      }

      public function set left(param1:Object) : void {
         this._position.leftValue=param1;
         return;
      }

      public function hasValue(param1:String) : Boolean {
         return (this._position.hasValue(param1))||(this._dimensions.hasValue(param1));
      }

      public function set opacity(param1:Number) : void {
         this.alpha=param1;
         return;
      }

      public function get opacity() : Number {
         return this.alpha;
      }

      public function get dimensions() : Dimensions {
         return this._dimensions;
      }

      public function get widthObj() : Object {
         return this._dimensions.width.asObject();
      }

      public function get heightStr() : Object {
         return this._dimensions.height.asObject();
      }

      public function get topStr() : Object {
         return this._position.top.asObject();
      }

      public function get rightStr() : Object {
         return this._position.right.asObject();
      }

      public function get bottomStr() : Object {
         return this._position.bottom.asObject();
      }

      public function get leftStr() : Object {
         return this._position.left.asObject();
      }
   }

}