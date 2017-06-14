import threading
import subprocess
import shlex

def call_pmm_framework(i_name, i_count):
    """
    Will call pmm-framework.sh script with given instance name and count.
    """
    # Not a multi-threaded run
    command = "pmm-framework.sh --addclient={},{}"
    new_command = command.format(i_name, i_count)
    process = subprocess.Popen(
                    shlex.spkit(new_command),
                    stdin=None,
                    stdout=None,
                    stderr=None)

call_pmm_framework(ps,2)
