<script>
  import InputBox from "$lib/InputBox.svelte";

  export let table = [{ example: "value" }];
  export let editable = () => false; 
  export let width = 40;

  function isDate(string) {
    // test whether the string is a valid date
    let date = new Date(string);
    return date instanceof Date 
      && !isNaN(date)
      && date.toISOString() === string
    ;
  }

  $: {
    console.log("ViewTable.table", table);
  }
</script>

{#each table as row, idx}
<div class="
p-2 my-2 
rounded-md border-2 border-solid border-neutral-300 
grid grid-cols-2 gap-2
"
style="grid-template-columns: {width/4}rem auto;"
>
  {#each Object.entries(row) as [key, value]}
    <div class="mr-auto">{key}</div>
    <!-- value can be null, nested objects, or atomic-->
    {#if value === null}
      <div class="text-neutral-500">None</div>
    {:else if typeof value === "object"}
      <svelte:self table={[value]} width={width} />
    {:else if !editable(key)}
      <div>{value}</div>
    {:else}
      <InputBox 
      label={""} 
      bind:value={table[idx][key]}
      type={isDate(value) ? "datetime-local" : "text"}
      on:input
      />
    {/if}
  {/each}
</div>
{/each}
