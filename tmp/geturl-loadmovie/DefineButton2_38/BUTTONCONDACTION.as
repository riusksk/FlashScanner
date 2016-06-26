if(_root.swc_exit_link=="true")
{
   if(!(_root.url_exit==""))
   {
      getUrl(_root.url_exit,"_blank");
   }
   getUrl("FSCommand:quit", "");
}
else
{
   getUrl("FSCommand:quit", "");
}
