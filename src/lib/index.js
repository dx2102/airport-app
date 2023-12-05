
import { writable } from 'svelte/store';
import { onMount } from 'svelte';
import { createClient } from '@supabase/supabase-js';


const supabaseUrl = 
  'https://jxqovsxcmnedhvwijedw.supabase.co'
const anonKey =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp4cW92c3hjbW5lZGh2d2lqZWR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE3NzMyOTQsImV4cCI6MjAxNzM0OTI5NH0.S1METynLi45u0ad8cxzsXAtqGqyeEeJEqqFSOGK9GNU'
export const supabase = createClient(supabaseUrl, anonKey);

function try_alert(msg) {
  try {
    alert(msg);
  } catch (e) {
    console.log('alert() not available, error:');
    console.log(msg);
  }
}

export function unwrap(supabaseResult) {
  const { data, error } = supabaseResult;
  if (error) {
    try_alert(error.message + '\n' + error.details);
  }
  return data;
}

export async function user() {
  let session = unwrap(await supabase.auth.getSession()).session;
  if (!session) {
    try_alert('Plase login first!');
  }
  console.log(session);
  return session.user;
}

export async function auth_uid() {
  return (await user()).id;
}

export async function rpc(name, params) {
  return unwrap(await supabase.rpc(name, params));
}





export const nav_message = writable('');
export const role = writable('customer'); // anonymous, client, booking_agent, airline_staff

export function print(...strings) {
  const string = strings.join(' ');
  nav_message.update((original) => original + string + '<br>');
}
export function clear() {
  nav_message.set('');
}

print('hi');









  



