#!/usr/bin/env sh

set -o errexit -o nounset -o pipefail
set -x

pwd_mkdb -p /etc/master.passwd

(cd /usr/local/lib/python3.9/ && patch -Np0) <<EOF
--- crypt.py	2022-10-08 02:35:01.000000000 +0200
+++ crypt.py	2022-11-08 18:49:13.334474908 +0100
@@ -110,11 +110,12 @@
 # the initial implementation, 'b' fixes flaws of 'a'.
 # 'y' is the same as 'b', for compatibility
 # with openwall crypt_blowfish.
-for _v in 'b', 'y', 'a', '':
-    if _add_method('BLOWFISH', '2' + _v, 22, 59 + len(_v), rounds=1<<4):
-        break
+#for _v in 'b', 'y', 'a', '':
+#    if _add_method('BLOWFISH', '2' + _v, 22, 59 + len(_v), rounds=1<<4):
+#        break
 
 _add_method('MD5', '1', 8, 34)
 _add_method('CRYPT', None, 2, 13)
 
-del _v, _add_method
+#del _v, _add_method
+del _add_method
EOF

cat >>/etc/dhcpcd.conf <<EOF
denyinterfaces vtnet0
EOF

>/etc/resolv.conf

sync
