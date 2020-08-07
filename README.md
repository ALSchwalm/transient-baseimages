transient-baseimages
--------------------

This repository contains a collection of [`transient`](https://github.com/alschwalm/transient)
Imagefiles. These files contain a declarative set of steps for
building minimal virtual machine disk images. For more information
on `transient` and building images, see the `transient` docs
[here](https://transient.readthedocs.io/en/latest/).

This repository contains Imagefiles that building images 'from scratch'.
That is, they are not based on any existing image. These images are
periodically built and uploaded to [Vagrant Cloud](https://app.vagrantup.com/boxes/search?utf8=%E2%9C%93&sort=downloads&provider=&q=transient-baseimage),
so they can be used with `transient` easily. For example, to use the
baseimage for Ubuntu 20.04 as a `transient` image, simply run:

```
transient run -image transient-baseimage/ubuntu-20.04:20200806 \
              -sshs -- -m 1G -enable-kvm
```
