import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

// Whitelist of allowed corporate tech domains
const ALLOWED_DOMAINS = [
  "ust.com", 
  "infosys.com", 
  "tcs.com", 
  "wipro.com", 
  "cognizant.com", 
  "ibm.com", 
  "accenture.com", 
  "capgemini.com", 
  "deloitte.com",
];

serve(async (req) => {
  try {
    const { record } = await req.json()
    const email = record.email

    if (!email) {
      return new Response(JSON.stringify({ error: "Email is required." }), { status: 400 })
    }

    const domain = email.split('@')[1]?.toLowerCase()
    
    if (!domain || !ALLOWED_DOMAINS.includes(domain)) {
      return new Response(JSON.stringify({ 
        error: "Registration denied. Use an approved company email from a registered tech park." 
      }), { status: 403 })
    }
    
    // Domain is valid
    return new Response(JSON.stringify({ 
      success: true, 
      message: "Domain validated successfully.",
      domain: domain
    }), { status: 200, headers: { "Content-Type": "application/json" } })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})
