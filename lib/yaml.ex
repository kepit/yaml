defmodule Yaml do

  def encode(term) when is_map(term), do: encode(Map.to_list(term))

  def encode([_|_] = term) do
    "---\n" <> encode_data(term,0)
  end

  def encode(term) do
    "--- " <> encode_data(term,0)
  end

  defp encode_data(scalar, level) when is_map(scalar) do
    encode_data(Map.to_list(scalar),level)
  end

  defp encode_data({key,val},level) do
    indent = indent(level)
    val = if is_map(val), do: Map.to_list(val), else: val
    case val do
      [_|_] ->
        encodedVal = encode_data(val,level+1)
        "#{indent}#{key}:\n#{encodedVal}"
      [] ->
        "#{indent}#{key}: []\n"
      _ ->
        encodedVal = encode_data(val,level)
        "#{indent}#{key}: #{encodedVal}"
    end
  end

  defp encode_data([first|remainder],level) do
    encodedSequence = encode_data(remainder,level)
    indent = indent(level)
    first = if is_map(first), do: Map.to_list(first), else: first
    case first do
      {_,_} ->
        encodedFirst = encode_data(first,level)
        "#{encodedFirst}#{encodedSequence}"
      [{_,_}|_] ->
        encodedFirst = encode_data(first,level+1)
        "#{indent}-\n#{encodedFirst}#{encodedSequence}"
      [_|_] ->
        encodedFirst = encode_data(first,level+1)
        "#{indent}-\n#{encodedFirst}#{encodedSequence}"
      _ ->
        encodedFirst = encode_data(first,level+1)
        "#{indent}- #{encodedFirst}#{encodedSequence}"
    end
  end

  defp encode_data([],_), do: ""

  defp encode_data(scalar,_) when is_binary(scalar) do
    single_quotes = (scalar =~ ~r/'/)
    double_quotes = (scalar =~ ~r/"/)
    case {single_quotes, double_quotes} do
      {true, true} -> ~s('''#{scalar}''')
      {false, true} -> ~s('#{scalar}')
      _ -> ~s("#{scalar}")
    end <> "\n"
  end

  defp encode_data(scalar,_) when is_integer(scalar) do
    "#{scalar}\n"
  end

  defp encode_data(scalar,_) when is_boolean(scalar) do
    "#{scalar}\n"
  end

  defp encode_data(scalar,_) when is_atom(scalar) do
    ~s("#{scalar}"\n)
  end

  defp indent(n), do: String.duplicate("  ", n)

  def decode(string, options \\ []) do
    YamlElixir.read_from_string(string, options)
  end

  def decode_file(path, options \\ []) do
    YamlElixir.read_from_file(path, options)
  end

  def decode_all(string, options \\ []) do
    YamlElixir.read_all_from_string(string, options)
  end

  def decode_file_all(path, options \\ []) do
    YamlElixir.read_all_from_file(path, options)
  end
end