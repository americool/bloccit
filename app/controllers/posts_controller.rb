class PostsController < ApplicationController
  def index
    @posts = Post.all

    @posts.each_with_index do  |x, y|
      #if (y+1) % 5 == 0 || y == 0 -- I misunderstood the directions and
      #was kinda proud of the ever slightly more complex solution
      #so I'm leaving it there
      if y % 5 == 0
        x.title = "SPAM"
      end
    end

  end

  def show
  end

  def new
  end

  def edit
  end
end
