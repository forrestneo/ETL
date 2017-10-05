#!/bin/bash
. ~/.bash_profile
###############################################
###############################################
cd `dirname $0`
##################################################
# ��������
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
# ����
##################################################
cd ${file_home}/shell

BAKDATE=`date '+%Y%m%d'`

echo [ftp upload date]: $BAKDATE
echo ==================================
##�жϱ�־λ
if [ -f ${file_home}/shell/ftplog/$BAKDATE* ];then
  echo "$BAKDATE"already done.
  exit 0
fi
##�ж��ļ��Ƿ����
temps=$(ssh  ${FTP_CONN}@${FTP_IP} find /app/data -name tem* |wc -l)

if [ "$temps" -ne "0" ];then
  echo "${FTP_PATH}" not prepared.
  exit 0
fi

##���±�־λ
echo `date` --------create ftp flag------------------
 rm -f ${file_home}/shell/ftplog/*.txt
 touch ${file_home}/shell/ftplog/$BAKDATE$ftp_start.txt
echo `date` --------create ftp flag------------------  


##��������
echo `date` --------ftping------------------
scp -r ${FTP_CONN}@${FTP_IP}:/app/data/* /etl/wind/data
##ɾ������
sftpD()
{
sftp   ${FTP_CONN}@${FTP_IP}<<EOF 
lcd ${BAK_PATH}
cd ${FTP_PATH}
rm -r ${FTP_PATH}/*

quit
EOF
}
##ִ��ɾ������
#sftpD
echo `date` --------ftp end------------------

mv ${file_home}/shell/ftplog/$BAKDATE$ftp_start.txt ${file_home}/shell/ftplog/$BAKDATE$ftp_end.txt
 echo =======================================================================  
    echo `date`�ɹ�����"$BAKDATE$"������
    echo ^_^ ^_^ȥ�����ݰ�^_^ ^_^
 echo ======================================================================= 