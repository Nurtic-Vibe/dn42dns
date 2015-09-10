#!/bin/bash
source `dirname`/watchdog.conf

DIG=dig
TARGETS=( "172.23.0.53" "$TIER0" "$TIER1" )
TARGETS_T2=( "$TIER2" )
ZONE=dn42
ZONE_T2=0.23.172.in-addr.arpa
ROUTE_RES='172.23.0.48/28'
ROUTE_TIERS="$ROUTE"
NEXTHOP="$OWN_IP" # own ip

INTERVAL=60

VALIDATE_KEYWORD='NS.*zone-servers\.dn42\.'
VALIDATE_KEYWORD_T2='NS.*dn42-servers\.dn42\.'

###########################

RUN_STATE=0

sleep 5

check_targets() {
        for item in "${TARGETS[@]}"; do
                ${DIG} @${item} ${ZONE} ANY | egrep -q "${VALIDATE_KEYWORD}" ||
                return 1
        done

	for item in "${TARGETS_T2[@]}"; do
		${DIG} @${item} ${ZONE_T2} ANY | egrep -q "${VALIDATE_KEYWORD_T2}" ||
		return 1
	done

	return 0
}

while [ 1 ]; do
        if [ ${RUN_STATE} -eq 0 ]; then
                check_targets && {
                        RUN_STATE=1
                        echo "announce route ${ROUTE_RES} next-hop ${NEXTHOP}"
			echo "announce route ${ROUTE_TIERS} next-hop ${NEXTHOP}"
                }
        else
            	check_targets || {
                        RUN_STATE=0
                        echo "withdraw route ${ROUTE_RES} next-hop ${NEXTHOP}"
			echo "withdraw route ${ROUTE_TIERS} next-hop ${NEXTHOP}"
                }
        fi

	sleep ${INTERVAL}

done

exit 0


