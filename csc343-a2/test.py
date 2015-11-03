from io import StringIO
from subprocess import Popen, DEVNULL
import sys

def run(command):
    stderr, stdout = StringIO(), StringIO()
    proc = Popen(command, shell=True, stdout=DEVNULL, stderr=DEVNULL)

    return proc.communicate()


run("cd starter/testdata && psql -f artistdb.ddl")
