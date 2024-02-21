# Scout

A sample repo showcasing [PhoenixTest] tests.

## How code was created

The code in the project was created with Phoenix generators.

The `users` resources use regular (non-liveview) pages and controllers. The code
[was generated][a3f2ced] with:

```elixir
mix phx.gen.html Accounts User users name:string age:integer active_at:datetime
```

The `posts` resources use LiveView. The code [was generated][34b3461] with:

```elixir
mix phx.gen.live Timeline Post posts body:string draft:boolean published_date:date
```

## Generated tests and PhoenixTest tests

We created counterpart tests to showcase how equivalent tests would look with
PhoenixTest.

The comparison isn't 1-1 since controller tests cannot test interactivity but
PhoenixTests can. That's just one of the things that makes PhoenixTest so great!

| Generated | PhoenixTest counterpart |
| --- | --- |
| [UserControllerTest] | [AccountManagementTest] |
| [PostLiveTest] | [TimelinePostsTest] |

## Running the tests

You can run all the tests with `mix test`

[PhoenixTest]: https://hexdocs.pm/phoenix_test/readme.html
[a3f2ced]: https://github.com/germsvel/scout/commit/a3f2ced
[34b3461]: https://github.com/germsvel/scout/commit/34b3461
[UserControllerTest]: https://github.com/germsvel/scout/blob/main/test/scout_web/controllers/user_controller_test.exs
[TimelinePostsTest]: https://github.com/germsvel/scout/blob/main/test/scout_web/features/timeline_posts_test.exs
[PostLiveTest]: https://github.com/germsvel/scout/blob/main/test/scout_web/live/post_live_test.exs
[AccountManagementTest]: https://github.com/germsvel/scout/blob/main/test/scout_web/features/account_management_test.exs
