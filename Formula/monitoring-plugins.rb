class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.3.tar.gz"
  sha256 "3fd96efaa751c7646fe3ba25f9714859a204176a155d12fe0ee420e39e90f56c"

  bottle do
    cellar :any
    sha256 "ffbe638346525cff73092be9951d3b670fbb421941ee7d12f64ca1cf8228e949" => :big_sur
    sha256 "24ba799d36a93d5cde26e1e52616166881164cabddd6c1c14a19316a07eebd6b" => :catalina
    sha256 "3aa775909751c2a826325b07f0a9b77df5160af6bacfa4f8cb082e635045c620" => :mojave
    sha256 "81f794e4736584eba6ecfc32b6c79b877579b3841e66b9f70754f98c499a5098" => :high_sierra
    sha256 "0fa42fdf9687faa06a7566322cf9014d06040338e5a988da6aef130b15e2953a" => :sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end
