vagrant_up() {
  pushd tmp
    run bundle exec vagrant up > /tmp/vagrant-cachier-tests.log
  popd
}

vagrant_destroy() {
  pushd tmp
    run bundle exec vagrant destroy -f
  popd
}

configure_env() {
  fixture=$1

  mkdir -p tmp/
  cp spec/acceptance/fixtures/${fixture} tmp/Vagrantfile

  vagrant_destroy
  [ "$status" -eq 0 ]
  rm -rf tmp/.vagrant
}

empty_cache() {
  rm -rf tmp/.vagrant/cache
}
