

<script>
  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";
  import Select from "$lib/Select.svelte";
  import ViewTable from "$lib/ViewTable.svelte";
  import { supabase, unwrap, rpc, print, auth_uid, role } from "$lib/index.js";
  import { onMount } from "svelte";

  let table_idx = 0;
  $: table_name = ["flight", "airplane", "airport", "booking_agent"][table_idx]
  let table = [{test : 1}]
  onMount(search)
  async function search() {
    rpc(`${table_name}s_of_my_airline`)
    .then(data => table = data )
  }

  function upsert() {
    console.log("upsert");
    supabase
      .from(table_name)
      .upsert(table)
      .then(unwrap)
      .then((data) => {
        console.log("upsert", data);
      });
  }

</script>

<h2 class="text-3xl py-2">Edit airline data</h2>
<Select 
  bind:selected={table_idx} 
  choices={["flight", "airplane", "airport", "booking_agent"]}
  on:click={search}
/>

<div class="my-2"></div>

<Button _class="w-full" on:click={upsert}>Confirm</Button>
<ViewTable 
  table={table} width={40}
  editable={key => key !== "id"}
/>
