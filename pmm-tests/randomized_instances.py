import threading
from subprocess import check_output
from shlex import split
import os
import uuid

def call_pmm_framework(i_name, i_count):
    """
    Will call pmm-framework.sh script with given instance name and count.
    """
    # Not a multi-threaded run
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    command = "{}/pmm-framework.sh --addclient={},{}"
    new_command = command.format(dname, i_name, i_count)
    process = subprocess.Popen(
                    shlex.split(new_command),
                    stdin=None,
                    stdout=None,
                    stderr=None)

#call_pmm_framework("ps",2)

# def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
#     return ''.join(random.choice(chars) for _ in range(size))

def getting_instance_socket():
    # For obtaining socket file path for each added instances
    command = "sudo pmm-admin list | grep 'mysql:metrics' | sed 's|.*(||;s|)||'"
    prc = check_output(command, shell=True)
    return prc.split()

#print getting_instance_socket()

def adding_instances(i_count):
    """
    Will try to add instances with randomized name, based on already added instances
    """
    # This is a multi-threaded run

    command = "sudo pmm-admin add mysql --user=root --socket={} {}"
    socket = getting_instance_socket()

    for sock in socket:
        for m in range(i_count):
            new_command = command.format(sock, str(uuid.uuid4()))
            
        

    # workers = [threading.Thread(target=backup_obj.run_all(backup_dir="thread_"+str(i)), name="thread_"+str(i))
    #                for i in range(i_count)]
    # [worker.start() for worker in workers]
    # [worker.join() for worker in workers]

adding_instances(100)