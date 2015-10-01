# User Configurations

# Uncomment for AD authentication; set JOIN_AD=1

JOIN_AD=0
AD_DOMAIN=company.com
AD_USER=administrator
D_PASS=password
VCENTER_HOSTNAME=vcsa5-5
 
## DO NOT EDIT BEYOND HERE ##
 
echo "Accepting EULA ..."
/usr/sbin/vpxd_servicecfg eula accept
 
if [ ${JOIN_AD} -eq 1 ]; then
        echo "Configuring vCenter hostname ..."
        SHORTHOSTNAME=$(echo ${VCENTER_HOSTNAME} |  cut -d. -f1)
        /bin/hostname ${VCENTER_HOSTNAME}
        echo ${VCENTER_HOSTNAME} > /etc/HOSTNAME
        sed -i "s/localhost.localdom/${VCENTER_HOSTNAME}/g" /etc/hosts
        sed -i "s/localhost/${SHORTHOSTNAME}/g" /etc/hosts
 
        echo "Configuring Active Directory ..."
        /usr/sbin/vpxd_servicecfg ad write "${AD_USER}" "${AD_PASS}" ${AD_DOMAIN}
fi
 
echo "Configuring Embedded DB ..."
/usr/sbin/vpxd_servicecfg db write embedded
 
echo "Configuring SSO..."
/usr/sbin/vpxd_servicecfg sso write embedded
 
echo "Starting VCSA ..."
/usr/sbin/vpxd_servicecfg service start