# Anarchy

## Building

To build, you need the Arma P-Drive set up in the standard way for Arma 3.

Set up the P-Drive for anarchy using `python build-tools\build.py pdrive` or manually set up (symlink or copy each .pbo folder to `P:\sgd\anarchy`).
To use the `pdrive` command, you'll need to be using a elevated command prompt (run as administrator). You will only need to ever do this once.

Finally, run `python build-tools\build.py build`. By default, this builds both the client and server addons into the `packed` directory.

## Filepatching

Filepatching can be enabled by using `python build-tools\build.py filepatching <Path to Arma Root>`, and disabled using `python build-tools\build.py filepatching -d <Path to Arma Root>`.


