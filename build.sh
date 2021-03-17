#!/bin/sh

## nasty ##
packer_builds="RedHat7 RedHat8"

for packer_build in $packer_builds; do
    packer build -force -only vsphere-iso $packer_build.json
done


# even more nasty. needs OVFtool on MAC & VMWare Fusion

for packer_build in $packer_builds; do
    packer build -force -only vmware-iso $packer_build.json
    mkdir -p $packer_build-output
    cd $packer_build-output
    tar -zxvf ../build.tgz
    rm ../build.tgz
    /Applications/VMware\ OVF\ Tool/ovftool --overwrite --compress=9 --shaAlgorithm=sha1 --noImageFiles packer-vmware-iso.vmx packer-rhel7.ovf
    /Applications/VMware\ OVF\ Tool/ovftool packer-rhel7.ovf packer_rhel7.ova
    cd ..
done






# aws s3 cp packer_rhel8.ova s3://phil-ovf-files
# aws s3 cp packer_rhel7.ova s3://phil-ovf-files

# aws ec2 import-image --description "rhel7-pgaw" --disk-containers "file://rhel7-import.json"
# aws ec2 import-image --description "rhel8-pgaw" --disk-containers "file://rhel8-import.json"

# mkdir -p old
# mv packer_rhel7.ova old
# mv packer_rhel8.ova old

# aws ec2 describe-import-image-tasks



# aws ec2 export-image --image-id ami-0fbb512db9d350a7f --disk-image-format VMDK --s3-export-location S3Bucket=phil-ovf-files,S3Prefix=exports/
# aws ec2 export-image --image-id ami-05f5619164b8ea460 --disk-image-format VMDK --s3-export-location S3Bucket=phil-ovf-files,S3Prefix=exports/

# aws ec2 describe-export-image-tasks

#$ovftool --overwrite --datastore="DSCL-DCA-PROD01" --network="Cloud_VM_IP_01 DPortGroup" $1-$VERSION.ova vi://dc/DCACLOUD/host/DCACLOUDRESCL01
