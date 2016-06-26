if(!_global.com)
{
   _global.com=new Object();
}
if(!_global.com.jeroenwijering)
{
   _global.com.jeroenwijering=new Object();
}
if(!_global.com.jeroenwijering.utils)
{
   _global.com.jeroenwijering.utils=new Object();
}
if(!_global.com.jeroenwijering.utils.Animations)
{
   register1=function()
   {
      
   };
   com.jeroenwijering.utils.Animations=function()
   {
      
   };
   register2=register1.prototype;
   register1.fadeIn=function(tgt, end, spd)
   {
      !(arguments.length<3)?null:register0;
      !(arguments.length<2)?null:register0;
      tgt._visible=true;
      tgt.onEnterFrame=function()
      {
            if(this._alpha>end-spd)
            {
                  delete this.onEnterFrame
                  this._alpha=end;
            }
            else
            {
                  this._alpha=this._alpha+spd;
            }
      };
   };
   register1.fadeOut=function(tgt, end, spd, rmv)
   {
      !(arguments.length<4)?null:register0;
      !(arguments.length<3)?null:register0;
      !(arguments.length<2)?null:register0;
      tgt.onEnterFrame=function()
      {
            if(this._alpha<end+spd)
            {
                  delete this.onEnterFrame
                  this._alpha=end;
                  !(end==0)?null:register0;
                  !(rmv==true)?null:this.removeMovieClip();
            }
            else
            {
                  this._alpha=this._alpha-spd;
            }
      };
   };
   register1.crossfade=function(tgt, alp)
   {
      var phs="out"
      var pct=alp/5
      tgt.onEnterFrame=function()
      {
            if(phs=="out")
            {
                  this._alpha=this._alpha-pct;
                  if(this._alpha<1)
                  {
                     phs="in";
                  }
            }
            else
            {
                  this._alpha=this._alpha+pct;
                  this._alpha<alp?null:true;
            }
      };
   };
   register1.easeTo=function(tgt, xps, yps, spd)
   {
      !(arguments.length<4)?null:register0;
      tgt.onEnterFrame=function()
      {
            this._x=xps-(xps-this._x)/(1+1/spd);
            this._y=yps-(yps-this._y)/(1+1/spd);
            if(this._x>xps-1&&this._x<xps+1&&this._y>yps-1&&this._y<yps+1)
            {
                  this._x=Math.round(xps);
                  this._y=Math.round(yps);
                  delete this.onEnterFrame
            }
      };
   };
   register1.easeText=function(tgt, txt, spd)
   {
      if(arguments.length<2)
      {
            tgt.str=tgt.tf.text;
            tgt.hstr=tgt.tf.htmlText;
      }
      else
      {
            register0=txt;
            tgt.hstr=txt;
            tgt.str=register0;
      }
      if(arguments.length<3)
      {
            spd=1.5;
      }
      tgt.tf.text="";
      tgt.i=0;
      tgt.onEnterFrame=function()
      {
            this.tf.text=this.str.substr(0,this.str.length-Math.floor((this.str.length-this.tf.text.length)/spd));
            if(this.tf.text==this.str)
            {
                  this.tf.htmlText=this.hstr;
                  delete this.onEnterFrame
            }
            this.i=this.i+1;
      };
   };
}
