defmodule Flour.CommentTest do
  use Flour.ModelCase

  alias Flour.Comment

  @valid_attrs %{content: "some content", post_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
