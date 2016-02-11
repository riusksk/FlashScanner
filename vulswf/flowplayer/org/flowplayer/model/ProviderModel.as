package org.flowplayer.model
{


   public class ProviderModel extends PluginModelImpl implements PluginModel
   {
         

      public function ProviderModel(param1:Object, param2:String) {
         super(param1,param2);
         return;
      }



      private var _connectionProvider:String;

      private var _urlResolver:String;

      private var _objectEncoding:uint = 3;

      public function get connectionProvider() : String {
         return this._connectionProvider;
      }

      public function set connectionProvider(param1:String) : void {
         this._connectionProvider=param1;
         return;
      }

      public function get urlResolver() : String {
         return this._urlResolver;
      }

      public function set urlResolver(param1:String) : void {
         this._urlResolver=param1;
         return;
      }

      public function get objectEncoding() : uint {
         return this._objectEncoding;
      }

      public function set objectEncoding(param1:uint) : void {
         this._objectEncoding=param1;
         return;
      }
   }

}