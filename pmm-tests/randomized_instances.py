from subprocess import check_output, Popen
from shlex import split
from uuid import uuid4
from random import randint
import threading
import click

###############################################################################
# Main logic goes here, below
def pmm_framework_add_client(i_name, i_count):
    """
    Will call pmm-framework.sh script with given instance name and count.
    """
    # Not a multi-threaded run
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    command = "{}/pmm-framework.sh --addclient={},{}"
    new_command = command.format(dname, i_name, i_count)
    process = Popen(
                    split(new_command),
                    stdin=None,
                    stdout=None,
                    stderr=None)
    process.communicate()

def pmm_framework_wipe_client():
    """
    For wiping added instances from pmm + to shutdown previosly started instances(pysically)
    """
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    command = "{}/pmm-framework.sh --wipe-clients"
    new_command = command.format(dname)
    process = Popen(
                    split(new_command),
                    stdin=None,
                    stdout=None,
                    stderr=None)
    process.communicate()


def getting_instance_socket():
    # For obtaining socket file path for each added instances
    # Return: the list of sockets
    command = "sudo pmm-admin list | grep 'mysql:metrics' | sed 's|.*(||;s|)||'"
    prc = check_output(command, shell=True)
    return prc.split()


def adding_instances(sock):
    """
    Will try to add instances with randomized name, based on already added instances
    """
    # This is a multi-threaded run

    command = "sudo pmm-admin add mysql --user=root --socket={} --service-port={} {} "
    new_command = command.format(sock, str(randint(10000, 60000)), str(uuid4()))
    print("Running -> " + new_command)
    process = Popen(
                    split(new_command),
                    stdin=None,
                    stdout=None,
                    stderr=None)
    # Uncomment below to wait for each command to exit
    #process.communicate()
            
def runner(count, i_name, i_count):
    """
    Main runner function; using Threading;
    """
    pmm_framework_wipe_client()
    pmm_framework_add_client(i_name, i_count)
    sockets = getting_instance_socket()
    for sock in sockets:
        # for i in range(count):
        #     adding_instances(sock)
        workers = [threading.Thread(target=adding_instances(sock), name="thread_"+str(i))
                    for i in range(count)]
        [worker.start() for worker in workers]
        [worker.join() for worker in workers]


#runner(100, "ps", 2)
# TODO: pass specific port number to --service-port= global flag -> DONE
# TODO: Read args from command line - pass values from commandline

##############################################################################
# Command line things are here, this is separate from main logic of script.
def print_version(ctx, param, value):
    if not value or ctx.resilient_parsing:
        return
    click.echo("PMM Stress Test Suite Version 1.0")
    ctx.exit()
 
@click.command()
@click.option(
    '--version', 
    is_flag=True, 
    callback=print_version,
    expose_value=False, 
    is_eager=True,
    help="Version information.")
###############################################################################

if __name__ == "__main__":
    runner(100, "ps", 2)