# PostgreSQL 数据库整库备份脚本
#作者：老农民（刘启华）
#Email: 46715422@qq.com

######################################################


#!/bin/sh

export PGHOME=/usr/local/pgsql/
export PATH=$PGHOME/bin:$PATH
export PGDATA=/usr/local/pgsql/data/
export BACKUP_DIR=/home/postgres/
export USER=postgres
export DATABASE=test
export DATE=`date +"%Y-%m-%d"`
export OLDDATE=`date -v -7d +"%Y-%m-%d"`

######################################################
##
##  purpose:backup total database everyday logically
##
##  file: back_database
##  
##  author: EricLiu
##  
##  email: 46715422@qq.com
##   
##  created:2018-08-24
##
##  restore_script:psql -d $DATABASE -U postgres < /home/postgres/file_name
##  
#####################################################

test -f $BACKUP_DIR/$DATABASE.$OLDDATE.dump

if [ $? -eq 0 ] ; then

  rm -f $BACKUP_DIR/$DATABASE.$OLDDATE.dump

  echo " `date +"%Y-%m-%d %H:%M:%S"` the file $BACKUP_DIR/$DATABASE.$OLDDATE.dump has been moved!"

fi

test -f $BACKUP_DIR/$DATABASE.$DATE.dump

if [ $? -eq 0 ] ; then

  echo "Today's(`date +"%Y-%m-%d %H:%M:%S"`) BACKUP job has done!"

else

  pg_dump -h 127.0.0.1 -p 5432 -U $USER -b -Fp $DATABASE -f $BACKUP_DIR/$DATABASE.$DATE.dump


######check the dump file whether produced successfully

  test -f $BACKUP_DIR/$DATABASE.$DATE.dump

  if [ $? -eq 0 ]; then
   
     echo " `date +"%Y-%m-%d %H:%M:%S"` the database $DATABASE has been backuped to $BACKUP_DIR/$DATABASE.$DATE.dump successfully!"

  else
    
     echo " `date +"%Y-%m-%d %H:%M:%S"` the pg_dump failed!"

  fi

fi
