

<script>
  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";
  import Select from "$lib/Select.svelte";
  import ViewTable from "$lib/ViewTable.svelte";
  import { supabase, unwrap, rpc, print, auth_uid, role } from "$lib/index.js";
  import { onMount } from "svelte";

  let table = [{test : 1}]
  let newStatus = []
  onMount(search)
  async function search() {
    rpc("flights_of_my_airline")
    .then(data => { table = data })
  }

  function updateStatus(idx, row) {
//     create or replace function operator_edit_status(
//     airline_name varchar(128), 
//     flight_number varchar(128), 
//     new_status varchar(128)
// ) 
    console.log("updateStatus", idx, row);
    rpc("operator_edit_status", {
      airline_name: row.airline_name,
      flight_number: row.flight_number,
      new_status: newStatus[idx]
    })
    .then(data => {
      console.log("updateStatus", data);
      search();
    })
  }

</script>

<h2 class="text-3xl py-2">Operate flights</h2>

<div class="my-2"></div>

{#each table as row, idx}
  <ViewTable 
    table={[row]} width={40}
  />
  <InputBox label="New status" bind:value={newStatus[idx]} />
  <Button _class="my-2 w-full" on:click={e => updateStatus(idx, row)}>Update status</Button>
{/each}