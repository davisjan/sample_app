class PagesController < ApplicationController
  # This code is called before rendering the view

  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

end
