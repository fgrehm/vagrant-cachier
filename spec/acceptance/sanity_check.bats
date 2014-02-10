#!/usr/bin/env bats

load test_helper

@test "Vagrantfile without cachier statement does not blow up when bringing the VM up" {
  configure_env "no-cachier-simple.rb"
  vagrant_up
  [ "$status" -eq 0 ]
  vagrant_destroy

  configure_env "no-cachier-with-provisioning.rb"
  vagrant_up
  [ "$status" -eq 0 ]
  vagrant_destroy
}

@test "Vagrantfile with cachier auto_detect statement does not blow up when bringing the VM up" {
  configure_env "auto-detect.rb"
  vagrant_up
  [ "$status" -eq 0 ]
  vagrant_destroy
}

@test "APT cache bucket configures the cache dir properly and keeps cache dir around" {
  configure_env "auto-detect-with-provisioning.rb"

  # Make sure cache/lista dir does not exist
  test ! -d tmp/.vagrant/machines/default/cache/apt/archives
  test ! -d tmp/.vagrant/machines/default/cache/apt/lists

  vagrant_up
  [ "$status" -eq 0 ]

  # Make sure packages are being cached
  test -d tmp/.vagrant/machines/default/cache/apt/archives
  FILES=(`ls tmp/.vagrant/machines/default/cache/apt/archives/git*.deb`)
  [ ${#FILES[@]} -gt 0 ]
  
  test -d tmp/.vagrant/machines/default/cache/apt/lists
  FILES=(`ls tmp/.vagrant/machines/default/cache/apt/lists/*Packages`)
  [ ${#FILES[@]} -gt 0 ]

  vagrant_destroy

  # Make sure packages are not removed between machine rebuilds
  FILES=(`ls tmp/.vagrant/machines/default/cache/apt/archives/git*.deb`)
  [ ${#FILES[@]} -gt 0 ]
  
  FILES=(`ls tmp/.vagrant/machines/default/cache/apt/lists/*Packages`)
  [ ${#FILES[@]} -gt 0 ]

  empty_cache
}
