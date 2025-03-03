def test_version():
    from pkg import __version__
    assert __version__ == "0.0.dev0"
