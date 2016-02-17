module UsersHelper

  def show_posts?(user)
    if user.posts.count >=1
      return true
    else
      return false
    end
  end

  def show_comments?(user)
    if user.comments.count >=1
      return true
    else
      return false
    end
  end

end
