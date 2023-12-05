
<script>
  // horizontal text choice boxes. Highlight the selected one.
  export let choices = [];
  export let selected = 0;
  export let width = 30;
</script>


<div class="flex flex-row rounded-lg bg-slate-100">
{#each choices as choice, i}
  {#if i!=0}
    <div class="w-px bg-slate-200"></div>
  {/if}
  <button 
    style="width: {100 / choices.length}%" 
    on:click={() => selected = i}
    on:click
    type="button"
    class="p-2 rounded-lg 
      hover:bg-slate-200 {i == selected ? "bg-slate-200" : ""}">
    {choice}
  </button>
{/each}
</div>













