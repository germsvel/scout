defmodule ScoutWeb.AlphaLive do
  use ScoutWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-semibold">Alpha testing ground for PhoenixTest</h1>

    <div class="py-8 space-y-4">
      <.form for={@form} phx-submit="save" phx-change="validate">
        <label>Avatar <.live_file_input upload={@uploads.avatar} /></label>

        <.input type="text" label="Greeting" name="greeting" field={@form[:greeting]} />

        <%= for entry <- @uploads.avatar.entries do %>
          <article class="upload-entry">
            <figure>
              <.live_img_preview entry={entry} />
              <figcaption><%= entry.client_name %></figcaption>
            </figure>
          </article>
        <% end %>
      </.form>

      <div id="result">
        <h2 class="text-2xl">Results</h2>
        <%= for upload <- @uploaded_files do %>
          <div data-role="upload"><%= upload %></div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_, _, socket) do
    data = %{"greeting" => ""}

    {:ok,
     socket
     |> assign(:form, to_form(data))
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        dest = Path.join(Application.app_dir(:scout, "priv/static/uploads"), Path.basename(path))
        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        File.cp!(path, dest)
        {:ok, "/uploads/#{Path.basename(dest)}"}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end
end
