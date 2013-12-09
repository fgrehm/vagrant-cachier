# Benchmarks

During the early days of this plugin, [@fgrehm](https://github.com/fgrehm) wrote
a [blog post](http://fabiorehm.com/blog/2013/05/24/stop-wasting-bandwidth-with-vagrant-cachier#show_me_the_numbers)
with some benchmarks on the time that was cut down by using the plugin. If you
are interested on the numbers only, the VMs tested were one of vagrant-lxc's
Ubuntu [dev boxes](https://github.com/fgrehm/vagrant-lxc/wiki/Development#using-virtualbox-for-development),
[rails-dev-box](https://github.com/rails/rails-dev-box), his own [rails-base-box](https://github.com/fgrehm/rails-base-box)
and Discourse's [dev box](https://github.com/discourse/discourse/blob/master/Vagrantfile)

|                | First provision | Second provision | Diff.  | APT cache |
| ---            | :---:           | :---:            | :---:  | :---:     |
| rails-dev-box  | 4m45s           | 3m20s            | ~29%   | 66mb      |
| rails-base-box | 11m56s          | 7m54s            | ~34%   | 77mb      |
| vagrant-lxc    | 10m16s          | 5m9s             | ~50%   | 124mb     |
| discourse      | 1m41s           | 49s              | ~51%   | 62mb      |
<br>
_Please note that the tests were made on May 24th 2013 and nowadays they might
be a bit different_

<br>
Some people have shared their numbers on Twitter and had experienced even better
results:

<blockquote><p>Holy cow... If you dig Vagrant, and like time - you need Vagrant Cachier. 60% speed increase for me. <a href="https://t.co/225jRH7bDa">https://t.co/225jRH7bDa</a> <a href="https://twitter.com/vagrantup">@vagrantup</a></p>&mdash; Chris Rickard (@chrisrickard) <a href="https://twitter.com/chrisrickard/statuses/400128294479081472">November 12, 2013</a></blockquote>
<blockquote><p>vagrant-cachier saved 3:20 off my <a href="https://twitter.com/search?q=%23vagrant&amp;src=hash">#vagrant</a> <a href="https://twitter.com/search?q=%23provisioning&amp;src=hash">#provisioning</a> <a href="http://t.co/VzRRu1QEwL">http://t.co/VzRRu1QEwL</a></p>&mdash; Joe Ferguson (@svpernova09) <a href="https://twitter.com/svpernova09/statuses/400040517943037952">November 11, 2013</a></blockquote>
<blockquote><p>Tested vagrant-cachier. Saved 60% of vagrant up time installing 10 rpms with chef. Pretty awesome. Check it out! <a href="https://t.co/HfbLJNP7GH">github.com/fgrehm/vagrant…</a></p>&mdash; Miguel. (@miguelcnf) <a href="https://twitter.com/miguelcnf/status/343757107058847746">June 9, 2013</a></blockquote>
<blockquote><p>vagrant-cachier took my vagrant spin up from 30 to 5 minutes and reduced my caffeine intake by 3 cups <a href="http://t.co/V0uYpr3U0y">http://t.co/V0uYpr3U0y</a></p>&mdash; Russell Cardullo (@russellcardullo) <a href="https://twitter.com/russellcardullo/statuses/343070870744494080">June 7, 2013</a></blockquote>
