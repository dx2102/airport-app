

<script>
  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";
  import ViewTable from "$lib/ViewTable.svelte";
  import { supabase, unwrap, print, auth_uid, role } from "$lib/index.js";
  import { onMount } from "svelte";

  let table
  onMount(async () => {
    table = unwrap(await supabase.rpc("view_commission"));
    console.log(table);
  });
</script>


<h2 class="text-3xl py-2">Top customers</h2>

<ViewTable table={table}></ViewTable>