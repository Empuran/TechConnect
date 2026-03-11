-- 20260312000000_initial_schema.sql
-- Initial schema for TechConnect MVP

-- Create custom types
CREATE TYPE public.gender_enum AS ENUM ('Male', 'Female', 'Non-Binary', 'Other');

-- USERS Table (extends Supabase Auth)
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  first_name TEXT NOT NULL,
  dob DATE NOT NULL,
  gender gender_enum NOT NULL,
  company_name TEXT NOT NULL,
  job_role TEXT NOT NULL,
  bio TEXT,
  interests TEXT[] DEFAULT '{}',
  tech_interests TEXT[] DEFAULT '{}',
  trust_score INTEGER DEFAULT 0,
  completeness INTEGER DEFAULT 0,
  email_verified BOOLEAN DEFAULT false,
  selfie_verified BOOLEAN DEFAULT false,
  linkedin_verified BOOLEAN DEFAULT false,
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  location_hash TEXT, -- For proximity search within Tech Parks
  is_banned BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- PROFILE PHOTOS
CREATE TABLE public.profile_photos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  photo_url TEXT NOT NULL,
  is_primary BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- SWIPES
CREATE TABLE public.swipes (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  swiper_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  swiped_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  is_like BOOLEAN NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(swiper_id, swiped_id)
);

-- MATCHES
CREATE TABLE public.matches (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user1_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  user2_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(user1_id, user2_id)
);

-- MESSAGES
CREATE TABLE public.messages (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  match_id UUID REFERENCES public.matches(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  content TEXT,
  image_url TEXT,
  read_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- BLOCKS & REPORTS
CREATE TABLE public.blocks (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  blocker_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  blocked_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(blocker_id, blocked_id)
);

CREATE TABLE public.reports (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  reporter_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  reported_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  reason TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Row Level Security (RLS) Policies
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Profiles: Anyone can read active profiles, users can update their own
CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (is_banned = false);
CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Photos: Viewable by anyone, managed by owner
CREATE POLICY "Photos are viewable by everyone." ON public.profile_photos FOR SELECT USING (true);
CREATE POLICY "Users can manage own photos." ON public.profile_photos FOR ALL USING (auth.uid() = profile_id);

-- Swipes: Only swiper can view their own swipes
CREATE POLICY "Users view own swipes." ON public.swipes FOR SELECT USING (auth.uid() = swiper_id);
CREATE POLICY "Users insert own swipes." ON public.swipes FOR INSERT WITH CHECK (auth.uid() = swiper_id);

-- Matches: Users involved can view
CREATE POLICY "Users view joined matches." ON public.matches FOR SELECT USING (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Messages: Users involved in the match can read/insert
CREATE POLICY "Users view match messages." ON public.messages FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.matches WHERE id = match_id AND (user1_id = auth.uid() OR user2_id = auth.uid()))
);
CREATE POLICY "Users insert match messages." ON public.messages FOR INSERT WITH CHECK (
  auth.uid() = sender_id AND EXISTS (SELECT 1 FROM public.matches WHERE id = match_id AND (user1_id = auth.uid() OR user2_id = auth.uid()))
);

-- MATCH TRIGGER
CREATE OR REPLACE FUNCTION public.check_for_match() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_like = true THEN
    -- Check if reciprocal like exists
    IF EXISTS (SELECT 1 FROM public.swipes WHERE swiper_id = NEW.swiped_id AND swiped_id = NEW.swiper_id AND is_like = true) THEN
      -- Create Match
      INSERT INTO public.matches (user1_id, user2_id) VALUES (LEAST(NEW.swiper_id, NEW.swiped_id), GREATEST(NEW.swiper_id, NEW.swiped_id));
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_check_match
AFTER INSERT ON public.swipes
FOR EACH ROW EXECUTE FUNCTION public.check_for_match();
