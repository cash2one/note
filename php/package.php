<?php

function addFileToZip($path, $extpath, $zip){
    $handler=opendir($path.$extpath); 
	//打开当前文件夹由$path指定。
    while(($filename=readdir($handler))){
        if($filename != "." && $filename != ".."){
		//文件夹文件名字为'.'和‘..’，不要对他们进行操作
			$pkgName = $extpath.$filename;
			$fullName = $path."/".$extpath.$pkgName;
            if(is_dir($fullName)){
			// 如果读取的某个对象是文件夹，则递归
                addFileToZip($path, $pkgName."/", $zip);
            }else{ 
			//将文件加入zip对象
                $zip->addFile($fullName, $pkgName);
				echo $pkgName."\n";
            }
        }
    }
    @closedir($path);
}

if ($argc < 3){
	echo 'para error\n';
}else{
	$zip = new ZipArchive();
	if($zip->open($argv[2], ZipArchive::OVERWRITE)=== TRUE){
		addFileToZip($argv[1], "", $zip);
		$zip->close();
	}
}
