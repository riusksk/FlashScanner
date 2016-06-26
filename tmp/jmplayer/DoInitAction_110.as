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
if(!_global.com.jeroenwijering.utils.Randomizer)
{
   register1=function(arr)
   {
      this.originalArray=arr;
      this.bufferArray=new Array();
   };
   com.jeroenwijering.utils.Randomizer=function(arr)
   {
      this.originalArray=arr;
      this.bufferArray=new Array();
   };
   register2=register1.prototype;
   register2.pick=function()
   {
      if(this.bufferArray.length==0)
      {
            register2=0;
            while(register2<this.originalArray.length)
            {
               this.bufferArray.push(register2);
               register2=register2+1;
            }
      }
      register3=random(this.bufferArray.length);
      register4=this.bufferArray[register3];
      this.bufferArray.splice(register3,1);
      return register4;
   };
}
