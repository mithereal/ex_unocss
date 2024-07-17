defmodule Mix.Tasks.Unocss.Install do
  @moduledoc """
  Installs unocss under `_build`.

  ```bash
  $ mix unocss.install
  $ mix unocss.install --if-missing
  ```

  By default, it installs #{Unocss.latest_version()} but you
  can configure it in your config files, such as:

      config :unocss, :version, "#{Unocss.latest_version()}"

  ## Options

      * `--runtime-config` - load the runtime configuration
        before executing command

      * `--if-missing` - install only if the given version
        does not exist
  """

  @shortdoc "Installs unocss under _build"
  use Mix.Task

  @impl true
  def run(args) do
    valid_options = [runtime_config: :boolean, if_missing: :boolean]

    {opts, base_url} =
      case OptionParser.parse_head!(args, strict: valid_options) do
        {opts, []} ->
          {opts, Unocss.default_base_url()}

        {opts, [base_url]} ->
          {opts, base_url}

        {_, _} ->
          Mix.raise("""
          Invalid arguments to unocss.install, expected one of:

              mix unocss.install
              mix unocss.install 'https://github.com/unocss/unocss/releases/download/v$version/unocsscss-$target'
              mix unocss.install --runtime-config
              mix unocss.install --if-missing
          """)
      end

    if opts[:runtime_config], do: Mix.Task.run("app.config")

    if opts[:if_missing] && latest_version?() do
      :ok
    else
      Unocss.install(base_url)
    end
  end

  defp latest_version?() do
    version = Unocss.configured_version()
    match?({:ok, ^version}, Unocss.bin_version())
  end
end
