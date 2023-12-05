<script>
  // This is a simple svelte airport project with tailwindcss

  // import css in project/src/routes/global.css
  import "./global.css";

  // nav bar:
  // nav_message is writable store, used to display messages
  import { role, nav_message, print, supabase, user } from "$lib/index.js";
  // for <a> tags in nav
  // if the url matches, there will be some highlight effect
  import { page } from "$app/stores";
  import { onMount } from "svelte";
  $: url = $page.url.pathname;
  onMount(() => {
    window.supabase = supabase;
  });

  const available = {
    anonymous: ["/flights"],
    customer: ["/flights", "/my_tickets"],
    booking_agent: ["/flights", "/my_tickets", "/customers"],
    airline_staff: ["/edit", "/operate_flights", "/invite_staff", "/reports"],
  };

  $: link_names = [
    { name: "Flights", url: "/flights" },
    { name: "My tickets", url: "/my_tickets" },
    { name: "Customers", url: "/customers" },

    { name: "Edit", url: "/edit" },
    { name: "Operate flights", url: "/operate_flights" },
    { name: "Invite staff", url: "/invite_staff" },
    { name: "Reports", url: "/reports" },
  ];

  $: left_links = available[$role].flatMap((url) => {
    return link_names.filter((link) => link.url == url);
  });

  $: right_links = [
    { name: "Login | Signup", url: "/login_signup" },
    { name: "Account settings", url: "/account_settings" },
  ];

  $: item_css = (item_url = null) => {
    return `
    p-2 rounded-lg
    ${item_url == null ? "" : "hover:bg-neutral-800"}
    ${item_url == url ? "bg-neutral-800" : ""}
    `;
  };

  print("<br>hi".repeat(20));
</script>

<div class="flex h-screen overflow-hidden text-lg">
  <nav
    class="
    flex flex-col
    w-64 h-screen
    p-4
    bg-neutral-950
    text-white
  "
  >
    <div class="p-2 pb-4 mb-2 text-xl
      border-b-2 border-solid border-neutral-800
    ">Air ticket system</div>

    {#each left_links as link}
      <a href={link.url} class={item_css(link.url)}>
        {link.name}
      </a>
    {/each}

    <div class="flex-grow"></div>

    {#each right_links as link}
      <a href={link.url} class={item_css(link.url)}>
        {link.name}
      </a>
    {/each}

    <div class={item_css()}><b>{$role}</b></div>
  </nav>

  <main class="p-4 flex-grow overflow-y-scroll">
    <nav
      class="
      p-2 rounded-lg h-24 overflow-y-scroll
      border-2 border-solid border-gray-300
    "
    >
      Messages:
      {@html $nav_message}
    </nav>
    <div class="p-2">
      <slot />
    </div>
  </main>
</div>
