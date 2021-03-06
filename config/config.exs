use Mix.Config

config :app,
  bot_name: "MartesMartesBot",
  blog_dirs: ["/home/polaris/Dropbox/archiv/martenblog",
	      "/home/polaris/Dropbox/archiv/christian",
	      "/home/polaris/Dropbox/archiv/listopad"],
  quote_file: "/home/polaris/Dropbox/draining_the_pond/Three_Subject_Quotebook.txt"

config :nadia,
  token: System.get_env("TELEGRAM_TOKEN")

import_config "#{Mix.env}.exs"
