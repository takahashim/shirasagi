# coding: utf-8
SS::Application.routes.draw do

  concern :deletion do
    get :delete, :on => :member
  end

  namespace "cms", path: ".:host" do
    get "/" => "main#index", as: :main
    get "preview/(*path)" => "preview#index", as: :preview
  end

  namespace "cms", path: ".:host/cms" do
    get "/" => "main#index"
    resource  :site, concerns: :deletion
    resources :roles, concerns: :deletion
    resources :users, concerns: :deletion
    resources :groups, concerns: :deletion
    resources :contents, path: "contents/(:mod)"
    resources :nodes, concerns: :deletion do
      get :routes, on: :collection
    end
    resources :parts, concerns: :deletion do
      get :routes, on: :collection
    end
    resources :pages, concerns: :deletion
    resources :layouts, concerns: :deletion
    get "/search_groups" => "search_groups#index"
    post "/search_groups" => "search_groups#search"
  end

  namespace "cms", path: ".cms" do
    match "link_check/check" => "link_check#check", via: [:post, :options], as: "link_check"
  end

  content "cms", name: "node", module: "cms/node" do
    get "/" => "main#index", as: :main
    resource :conf, concerns: :deletion
    resources :nodes, concerns: :deletion
    resources :pages, concerns: :deletion
    resources :parts, concerns: :deletion
    resources :layouts, concerns: :deletion
  end

  node "cms" do
    get "node/(index.:format)" => "public#index", cell: "nodes/node"
    get "page/(index.:format)" => "public#index", cell: "nodes/page"
    get "page/rss.xml"         => "public#rss", cell: "nodes/page", format: "xml"
  end

  part "cms" do
    get "free"  => "public#index", cell: "parts/free"
    get "node"  => "public#index", cell: "parts/node"
    get "page"  => "public#index", cell: "parts/page"
    get "tabs"  => "public#index", cell: "parts/tabs"
    get "crumb" => "public#index", cell: "parts/crumb"
  end

  page "cms" do
    get "page/:filename.:format" => "public#index", cell: "pages/page"
  end

  match "*public_path" => "cms/public#index", public_path: /[^\.].*/,
    via: [:get, :post, :put, :patch, :destroy], format: true
  match "*public_path" => "cms/public#index", public_path: /[^\.].*/,
    via: [:get, :post, :put, :patch, :destroy], format: false

  root "cms/public#index", defaults: { format: :html }

end
