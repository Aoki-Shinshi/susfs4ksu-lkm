#!/system/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
[ "$KSU" = true ] || abort "- KernelSU-compatible manager required."
[ "$ARCH" = arm64 ] || abort "- arm64 only."
REL=$(cat /proc/sys/kernel/osrelease) || abort "- cannot read kernel release."
. "$MODPATH/kmi.sh"
KMI=$(select_kmi "$REL" "$MODPATH") || abort "- no packaged .ko for this kernel: $REL"
[ -s "$MODPATH/lib/susfs_guard_lkm-$KMI.ko" ] || abort "- missing .ko for $KMI."
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/bin/susfs_insmod" 0 0 0755
touch "$MODPATH/skip_mount"
ui_print "- susfs_guard_lkm for $KMI (arm64)"
ui_print "- Loader only; no rules are applied"
ui_print "- Reboot to load; will not stack on an already-present susfs"
