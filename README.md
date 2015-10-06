# Leaderboard


*Leaderboard* is a quick Rails API you can set up to include a high-score leaderboard in your browser-based games.


![leaderboard]
[leaderboard]: /docs/leaderboard.png

## Instructions
### Gemfile
- Add `'rack-cors'` to your Gemfile and run `$ bundle install`

```
gem 'rack-cors' => 'rack/cors'
```

### Configure CORS
- [application.rb](https://github.com/mikeyshean/leaderboard/blob/master/config/application.rb#L23-L28)
- Provide any origins to be given access to your API
- You may also define the type of requests allowed
- For dev purposes you can use a wildcard to allow all origins `"*"`

```
config.middleware.insert_before 0, "Rack::Cors" do
  allow do
    origins '*', 'localhost:3000', 'your_domain_here'
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end
```


### Setup your API
#### Routes:
 [routes.rb](https://github.com/mikeyshean/leaderboard/blob/master/config/routes.rb#L1-L3)

```
Rails.application.routes.draw do
  resources :leaders, only: [:create, :index]
end
```
#### Controller:
 - [leaders_controller.rb](https://github.com/mikeyshean/leaderboard/blob/master/config/routes.rb#L1-L3)
 - Define your controller actions to create new entries and retrieve all leaders

```
class LeadersController < ActionController::Base

  def create
    leader = Leader.new(leader_params)

    if leader.name == "Enter your name" || leader.name.strip.empty?
      leader.name = "Anonymous"
    end

    leader.save
    @leaders = Leader.all.order(score: :desc).limit(10)

    render json: @leaders
  end

  def index
    @leaders = Leader.all.order(score: :desc).limit(10)

    render json: @leaders
  end

  private

  def leader_params
    params.permit(:name, :score)
  end
end
```



## AJAX Requests

- jQuery AJAX requests to the *GET* and *POST* API routes

```
  GameView.prototype.getLeaders = function () {
    $.ajax({
     type: "GET",
     url:"your_production_url",
     dataType: 'json',
     success:function(leaders){
         this.renderLeaderboard(leaders);
     }.bind(this)
   });
  };

  GameView.prototype.submitScore = function (name) {
    var data = {}
    data["name"] = name
    data["score"] = this.game.highestScore();

    $.ajax({
     type: "POST",
     data: data,
     url:"your_production_url",
     dataType: 'json',
     success:function(leaders){
         this.renderLeaderboard(leaders);
     }.bind(this)
   });
  };
```
