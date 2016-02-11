package org.flowplayer.util
{
   import flash.display.LoaderInfo;
   import com.adobe.utils.StringUtil;
   import flash.external.ExternalInterface;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;


   public class URLUtil extends Object
   {
         

      public function URLUtil() {
         super();
         return;
      }

      private static var _log:Log = new Log("org.flowplayer.util::URLUtil");

      private static var _loaderInfo:LoaderInfo;

      public static function completeURL(param1:String, param2:String) : String {
         return addBaseURL((param1)||(pageLocation)||(playerBaseUrl),param2);
      }

      public static function isValid(param1:String) : Boolean {
         var _loc2_:RegExp = new (RegExp)("^http(s)?:\\/\\/((\\d+\\.\\d+\\.\\d+\\.\\d+)|(([\\w-]+\\.)+([a-z,A-Z][\\w-]*)))(:[1-9][0-9]*)?(\\/([\\w-.\\/:%+@&=]+[\\w- .\\/?:%+@&=]*)?)?(#(.*))?$","i");
         return _loc2_.test(param1);
      }

      public static function addBaseURL(param1:String, param2:String) : String {
         if(param2==null)
            {
               return null;
            }
         if(isCompleteURLWithProtocol(param2))
            {
               return param2;
            }
         if(param2.indexOf("/")==0)
            {
               return param2;
            }
         if(param1==""||param1==null||param1=="null")
            {
               return param2;
            }
         if(param1!=null)
            {
               if(param1.lastIndexOf("/")==param1.length-1)
                  {
                     return param1+param2;
                  }
               return param1+"/"+param2;
            }
         return param2;
      }

      public static function appendToPath(param1:String, param2:String) : String {
         if(StringUtil.endsWith(param1,"/"))
            {
               return param1+param2;
            }
         return param1+"/"+param2;
      }

      public static function isCompleteURLWithProtocol(param1:String) : Boolean {
         if(!param1)
            {
               return false;
            }
         return param1.indexOf("://")<0;
      }

      private static function detectPageUrl(param1:String) : String {
         var functionName:String = param1;
         _log.debug("detectPageUrl() "+functionName);
         try
            {
               return ExternalInterface.call(functionName);
            }
         catch(e:Error)
            {
               _log.debug("Error in detectPageUrl() "+e);
            }
         return null;
      }

      public static function get pageUrl() : String {
         if(!ExternalInterface.available)
            {
               return null;
            }
         var _loc1_:String = detectPageUrl("window.location.href.toString");
         if(!_loc1_||_loc1_=="")
            {
               _loc1_=detectPageUrl("document.location.href.toString");
            }
         if(!_loc1_||_loc1_=="")
            {
               _loc1_=detectPageUrl("document.URL.toString");
            }
         return _loc1_;
      }

      public static function get pageLocation() : String {
         var _loc1_:String = pageUrl;
         return _loc1_?baseUrlAndRest(_loc1_)[0]:null;
      }

      public static function baseUrlAndRest(param1:String) : Array {
         var _loc2_:int = param1.indexOf("?");
         if(_loc2_>0)
            {
               _loc2_=param1.substring(0,_loc2_).lastIndexOf("/");
            }
         else
            {
               if(param1.indexOf("#")!=-1)
                  {
                     _loc2_=param1.substring(0,param1.indexOf("#")).lastIndexOf("/");
                  }
               else
                  {
                     _loc2_=param1.lastIndexOf("/");
                  }
            }
         if(_loc2_>0)
            {
               return [param1.substring(0,_loc2_),param1.substring(_loc2_+1)];
            }
         return [null,param1];
      }

      public static function baseUrl(param1:String) : String {
         return param1.substr(0,param1.lastIndexOf("/"));
      }

      public static function isRtmpUrl(param1:String) : Boolean {
         var _loc2_:Array = ["rtmp","rtmpt","rtmpe","rtmpte","rtmfp"];
         var _loc3_:String = param1.substr(0,param1.indexOf("://"));
         return _loc2_.indexOf(_loc3_)>=0;
      }

      public static function get playerBaseUrl() : String {
         var _loc1_:String = _loaderInfo.url;
         var _loc2_:Number = _loc1_.indexOf(".swf");
         _loc1_=_loc1_.substring(0,_loc2_);
         var _loc3_:Number = _loc1_.lastIndexOf("/");
         return _loc1_.substring(0,_loc3_);
      }

      public static function localDomain(param1:String) : Boolean {
         if(param1.indexOf("http://localhost/")==0)
            {
               return true;
            }
         if(param1.indexOf("file://")==0)
            {
               return true;
            }
         if(param1.indexOf("chrome://")==0)
            {
               return true;
            }
         if(param1.indexOf("http://127.0.0.1")==0)
            {
               return true;
            }
         if(param1.indexOf("http://")==0)
            {
               return false;
            }
         if(param1.indexOf("/")==0)
            {
               return true;
            }
         return false;
      }

      public static function set loaderInfo(param1:LoaderInfo) : void {
         _loaderInfo=param1;
         return;
      }

      public static function openPage(param1:String, param2:String="_blank", param3:Array=null) : void {
         var url:String = param1;
         var linkWindow:String = param2;
         var popUpDimensions:Array = param3;
         try
            {
               ExternalInterface.call(getJSOpenPageCallString(linkWindow,popUpDimensions,url));
            }
         catch(e:Error)
            {
               navigateToURL(new URLRequest(url),linkWindow);
            }
         return;
      }

      private static function getJSOpenPageCallString(param1:String, param2:Array, param3:String) : String {
         var _loc4_:Array = null;
         if(param1=="_popup")
            {
               _log.debug("getJSOpenPageCallString(), will use a popup");
               _loc4_=(param2)||([800,600]);
               return "window.open(\'"+param3+"\',\'PopUpWindow\',\'width="+_loc4_[0]+",height="+_loc4_[1]+",toolbar=yes,scrollbars=yes\')";
            }
         return "window.open(\""+param3+"\",\""+param1+"\")";
      }


   }

}