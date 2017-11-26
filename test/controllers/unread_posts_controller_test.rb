require 'test_helper'

class UnreadPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unread_post = unread_posts(:one)
  end

  test "should get index" do
    get unread_posts_url
    assert_response :success
  end

  test "should get new" do
    get new_unread_post_url
    assert_response :success
  end

  test "should create unread_post" do
    assert_difference('UnreadPost.count') do
      post unread_posts_url, params: { unread_post: { post_id: @unread_post.post_id, unread: @unread_post.unread, user_id: @unread_post.user_id } }
    end

    assert_redirected_to unread_post_url(UnreadPost.last)
  end

  test "should show unread_post" do
    get unread_post_url(@unread_post)
    assert_response :success
  end

  test "should get edit" do
    get edit_unread_post_url(@unread_post)
    assert_response :success
  end

  test "should update unread_post" do
    patch unread_post_url(@unread_post), params: { unread_post: { post_id: @unread_post.post_id, unread: @unread_post.unread, user_id: @unread_post.user_id } }
    assert_redirected_to unread_post_url(@unread_post)
  end

  test "should destroy unread_post" do
    assert_difference('UnreadPost.count', -1) do
      delete unread_post_url(@unread_post)
    end

    assert_redirected_to unread_posts_url
  end
end
