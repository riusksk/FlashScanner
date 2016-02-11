##工具简介：
 
一款用于检测Flash漏洞库（http://web.appsec.ws/FlashExploitDatabase.php）的Perl工具，同时支持简单的flash xss检测

##运行环境：
 
OSX/Linux

##注意事项：
     
由于工具使用到 flare06doswin 与 asdec 反编译工具，请使用者自行下载。

##使用方法：    

perl FlashScanner.pl <br>
	-g  Google 搜索语句 <br>
    -p  搜索结果的起始页数<br>
    -u  指定Flash网址<br>
    -f  本地swf文件路径<br>
    -h  帮助信息   <br> 
Example: perl FlashScanner.pl -g "site:test.com filetype:swfinurl:player" -p 1
