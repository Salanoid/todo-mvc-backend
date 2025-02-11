require "rails_helper"

RSpec.describe Mutations::Todo::DeleteTodoMutation, type: :request do
  fixtures :todos

  let(:graphql_uri) { '/graphql' }
  let(:delete_todo_mutation_string) do
    <<-'GRAPHQL'
      mutation DeleteTodo($input: DeleteTodoMutationInput!) {
        deleteTodo(input: $input) {
          body
        }
      }
    GRAPHQL
  end

  it "delete todo" do
    expect(Todo.count).to eq 1
    post(
      graphql_uri,
      params: { query: delete_todo_mutation_string, variables: { input: { id: Todo.first.id } } }
    )
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq 200
    expect(parsed_body).to eq({ "data" => { "deleteTodo" => { "body" => "primul todo" } } })
    expect(Todo.count).to eq 0
  end

  it "validate missing id" do
    post(
      graphql_uri,
      params: { query: delete_todo_mutation_string, variables: { input: { id: nil } } }
    )
    parsed_body = JSON.parse(response.body)

    expect(parsed_body).to eq({ "errors" =>  [ { "message" => "Variable $input of type DeleteTodoMutationInput! was provided invalid value for id (Expected value to not be null)",    "locations" => [ { "line" => 1, "column" => 27 } ],    "extensions" => { "value" => { "id" => nil }, "problems" => [ { "path" => [ "id" ], "explanation" => "Expected value to not be null" } ] } } ] })
  end


  it "validate wrong id" do
    post(
      graphql_uri,
      params: { query: delete_todo_mutation_string, variables: { input: { id: rand(Todo.first.id - 1).to_i } } }
    )
    parsed_body = JSON.parse(response.body)
    expect(parsed_body).to eq({ "errors" => [ { "message" => "Missing item", "locations" => [ { "line" => 2, "column" => 9 } ], "path" => [ "deleteTodo" ] } ], "data" => { "deleteTodo" => nil } })
  end
end
