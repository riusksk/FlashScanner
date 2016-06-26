function pgs()
{
   bar.bg._width=_root.page/_root.maxpage*130;
   p_no.text="PAGE "+_root.page+"/"+_root.maxpage;
}
this.onEnterFrame=pgs;
p_no.autoSize="center";
