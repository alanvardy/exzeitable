defmodule Exzeitable.ParametersTest do
  @moduledoc false
  use TestWeb.DataCase, async: true

  alias Exzeitable.Parameters

  test "set_fields/2 merges fields over the defaults" do
    opts = [
      fields: [
        first: [label: "something"]
      ]
    ]

    after_merge = [
      first: [function: false, hidden: false, search: true, order: true, label: "something"]
    ]

    assert Parameters.set_fields(opts) == after_merge
  end

  test "set_fields/2 overwrites other options when virtual: true is set" do
    opts = [
      fields: [
        first: [label: "something", virtual: true]
      ]
    ]

    after_merge = [
      first: [
        hidden: false,
        label: "something",
        virtual: true,
        function: true,
        search: false,
        order: false
      ]
    ]

    assert Parameters.set_fields(opts) == after_merge
  end
end
