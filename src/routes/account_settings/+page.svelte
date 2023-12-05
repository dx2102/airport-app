
<script>
  // account_settings.svelte
  import InputBox from "$lib/InputBox.svelte";
  import EditTable from "$lib/EditTable.svelte";
  import Button from "$lib/Button.svelte";
  import Select from "$lib/Select.svelte";
  import { supabase, role } from "$lib/index.js";

  let role_idx = 0;
  $: $role = ["customer", "booking_agent", "airline_staff"][role_idx];

  let customer_fields = `address 
    building_number 
    street 
    city 
    state 
    phone_number 
    passport_number 
    passport_expiration 
    passport_country
    date_of_birth 
  `.trim().split(/\s+/);
  let booking_agent_fields = ["booking_agent_id"];
  let airline_staff_fields = ["first_name", "last_name", "date_of_birth"];

  let fields = [customer_fields, booking_agent_fields, airline_staff_fields];
  let values = [];

  async function signOut() {
    const { error } = await supabase.auth.signOut();
    if (error) alert(error.message);
    alert("You have signed out successfully");
  }

  async function change_info() {

  }

</script>


<form 
  on:submit|preventDefault={change_info}
  class="flex flex-col gap-2 text-lg"
>

  <Button _class="my-2" onClick={signOut}><b>Sign out</b></Button>

  <h2 class="text-3xl p-2">Change user mode</h2>

  <Select 
  choices={["Client", "Booking agent", "Airline Staff"]} 
  bind:selected={role_idx} />

  <!-- <h2 class="text-3xl p-2">Account settings</h2> -->

  <!-- <EditTable 
  table_name={$role}
  ></EditTable> -->
<!-- 
  {#each fields[role_idx] as field, i}
    <InputBox 
      label={field} 
      bind:value={values[i]} 
      type={field.includes("password") ? "password" : "text"} />
  {/each}

  <Button on:click={change_info}>Confirm</Button> -->


</form>


















