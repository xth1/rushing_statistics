defmodule Nfl.Utils do
  def to_float(value) when is_integer(value), do: value / 1

  def to_float(value) when is_float(value), do: value

  def to_float(value) when is_binary(value) do
    {num, _} = Float.parse(value)
    num
  end

  def to_float(_), do: nil

  def to_string(value), do: "#{value}"
end
