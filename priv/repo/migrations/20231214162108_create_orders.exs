defmodule OrderManagement.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :email, :string
      add :price, :integer
      add :balance_due, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
