defmodule App.Commands.Quotebook do
  use App.Commander
  alias App.Aphorisms.Quotes

  def quote(update) do
    Logger.log :info, "Command /quote"

    send_message Quotes.random_quote()
  end

  def inline_quote() do
    Logger.log :info, "Inline query /quote"
    respuestas = Enum.map(1..6, fn(i) ->
      thurk = Quotes.random_quote()
      %InlineQueryResult.Article{
	id: "quote#{i}",
	title: "quote ##{i}",
	description: thurk,
	input_message_content: %{
	  message_text: thurk,
	},
      }
    end)
    respuestas
  end
end
