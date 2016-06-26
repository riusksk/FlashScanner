if(!_global.com)
{
   _global.com=new Object();
}
if(!_global.com.jeroenwijering)
{
   _global.com.jeroenwijering=new Object();
}
if(!_global.com.jeroenwijering.players)
{
   _global.com.jeroenwijering.players=new Object();
}
if(!_global.com.jeroenwijering.players.EqualizerView)
{
   register1=function(ctr, cfg, fed)
   {
      super(ctr,cfg,fed);
      this.setupEQ();
      Stage.addListener(this);
   };
   com.jeroenwijering.players.EqualizerView=function(ctr, cfg, fed)
   {
      super(ctr,cfg,fed);
      this.setupEQ();
      Stage.addListener(this);
   };
   com.jeroenwijering.players.EqualizerView extends com.jeroenwijering.players.AbstractView
   register2=register1.prototype;
   register2.setupEQ=function()
   {
      this.eqClip=this.config.clip.equalizer;
      this.eqClip._y=this.config.displayheight-50;
      this.eqStripes=Math.floor((this.config.displaywidth-20)/6);
      this.eqClip.stripes.duplicateMovieClip("stripes2",1);
      this.eqClip.mask.duplicateMovieClip("mask2",3);
      register0=this.config.displaywidth-20;
      this.eqClip.stripes2._width=this.config.displaywidth-20;
      this.eqClip.stripes._width=register0;
      this.eqClip.stripes.top.col=new Color(this.eqClip.stripes.top);
      this.eqClip.stripes.top.col.setRGB(this.config.lightcolor);
      this.eqClip.stripes.bottom.col=new Color(this.eqClip.stripes.bottom);
      this.eqClip.stripes.bottom.col.setRGB(16777215);
      this.eqClip.stripes2.top.col=new Color(this.eqClip.stripes2.top);
      this.eqClip.stripes2.top.col.setRGB(this.config.lightcolor);
      this.eqClip.stripes2.bottom.col=new Color(this.eqClip.stripes2.bottom);
      this.eqClip.stripes2.bottom.col.setRGB(16777215);
      this.eqClip.stripes.setMask(this.eqClip.mask);
      this.eqClip.stripes2.setMask(this.eqClip.mask2);
      register0=50;
      this.eqClip.stripes2._alpha=50;
      this.eqClip.stripes._alpha=register0;
      setInterval(this,"drawEqualizer",100,this.eqClip.mask);
      setInterval(this,"drawEqualizer",100,this.eqClip.mask2);
   };
   register2.drawEqualizer=function(tgt)
   {
      tgt.clear();
      tgt.beginFill(0,100);
      tgt.moveTo(0,0);
      register5=Math.round(this.currentVolume/4);
      register2=0;
      while(register2<this.eqStripes)
      {
            register4=random(register5)+register5/2+2;
            if(register2==Math.floor(this.eqStripes/2))
            {
               register4=0;
            }
            tgt.lineTo(register2*6,-1);
            tgt.lineTo(register2*6,0-register4);
            tgt.lineTo(register2*6+4,0-register4);
            tgt.lineTo(register2*6+4,-1);
            tgt.lineTo(register2*6,-1);
            register2=register2+1;
      }
      tgt.lineTo(this.eqStripes*6,0);
      tgt.lineTo(0,0);
      tgt.endFill();
   };
   register2.setVolume=function(vol)
   {
      this.currentVolume=vol;
   };
   register2.setState=function(stt)
   {
      if(!(stt==2))
      {
            register0=false;
            this.eqClip._visible=false;
      }
      else
      {
            register0=true;
            this.eqClip._visible=true;
      }
   };
   register2.onFullScreen=function(fs)
   {
      if(fs==true)
      {
            this.eqClip._visible=false;
      }
      else
      {
            this.eqClip._visible=true;
      }
   };
}
