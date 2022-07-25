Run these commands:


python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
./build_image.sh


Then, upload the two images to glance.

```
openstack image create \
	--container-format aki --disk-format aki \
 	--public --project openstack --progress \
 	--file "./${INITRAMFS_NAME}" "${INITRAMFS_NAME}"

openstack image create \
	--container-format aki --disk-format aki \
	--public --project openstack --progress \
	--file "./${KERNEL_NAME}" "${KERNEL_NAME}"
```