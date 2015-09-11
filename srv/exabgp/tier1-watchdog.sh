#!/bin/bash
source `dirname`/watchdog.conf

DIG=dig
TARGETS=( "tier1" )
ZONE=dn42
ROUTE="$TIER1/32"
NEXTHOP="$OWN_IP" # own ip

INTERVAL=60

VALIDATE_KEYWORD='NS.*zone-servers\.dn42\.'

###########################

RUN_STATE=0

sleep 5

check_targets() {
        for item in "${TARGETS[@]}"; do
                ${DIG} @${item} ${ZONE} ANY | egrep -q "${VALIDATE_KEYWORD}" ||
                return 1
        done

	return 0
}

while [ 1 ]; do
        if [ ${RUN_STATE} -eq 0 ]; then
                check_targets && {
                        RUN_STATE=1
			echo "announce route ${ROUTE} next-hop ${NEXTHOP}"
                }
        else
            	check_targets || {
                        RUN_STATE=0
			echo "withdraw route ${ROUTE} next-hop ${NEXTHOP}"
                }
        fi

	sleep ${INTERVAL}

done

exit 0

