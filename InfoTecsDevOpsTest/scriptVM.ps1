# Download debian.iso
if (![System.IO.File]::Exists(".\Debian11.iso")){
    Invoke-WebRequest https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.4.0-amd64-netinst.iso -OutFile .\Debian11.iso
} 

#Create VM
VBoxManage createvm --name "infotecsTestDebian" --ostype "Debian_64" --register --basefolder ./

#Set memory, network and graphic controller
VBoxManage modifyvm "infotecsTestDebian" --ioapic on
VBoxManage modifyvm "infotecsTestDebian" --memory 1024 --vram 128 --graphicscontroller vmsvga
VBoxManage modifyvm "infotecsTestDebian" --nic1 nat --nic2 bridged --bridgeadapter2 'Realtek PCIe GbE Family Controller'

#Create Disk and connect Debian Iso
VBoxManage createhd --filename ./"infotecsTestDebian"/"infotecsTestDebian_DISK".vdi --size 10000 --format VDI
VBoxManage storagectl "infotecsTestDebian" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "infotecsTestDebian" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  ./"infotecsTestDebian"/"infotecsTestDebian_DISK".vdi
VBoxManage storagectl "infotecsTestDebian" --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach "infotecsTestDebian" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ./Debian11.iso
VBoxManage modifyvm "infotecsTestDebian" --boot1 dvd --boot2 disk --boot3 none --boot4 none

#Enable RDPс
VBoxManage modifyvm "infotecsTestDebian" --vrde on
VBoxManage modifyvm "infotecsTestDebian" --vrdemulticon on --vrdeport 10001

#Start the VM
VBoxManage startvm "infotecsTestDebian"
