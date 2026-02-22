# frozen_string_literal: true

FactoryBot.define do
  factory :request, class: 'Sofia::Request' do
    http_method { :get }
    base_url    { 'https://api.example.com' }
    path        { '/resource' }
    headers     { { 'Accept' => 'application/json' } }
    params      { { page: 1 } }
    body        { nil }

    trait :get do
      http_method { :get }
    end

    trait :post do
      http_method { :post }
      body        { { 'name' => 'Sofia' } }
      headers     { super().merge('Content-Type' => 'application/json') }
    end

    trait :put do
      http_method { :put }
      body        { { 'name' => 'Updated Sofia' } }
      headers     { super().merge('Content-Type' => 'application/json') }
    end

    trait :patch do
      http_method { :patch }
      body        { { 'name' => 'Patched Sofia' } }
      headers     { super().merge('Content-Type' => 'application/json') }
    end

    trait :delete do
      http_method { :delete }
    end

    initialize_with do
      req = new(
        http_method: http_method,
        base_url:    base_url,
      )
      req.path    = path
      req.headers = headers
      req.params  = params
      req.body    = body
      req
    end
  end
end
