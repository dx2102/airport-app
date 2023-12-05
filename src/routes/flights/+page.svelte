<script>
  import { onMount } from "svelte";
  import { print, clear, supabase, unwrap, user, role } from "$lib/index.js";
  // lib/inputBox:
  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";
  import ViewTable from "$lib/ViewTable.svelte";

  let purchase_for_email = "";
  let purchase_for_uid = "";
  async function search_uid() {
    if (!purchase_for_email) {
      purchase_for_uid = "";
      return;
    }
    let data = unwrap(await supabase.rpc("search_uid_by_email", {
      email: purchase_for_email,
    }));
    if (!data) {
      purchase_for_uid = "";
    } else {
      purchase_for_uid = data;
    }
  };

  let departure_airport = "";
  let arrival_airport = "";
  let departure_city = "";
  let arrival_city = "";
  let date = "";

  //let result_date = '2021-01-01 00:00:00';
  let results = [];

  async function search() {
    clear();

    print(departure_city);
    // we also manually count seats ordered
    let query = supabase.from("flight").select(`
      *,
      airline_name, 
      price, curr_status,

      airplane!inner(seats), 
      seats_ordered(*),
      ticket(count),

      departure_airport!inner(name, city), 
      arrival_airport!inner(name, city),
      departure_time, arrival_time

    `);
    query = query.ilike("departure_airport.city", `%${departure_city}%`);
    query = query.ilike("arrival_airport.city", `%${arrival_city}%`);
    query = query.ilike("departure_airport.name", `%${departure_airport}%`);
    query = query.ilike("arrival_airport.name", `%${arrival_airport}%`);
    if (date) query = query.eq("departure_time", date);
    query = query.order("departure_time", { ascending: true })

    let data = unwrap(await query);
    results = data;
  }
  search();

  async function purchase(flight) {
    let uid = (await user()).id;
    let customer_id = null;
    let agent_id = null;
    if ($role == 'booking_agent') {
      if (!purchase_for_uid) {
        alert("Please specify users you want to purchase for by");
        return;
      }
      customer_id = purchase_for_uid;
      agent_id = uid;
    } else if ($role == 'customer') {
      customer_id = uid;
      agent_id = null;
    }
    unwrap(await(supabase.rpc("purchase_ticket", {
      _airline_name: flight.airline_name,
      _flight_number: flight.flight_number,
      customer_id, 
      agent_id,
    })));
    alert("Purchase success!");
    await search();
  }

</script>


<h2 class="text-3xl py-2">Find flights</h2>

<form on:submit|preventDefault={search} class="mt-2 mb-4 flex flex-col gap-2 text-lg">
  {#if $role == 'booking_agent'}
    <InputBox label="Pruchase for" on:input={search_uid} bind:value={purchase_for_email}></InputBox>
    <div class="my-2">Found user: {purchase_for_uid}</div>
  {/if}
  <InputBox label="Departure Airport" width="40" bind:value={departure_airport} />
  <InputBox label="Arrival Airport" width="40" bind:value={arrival_airport} />
  <InputBox label="Departure City" width="40" bind:value={departure_city} />
  <InputBox label="Arrival City" width="40" bind:value={arrival_city} />
  <InputBox label="Date" type="date" width="40" bind:value={date} />
  <Button type="submit">Search</Button>
</form>


<!-- <ViewTable table={results}></ViewTable> -->



{#if results.length != 0}
  {#each results as flight, i}
    <div
      class="hover:bg-gray-100 py-2 px-4 flex flex-row gap-6
    {i == 0 ? 'border-y-2' : 'border-b-2'} border-solid border-gray-300"
    >
      <div class="flex flex-col gap-1">
        <div class="my-auto text-gray-500">
          {flight.airline_name}, {flight.flight_number}
        </div>
        <div>
          {flight.seats_ordered.length == 0 ? 0 : flight.seats_ordered[0].count }
          /{flight.airplane.seats}
          {flight.curr_status}
        </div>
      </div>
      <div class="flex flex-col gap-1">
        <div>{flight.departure_time.split("T").join(" ")}</div>
        <div>
          {flight.departure_airport.city} | {flight.departure_airport.name}
        </div>
      </div>
      <div
        class="flex my-auto w-[10vw]
      border-y border-solid border-gray-300"
      ></div>
      <div class="flex flex-col gap-1">
        <div>{flight.arrival_time.split("T").join(" ")}</div>
        <div>{flight.arrival_airport.city} | {flight.arrival_airport.name}</div>
      </div>
      <div class="flex-grow"></div>
      <div class="flex justify-center items-center text-blue-900">
        ${flight.price}
      </div>
      <Button onClick={() => purchase(flight)}>Purchase</Button>
    </div>
  {/each}
{/if}


