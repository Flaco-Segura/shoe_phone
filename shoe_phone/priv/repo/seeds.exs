# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

defmodule SeedHelpers do
  def number_pool do
    for _ <- 1..20, do: invalid_fake_number()
  end

  def invalid_fake_number do
    [
      "+1",
      1,
      Enum.random(0..9),
      Enum.random(0..9),
      1,
      Enum.random(0..9),
      Enum.random(0..9),
      Enum.random(0..9),
      Enum.random(0..9),
      Enum.random(0..9),
      Enum.random(0..9)
    ]
    |> Enum.join("")
  end
end

your_number = "+12223334444"
number_pool = SeedHelpers.number_pool()

for _ <- 1..500 do
  other_party = Enum.random(number_pool)
  direction = Enum.random([:incoming, :outgoing])

  {from, to} =
    case direction do
      :incoming -> {other_party, your_number}
      :outgoing -> {your_number, other_party}
    end

  params = %{
    message_sid: "seed-" <> Ecto.UUID.generate(),
    account_sid: "seed",
    body: Faker.Lorem.paragraph(1..3),
    from: from,
    to: to,
    status: "seeded",
    direction: direction
  }

  {:ok, _} = ShoePhone.Conversations.create_sms_message(params)
end
