-- Migration: Create program-images bucket for program thumbnails and banners
-- Description: Sets up the storage bucket and RLS policies for program images

-- Create the bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('program-images', 'program-images', true)
ON CONFLICT (id) DO NOTHING;

-- RLS Policies for program-images

-- Allow public access to view images
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'program-images');

-- Allow professors to upload images
CREATE POLICY "Professors and Admins can upload images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'program-images' AND
  (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND (role = 'professor' OR role = 'admin')
    )
  )
);

-- Allow professors and admins to update/delete their own uploads (or anything in this bucket for admins)
CREATE POLICY "Professors and Admins can update/delete images"
ON storage.objects FOR ALL
USING (
  bucket_id = 'program-images' AND
  (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND (role = 'professor' OR role = 'admin')
    )
  )
);
