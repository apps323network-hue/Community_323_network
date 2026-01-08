-- Migration: Add email notification trigger for new program enrollments
-- Description: Automatically notify professors when students complete enrollment payment

-- Enable pg_net extension for HTTP requests from database
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Function to notify professors of new enrollment
CREATE OR REPLACE FUNCTION notify_professor_new_enrollment()
RETURNS TRIGGER AS $$
DECLARE
  function_url TEXT;
  project_url TEXT;
  service_role_key TEXT;
BEGIN
  -- Only notify when status changes from 'pending' to 'active'
  IF OLD.status = 'pending' AND NEW.status = 'active' THEN
    
    -- Get project URL from current settings
    project_url := current_setting('app.settings.supabase_url', true);
    service_role_key := current_setting('app.settings.supabase_service_role_key', true);
    
    -- If not set in settings, use environment variable or default
    IF project_url IS NULL THEN
      project_url := current_setting('request.headers', true)::json->>'x-forwarded-host';
      IF project_url IS NOT NULL THEN
        project_url := 'https://' || project_url;
      END IF;
    END IF;
    
    -- Construct Edge Function URL
    IF project_url IS NOT NULL THEN
      function_url := project_url || '/functions/v1/notify-professor-enrollment';
      
      -- Make async HTTP request to Edge Function
      PERFORM net.http_post(
        url := function_url,
        headers := jsonb_build_object(
          'Content-Type', 'application/json',
          'Authorization', 'Bearer ' || COALESCE(service_role_key, '')
        ),
        body := jsonb_build_object(
          'enrollment_id', NEW.id,
          'program_id', NEW.program_id,
          'user_id', NEW.user_id,
          'enrolled_at', NEW.enrolled_at,
          'paid_at', NEW.paid_at
        ),
        timeout_milliseconds := 5000
      );
      
      -- Log the notification attempt
      RAISE NOTICE 'Enrollment notification triggered for enrollment_id: %, program_id: %, user_id: %', 
        NEW.id, NEW.program_id, NEW.user_id;
    ELSE
      RAISE WARNING 'Could not determine project URL for enrollment notification';
    END IF;
  END IF;
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail the transaction
    RAISE WARNING 'Error in notify_professor_new_enrollment: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS trigger_notify_professor_enrollment ON program_enrollments;

-- Create trigger on program_enrollments table
CREATE TRIGGER trigger_notify_professor_enrollment
  AFTER UPDATE ON program_enrollments
  FOR EACH ROW
  EXECUTE FUNCTION notify_professor_new_enrollment();

-- Add comment for documentation
COMMENT ON TRIGGER trigger_notify_professor_enrollment ON program_enrollments IS 
  'Automatically sends email notification to professors when a student completes enrollment payment (status changes from pending to active)';

COMMENT ON FUNCTION notify_professor_new_enrollment() IS 
  'Invokes the notify-professor-enrollment Edge Function via HTTP request when enrollment status becomes active';
