#! /usr/bin/bash
HOSTNAME=`ifconfig -a |ggrep sppp0 -A 1|grep inet |cut -d" " -f 4`
PORT="22"
USER="marty"
PASS="everglow"
TODAY=$(date +%F)
CMD="showhardconf; \
showenvironment temp; \
     showenvironment volt; \
     showenvironment Fan; \
     showenvironment power; \
     showenvironment air; \
     showboards -a; \
     "
TMP=$(mktemp)
# create expect script
cat > $TMP << EOF 
# exp_internal 1 # Uncomment for debug
log_user 0
set timeout 20
puts $TODAY
puts "-----Begin of XCSF-----"
spawn ssh -o "PubkeyAuthentication=no" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" $USER@$HOSTNAME "$CMD"
expect "password:"
send "$PASS\r";
interact
#expect eof
puts "-----End of XCSF-----"
EOF

# run expect script
# cat $TMP # Uncomment for debug
expect -f $TMP 
# remove expect script
rm $TMP
echo "-----Begin of Disks-----"
sudo raidctl -S
echo "-----End of Disks-----"
