

<script>
  import { onMount } from "svelte";
  import { print, clear, supabase, role, unwrap, auth_uid } from "$lib/index.js";
  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";
  import Select from "$lib/Select.svelte";
  
  console.log($role);
  let roles = ["customer", "booking_agent", "airline_staff"];
  let val = 0;
  let role_idx = val;
  $: $role = roles[role_idx];
  console.log(role_idx, $role);

  let is_signup = 0;
  let email = '';
  let password = '';
  let confirm_password = '';
  let hint_text = '';

  function alert_if(error) {
    if (error) {
      alert(error.message);
    }
  }

  async function login() {
    hint_text = "logging in..."
    let { user, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    hint_text = "";
    alert_if(error);
    alert("You have logged in successfully");

    window.auth_uid = auth_uid;
    const data = unwrap(await supabase.from($role).upsert({
      id: await auth_uid(),
    }));
    console.log(data);
  }

  async function signup() {
    if (password != confirm_password) {
      alert("Passwords don't match");
      return;
    }
    hint_text = "signing up..."
    const { user, error } = await supabase.auth.signUp({
      email,
      password,
    });
    hint_text = "";
    alert_if(error);
    alert("Please check your email for confirmation");

  }


</script>


<h2 class="text-3xl p-2">Welcome!</h2>

<form 
  on:submit|preventDefault
  class="flex flex-col gap-2 text-lg"
>
  <Select 
    choices={["Login", "Signup"]} 
    bind:selected={is_signup} />

    <Select 
      choices={["Client", "Booking agent", "Airline Staff"]} 
      bind:selected={role_idx} />

  <InputBox label="Email" bind:value={email} />
  <InputBox label="Password" type="password" bind:value={password} />
  {#if is_signup}
    <InputBox label="Confirm password" type="password" bind:value={confirm_password} />
  {/if}
  
  <Button onClick={is_signup ? signup : login} >
    {is_signup ? "Sign up" : "Login"}
  </Button>

  <p>{hint_text}</p>

</form>
