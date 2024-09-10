# FCOS image with all the dependencies baked in for easier setup
FROM quay.io/fedora/fedora-coreos:stable
RUN curl https://mirror.openshift.com/pub/openshift-v4/$(uname -m)/clients/ocp/stable/openshift-client-linux.tar.gz | tar -U -C /usr/bin -xzf - && rm /usr/bin/README.md
# https://github.com/coreos/fedora-coreos-tracker/issues/1687
RUN rpm-ostree override remove nfs-utils-coreos && rpm-ostree install bootc tmux virt-install libvirt-daemon-driver-network libvirt-daemon-config-network libvirt-daemon qemu-img qemu-kvm-core libvirt-client libvirt-daemon-driver-qemu libvirt-daemon-driver-storage-disk && rm -rf /var/cache
# XXX: for now. hitting selinux issues from libvirt and gssproxy probably related to layering
RUN mkdir -p /usr/lib/bootc/kargs.d && echo 'kargs = ["enforcing=0"]' > /usr/lib/bootc/kargs.d/10-example.toml
# yeah... sno-common.sh shouldn't be in there but meh... it's not actually executable.
# the next step up is to have a proper makefile and e.g. put it in /usr/lib/miniagent
# but let's keep it lightweight for now in the spirit of the repo
COPY sno-common.sh sno-setup sno-cleanup /usr/bin/
