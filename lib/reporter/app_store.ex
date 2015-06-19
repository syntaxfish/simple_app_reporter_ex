defmodule Reporter.AppStore do
  alias Reporter.AppStore

  use HTTPoison.Base

  defstruct host: Application.get_env(:reporter, :app_host),
            app_id: Application.get_env(:reporter, :app_id)


  def parse_to_map(json) do
    Poison.Parser.parse!(json)
  end

  def author(json) do
    Poison.Parser.parse!(json)["feed"]["author"]
  end

  def entry(json) do
    Poison.Parser.parse!(json)["feed"]["entry"]
    |> Enum.at(0)
  end

  @doc ~S"""
  Returns collection of reviews.

  ## Examples

    iex> File.read!("./test/data/ios_review.json") |> Reporter.AppStore.reviews |> Enum.at(0)
    %{"author" => %{"label" => "", "name" => %{"label" => "m.aaa..."},
      "uri" => %{"label" => "https://itunes.apple.com/jp/reviews/id451145371"}},
      "content" => %{"attributes" => %{"type" => "text"},
      "label" => "利便性がわかりずらい"},
      "id" => %{"label" => "1205430410"},
      "im:contentType" => %{"attributes" => %{"label" => "アプリケーション",
      "term" => "Application"}}, "im:rating" => %{"label" => "4"},
      "im:version" => %{"label" => "3.3"}, "im:voteCount" => %{"label" => "0"},
      "im:voteSum" => %{"label" => "0"},
      "link" => %{"attributes" => %{"href" => "https://itunes.apple.com/jp/review?id=375380948&type=Purple%20Software",
      "rel" => "related"}}, "title" => %{"label" => "あまり"}}

  """
  def reviews(json) do
    Poison.Parser.parse!(json)["feed"]["entry"]
    |> Enum.drop(1)
  end

  def icon(json) do
    Poison.Parser.parse!(json)["feed"]["icon"]
  end

  def id(json) do
    Poison.Parser.parse!(json)["feed"]["id"]
  end

  def link(json) do
    Poison.Parser.parse!(json)["feed"]["link"]
  end

  def rights(json) do
    Poison.Parser.parse!(json)["feed"]["rights"]
  end

  def title(json) do
    Poison.Parser.parse!(json)["feed"]["title"]
  end

  def updated(json) do
    Poison.Parser.parse!(json)["feed"]["updated"]
  end


  @doc ~S"""
  Return URLs with JSON.

  ## Examples

    iex> Reporter.AppStore.rss_json("375380948")
    "https://itunes.apple.com/en/rss/customerreviews/id=375380948/sortby=mostrecent/json"

    iex> Reporter.AppStore.rss_json("375380948", "jp")
    "https://itunes.apple.com/jp/rss/customerreviews/id=375380948/sortby=mostrecent/json"
  """
  @spec rss_json(String.t, String.t) :: String.t
  def rss_json(app_id, locale \\ "en") do
    rss(app_id, locale, "json")
  end

  @doc ~S"""
  Return URLs with XML.

  ## Examples

    iex> Reporter.AppStore.rss_xml("375380948")
    "https://itunes.apple.com/en/rss/customerreviews/id=375380948/sortby=mostrecent/xml"

    iex> Reporter.AppStore.rss_xml("375380948", "jp")
    "https://itunes.apple.com/jp/rss/customerreviews/id=375380948/sortby=mostrecent/xml"
  """
  @spec rss_json(String.t, String.t) :: String.t
  def rss_xml(app_id, locale \\ "en") do
    rss(app_id, locale, "xml")
  end

  defp rss(app_id, locale, format) do
    Enum.join([
      %AppStore{}.host,
      "/",
      locale,
      "/rss/customerreviews/id=",
      app_id,
      "/sortby=mostrecent/",
      format
      ]
    )
  end
end
