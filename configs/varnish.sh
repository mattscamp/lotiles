echo "
# Should we start varnishd at boot?  Set to \"no\" to disable.
START=yes

# Maximum number of open files (for ulimit -n)
NFILES=131072

# Maximum locked memory size (for ulimit -l)
# Used for locking the shared memory log in memory.  If you increase log size,
# you need to increase this number as well
MEMLOCK=82000

DAEMON_OPTS=\"-a :$VARNISH_PORT \
             -T localhost:6082 \
             -f /etc/varnish/default.vcl \
             -S /etc/varnish/secret \
             -s malloc,256m\"


## Alternative 3, Advanced configuration
#
# This example uses the INSTANCE variable above, which you need to uncomment.
#
# See varnishd(1) for more information.
#
# # Main configuration file. You probably want to change it :)
# VARNISH_VCL_CONF=/etc/varnish/default.vcl
#
# # Default address and port to bind to
# # Blank address means all IPv4 and IPv6 interfaces, otherwise specify
# # a host name, an IPv4 dotted quad, or an IPv6 address in brackets.
# VARNISH_LISTEN_ADDRESS=
# VARNISH_LISTEN_PORT=6081
#
# # Telnet admin interface listen address and port
# VARNISH_ADMIN_LISTEN_ADDRESS=127.0.0.1
# VARNISH_ADMIN_LISTEN_PORT=6082
#
# # The minimum number of worker threads to start
# VARNISH_MIN_THREADS=1
#
# # The Maximum number of worker threads to start
# VARNISH_MAX_THREADS=1000
#
# # Idle timeout for worker threads
# VARNISH_THREAD_TIMEOUT=120
#
# # Cache file location
# VARNISH_STORAGE_FILE=/var/lib/varnish/varnish_storage.bin
#
# # Cache file size: in bytes, optionally using k / M / G / T suffix,
# # or in percentage of available disk space using the % suffix.
# VARNISH_STORAGE_SIZE=1G
#
# # File containing administration secret
# VARNISH_SECRET_FILE=/etc/varnish/secret
#
# # Backend storage specification
# VARNISH_STORAGE=\"file,storage_file,size\"
#
# # Default TTL used when the backend does not specify one
# VARNISH_TTL=120
" > /etc/default/varnish