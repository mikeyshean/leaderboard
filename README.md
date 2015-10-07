# Leaderboard


*Leaderboard* is a Rails API that allows you to incorporate a high-score leaderboard in your browser-based games.


![leaderboard]
[leaderboard]: /docs/leaderboard.png

## Quick Start

1.  Clone or [download](https://github.com/mikeyshean/leaderboard/archive/master.zip_) this repo
2.  Add the origin that you will be making requests **FROM** to the [application.rb](https://github.com/mikeyshean/leaderboard/blob/master/config/application.rb#L23-L28) configuration:
```
config.middleware.insert_before 0, "Rack::Cors" do
  allow do
    origins 'your_domain_here'
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end
```
3.  Deploy to [heroku](www.heroku.com) or hosting of your choice
4.  Insert new scores by providing a **name** and **score**:
```
    var data = {}
    data["name"] = name
    data["score"] = score

    $.ajax({
      type: "POST",
      data: data,
      url:"your_production_url",
      dataType: 'json',
      success:function(leaders){
        // do something with leaders here
      }.bind(this)
    });
```
5.  Fetch **Top 10** highest scores with names:
```
    $.ajax({
      type: "GET",
      url:"your_production_url",
      dataType: 'json',
      success:function(leaders){
        // do something with leaders here
      }.bind(this)
   });
```
#### *Note:*  
  - Names that do not include any characters will be converted to "Anonymous"
  - Both POST and GET requests will return the most current **TOP 10** leaders.


## Full Instructions



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


### Rails API Setup


#### Migration
[create_leaders.rb](https://github.com/mikeyshean/leaderboard/blob/master/db/migrate/20151006030315_create_leaders.rb#L1-L9)
```
class CreateLeaders < ActiveRecord::Migration
  def change
    create_table :leaders do |t|
      t.string :name
      t.integer :score
      t.timestamps null: false
    end
  end
end
```

#### Routes:
 [routes.rb](https://github.com/mikeyshean/leaderboard/blob/master/config/routes.rb#L1-L3)

```
Rails.application.routes.draw do
  resources :leaders, only: [:create, :index]
end
```
#### Controller:
 - [leaders_controller.rb](https://github.com/mikeyshean/leaderboard/blob/master/config/routes.rb#L1-L3)
 - Define your controller actions to create new entries and retrieve the **TOP 10** leaders

```
class LeadersController < ActionController::Base

  def create
    leader = Leader.new(leader_params)

    if leader.name == "Enter your name" || leader.name.strip.empty?
      leader.name = "Anonymous"
    end

    leader.save
    leaders = Leader.order(score: :desc).limit(10)

    render json: leaders
  end

  def index
    leaders = Leader.order(score: :desc).limit(10)

    render json: leaders
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
         // do something with leaders here
     }.bind(this)
   });
  };

  GameView.prototype.submitScore = function (name) {
    var data = {}
    data["name"] = name
    data["score"] = score

    $.ajax({
     type: "POST",
     data: data,
     url:"your_production_url",
     dataType: 'json',
     success:function(leaders){
         // do something with leaders here
     }.bind(this)
   });
  };
```
