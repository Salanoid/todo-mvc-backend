require "rails_helper"

RSpec.describe Resolvers::TodoResolver, type: :request do
  fixtures :todos

  let(:graphql_uri) { '/graphql' }
  it "lists all todos" do
    all_todos_query_string = <<-'GRAPHQL'
      query {
      todos {
        body
      }
    }
    GRAPHQL

    post(graphql_uri, params: { query: all_todos_query_string })
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq 200
    expect(parsed_body).to eq({ 'data' => { 'todos' => [ { 'body' => 'primul todo' } ] } })
  end
end
