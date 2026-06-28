


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."submit_bracket"("p_token" "uuid", "p_name" "text", "p_picks" "jsonb") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare v_locked boolean; v_id uuid;
begin
  select locked into v_locked from settings where id=1;
  if v_locked then raise exception 'El torneo está cerrado.'; end if;
  if coalesce(trim(p_name),'')='' then raise exception 'El nombre es obligatorio.'; end if;
  update brackets set name=p_name, picks=p_picks, updated_at=now()
    where token=p_token returning id into v_id;
  if v_id is null then
    insert into brackets(token,name,picks) values (p_token,p_name,p_picks) returning id into v_id;
  end if;
  return v_id;
end $$;


ALTER FUNCTION "public"."submit_bracket"("p_token" "uuid", "p_name" "text", "p_picks" "jsonb") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."brackets" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "token" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "picks" "jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."brackets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."official" (
    "id" integer DEFAULT 1 NOT NULL,
    "picks" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "official_id_check" CHECK (("id" = 1))
);


ALTER TABLE "public"."official" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."settings" (
    "id" integer DEFAULT 1 NOT NULL,
    "locked" boolean DEFAULT false NOT NULL,
    "scoring" "jsonb" DEFAULT '{"qf": 2, "sf": 4, "fin": 6, "r16": 1, "diff": 1, "champ": 10, "exact": 3}'::"jsonb" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "settings_id_check" CHECK (("id" = 1))
);


ALTER TABLE "public"."settings" OWNER TO "postgres";


ALTER TABLE ONLY "public"."brackets"
    ADD CONSTRAINT "brackets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."official"
    ADD CONSTRAINT "official_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."settings"
    ADD CONSTRAINT "settings_pkey" PRIMARY KEY ("id");



CREATE POLICY "b_delete" ON "public"."brackets" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "b_read" ON "public"."brackets" FOR SELECT USING ((( SELECT "settings"."locked"
   FROM "public"."settings"
  WHERE ("settings"."id" = 1)) OR ("auth"."role"() = 'authenticated'::"text")));



ALTER TABLE "public"."brackets" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "o_read" ON "public"."official" FOR SELECT USING ((( SELECT "settings"."locked"
   FROM "public"."settings"
  WHERE ("settings"."id" = 1)) OR ("auth"."role"() = 'authenticated'::"text")));



CREATE POLICY "o_write" ON "public"."official" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



ALTER TABLE "public"."official" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "s_read" ON "public"."settings" FOR SELECT USING (true);



CREATE POLICY "s_write" ON "public"."settings" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



ALTER TABLE "public"."settings" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";






















































































































































REVOKE ALL ON FUNCTION "public"."submit_bracket"("p_token" "uuid", "p_name" "text", "p_picks" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."submit_bracket"("p_token" "uuid", "p_name" "text", "p_picks" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."submit_bracket"("p_token" "uuid", "p_name" "text", "p_picks" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."submit_bracket"("p_token" "uuid", "p_name" "text", "p_picks" "jsonb") TO "service_role";


















GRANT ALL ON TABLE "public"."brackets" TO "anon";
GRANT ALL ON TABLE "public"."brackets" TO "authenticated";
GRANT ALL ON TABLE "public"."brackets" TO "service_role";



GRANT ALL ON TABLE "public"."official" TO "anon";
GRANT ALL ON TABLE "public"."official" TO "authenticated";
GRANT ALL ON TABLE "public"."official" TO "service_role";



GRANT ALL ON TABLE "public"."settings" TO "anon";
GRANT ALL ON TABLE "public"."settings" TO "authenticated";
GRANT ALL ON TABLE "public"."settings" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































