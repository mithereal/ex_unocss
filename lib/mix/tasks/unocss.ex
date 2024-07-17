defmodule Mix.Tasks.Unocss do
  @moduledoc """
  Invokes unocss with the given args.

  Usage:

      $ mix unocss TASK_OPTIONS PROFILE UNO_ARGS

  Example:

      $ mix unocss default --config=unocss.config.js \
        --input=css/app.css \
        --output=../priv/static/assets/app.css \
        --minify

  If unocss is not installed, it is automatically downloaded.
  Note the arguments given to this task will be appended
  to any configured arguments.

  ## Options

    * `--runtime-config` - load the runtime configuration
      before executing command

  Note flags to control this Mix task must be given before the
  profile:

      $ mix unocss --runtime-config default
  """

  @shortdoc "Invokes unocss with the profile and args"

  use Mix.Task

  @impl true
  def run(args) do
    switches = [runtime_config: :boolean]
    {opts, remaining_args} = OptionParser.parse_head!(args, switches: switches)

    if opts[:runtime_config] do
      Mix.Task.run("app.config")
    else
      Application.ensure_all_started(:unocss)
    end

    Mix.Task.reenable("unocss")
    install_and_run(remaining_args)
  end

  defp install_and_run([profile | args] = all) do
    case Unocss.install_and_run(String.to_atom(profile), args) do
      0 -> :ok
      status -> Mix.raise("`mix unocss #{Enum.join(all, " ")}` exited with #{status}")
    end
  end

  defp install_and_run([]) do
    Mix.raise("`mix unocss` expects the profile as argument")
  end
end
