http://http.kali.org/README.mirrorlist

# Page:

```
Mirrors for README
File information
Filename: README
Path: /README
Size: 325 (325 bytes)
Last modified: Wed, 30 Mar 2022 07:15:47 GMT (Unix time: 1648624547)
Download file from preferred mirror

Reliable downloads
Metalink
http://http.kali.org/README.meta4 (IETF Metalink)
http://http.kali.org/README.metalink (old (v3) Metalink)
Mirrors
List of best mirrors for IP address 154.28.188.238, located at 37.750999,-97.821999 in United States (US).

Map showing the closest mirrors

Found 3 mirrors which handle this country (US)
http://kali.download/kali/README (us, prio 400)
http://mirrors.jevincanders.net/kali/README (us, prio 100)
http://mirrors.ocf.berkeley.edu/kali/README (us, prio 100)
Found 17 mirrors in other parts of the world
http://ftp.free.fr/pub/kali/README (fr, prio 200)
http://archive-4.kali.org/kali/README (fr, prio 200)
http://ftp.belnet.be/pub/kali/kali/README (be, prio 100)
http://ftp2.nluug.nl/os/Linux/distr/kali/README (nl, prio 100)
http://ftp1.nluug.nl/os/Linux/distr/kali/README (nl, prio 100)
http://mirror.serverius.net/kali/README (nl, prio 100)
http://ftp.halifax.rwth-aachen.de/kali/README (de, prio 400)
http://mirror.netcologne.de/kali/README (de, prio 100)
http://mirror.pyratelan.org/kali/README (de, prio 100)
http://mirrors.dotsrc.org/kali/README (dk, prio 100)
http://mirror.karneval.cz/pub/linux/kali/README (cz, prio 100)
http://ftp.acc.umu.se/mirror/kali.org/kali/README (se, prio 200)
http://mirror.anigil.com/kali/README (kr, prio 100)
http://ftp.jaist.ac.jp/pub/Linux/kali/README (jp, prio 100)
http://mirror.lagoon.nc/kali/README (nc, prio 100)
http://hlzmel.fsmg.org.nz/kali/README (nz, prio 100)
http://wlglam.fsmg.org.nz/kali/README (nz, prio 100)
Powered by MirrorBrain
```

# change /etc/apt/sources.list url
## sample old:
```
deb http://http.kali.org/kali        kali-rolling main contrib non-free
```

## sample new: can be picked from any of the mirror urls above
```
deb http://mirror.netcologne.de/kali kali-rolling main contrib non-free
```