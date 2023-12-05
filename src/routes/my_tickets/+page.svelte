

<script>
  import InputBox from "$lib/InputBox.svelte";
  import Button from "$lib/Button.svelte";
  import ViewTable from "$lib/ViewTable.svelte";
  import { supabase, unwrap, print, auth_uid, role } from "$lib/index.js";

  // startDate and endDate must be "yyyy-mm-dd", startDate is 4 years ago by default
  let startDate = new Date();
  startDate.setFullYear(startDate.getFullYear() - 4);
  startDate = startDate.toISOString().slice(0, 10);
  let endDate = new Date().toISOString().slice(0, 10);
  let tickets = [];
  let table = [];

  async function init() {
    let query = supabase
      .from("ticket")
      .select("customer_id, agent_id, flight(*)");
    if ($role === "customer") {
      query = query.eq("customer_id", await auth_uid());
    } else if ($role === "booking_agent") {
      query = query.eq("agent_id", await auth_uid());
    }
    tickets = unwrap(await query);
    table = tickets;
    console.log(tickets);
  }
  init();

  function filter() {
    table = tickets.filter(ticket => {
      let date = new Date(ticket.flight.departure_time).toISOString();
      let ok = date >= startDate && date <= endDate;
      return ok;
    });
  }

  function get_all() {
    table = tickets;
  }

  $: total_spending = table.reduce((acc, ticket) => {
    return acc + ticket.flight.price;
  }, 0);

  // groups tickets by month, calculate spending_this_month
  let table_groups = []
  $: {
    table_groups = [];
    table;
    let groups = {};
    for (let ticket of table) {
      let date = new Date(ticket.flight.departure_time);
      // title is like January 2021, use English
      let title = date.toLocaleString("en-US", { month: "long", year: "numeric" });
      if (!groups[title]) groups[title] = [];
      groups[title].push(ticket);
    }
    let titles = Object.keys(groups);
    titles.sort();
    for (let title of titles) {
      let spending_this_month = groups[title].reduce((acc, ticket) => {
        return acc + ticket.flight.price;
      }, 0);
      table_groups.push({
        title,
        data: groups[title],
        spending_this_month,
      });
    }
    table_groups = table_groups;
    console.log("table_groups", table_groups);
  }



  

</script>

<h2 class="text-3xl py-2">My tickets</h2>

<div class="flex flex-col gap-2 ">
  <InputBox bind:value={startDate} type="date" label="Start date" />
  <InputBox bind:value={endDate} type="date" label="End date" />
  <Button on:click={filter} _class="w-full">Filter</Button>
  <Button on:click={get_all} _class="w-full">All</Button>
  <!-- booking agents get 10 percent commission -->
  <h3 class="text-2xl">
    Total spendings: ${total_spending}
    {#if $role === "booking_agent"}
      | Total commission: ${total_spending * 0.1}
    {/if}
  </h3>
  {#each table_groups as { title, data, spending_this_month }}
    <h3 class="text-2xl">{title}, ${spending_this_month}
      {#if $role === "booking_agent"}
        | Commission: ${spending_this_month * 0.1}
      {/if}
    </h3>
    <ViewTable table={data}></ViewTable>
  {/each}
</div>





