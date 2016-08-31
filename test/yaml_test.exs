defmodule YamlTest do
  use ExUnit.Case
  doctest Yaml

  test "basic string test" do
    expected = "--- \"teststring\"\n"
    returned = Yaml.encode("teststring")

    assert expected == returned
  end

  test "basic string with single quotes test" do
    expected = ~s(--- "foo 'bar'"\n)
    returned = Yaml.encode("foo 'bar'")

    assert expected == returned
  end

  test "basic string with double quotes test" do
    expected = ~s(--- 'foo "bar"'\n)
    returned = Yaml.encode(~s(foo "bar"))

    assert expected == returned
  end

  test "basic string with single and double quotes test" do
    expected = ~s(--- '''foo "bar" 'baz''''\n)
    returned = Yaml.encode(~s(foo "bar" 'baz'))

    assert expected == returned
  end

  test "basic number test" do
    expected = ~s(--- 1\n)
    returned = Yaml.encode(1)

    assert expected == returned
  end

  test "basic boolean test" do
    expected = ~s(--- true\n)
    returned = Yaml.encode(true)

    assert expected == returned

    expected = ~s(--- false\n)
    returned = Yaml.encode(false)

    assert expected == returned
  end

  test "basic atom test" do
    expected = ~s(--- "foo"\n)
    returned = Yaml.encode(:foo)

    assert expected == returned
  end

  test "basic tuple test" do
    expected = ~s(--- foo: "bar"\n)
    returned = Yaml.encode({:foo, :bar})

    assert expected == returned
  end

  test "basic sequence test" do
    expected = "---\n- \"foo\"\n- \"bar\"\n- \"baz\"\n"
    returned = Yaml.encode(["foo","bar","baz"])

    assert expected == returned
  end

  test "basic keyword test" do
    expected = "---\nfoo: \"bar\"\nbaz: \"blah\"\nasdf: \"fdsa\"\n"
    returned = Yaml.encode([foo: "bar", baz: "blah", asdf: "fdsa"])

    assert expected == returned
  end

  test "basic map test" do
    expected = "---\nfoo: \"bar\"\nbaz: \"blah\"\nasdf: \"fdsa\"\n"
    returned = Yaml.encode(%{foo: "bar", baz: "blah", asdf: "fdsa"})

    lines = String.split returned, "\n"

    for expected <- String.split(expected,"\n") do
      found = Enum.find lines, &(&1 == expected)
      assert found
    end
  end

  test "keyword of sequences" do
    expected = """
    ---
    foo:
      - "foo"
      - "bar"
    baz:
      - "asdf"
      - "fdsa"
    asdf:
      - "aaaa"
      - "bbbb"
    """
    returned = Yaml.encode([
      foo: ["foo", "bar"],
      baz: ["asdf", "fdsa"],
      asdf: ["aaaa", "bbbb"]
    ])

    assert expected == returned
  end

  test "map of sequences" do
    expected = """
    ---
    foo:
      - "foo"
      - "bar"
    baz:
      - "asdf"
      - "fdsa"
    asdf:
      - "aaaa"
      - "bbbb"
    """
    returned = Yaml.encode(%{
      foo: ["foo", "bar"],
      baz: ["asdf", "fdsa"],
      asdf: ["aaaa", "bbbb"]
    })

    lines = String.split returned, "\n"

    for expected <- String.split(expected,"\n") do
      found = Enum.find lines, &(&1 == expected)
      assert found
    end
  end

  test "keyword of empty sequences" do
    expected = """
    ---
    foo: []
    baz: []
    asdf: []
    """
    returned = Yaml.encode([
      foo: [],
      baz: [],
      asdf: []
    ])

    assert expected == returned
  end

  test "map of empty sequences" do
    expected = """
    ---
    foo: []
    baz: []
    asdf: []
    """
    returned = Yaml.encode(%{
      foo: [],
      baz: [],
      asdf: []
    })

    lines = String.split returned, "\n"

    for expected <- String.split(expected,"\n") do
      found = Enum.find lines, &(&1 == expected)
      assert found
    end
  end

  test "sequence of keywords" do
    expected = """
    ---
    -
      a: "b"
      b: "c"
    -
      d: 3
      e: "f"
    """
    returned = Yaml.encode([
      [a: "b", b: "c"],
      [d: 3, e: "f"]
    ])

    assert expected == returned
  end

  test "sequence of maps" do
    expected = """
    ---
    -
      a: "b"
      b: "c"
    -
      d: 3
      e: "f"
    """
    returned = Yaml.encode([
      [a: "b", b: "c"],
      [d: 3, e: "f"]
    ])

    lines = String.split returned, "\n"

    for expected <- String.split(expected,"\n") do
      found = Enum.find lines, &(&1 == expected)
      assert found
    end
  end

  test "sequence of sequences" do
    expected = """
    ---
    -
      - "a"
      - "b"
    -
      - "a"
      - "b"
    """
    returned = Yaml.encode([
      ["a","b"],
      ["a","b"]
    ])

    assert expected == returned
  end

  test "keyword of keyword" do
    expected = """
    ---
    foo:
      foo: "a"
      bar: "b"
    baz:
      asdf: "a"
      fdsa: "b"
    asdf:
      aaaa: "a"
      bbbb: "b"
    """

    returned = Yaml.encode([
      foo: [
        foo: "a",
        bar: "b"
      ],
      baz: [
        asdf: "a",
        fdsa: "b"
      ],
      asdf: [
        aaaa: "a",
        bbbb: "b"
      ]
    ])

    assert expected == returned
  end

  test "map of map" do
    expected = """
    ---
    foo:
      foo: "a"
      bar: "b"
    baz:
      asdf: "a"
      fdsa: "b"
    asdf:
      aaaa: "a"
      bbbb: "b"
    """

    returned = Yaml.encode(%{
      foo: %{
        foo: "a",
        bar: "b"
      },
      baz: %{
        asdf: "a",
        fdsa: "b"
      },
      asdf: %{
        aaaa: "a",
        bbbb: "b"
      }
    })

    lines = String.split returned, "\n"

    for expected <- String.split(expected,"\n") do
      found = Enum.find lines, &(&1 == expected)
      assert found
    end
  end

  test "very complex keyword" do
    expected = """
    ---
    foo:
      foo:
        - "test"
        -
          foo: 123
          bar: "asdf"
      baz:
        a: "b"
        b: "c"
        d:
          -
            - "a"
            -
              a: "b"
          - "asdf"
    baz:
      asdf: "a"
      fdsa: "b"
    asdf:
      aaaa: "a"
      bbbb: "b"
    """

    returned = Yaml.encode([
      foo: [
        foo: [
          "test",
          [
            foo: 123,
            bar: "asdf"
          ]
        ],
        baz: [
          a: "b",
          b: "c",
          d: [
            [
              "a",
              [
                a: "b"
              ]
            ],
            "asdf"
          ]
        ]
      ],
      baz: [
        asdf: "a",
        fdsa: "b"
      ],
      asdf: [
        aaaa: "a",
        bbbb: "b"
      ]
    ])

    assert expected == returned
  end

  test "very complex map" do
    expected = """
    ---
    foo:
      foo:
        - "test"
        -
          foo: 123
          bar: "asdf"
      baz:
        a: "b"
        b: "c"
        d:
          -
            - "a"
            -
              a: "b"
          - "asdf"
    baz:
      asdf: "a"
      fdsa: "b"
    asdf:
      aaaa: "a"
      bbbb: "b"
    """

    returned = Yaml.encode(%{
      foo: %{
        foo: [
          "test",
          %{
            foo: 123,
            bar: "asdf"
          }
        ],
        baz: %{
          a: "b",
          b: "c",
          d: [
            [
              "a",
              %{
                a: "b"
              }
            ],
            "asdf"
          ]
        }
      },
      baz: %{
        asdf: "a",
        fdsa: "b"
      },
      asdf: %{
        aaaa: "a",
        bbbb: "b"
      }
    })

    lines = String.split returned, "\n"

    for expected <- String.split(expected,"\n") do
      found = Enum.find lines, &(&1 == expected)
      assert found
    end
  end

end
