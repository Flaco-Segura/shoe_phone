defmodule ShoePhone.Conversations.Schema.NewMessage do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :to, :string
    field :body, :string
  end

  def changeset(attrs) do
    fields = [:to, :body]
    attrs = force_country_code(attrs)

    %__MODULE__{}
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_change(:to, &validate_phone_number/2)
  end

  # ...data functions below

  defp force_country_code(attrs) do
    case attrs do
      %{"to" => "+" <> _} -> attrs
      %{"to" => to} when to != "" -> Map.put(attrs, "to", "+1 " <> to)
      _ -> attrs
    end
  end

  defp validate_phone_number(_field, to) do
    with {:ok, phone_number} <- ExPhoneNumber.parse(to, ""),
         # Conditional logic is to allow invalid phone numbers to work for demo purposes.
         true <- ExPhoneNumber.is_valid_number?(phone_number) || String.starts_with?(to, "+11") do
      []
    else
      false -> [to: "is an invalid phone number"]
      {:error, err} -> [to: err]
    end
  end
end
