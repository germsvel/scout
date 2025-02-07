defmodule ScoutWeb.CounterLive do
  use ScoutWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="space-y-20">
      <div class="max-w-xs mx-auto flex justify-center space-x-10 border-2 p-8">
        <.button id="decrement" phx-click="decrease" class="bg-red-500 hover:bg-red-700" type="button">
          <.icon name="hero-minus" />
        </.button>

        <div id="count" class="font-extrabold text-3xl">{@count}</div>

        <.button
          id="increment"
          phx-click="increase"
          class="bg-blue-500 hover:bg-blue-700"
          type="button"
        >
          <.icon name="hero-plus" />
        </.button>
      </div>
    </div>
    """
  end

  def mount(_, _, socket) do
    {:ok, socket |> assign(:count, 0)}
  end

  def handle_event("increase", _, socket) do
    {:noreply, update(socket, :count, fn count -> count + 1 end)}
  end

  def handle_event("decrease", _, socket) do
    {:noreply, update(socket, :count, fn count -> count - 1 end)}
  end
end
