require 'spec_helper'
require 'unit/support/shared/apt_proxy_config'
require 'vagrant-cachier/apt_proxy_config'

describe VagrantPlugins::Cachier::AptProxyConfig do
  let(:instance) { described_class.new }

  before :each do
    # Ensure tests are not affected by environment variables
    %w[APT_PROXY_HTTP APT_PROXY_HTTPS].each { |k| ENV.delete(k) }
  end

  context "defaults" do
    subject        { config_with({}) }
    its(:enabled?) { should be_false }
    its(:to_s)     { should eq "" }
  end

  include_examples "apt proxy config", "http"
  include_examples "apt proxy config", "https"

  context "with both http and https proxies" do
    subject        { config_with(http: "10.2.3.4", https: "ssl-proxy:8443") }
    its(:enabled?) { should be_true }
    its(:to_s)     { should match conf_line_pattern("http", "10.2.3.4") }
    its(:to_s)     { should match conf_line_pattern("https", "ssl-proxy", 8443) }
  end

  context "with env var" do
    include_examples "apt proxy env var", "APT_PROXY_HTTP", "http"
    include_examples "apt proxy env var", "APT_PROXY_HTTPS", "https"
  end

end
