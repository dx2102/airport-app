
<script>
  // edit a table in supabase
  // a rough implementation based on just json
  import { supabase, unwrap, auth_uid } from "$lib/index.js";
  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";

  export let width = 40;
  export let table = [{default_key: "default_value"}];
  $: {
    console.log("EditTable.table", table);
  }

  function isDate(string) {
    // test whether the string is a valid date
    let date = new Date(string);
    return date instanceof Date 
      && !isNaN(date)
      && date.toISOString() === string
    ;
  }
</script>

<Button onClick={()=>{console.log("table", table)}}>try</Button>
{#each Object.entries(table) as [idx, row]}

<div class="flex flex-col gap-2"
style="grid-template-columns: {width/4}rem auto;"
>

  {#each Object.entries(row) as [label, value]}
    <InputBox 
      label={label} 
      bind:value={table[idx][label]}
      type={isDate(value) ? "datetime-local" : "text"}
      on:input
    />
  {/each}
  <div class="my-2"></div>
</div>
{/each}



































