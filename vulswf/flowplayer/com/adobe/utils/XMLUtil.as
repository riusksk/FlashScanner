package com.adobe.utils
{


   public class XMLUtil extends Object
   {
         

      public function XMLUtil() {
         super();
         return;
      }

      public static const TEXT:String = "text";

      public static const COMMENT:String = "comment";

      public static const PROCESSING_INSTRUCTION:String = "processing-instruction";

      public static const ATTRIBUTE:String = "attribute";

      public static const ELEMENT:String = "element";

      public static function isValidXML(param1:String) : Boolean {
         var xml:XML = null;
         var data:String = param1;
         try
            {
               xml=new XML(data);
            }
         catch(e:Error)
            {
               return false;
            }
         if(xml.nodeKind()!=XMLUtil.ELEMENT)
            {
               return false;
            }
         return true;
      }

      public static function getNextSibling(param1:XML) : XML {
         return XMLUtil.getSiblingByIndex(param1,1);
      }

      public static function getPreviousSibling(param1:XML) : XML {
         return XMLUtil.getSiblingByIndex(param1,-1);
      }

      protected static function getSiblingByIndex(param1:XML, param2:int) : XML {
         var out:XML = null;
         var x:XML = param1;
         var count:int = param2;
         try
            {
               out=x.parent().children()[x.childIndex()+count];
            }
         catch(e:Error)
            {
               return null;
            }
         return out;
      }


   }

}