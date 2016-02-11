##工具简介：
 
一款用于检测Flash漏洞库（http://web.appsec.ws/FlashExploitDatabase.php）的Perl工具，同时支持简单的flash xss检测

##运行环境：
 
OSX/Linux

##注意事项：
     
由于工具使用到 flare06doswin 与 asdec 反编译工具，请使用者自行下载。

##使用方法：    
		perl FlashScanner.pl 
		  -g  Google 搜索语句 
		  -p  搜索结果的起始页数
     	  -u  指定Flash网址
     	  -f  本地swf文件路径
     	  -h  帮助信息 

		Example: perl FlashScanner.pl -g "site:test.com filetype:swfinurl:player" -p 1

##运行截图
![](http://security.tencent.com/uploadimg_dir/201311/1159ecd6bbc1b6c40a58d7f394ec4005.png)
