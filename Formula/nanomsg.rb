class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.4.tar.gz"
  sha256 "ae5c688e874bf9bf1db764d08538c54f6ce9e4dc78bc5948008a304d519ad3b6"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    sha256 "308f97b5316cb5bc01ba78746518cde9bca7d191d4ca3612b0670d5d10a480ef" => :high_sierra
    sha256 "6f34a93c9fbb60f3b7c9b18e353934b5ae17c7234975e1d3a55800a79b55bf70" => :sierra
    sha256 "e9726200950742bfe0eab4e2a6275d9c8c64c864f9acc15920f4f6616486e572" => :el_capitan
    sha256 "f756184501e7c329c5561fa013e4e3a62e9b986cb4c6d2f5f92a4fa81c0a32d4" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    bind = "tcp://127.0.0.1:8000"

    pid = fork do
      exec "#{bin}/nanocat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    begin
      output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
      assert_match /home/, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
