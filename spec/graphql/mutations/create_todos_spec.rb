require "rails_helper"

RSpec.describe Mutations::Todo::CreateTodoMutation, type: :request do
  let(:graphql_uri) { '/graphql' }

  it "lists all todos" do
    create_todo_mutation_string = <<-'GRAPHQL'
      mutation CreateTodo($input: CreateTodoMutationInput!) {
        createTodo(input: $input) {
          id
          body
        }
      }
    GRAPHQL

    post(
      graphql_uri,
      params: { query: create_todo_mutation_string, variables: { input: { body: "todo content" } } }
    )
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq 200
    # binding.pry
    # expect(parsed_body).to eq({ 'data' => { 'todos' => [ { 'body' => 'todo content' } ] } })
  end
end
