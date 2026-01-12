-- Migration: Make youtube_video_id optional in program_lessons
-- Description: Permite criar aulas sem vídeo do YouTube

-- Tornar youtube_video_id opcional (nullable)
ALTER TABLE program_lessons 
ALTER COLUMN youtube_video_id DROP NOT NULL;

-- Comentário explicativo
COMMENT ON COLUMN program_lessons.youtube_video_id IS 'ID do vídeo do YouTube (opcional - aulas podem ser criadas sem vídeo)';
