import subprocess
import config

def arma_launch():
    args = [
        "-mod=" + ";".join(config.arma_arg_mods),
    ] + config.arma_args

    # start arma
    subprocess.Popen([config.arma_exe_path] + args)


arma_launch()
