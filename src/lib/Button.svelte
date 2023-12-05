


<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();

  export let type = 'button';
  export let disabled = false;
  export let onClick = null;
  export let _class = '';
  

  function handleClick() {
    if (onClick) {
      onClick();
    }
    dispatch('click');
  }
</script>



<!-- 渲染按钮 -->
<button 
  type={type} on:click={handleClick} {disabled}
  class="bg-slate-800 text-white p-2 rounded-md {_class}"
>
  <slot></slot>
</button>
