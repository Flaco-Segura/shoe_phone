# Script for removing all seeded data from the database. You can run it as:
#
#     mix run priv/repo/delete_seeds.exs
#

import Ecto.Query

from(
  m in ShoePhone.Conversations.Schema.SmsMessage,
  where: m.account_sid == "seed"
)
|> ShoePhone.Repo.delete_all()
