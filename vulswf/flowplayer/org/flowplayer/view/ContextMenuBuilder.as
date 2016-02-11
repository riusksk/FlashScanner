package org.flowplayer.view
{
   import org.flowplayer.util.Log;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import org.flowplayer.config.VersionInfo;
   import flash.events.ContextMenuEvent;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;


   public class ContextMenuBuilder extends Object
   {
         

      public function ContextMenuBuilder(param1:String, param2:Array) {
         this.log=new Log(this);
         super();
         this._playerId=param1;
         this._menuItems=param2;
         return;
      }



      private var log:Log;

      private var _menuItems:Array;

      private var _playerId:String;

      public function build() : ContextMenu {
         return this.buildMenu(this.createMenu());
      }

      private function buildMenu(param1:ContextMenu) : ContextMenu {
         var menu:ContextMenu = param1;
         this.addItem(menu,new ContextMenuItem("About "+VersionInfo.versionInfo()+"...",false,true),new function(param1:ContextMenuEvent):void
            {
               navigateToURL(new URLRequest("http://flowplayer.org"),"_self");
               return;
               });
               this.addItem(menu,new ContextMenuItem("Copyright ? 2008-2011 Flowplayer Oy",true,false));
               this.addItem(menu,new ContextMenuItem("Flowplayer comes without any warranty",false,false));
               this.addItem(menu,new ContextMenuItem("GNU GENERAL PUBLIC LICENSE...",false,true),new function(param1:ContextMenuEvent):void
                  {
                     navigateToURL(new URLRequest("http://flowplayer.org/license_gpl.html"),"_self");
                     return;
                     });
                     return menu;
      }

      private function createMenu() : ContextMenu {
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         return _loc1_;
      }

      private function addItem(param1:ContextMenu, param2:ContextMenuItem, param3:Function=null) : void {
         param1.customItems.push(param2);
         if(param3!=null)
            {
               param2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,param3);
            }
         return;
      }
   }

}