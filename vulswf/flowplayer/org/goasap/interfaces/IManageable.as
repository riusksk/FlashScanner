package org.goasap.interfaces
{


   public interface IManageable extends IUpdatable
   {
         



      function getActiveTargets() : Array;

      function getActiveProperties() : Array;

      function isHandling(param1:Array) : Boolean;

      function releaseHandling(... rest) : void;
   }

}