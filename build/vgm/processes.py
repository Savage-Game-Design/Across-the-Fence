"""
Process management utility functions.
"""

from subprocess import Popen
from time import sleep
from typing import List


def check_terminate_process(process: Popen, timeout: int = 15):
    """
    Terminate/kill a process. Kills if not exited after specified timeout.

    Args:
        - process: a `subprocess.Popen` process
        - timeout: number of seconds to wait for process termination before
          sending a SIGKILL

    Returns: None
    """
    if process.returncode is not None:
        print(f"Process already exited: {process.returncode}")
        return

    returncode = process.poll()
    if returncode is None:
        print(f"Attempting SIGTERM: pid={process.pid}")
        process.terminate()

    returncode = process.wait(timeout)
    if returncode is None:
        print(f"Process still alive after {timeout} seconds, SIGKILL: pid={process.pid}")
        process.kill()


def check_alive(process: Popen):
    """
    Check if a process is still alive.

    Args:
    	- process: a `subprocess.Popen` object

    Returns: `True` when process is alive, `False` when process has exited
    """
    return process.poll() is None


def process_handler(processes: List[Popen], polling_seconds: int = 1):
    """
    Manages launched processes, terminating/killing running processes when

    1. SIGINT recevied (Ctrl + C)
    2. a process is killed externally (externally killing server process will
      terminate still running client process)
    3. some error occurs while processes are running (bug in CLI)

    Args:
        - processes: list of subprocess.Popen objects
        - polling_seconds: check alive-ness of all processes every X seconds

    Notes:
        capturing SIGINT annoyingly needs try-except for branch logic :/

        could use `signal.signal()`, but means mutating some process tracking
        object/variable in global namespace (more complicated script state etc)
        https://stackoverflow.com/a/4205386/5945794

    Returns: None
    """

    try:
        while all(check_alive(x) for x in processes):
            sleep(polling_seconds)

    except KeyboardInterrupt:
        print("Interrupt!")

    except BaseException as err:
        print(f"An unknown error occured: {err}")

    else:
        print("A process was terminated externally. Terminating any remaining processes.")

    finally:
        for p in processes:
            check_terminate_process(p)
