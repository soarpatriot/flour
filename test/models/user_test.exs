defmodule Flour.UserTest do
  use Flour.ModelCase

  alias Flour.User

  @valid_attrs %{country: "some content", headimgurl: "some content", nickname: "some content", openid: "some content", province: "some content", sex: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
