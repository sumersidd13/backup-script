echo "The Process of Backup is started"

CURRTIME=`date +'%Y%m%d%H%M%S'`
CURDT=`date +'%d-%b-%Y %H:%M:%S'`

BASEDIR=/home/ec2-user/project
INDIR=${BASEDIR}/inbound
INFILE=${INDIR}/stud.txt
DBDIR=${BASEDIR}/database
DBFILE=${DBDIR}/avd-students-table.csv
LOGDIR=${BASEDIR}/log
LOGFILE=${LOGDIR}/stud-data.log
ARCDIR=${BASEDIR}/archive
ARCFILE=${ARCDIR}/stud_${CURRTIME}.txt


if [ ! -e ${INFILE} ]
then
        echo "${CURDT}  : ${INFILE} did't arrive" >> ${LOGFILE}
        exit 5
else
        echo "${CURDT}  : ${INFILE} arrived" >> ${LOGFILE}
fi

awk 'BEGIN{FS=" "; OFS=","} {print $2,$4,$5,$6,$7}' ${INFILE} >> ${DBFILE} 2>> ${LOGFILE}
if [ $? -ne 0 ]
then
        echo "${CURDT}  : ${INFILE} did't process" >> ${LOGFILE}
        exit 6
else
        echo "${CURDT}  : ${INFILE} Data written into databse" >> ${LOGFILE}
fi

cp ${INFILE} ${ARCFILE} 2>> ${LOGFILE}
if [ $? -ne 0 ]
then
        echo "${CURDT}  : ${INFILE} backup failed" >> ${LOGFILE}
        exit 7
else
        echo "${CURDT}  : ${INFILE} Backup Succsessful" >> ${LOGFILE}
fi

gzip ${ARCFILE} 2>> ${LOGFILE}
if [ $? -ne 0 ]
then
        echo "${CURDT}  : ${INFILE} Archiving failed" >> ${LOGFILE}
        exit 8
else
        echo "${CURDT}  : ${INFILE} Archiving Succsessful" >> ${LOGFILE}
fi

echo "The Process of Backup is completed"
