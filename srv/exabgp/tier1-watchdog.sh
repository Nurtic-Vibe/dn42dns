#!/bin/bash
DIG=dig
TARGETS=( "tier1" )
ZONE=dn42
ROUTE="172.23.0.74/32"
NEXTHOP="172.23.149.70" # own ip

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

