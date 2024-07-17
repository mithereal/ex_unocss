defmodule UnocssTest do
  use ExUnit.Case, async: true

  @version Unocss.latest_version()

  setup do
    Application.put_env(:unocss, :version, @version)
    File.mkdir_p!("assets/js")
    File.mkdir_p!("assets/css")
    File.rm("assets/unocss.config.ts")
    File.rm("assets/css/app.css")
    :ok
  end

  test "run on default" do
    assert ExUnit.CaptureIO.capture_io(fn ->
             assert Unocss.run(:default, ["--help"]) == 0
           end) =~ @version
  end

  test "run on profile" do
    assert ExUnit.CaptureIO.capture_io(fn ->
             assert Unocss.run(:another, []) == 0
           end) =~ @version
  end

  test "run with pre-existing app.css" do
    assert ExUnit.CaptureIO.capture_io(fn ->
             assert Unocss.run(:default, []) == 0
           end) =~ @version
  end

  test "updates on install" do
    Application.put_env(:unocss, :version, "3.0.3")
    Mix.Task.rerun("unocss.install", ["--if-missing"])

    assert ExUnit.CaptureIO.capture_io(fn ->
             assert Unocss.run(:default, ["--help"]) == 0
           end) =~ "3.0.3"

    Application.delete_env(:unocss, :version)

    Mix.Task.rerun("unocss.install", ["--if-missing"])
    assert File.exists?("assets/unocss.config.ts")
    assert File.read!("assets/css/app.css") =~ "unocss"

    assert ExUnit.CaptureIO.capture_io(fn ->
             assert Unocss.run(:default, ["--help"]) == 0
           end) =~ @version
  end

  test "installs with custom URL" do
    assert :ok =
             Mix.Task.rerun("unocss.install", [
               "https://github.com/unocss/unocss/releases/download/v$version/unocss-$target"
             ])
  end
end
