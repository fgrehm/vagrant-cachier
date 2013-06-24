def config_with(options)
  instance.tap do |c|
    options.each_pair { |k, v| c.send("#{k}=".to_sym, v) }
    c.finalize!
  end
end

def conf_line(proto, name, port = 3142)
  if name == :direct
    %Q{Acquire::#{proto}::Proxy "DIRECT";\n}
  else
    %Q{Acquire::#{proto}::Proxy "#{proto}://#{name}:#{port}";\n}
  end
end

def conf_line_pattern(proto, name, port = 3142)
  "^#{Regexp.escape(conf_line(proto, name, port))}"
end

shared_examples "apt proxy config" do |proto|
  context "#{proto} proxy" do

    context "with ip" do
      subject        { config_with(proto => "10.1.2.3") }
      its(:enabled?) { should be_true }
      its(:to_s)     { should eq conf_line(proto, "10.1.2.3") }
    end

    context "with name" do
      subject        { config_with(proto => "proxy.example.com") }
      its(:enabled?) { should be_true }
      its(:to_s)     { should eq conf_line(proto, "proxy.example.com") }
    end

    context "with name and port" do
      subject        { config_with(proto => "acng:8080") }
      its(:enabled?) { should be_true }
      its(:to_s)     { should eq conf_line(proto, "acng", 8080) }
    end

    context "with protocol and name" do
      subject        { config_with(proto => "#{proto}://proxy.foo.tld") }
      its(:enabled?) { should be_true }
      its(:to_s)     { should eq conf_line(proto, "proxy.foo.tld") }
    end

    context "with protocol and name and port" do
      subject        { config_with(proto => "#{proto}://prism.nsa.gov:666") }
      its(:enabled?) { should be_true }
      its(:to_s)     { should eq conf_line(proto, "prism.nsa.gov", 666) }
    end

    ["DIRECT", "direct"].each do |direct|
      context "with #{direct.inspect}" do
        subject        { config_with(proto => direct) }
        its(:enabled?) { should be_true }
        its(:to_s)     { should eq conf_line(proto, :direct) }
      end
    end

    [false, ""].each do |unset|
      context "with #{unset.inspect}" do
        subject        { config_with(proto => unset) }
        its(:enabled?) { should be_true }
        its(:to_s)     { should eq "" }
      end
    end

    context "with nil" do
      subject        { config_with(proto => nil) }
      its(:enabled?) { should be_false }
      its(:to_s)     { should eq "" }
    end

  end
end

shared_examples "apt proxy env var" do |var, proto|
  context var do
    let(:conf) { config_with(http: "acng:8080", https: "ssl-proxy:8443") }

    it "sets #{proto} proxy" do
      ENV[var] = "myproxy"
      expect(conf.to_s).to match conf_line_pattern(proto, "myproxy")
    end

    it "does not set other proxies" do
      ENV[var] = "myproxy:2345"
      conf = config_with({})
      expect(conf.to_s).to eq conf_line(proto, "myproxy", 2345)
    end

    it "sets empty configuration" do
      ENV[var] = ""
      expect(conf.to_s).to_not match %r{#{proto}://}
    end

    it "sets direct configuration" do
      ENV[var] = "direct"
      expect(conf.to_s).to match conf_line_pattern(proto, :direct)
    end
  end
end
