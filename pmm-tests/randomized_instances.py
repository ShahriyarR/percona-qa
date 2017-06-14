import threading
import subprocess
import shlex
import os

def call_pmm_framework(i_name, i_count):
    """
    Will call pmm-framework.sh script with given instance name and count.
    """
    # Not a multi-threaded run
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    command = "{}/pmm-framework.sh --addclient={},{}"
    new_command = command.format(dbname, i_name, i_count)
    process = subprocess.Popen(
                    shlex.split(new_command),
                    stdin=None,
                    stdout=None,
                    stderr=None)

call_pmm_framework("ps",2)
