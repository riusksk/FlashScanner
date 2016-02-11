package org.flowplayer.util
{


   public class LogConfiguration extends Object
   {
         

      public function LogConfiguration() {
         super();
         return;
      }



      private var _level:String = "error";

      private var _filter:String = "*";

      private var _trace:Boolean = false;

      public function get level() : String {
         return this._level;
      }

      public function set level(param1:String) : void {
         this._level=param1;
         return;
      }

      public function get filter() : String {
         return this._filter;
      }

      public function set filter(param1:String) : void {
         this._filter=param1;
         return;
      }

      public function get trace() : Boolean {
         return this._trace;
      }

      public function set trace(param1:Boolean) : void {
         this._trace=param1;
         return;
      }
   }

}