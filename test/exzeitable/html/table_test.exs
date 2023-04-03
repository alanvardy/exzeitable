defmodule Exzeitable.HTML.TableTest do
  use TestWeb.ConnCase, async: true
  use ExUnitProperties

  alias Exzeitable.HTML.Table
  alias Exzeitable.Support.Generators

  describe "build/1" do
    property "always returns {:safe, iolist}", %{conn: conn} do
      check all(params <- Generators.params()) do
        assert {:safe, [_ | _]} = Table.build(%{params: params, socket: conn})
      end
    end
  end
end
