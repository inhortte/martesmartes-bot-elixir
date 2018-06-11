defmodule App.Aphorisms.Quotes do
  require Logger
  
  @quote_regex ~r/"[\w\s,;:'\.\?!\(\)]+"/
  @human_regex ~r/-[\w\s]+[\("]/
  @date_regex ~r/\(([0-9]+\/){0,1}([0-9]+\/){0,1}([0-9]+)\)/

  def string_to_quote(s) do
    quotes = Regex.scan(@quote_regex, s) |> Enum.map(fn(s) -> List.first(s) |> String.replace(~r/\s+/, " ") end)
    Logger.info quotes
    humans = Regex.scan(@human_regex, s) |> Enum.map(fn(s) -> List.first(s) |> String.slice(1..-2) |> String.trim end)
    Logger.info humans
    d = case d_scan = Regex.scan(@date_regex, s) do
	  [] ->
	    ["1970"]
	  _ ->
	    d_scan |> List.first |> List.first |> String.slice(1..-2) |> String.split(~r/\//)
	end
    Logger.info d
    date = case length(d) do
	     1 ->
	       y = case Integer.parse(Enum.at(d, 0)) do
		     {y, _} ->
		       y
		     :error ->
		       1970
		   end
	       %DateTime{year: y, month: 1, day: 1, zone_abbr: "UTC",
			 hour: 0, minute: 0, second: 0, microsecond: {0, 0},
			 utc_offset: 0, std_offset: 0, time_zone: "Europe/London"}
	     2 ->
	       {y, _} = Integer.parse(Enum.at(d, 1))
	       {m, _} = Integer.parse(Enum.at(d, 0))
	       %DateTime{year: y, month: m, day: 1, zone_abbr: "UTC",
			 hour: 0, minute: 0, second: 0, microsecond: {0, 0},
			 utc_offset: 0, std_offset: 0, time_zone: "Europe/London"}
	     _ ->
	       {y, _} = Integer.parse(Enum.at(d, 2))
	       {m, _} = Integer.parse(Enum.at(d, 0))
	       {day, _} = Integer.parse(Enum.at(d, 1))
	       %DateTime{year: y, month: m, day: day, zone_abbr: "UTC",
			 hour: 0, minute: 0, second: 0, microsecond: {0, 0},
			 utc_offset: 0, std_offset: 0, time_zone: "Europe/London"}
	   end
    [quotes: quotes, humans: humans, date: date]
  end

  def is_line_empty?(line), do: String.trim(line) |> (fn(s) -> String.length(s) == 0 end).()

  def eval_line(line, acc) when length(acc) == 0, do: [line]
  def eval_line(line, acc = [q | qs]) do
    if is_line_empty?(line) do
      ["" | acc]
    else
      ["#{line} #{q}" | qs]
    end
  end

  def split_into_quote_blocks(lines) do
    lines |> List.foldr([], &eval_line/2)
  end

  def quotebook_to_quotes() do
    Application.get_env(:app, :quote_file) |> File.read! |> String.split(~r/\n/) |> split_into_quote_blocks |> Enum.map(&string_to_quote/1)
  end
end
