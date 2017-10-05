#!/bin/bash
. ~/.bash_profile
###############################################
###############################################
cd `dirname $0`
##################################################
# 参数设置
##################################################
file_home=/etl
ftp_start=ftps
ftp_end=ftpe
BIN_PATH=`pwd`
BAK_PATH=/etl/wind/data
FTP_CONN="dmz"
FTP_IP=10.4.5.*
FTP_PATH=/app/data
##################################################
# 程序
##################################################
cd ${file_home}/shell

BAKDATE=`date '+%Y%m%d'`

echo [ftp upload date]: $BAKDATE
echo ==================================
##判断标志位
if [ -f ${file_home}/shell/ftplog/$BAKDATE* ];then
  echo "$BAKDATE"already done.
  exit 0
fi
##判断文件是否存在
temps=$(ssh  ${FTP_CONN}@${FTP_IP} find /app/data -name tem* |wc -l)

if [ "$temps" -ne "0" ];then
  echo "${FTP_PATH}" not prepared.
  exit 0
fi

##更新标志位
echo `date` --------create ftp flag------------------
 rm -f ${file_home}/shell/ftplog/*.txt
 touch ${file_home}/shell/ftplog/$BAKDATE$ftp_start.txt
echo `date` --------create ftp flag------------------  


##传输数据
echo `date` --------ftping------------------
scp -r ${FTP_CONN}@${FTP_IP}:/app/data/* /etl/wind/data
##删除数据
sftpD()
{
sftp   ${FTP_CONN}@${FTP_IP}<<EOF 
lcd ${BAK_PATH}
cd ${FTP_PATH}
rm -r ${FTP_PATH}/*

quit
EOF
}
##执行删除数据
#sftpD
echo `date` --------ftp end------------------

mv ${file_home}/shell/ftplog/$BAKDATE$ftp_start.txt ${file_home}/shell/ftplog/$BAKDATE$ftp_end.txt
 echo =======================================================================  
    echo `date`成功处理"$BAKDATE$"日数据
    echo ^_^ ^_^去对数据吧^_^ ^_^
 echo ======================================================================= 