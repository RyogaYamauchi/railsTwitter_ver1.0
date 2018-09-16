Rails.application.routes.draw do
  get "/" => "calendar#callback"
  get "/callbacked" => "calendar#callbacked"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
