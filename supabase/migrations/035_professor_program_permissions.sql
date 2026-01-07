-- Allow professors to create and manage their own programs
-- Migration: 035_professor_program_permissions

-- Drop existing policies if any
DROP POLICY IF EXISTS "Professors can create programs" ON programs;
DROP POLICY IF EXISTS "Professors can view their assigned programs" ON programs;
DROP POLICY IF EXISTS "Professors can update their assigned programs" ON programs;

-- Allow professors to create programs
CREATE POLICY "Professors can create programs"
ON programs
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role IN ('professor', 'admin')
  )
);

-- Allow professors to view programs they created or are assigned to
CREATE POLICY "Professors can view their programs"
ON programs
FOR SELECT
TO authenticated
USING (
  status = 'published'  -- Anyone can see published programs
  OR
  EXISTS (
    SELECT 1 FROM program_professors
    WHERE program_professors.program_id = programs.id
    AND program_professors.professor_id = auth.uid()
  )
  OR
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Allow professors to update programs they're assigned to
CREATE POLICY "Professors can update their programs"
ON programs
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM program_professors
    WHERE program_professors.program_id = programs.id
    AND program_professors.professor_id = auth.uid()
  )
  OR
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM program_professors
    WHERE program_professors.program_id = programs.id
    AND program_professors.professor_id = auth.uid()
  )
  OR
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
);
