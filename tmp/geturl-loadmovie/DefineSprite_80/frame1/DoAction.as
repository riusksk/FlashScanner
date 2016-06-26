function autoFlip()
{
   if(autoFlipSecondSet==0)
   {
         return undefined;
   }
   autoFlipSecondPass=autoFlipSecondPass+1;
   if(_root.page==_root.maxpage)
   {
         return undefined;
   }
   if(!(autoFlipSecondPass<autoFlipSecondSet))
   {
         autoFlipSecondPass=0;
         _root.snd_page.start();
         _root.nextPage();
   }
}
var snd=0
if(_root.default_auto==undefined)
{
   xx=snd;
}
else
{
   xx=_root.default_auto;
}
xx=xx*70/100+13.5;
if(xx>71)
{
   btn._x=71;
}
else
{
   btn._x=xx;
}
bar.bg._width=btn._x-13.5;
snd=Math.ceil((btn._x-13.5)*100/71);
volume_mc.volume_txt.text=snd;
var ctrl=1
var info=new Array()
btn.onPress=function()
{
   startDrag(btn,0,13.5,2,56.5,2)
   bar.onEnterFrame=function()
   {
         this.bg._width=btn._x-13.5;
         snd=Math.ceil((btn._x-13.5)*100/71);
         volume_mc.volume_txt.text=snd;
         autoFlipSecondSet=snd;
   };
};
register0=function()
{
   delete bar.onEnterFrame
   stopDrag();
};
btn.onReleaseOutside=function()
{
   delete bar.onEnterFrame
   stopDrag();
};
btn.onRelease=register0;
bar.onPress=function()
{
   if(_xmouse>72)
   {
         btn._x=72;
   }
   else
   {
         btn._x=_xmouse-3;
   }
   this.bg._width=btn._x-32;
   snd=Math.ceil((btn._x-32)*100/71);
   volume_mc.volume_txt.text=snd;
   autoFlipSecondSet=snd;
};
autoFlipSecondPass=0;
autoFlipSecondSet=snd;
setInterval(autoFlip,1000);
