

<script>
  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";
  import EditTable from "$lib/EditTable.svelte";
  import ViewTable from "$lib/ViewTable.svelte";
  import { supabase, unwrap, print, auth_uid, role, rpc } from "$lib/index.js";
  import { onMount } from "svelte";

  let top_booking_agents = []
  let top_customers = []
  let top_destination_airports = []

  let direct_revenue = 0
  let agent_revenue = 0

  onMount(select)

  function select() {
    rpc("top_booking_agents")
    .then(data => top_booking_agents = data )

    rpc("top_customers")
    .then(data => top_customers = data )

    rpc("top_destination_airports")
    .then(data => top_destination_airports = data )

    rpc("direct_revenue")
    .then(data => direct_revenue = data )

    rpc("agent_revenue")
    .then(data => agent_revenue = data )


  }

</script>

<h2 class="text-3xl py-2">Direct revenue: {direct_revenue}</h2>
<h2 class="text-3xl py-2">Agent revenue: {agent_revenue}</h2>

<h2 class="text-3xl py-2">Top booking agents</h2>
<ViewTable table={top_booking_agents} />

<h2 class="text-3xl py-2">Top customers</h2>
<ViewTable table={top_customers} />

<h2 class="text-3xl py-2">Top destination airports</h2>
<ViewTable table={top_destination_airports} />

