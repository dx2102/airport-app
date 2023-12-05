

<!-- simple input box example in svelte -->

<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
  
  export let value = '';
  export let placeholder = 'Enter text...';
  export let type = 'text';

  export let label = 'Label';
  export let _for = '';
  export let width = 40;

  function handleChange(event) {
    value = event.target.value;
  }

  const css = `
    border-2 border-solid border-neutral-300 rounded-md
    p-2 w-72 grow
    focus:outline-none focus:border-neutral-500
  `;
</script>


<label for={_for} class="flex">
  <div style="width: {width/4}rem" class="my-auto">{label}</div>

  {#if type === 'text'}
  <input type="text" class={css} bind:value on:input placeholder={placeholder} />
  {:else if type === 'date'}
  <input type="date" class={css} bind:value on:input placeholder={placeholder} />
  {:else if type === 'datetime-local'}
  <input type="datetime-local" class={css} bind:value on:input placeholder={placeholder} />
  {:else if type === 'password'}
  <input type="password" class={css} bind:value on:input placeholder={placeholder} />
  {:else}
  <input type="text" class={css} bind:value on:input placeholder={placeholder} />
  {/if}
</label>