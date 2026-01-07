/**
 * YouTube utility functions for the frontend
 */

/**
 * Extracts the video ID from various YouTube URL formats
 * Supports:
 * - https://www.youtube.com/watch?v=dQw4w9WgXcQ
 * - https://youtu.be/dQw4w9WgXcQ
 * - https://www.youtube.com/embed/dQw4w9WgXcQ
 * - dQw4w9WgXcQ (direct ID)
 */
export function extractYouTubeVideoId(input: string): string | null {
    if (!input) return null;

    // If it's already just a 11-char ID
    if (/^[a-zA-Z0-9_-]{11}$/.test(input)) {
        return input;
    }

    const patterns = [
        /(?:v=|\/v\/|embed\/|youtu\.be\/|shorts\/)([^#&?]*)/,
        /youtube\.com\/watch\?v=([^#&?]*)/,
        /youtube\.com\/embed\/([^#&?]*)/,
        /youtu\.be\/([^#&?]*)/
    ];

    for (const pattern of patterns) {
        const match = input.match(pattern);
        if (match && match[1] && match[1].length === 11) {
            return match[1];
        }
    }

    return null;
}

/**
 * Validates if a string is a valid YouTube Video ID format
 */
export function validateYouTubeVideoId(id: string): boolean {
    return /^[a-zA-Z0-9_-]{11}$/.test(id);
}

/**
 * Generates a thumbnail URL for a YouTube video without calling the API
 */
export function getYouTubeThumbnail(videoId: string, quality: 'default' | 'mq' | 'hq' | 'max' = 'hq'): string {
    const qualities = {
        default: 'default',
        mq: 'mqdefault',
        hq: 'hqdefault',
        max: 'maxresdefault'
    };
    return `https://img.youtube.com/vi/${videoId}/${qualities[quality]}.jpg`;
}
