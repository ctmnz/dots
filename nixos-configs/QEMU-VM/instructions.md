## Download the iso

https://channels.nixos.org/nixos-25.11/latest-nixos-minimal-x86_64-linux.iso

```bash
curl -o nixos.iso -L https://channels.nixos.org/nixos-25.11/latest-nixos-minimal-x86_64-linux.iso
```

Create QEMU disk
```bash
qemu-img create -f qcow2 nixos-disk.qcow2 50G
```


Create the VM
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 2G \
  -smp 2 \
  -drive file=nixos-disk.qcow2,format=qcow2 \
  -cdrom nixos-25-11.iso \
  -boot d \
  -net nic,model=virtio -net user
```

Boot

Create partitions and file systems

```bash
sudo -i

parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- set 1 boot on
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2
nixos-generate-config --root /mnt
vim /mnt/etc/nixos/configuration.nix
# uncomment-> # boot.loader.grub.device = "/dev/sda";
# uncommnet the user and change it to your user (mine: daniel)
# optional you can add git to the packages (next to the tree)
nixos-install
# <enter root password>
nixos-enter --root /mnt -c 'passwd daniel'
# <enter daniel password>
```


Reboot without cd
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 2G \
  -smp 2 \
  -drive file=nixos-disk.qcow2,format=qcow2 \
  -boot d \
  -net nic,model=virtio -net user
```



## how to mount QEMU image and accessing files from the qcow2 image on the host

```bash
nix-shell -p util-linux
qemu-img convert -p -O raw nixos-disk.qcow2 nixos-disk.raw
sudo losetup -fP nixos-disk.raw
lsblk
mkdir ./mnt
sudo mount /dev/loop0p1 ./mnt
cd ./mnt
## Operate
```

