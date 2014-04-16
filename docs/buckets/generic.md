# Generic

This bucket is never enabled by default. You have to enable it explicitly like
this:

```ruby
Vagrant.configure("2") do |config|
  config.cache.enable :generic, { :cache_dir => "/var/cache/some" }
end
```

The `:cache_dir` parameter is required. It specifies the directory on the guest
that will be cached under the "/tmp/vagrant-cache/generic" bucket.

You may enable more than one generic bucket by giving them different names,
like this:

```ruby
Vagrant.configure("2") do |config|
  config.cache.enable :generic, {
    "one" => { cache_dir: "/var/cache/one" },
    "two" => { cache_dir: "/var/cache/two" },
  }
end
```

In this case you get two buckets called "one" and "two" under the guest's
`/tmp/vagrant-cache` directory.

The Generic bucket is useful if you want to implement a caching mechanism by
hand. For instance, if you want to cache your wget downloads under
`/var/cache/wget` you can do this:

```ruby
Vagrant.configure("2") do |config|
  config.cache.enable :generic, {
    "wget" => { cache_dir: "/var/cache/wget" },
  }
end
```

Then, you invoke wget like this:

```sh
wget -N -P /var/cache/wget URL
```
