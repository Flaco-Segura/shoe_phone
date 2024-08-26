defmodule ShoePhone.Conversations.Query.SmsMessageStore do
  import Ecto.Query

  alias ShoePhone.Repo
  alias ShoePhone.Conversations.Schema.SmsMessage
  alias ShoePhone.Conversations.Query.ContactStore

  def create_sms_message(params) do
    {:ok, contact} = ContactStore.upsert_contact(params)

    params
    |> Map.merge(%{contact_id: contact.id})
    |> SmsMessage.changeset()
    |> Repo.insert()
  end

  def update_sms_message(message_sid, update_params) do
    case Repo.get_by(SmsMessage, message_sid: message_sid) do
      nil ->
        {:error, :not_found}

      existing ->
        update_params
        |> SmsMessage.update_changeset(existing)
        |> Repo.update()
    end
  end

  def load_messages_with(contact) do
    from(
      m in SmsMessage,
      where: m.contact_id == ^contact.id,
      order_by: [desc: m.inserted_at],
      preload: [:contact]
    )
    |> Repo.all()
  end

  def example_load_messages_with_join(contact) do
    from(
      m in SmsMessage,
      join: c in assoc(m, :contact),
      where: m.contact == ^contact.id,
      order_by: [desc: m.inserted_at],
      preload: [contact: c]
    )
    |> Repo.all()
  end

  def load_messages_list do
    distinct_query =
      from(
        m in SmsMessage,
        select: m.id,
        distinct: [m.contact_id],
        order_by: [desc: m.inserted_at]
      )

    from(
      m in SmsMessage,
      where: m.id in subquery(distinct_query),
      order_by: [desc: m.inserted_at],
      preload: [:contact]
    )
    |> Repo.all()
  end
end
