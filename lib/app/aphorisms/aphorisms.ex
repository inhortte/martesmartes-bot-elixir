defmodule App.Aphorisms.Aphorisms do
  @blog_regex ~r<[A-Z][-\*\w\s,;:"']+[\.\?!]>
  @no_match ~r<^(Topic|Subject|_id|Date)>
  
  def blog_files() do
    Enum.map(Application.get_env(:app, :blog_dirs), fn(dir) ->
      case File.ls dir do
	{:ok, files} ->
	  Enum.map(files, fn(f) -> Path.join(dir, f) end)
	{:error, _} ->
	  []
      end
    end) |> List.flatten
  end

  def random_from_list(l) do
    Enum.random l
  end

  def sentence_from_text(text) do
    Regex.scan(@blog_regex, text) |> Enum.map(&List.first/1) |> Enum.reject(&is_nil/1) |> Enum.filter(fn(s) -> !Regex.match?(@no_match, s) end) |> random_from_list
  end

  def sentence_from_blog() do
    blog_files() |> random_from_list |> File.read! |> sentence_from_text
  end
end
