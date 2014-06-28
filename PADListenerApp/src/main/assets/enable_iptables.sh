#!/system/bin/sh

##################################################
# Expected variables
##################################################
CHAIN_NAME_PREFIX="$1"
DESTINATION="$2"
EXCLUDED_PROCESS_ID=$3

##################################################
# Variables check
##################################################
if [ "$CHAIN_NAME_PREFIX" == "" ] ; then
	echo "CHAIN_NAME_PREFIX is mandatory !"
	exit 11
fi
if [ "$DESTINATION" == "" ] ; then
	echo "DESTINATION is mandatory !"
	exit 12
fi
if [ "$EXCLUDED_PROCESS_ID" == "" ] ; then
	echo "EXCLUDED_PROCESS_ID is mandatory !"
	exit 13
fi

CHAIN_NAME_1=$CHAIN_NAME_PREFIX
CHAIN_NAME_2=$CHAIN_NAME_PREFIX"_OUTPUT"
ERROR="N"

##################################################
# Init
##################################################
echo "Enabling IPTables redirection for"
echo " - Chain name prefix : "$CHAIN_NAME_PREFIX
echo "   -> Chain name 1 : "$CHAIN_NAME_1
echo "   -> Chain name 2 : "$CHAIN_NAME_2
echo " - Destination : "$DESTINATION
echo " - Excluded process id "$EXCLUDED_PROCESS_ID


##################################################
# Creating Chains
##################################################
echo "Creating Chain 1"
iptables --new $CHAIN_NAME_1
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi

echo "Creating Chain 1 nat"
iptables -t nat --new $CHAIN_NAME_1
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi

echo "Creating Chain 2 nat"
iptables -t nat --new $CHAIN_NAME_2
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi


##################################################
# Creating HTTP rules
##################################################
echo "Creating HTTP rule for Chain 1"
iptables -A $CHAIN_NAME_1 -p tcp --destination $DESTINATION --dport 80 -j ACCEPT
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi

echo "Creating HTTP rule for Chain 1 nat"
iptables -A $CHAIN_NAME_1 -t nat -p tcp --dport 80 -j REDIRECT --to-port 8009
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi

echo "Creating HTTP rule for Chain 2 nat"
iptables -t nat -A $CHAIN_NAME_2 -m owner ! --uid-owner $EXCLUDED_PROCESS_ID -p tcp --destination $DESTINATION --dport 80 -j DNAT --to 127.0.0.1:8009
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi


##################################################
# Creating HTTPS rules
##################################################
echo "Creating HTTPS rule for Chain 1"
iptables -A $CHAIN_NAME_1 -p tcp --destination $DESTINATION --dport 443 -j ACCEPT
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi

echo "Creating HTTPS rule for Chain 1 nat"
iptables -A $CHAIN_NAME_1 -t nat -p tcp --destination $DESTINATION --dport 443 -j REDIRECT --to-port 8010
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi

echo "Creating HTTPS rule for Chain 2 nat"
iptables -t nat -A $CHAIN_NAME_2 -m owner ! --uid-owner $EXCLUDED_PROCESS_ID -p tcp --destination $DESTINATION --dport 443 -j DNAT --to 127.0.0.1:8010
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi


##################################################
# Adding Chains
##################################################
echo "Adding Chain 1"
iptables -A INPUT -j $CHAIN_NAME_1
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi

echo "Adding Chain 1 nat"
iptables -t nat -A PREROUTING -j $CHAIN_NAME_1
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi

echo "Adding Chain 2 nat"
iptables -t nat -A OUTPUT -j $CHAIN_NAME_2
if [ $? -ne 0 ] ; then echo "Error !" && exit 1 ; fi



echo "Finished !"
exit 0