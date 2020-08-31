defmodule Exzeitable.SearchParameters do
  @moduledoc "Rust NIF for processing search parameters. Find in /native/searchparameters"

  use Rustler, otp_app: :exzeitable, crate: "searchparameters"

  # When your NIF is loaded, it will override this function.
  def convert(_string), do: :erlang.nif_error(:nif_not_loaded)

  def benchmark do
    small_string_no_space = "~roger!federer$"
    small_string_space = "  ~roger!   federer$   "

    medium_string_no_space =
      "RogerFedererisaSwissprofessionaltennisplayerwhoisrankedworldNo.4inmen'ssinglestennisbytheAssociationofTennisProfessionals(ATP).[3]"

    medium_string_space =
      "  Roger Federer is a Swiss professional tennis player who is ranked world No. 4 in men's singles tennis by the Association of Tennis Professionals (ATP).[3]   "

    large_string_no_space =
      "RogerFedererisaSwissprofessionaltennisplayerwhoisrankedworldNo.4inmen'ssinglestennisbytheAssociationofTennisProfessionals(ATP).[3]Hehaswon20GrandSlamsinglestitles—themostinhistoryforamaleplayer—andhasheldtheworldNo.1spotintheATPrankingsforarecordtotalof310weeks(includingarecord237consecutiveweeks)andwastheyear-endNo.1fivetimes,includingfourconsecutive.Federer,whoturnedprofessionalin1998,wascontinuouslyrankedinthetop10fromOctober2002toNovember2016.FedererhaswonarecordeightWimbledonmen'ssinglestitles,sixAustralianOpentitles,fiveUSOpentitles(allconsecutive,arecord),andoneFrenchOpentitle.HeisoneofeightmentohaveachievedaCareerGrandSlam.Federerhasreachedarecord31men'ssinglesGrandSlamfinals,including10consecutivelyfromthe2005WimbledonChampionshipstothe2007USOpen.FedererhasalsowonarecordsixATPFinalstitles,28ATPTourMasters1000titles,andarecord24ATPTour500titles.FedererwasamemberofSwitzerland'swinningDavisCupteamin2014.HeisalsotheonlyplayerafterJimmyConnorstohavewon100ormorecareersinglestitles,aswellastoamass1,200winsintheOpenEra.Federer'sall-courtgameandversatilestyleofplayinvolveexceptionalfootworkandshot-making.[4]Effectivebothasabaselinerandavolleyer,hisapparenteffortlessnessandefficientmovementonthecourthavemadeFedererhighlypopularamongtennisfans.HehasreceivedthetourSportsmanshipAward13timesandbeennamedtheATPPlayeroftheYearandITFWorldChampionfivetimes.HehaswontheLaureusWorldSportsmanoftheYearawardarecordfivetimes,includingfourconsecutiveawardsfrom2005to2008.HeisalsotheonlypersontohavewontheBBCOverseasSportsPersonalityoftheYearawardfourtimes."

    large_string_space =
      "  Roger Federer is a Swiss professional tennis player who is ranked world No. 4 in men's singles tennis by the Association of Tennis Professionals (ATP).[3] He has won 20 Grand Slam singles titles—the most in history for a male player—and has held the world No. 1 spot in the ATP rankings for a record total of 310 weeks (including a record 237 consecutive weeks) and was the year-end No. 1 five times, including four consecutive. Federer, who turned professional in 1998, was continuously ranked in the top 10 from October 2002 to November 2016. Federer has won a record eight Wimbledon men's singles titles, six Australian Open titles, five US Open titles (all consecutive, a record), and one French Open title. He is one of eight men to have achieved a Career Grand Slam. Federer has reached a record 31 men's singles Grand Slam finals, including 10 consecutively from the 2005 Wimbledon Championships to the 2007 US Open. Federer has also won a record six ATP Finals titles, 28 ATP Tour Masters 1000 titles, and a record 24 ATP Tour 500 titles. Federer was a member of Switzerland's winning Davis Cup team in 2014. He is also the only player after Jimmy Connors to have won 100 or more career singles titles, as well as to amass 1,200 wins in the Open Era. Federer's all-court game and versatile style of play involve exceptional footwork and shot-making.[4] Effective both as a baseliner and a volleyer, his apparent effortlessness and efficient movement on the court have made Federer highly popular among tennis fans. He has received the tour Sportsmanship Award 13 times and been named the ATP Player of the Year and ITF World Champion five times. He has won the Laureus World Sportsman of the Year award a record five times, including four consecutive awards from 2005 to 2008. He is also the only person to have won the BBC Overseas Sports Personality of the Year award four times.   "

    regex = fn terms ->
      terms
      |> String.trim()
      |> String.replace(~r/[^\w\s]/u, "")
      |> String.replace(~r/\s+/u, ":* & ")
      |> Kernel.<>(":*")
    end

    enum = fn terms ->
      terms
      |> String.split()
      |> Enum.map(fn term ->
        String.replace(term, ~r/\W|_/u, "") <> ":*"
      end)
      |> Enum.join(" & ")
    end

    rust_nif = fn terms -> convert(terms) end

    Benchee.run(%{
      "regex_small_no_space" => fn -> regex.(small_string_no_space) end,
      "enum_small_no_space" => fn -> enum.(small_string_no_space) end,
      "rust_nif_small_no_space" => fn -> rust_nif.(small_string_no_space) end,
      "regex_small_space" => fn -> regex.(small_string_space) end,
      "enum_small_space" => fn -> enum.(small_string_space) end,
      "rust_nif_small_space" => fn -> rust_nif.(small_string_space) end,
      "regex_medium_no_space" => fn -> regex.(medium_string_no_space) end,
      "enum_medium_no_space" => fn -> enum.(medium_string_no_space) end,
      "rust_nif_medium_no_space" => fn -> rust_nif.(medium_string_no_space) end,
      "regex_medium_space" => fn -> regex.(medium_string_space) end,
      "enum_medium_space" => fn -> enum.(medium_string_space) end,
      "rust_nif_medium_space" => fn -> rust_nif.(medium_string_space) end,
      "regex_large_no_space" => fn -> regex.(large_string_no_space) end,
      "enum_large_no_space" => fn -> enum.(large_string_no_space) end,
      "rust_nif_large_no_space" => fn -> rust_nif.(large_string_no_space) end,
      "regex_large_space" => fn -> regex.(large_string_space) end,
      "enum_large_space" => fn -> enum.(large_string_space) end,
      "rust_nif_large_space" => fn -> rust_nif.(large_string_space) end
    })
  end
end
