module ApplicationHelper

  def title
    if @title.nil?
      "Bug Tracker"
    else
      "Bug Tracker - " + @title
    end
  end
end
