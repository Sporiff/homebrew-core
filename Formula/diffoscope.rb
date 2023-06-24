class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/86/79/5c6302005ff14577e712cc8d0dd944ac65dfee6d64c1a6b7e703c9a846ff/diffoscope-243.tar.gz"
  sha256 "3ce7ff00d72ffd9c904d1d93a4a147208878f56e8f0286073533615689d840b1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4df41ec013d38b1f0c07362486ec76977d930a8dd2306894470ef3fc702b0743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d0abad49cd354cd25145398e6af4a3562a1fb9c566078b9332f5f7007d270f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9391fd4adf12f36e54f5b4d5c34be91d8ee65ef97cef98b550467e8cd2dbbefc"
    sha256 cellar: :any_skip_relocation, ventura:        "25090c21c5dc14c0eebe5a4f1ba162da7fe9041a574e22aacf7bc6d1621e89c8"
    sha256 cellar: :any_skip_relocation, monterey:       "07fa194d98969181de4aad907691a51c9a9949c8c846f2aff7a84c77268fc1a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2961117b9e91352cbe501fe5951deaf82a670ca8dda1696ee514adca0975b157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2211ed1887759ca80e20591993c4a6b11d2496821258210c820bede0f3103652"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end
