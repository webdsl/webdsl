# WebDSL
Main repository for the WebDSL domain-specific language for web applications.

## Installation
Either follow the [installation instructions][1], or build from source.
See also [how to get WebDSL in Eclipse][2].

## Building
Invoke the following commands from the root of the repository:

    ./bootstrap
    ./configure --enable-java-backend--prefix=/usr/local
    make
    make install

You can check the current version of your WebDSL installation:

    webdsl version

It will report the hash of the commit from which WebDSL was built.

> Note: If you get this error when invoking `make`:
>
>     Making all in src
>     make[1]: *** No rule to make target `libwebdsl-front.rtree',
>       needed by `src-gen/org/webdsl/webdsl_generator/Main.java'.  Stop.
>     make: *** [all-recursive] Error 1
>
> Clean the temporary files from the repository, e.g.:
>
>     git clean -fXd
>
> Then reissue the commands for building WebDSL.


[1]: https://webdsl.org/singlepage/Download
[2]: https://webdsl.org/selectpage/Download/WebDSLplugin