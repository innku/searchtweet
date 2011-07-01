class Search < ActiveRecord::Base
  
  validates_presence_of :query
  
  def fetch_tweets(number=3)
    fetch_if_not_cached do 
      Twitter::Search.new.containing(query).no_retweets.per_page(number).collect do |tweet_hash|
        {:user => tweet_hash.from_user, 
         :time => tweet_hash.created_at, 
         :photo => tweet_hash.profile_image_url, 
         :text => tweet_hash.text}
      end
    end
  end
  
  def fetch_if_not_cached
    if tweets.nil?
      Rails.cache.write("search-#{self.id}", "pending")
      Rails.cache.write("search-#{self.id}", JSON.dump(yield) , :expires_in => 1.minute)
    end
  end
  
  def tweets
    @tweets ||= cached_tweets
  end
  
  def cached_tweets
    cached_value = Rails.cache.read("search-#{self.id}")
    if cached_value && cached_value.to_s != "pending"
      cached_value = JSON.parse(Rails.cache.read("search-#{self.id}")).collect do |atts|
        Tweet.new(atts)
      end
    end
    cached_value
  end
  
  def ready?
    !tweets.nil? && tweets != "pending"
  end
  
end
