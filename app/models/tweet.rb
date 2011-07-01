class Tweet
  
  attr_accessor :user, :time, :photo, :text
  
  def initialize(hash)
    @user = hash["user"]
    @time = hash["time"]
    @photo = hash["photo"]
    @text = hash["text"]
  end
  
  def user_page
    "http://twitter.com/#{@user}"
  end
  
end