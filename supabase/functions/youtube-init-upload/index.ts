import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const GOOGLE_CLIENT_ID = Deno.env.get('GOOGLE_CLIENT_ID')
const GOOGLE_CLIENT_SECRET = Deno.env.get('GOOGLE_CLIENT_SECRET')
const YOUTUBE_REFRESH_TOKEN = Deno.env.get('YOUTUBE_REFRESH_TOKEN')

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        const { title, description, privacyStatus = 'unlisted' } = await req.json()

        if (!YOUTUBE_REFRESH_TOKEN || !GOOGLE_CLIENT_ID || !GOOGLE_CLIENT_SECRET) {
            throw new Error('Google/YouTube credentials not configured in environment')
        }

        // 1. Get a fresh Access Token
        const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({
                client_id: GOOGLE_CLIENT_ID,
                client_secret: GOOGLE_CLIENT_SECRET,
                refresh_token: YOUTUBE_REFRESH_TOKEN,
                grant_type: 'refresh_token',
            }),
        })

        const tokenData = await tokenResponse.json()
        if (!tokenData.access_token) {
            throw new Error('Failed to refresh access token: ' + JSON.stringify(tokenData))
        }

        const accessToken = tokenData.access_token

        // 2. Initialize Resumable Upload
        const youtubeResponse = await fetch(
            'https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable&part=snippet,status',
            {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${accessToken}`,
                    'Content-Type': 'application/json',
                    'X-Upload-Content-Type': 'video/*',
                },
                body: JSON.stringify({
                    snippet: {
                        title,
                        description,
                        categoryId: '22', // People & Blogs
                    },
                    status: {
                        privacyStatus,
                        selfDeclaredMadeForKids: false,
                    },
                }),
            }
        )

        if (!youtubeResponse.ok) {
            const error = await youtubeResponse.text()
            throw new Error(`YouTube API Error: ${error}`)
        }

        // The unique upload URL is in the 'Location' header
        const uploadUrl = youtubeResponse.headers.get('Location')

        return new Response(
            JSON.stringify({ uploadUrl }),
            { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )

    } catch (error) {
        return new Response(
            JSON.stringify({ error: error.message }),
            { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
    }
})
