require "rails_helper"

RSpec.describe Mutations::Todo::CreateTodoMutation, type: :request do
  let(:graphql_uri) { '/graphql' }
  let(:create_todo_mutation_string) do
    <<-'GRAPHQL'
      mutation CreateTodo($input: CreateTodoMutationInput!) {
        createTodo(input: $input) {
          body
          active
        }
      }
    GRAPHQL
  end

  it "create todo" do
    post(
      graphql_uri,
      params: { query: create_todo_mutation_string, variables: { input: { body: "todo content" } } }
    )
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq 200
    expect(parsed_body).to eq({ 'data' => { 'createTodo' => { 'active' => true, 'body' => 'todo content' } } })
  end

  it "validate empty body" do
    create_todo_mutation_string = <<-'GRAPHQL'
      mutation CreateTodo($input: CreateTodoMutationInput!) {
        createTodo(input: $input) {
          body
        }
      }
    GRAPHQL

    post(
      graphql_uri,
      params: { query: create_todo_mutation_string, variables: { input: { body: "" } } }
    )
    parsed_body = JSON.parse(response.body)

    expect(parsed_body).to eq({ "data" => { "createTodo" => nil }, "errors" => [ { "locations" => [ { "column" => 9, "line" => 2 } ], "message" => "Body can't be blank", "path" => [ "createTodo" ] } ] })
  end

  it "validate random invalid value" do
    post(
      graphql_uri,
      params: { query: create_todo_mutation_string, variables: { input: { random: "" } } }
    )
    parsed_body = JSON.parse(response.body)
    expect(parsed_body).to eq({ "errors" => [ { "extensions" => { "problems" => [ { "explanation" => "Field is not defined on CreateTodoMutationInput", "path" => [ "random" ] }, { "explanation" => "Expected value to not be null", "path" => [ "body" ] } ], "value" => { "random" => "" } }, "locations" => [ { "column" => 27, "line" => 1 } ], "message" => "Variable $input of type CreateTodoMutationInput! was provided invalid value for random (Field is not defined on CreateTodoMutationInput), body (Expected value to not be null)" } ] })
  end
end
