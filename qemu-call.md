qemu-system-aarch64 \
-M virt \
-m 512 \
-cpu cortex-a57 \
-bios QEMU_EFI.fd \
-drive format=raw,file=fat:rw:bootloader,media=disk \
-drive file=/nfs/openbsd/test.img,format=raw \
-nographic \
-serial tcp::4450,server,telnet,wait



-drive format=raw,file=fat:rw:bootloader,media=disk \