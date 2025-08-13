{
  language_server-protocol = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0scnz2fvdczdgadvjn0j9d49118aqm3hj66qh8sd2kv6g1j65164";
      type = "gem";
    };
    version = "3.17.0.4";
  };
  logger = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05s008w9vy7is3njblmavrbdzyrwwc1fsziffdr58w9pwqj8sqfx";
      type = "gem";
    };
    version = "1.6.6";
  };
  prism = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fi7hvrm2wzbhm21d3w87z5nrqx6z0gwhilvdizcpc9ik21205mi";
      type = "gem";
    };
    version = "1.3.0";
  };
  rbs = {
    dependencies = [ "logger" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07cwjkx7b3ssy8ccqq1s34sc5snwvgxan2ikmp9y2rz2a9wy6v1b";
      type = "gem";
    };
    version = "3.8.1";
  };
  ruby-lsp = {
    dependencies = [
      "language_server-protocol"
      "prism"
      "rbs"
      "sorbet-runtime"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hx0hb0j0jpzizc76sjrmvgvwifr7507xap66wzg6mj3mqc0y46r";
      type = "gem";
    };
    version = "0.23.11";
  };
  ruby-lsp-rspec = {
    dependencies = [ "ruby-lsp" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h2rnylicx9cw2agrxzgxcr0bl2ac8iy99sz7w657hbfrpsyv0p9";
      type = "gem";
    };
    version = "0.1.22";
  };
  ruby-lsp-rubyfmt = {
    dependencies = [
      "ruby-lsp"
      "sorbet-runtime"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qz6rxkvdgg6j2k3yiwq9izifj0sjmgfm2lmd42dll0vcjj9ywa4";
      type = "gem";
    };
    version = "0.1.0";
  };
  sorbet-runtime = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wn8g38ps6lvilp053i49xy02hq9zl361kcm72cl5hairk7ssdcl";
      type = "gem";
    };
    version = "0.5.11851";
  };
}
