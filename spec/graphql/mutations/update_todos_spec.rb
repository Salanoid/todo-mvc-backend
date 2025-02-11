require "rails_helper"

RSpec.describe Mutations::Todo::UpdateTodoMutation, type: :request do
  fixtures :todos

  let(:graphql_uri) { '/graphql' }
  let(:update_todo_mutation_string) do
    <<-'GRAPHQL'
      mutation UpdateTodo($input: UpdateTodoMutationInput!) {
        updateTodo(input: $input) {
          body
        }
      }
    GRAPHQL
  end
  let(:mark_todo_mutation_active) do
    <<-'GRAPHQL'
      mutation UpdateTodo($input: UpdateTodoMutationInput!) {
        updateTodo(input: $input) {
          active
        }
      }
    GRAPHQL
  end

  it "update todo" do
    post(
      graphql_uri,
      params: { query: update_todo_mutation_string, variables: { input: { id: Todo.first.id, body: "updated todo content" } } }
    )
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq 200
    expect(parsed_body).to eq({ "data" => { "updateTodo" => { "body" => "updated todo content" } } })
  end

  it "validate empty body" do
    post(
      graphql_uri,
      params: { query: update_todo_mutation_string, variables: { input: { id: Todo.first.id, body: "" } } }
    )
    parsed_body = JSON.parse(response.body)

    expect(parsed_body).to eq({ "errors" => [ { "message" => "Body can't be blank", "locations" => [ { "line" => 2, "column" => 9 } ], "path" => [ "updateTodo" ] } ], "data" => { "updateTodo" => nil } })
  end

  it "validate missing id" do
    post(
      graphql_uri,
      params: { query: update_todo_mutation_string, variables: { input: { id: nil, body: "" } } }
    )
    parsed_body = JSON.parse(response.body)

    expect(parsed_body).to eq({ "errors" =>  [ { "message" => "Variable $input of type UpdateTodoMutationInput! was provided invalid value for id (Expected value to not be null)",    "locations" => [ { "line" => 1, "column" => 27 } ],    "extensions" => { "value" => { "id" => nil, "body" => "" }, "problems" => [ { "path" => [ "id" ], "explanation" => "Expected value to not be null" } ] } } ] })
  end


  it "validate wrong id" do
    post(
      graphql_uri,
      params: { query: update_todo_mutation_string, variables: { input: { id: rand(Todo.first.id - 1).to_i, body: "" } } }
    )
    parsed_body = JSON.parse(response.body)
    expect(parsed_body).to eq({ "errors" => [ { "message" => "Missing item", "locations" => [ { "line" => 2, "column" => 9 } ], "path" => [ "updateTodo" ] } ], "data" => { "updateTodo" => nil } })
  end


  it "mark as completed" do
    post(
      graphql_uri,
      params: { query: mark_todo_mutation_active, variables: { input: { id: Todo.first.id, active: false } } },
      as: :json
    )
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq 200
    expect(parsed_body).to eq({ "data" => { "updateTodo" => { "active" => false } } })
  end
end
