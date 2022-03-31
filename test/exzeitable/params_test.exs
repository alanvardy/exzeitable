defmodule Exzeitable.ParamsTest do
  @moduledoc false
  use TestWeb.DataCase, async: true

  alias Exzeitable.Params

  test "set_fields/2 merges fields over the defaults" do
    opts = [
      fields: [
        first: [label: "something"]
      ]
    ]

    after_merge = [
      first: [
        function: false,
        hidden: false,
        search: true,
        order: true,
        formatter: {Exzeitable.HTML.Format, :format_field},
        label: "something"
      ]
    ]

    assert Params.set_fields(opts) == after_merge
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
        formatter: {Exzeitable.HTML.Format, :format_field},
        label: "something",
        virtual: true,
        function: true,
        search: false,
        order: false
      ]
    ]

    assert Params.set_fields(opts) == after_merge
  end
end
