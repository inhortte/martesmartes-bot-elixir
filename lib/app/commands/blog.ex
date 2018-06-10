defmodule App.Commands.Blog do
  # Notice that here we just `use` Commander. Router is only
  # used to map commands to actions. It's best to keep routing
  # only in App.Commands file. Commander gives us helpful
  # macros to deal with Nadia functions.
  use App.Commander
  alias App.Aphorisms.Aphorisms

  # Functions must have as first parameter a variable named
  # update. Otherwise, macros (like `send_message`) will not
  # work as expected.
  def goat(update) do
    Logger.log :info, "Command /goat"

    send_message Aphorisms.sentence_from_blog()
  end

  def inline_goat() do
    Logger.log :info, "Inline query /goat"
    respuestas = Enum.map(1..11, fn(i) ->
      thurk = Aphorisms.sentence_from_blog()
      %InlineQueryResult.Article{
	id: "aphorism#{i}",
	title: "aphorism ##{i}",
	description: thurk,
	input_message_content: %{
	  message_text: thurk,
	},
      }
    end)
    respuestas
  end
end
