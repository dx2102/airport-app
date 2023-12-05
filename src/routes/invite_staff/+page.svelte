<script>
  // invite booking agens and staffs
  // use encapsculated supabase rpc:
  // search_uid_by_email(email varchar(128)) returns uuid 
  // create or replace function invite_booking_agent(email varchar(128)) returns void as $$
  // create or replace function invite_airline_staff(email varchar(128), permission varchar(128)) returns void as $$

  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";
  import { rpc } from "$lib/index.js";

  let email = "";
  let uid = "";

  function search() {
    rpc("search_uid_by_email", { email })
    .then(data => uid = data)
  }

  function inviteBookingAgent() {
    rpc("invite_booking_agent", { email })
    .then(data => {
      console.log("inviteBookingAgent", data);
    })
  }

  function inviteAirlineStaff() {
    rpc("invite_airline_staff", { email, permission: "operator" })
    .then(data => {
      console.log("inviteAirlineStaff", data);
    })
  }

</script>

<InputBox label="Email" on:input={search} bind:value={email} />
<div>Found uid: {uid}</div>
<Button _class="my-2 w-full" on:click={inviteBookingAgent}>Invite booking agent</Button>
<Button _class="my-2 w-full" on:click={inviteAirlineStaff}>Invite airline staff</Button>














