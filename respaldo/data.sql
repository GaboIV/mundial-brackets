SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict UkFOn2WLxLvFq1JhzaHFcVEZY3AKD41xbp3btnN9g1GlozgNjKm225UcnYxBOgX

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', 'bf2cbbd8-b847-4715-9b94-0632cf983e64', 'authenticated', 'authenticated', 'gabrielcaraballo1907@gmail.com', '$2a$10$8u.WjowutxKzxpBKHf2Jku7f/d0S2d4rqEh8JC7QSreRIbMBsTM7m', '2026-06-28 05:42:28.283315+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-06-28 19:33:41.706811+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-06-28 05:42:28.246006+00', '2026-06-28 19:33:41.744012+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('bf2cbbd8-b847-4715-9b94-0632cf983e64', 'bf2cbbd8-b847-4715-9b94-0632cf983e64', '{"sub": "bf2cbbd8-b847-4715-9b94-0632cf983e64", "email": "gabrielcaraballo1907@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2026-06-28 05:42:28.273294+00', '2026-06-28 05:42:28.273357+00', '2026-06-28 05:42:28.273357+00', '0369bc40-3707-42ff-a799-9d83505ec8cc');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") VALUES
	('b4e3e582-cd37-42dc-a175-7f102de31b42', 'bf2cbbd8-b847-4715-9b94-0632cf983e64', '2026-06-28 19:33:41.70698+00', '2026-06-28 19:33:41.70698+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '45.189.108.72', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('b4e3e582-cd37-42dc-a175-7f102de31b42', '2026-06-28 19:33:41.751383+00', '2026-06-28 19:33:41.751383+00', 'password', 'a05aa70d-b4af-4d53-b5c1-f036d0b7ad60');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 6, 'lykuflu6jhgl', 'bf2cbbd8-b847-4715-9b94-0632cf983e64', false, '2026-06-28 19:33:41.738066+00', '2026-06-28 19:33:41.738066+00', NULL, 'b4e3e582-cd37-42dc-a175-7f102de31b42');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: brackets; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."brackets" ("id", "token", "name", "picks", "created_at", "updated_at") VALUES
	('f925d0c3-b0eb-451d-b604-5518fd408b30', '6b60292c-d8c1-4e8a-906b-6bd577fa82b9', 'Gabo', '{"scores": {"L-fin": [2, 2], "R-fin": [0, 3], "champ": [0, 1], "L-qf-0": [1, 2], "L-qf-1": [0, 3], "L-qf-2": [1, 2], "L-qf-3": [0, 0], "L-sf-0": [2, 0], "L-sf-1": [3, 1], "R-qf-0": [1, 0], "R-qf-1": [3, 1], "R-qf-2": [3, 1], "R-qf-3": [1, 2], "R-sf-0": [0, 1], "R-sf-1": [0, 0], "L-r16-0": [2, 0], "L-r16-1": [3, 0], "L-r16-2": [0, 0], "L-r16-3": [1, 1], "L-r16-4": [2, 1], "L-r16-5": [3, 1], "L-r16-6": [4, 1], "L-r16-7": [2, 0], "R-r16-0": [0, 1], "R-r16-1": [2, 2], "R-r16-2": [0, 3], "R-r16-3": [3, 0], "R-r16-4": [4, 0], "R-r16-5": [1, 3], "R-r16-6": [1, 0], "R-r16-7": [2, 0]}, "winners": {"L-fin": {"c": "es", "n": "España"}, "R-fin": {"c": "co", "n": "Colombia"}, "champ": {"c": "co", "n": "Colombia"}, "L-qf-0": {"c": "fr", "n": "Francia"}, "L-qf-1": {"c": "nl", "n": "Países Bajos"}, "L-qf-2": {"c": "es", "n": "España"}, "L-qf-3": {"c": "be", "n": "Bélgica"}, "L-sf-0": {"c": "fr", "n": "Francia"}, "L-sf-1": {"c": "es", "n": "España"}, "R-qf-0": {"c": "jp", "n": "Japón"}, "R-qf-1": {"c": "ec", "n": "Ecuador"}, "R-qf-2": {"c": "ar", "n": "Argentina"}, "R-qf-3": {"c": "co", "n": "Colombia"}, "R-sf-0": {"c": "ec", "n": "Ecuador"}, "R-sf-1": {"c": "co", "n": "Colombia"}, "L-r16-0": {"c": "de", "n": "Alemania"}, "L-r16-1": {"c": "fr", "n": "Francia"}, "L-r16-2": {"c": "ca", "n": "Canadá"}, "L-r16-3": {"c": "nl", "n": "Países Bajos"}, "L-r16-4": {"c": "pt", "n": "Portugal"}, "L-r16-5": {"c": "es", "n": "España"}, "L-r16-6": {"c": "us", "n": "Estados Unidos"}, "L-r16-7": {"c": "be", "n": "Bélgica"}, "R-r16-0": {"c": "jp", "n": "Japón"}, "R-r16-1": {"c": "ci", "n": "Costa de Marfil"}, "R-r16-2": {"c": "ec", "n": "Ecuador"}, "R-r16-3": {"c": "gb-eng", "n": "Inglaterra"}, "R-r16-4": {"c": "ar", "n": "Argentina"}, "R-r16-5": {"c": "eg", "n": "Egipto"}, "R-r16-6": {"c": "ch", "n": "Suiza"}, "R-r16-7": {"c": "co", "n": "Colombia"}}}', '2026-06-28 06:30:06.725733+00', '2026-06-28 06:45:20.716163+00'),
	('63b62368-7dfa-464c-9e35-4e3b88ba2508', 'd7ba7758-51bf-42c3-b742-8022df242bce', 'Franco', '{"scores": {"L-fin": [4, 1], "R-fin": [0, 2], "champ": [3, 2], "L-qf-0": [1, 2], "L-qf-1": [1, 3], "L-qf-2": [1, 3], "L-qf-3": [0, 1], "L-sf-0": [3, 1], "L-sf-1": [2, 0], "R-qf-0": [1, 2], "R-qf-1": [0, 2], "R-qf-2": [2, 1], "R-qf-3": [1, 3], "R-sf-0": [1, 3], "R-sf-1": [4, 1], "L-r16-0": [4, 1], "L-r16-1": [2, 0], "L-r16-2": [2, 1], "L-r16-3": [2, 1], "L-r16-4": [0, 2], "L-r16-5": [3, 0], "L-r16-6": [1, 0], "L-r16-7": [2, 0], "R-r16-0": [1, 2], "R-r16-1": [2, 0], "R-r16-2": [0, 2], "R-r16-3": [3, 0], "R-r16-4": [2, 0], "R-r16-5": [0, 2], "R-r16-6": [1, 2], "R-r16-7": [2, 1]}, "winners": {"L-fin": {"c": "fr", "n": "Francia"}, "R-fin": {"c": "ar", "n": "Argentina"}, "champ": {"c": "fr", "n": "Francia"}, "L-qf-0": {"c": "fr", "n": "Francia"}, "L-qf-1": {"c": "nl", "n": "Países Bajos"}, "L-qf-2": {"c": "es", "n": "España"}, "L-qf-3": {"c": "be", "n": "Bélgica"}, "L-sf-0": {"c": "fr", "n": "Francia"}, "L-sf-1": {"c": "es", "n": "España"}, "R-qf-0": {"c": "ci", "n": "Costa de Marfil"}, "R-qf-1": {"c": "gb-eng", "n": "Inglaterra"}, "R-qf-2": {"c": "ar", "n": "Argentina"}, "R-qf-3": {"c": "co", "n": "Colombia"}, "R-sf-0": {"c": "gb-eng", "n": "Inglaterra"}, "R-sf-1": {"c": "ar", "n": "Argentina"}, "L-r16-0": {"c": "de", "n": "Alemania"}, "L-r16-1": {"c": "fr", "n": "Francia"}, "L-r16-2": {"c": "za", "n": "Sudáfrica"}, "L-r16-3": {"c": "nl", "n": "Países Bajos"}, "L-r16-4": {"c": "hr", "n": "Croacia"}, "L-r16-5": {"c": "es", "n": "España"}, "L-r16-6": {"c": "us", "n": "Estados Unidos"}, "L-r16-7": {"c": "be", "n": "Bélgica"}, "R-r16-0": {"c": "jp", "n": "Japón"}, "R-r16-1": {"c": "ci", "n": "Costa de Marfil"}, "R-r16-2": {"c": "ec", "n": "Ecuador"}, "R-r16-3": {"c": "gb-eng", "n": "Inglaterra"}, "R-r16-4": {"c": "ar", "n": "Argentina"}, "R-r16-5": {"c": "eg", "n": "Egipto"}, "R-r16-6": {"c": "dz", "n": "Argelia"}, "R-r16-7": {"c": "co", "n": "Colombia"}}}', '2026-06-28 08:02:44.415064+00', '2026-06-28 08:02:44.415064+00'),
	('ea67b84f-319b-4d91-9f5c-808f090246f6', 'ba9dd08a-6ce0-4ed6-b04e-88b5df9c1a50', 'Chuchildo', '{"scores": {"L-fin": [1, 0], "R-fin": [0, 0], "champ": [2, 3], "L-qf-0": [0, 1], "L-qf-1": [0, 2], "L-qf-2": [2, 2], "L-qf-3": [2, 0], "L-sf-0": [1, 0], "L-sf-1": [0, 1], "R-qf-0": [2, 1], "R-qf-1": [0, 1], "R-qf-2": [2, 1], "R-qf-3": [0, 1], "R-sf-0": [2, 2], "R-sf-1": [2, 1], "L-r16-0": [2, 0], "L-r16-1": [3, 1], "L-r16-2": [0, 1], "L-r16-3": [3, 2], "L-r16-4": [3, 1], "L-r16-5": [1, 0], "L-r16-6": [2, 0], "L-r16-7": [1, 1], "R-r16-0": [2, 2], "R-r16-1": [2, 1], "R-r16-2": [0, 0], "R-r16-3": [3, 1], "R-r16-4": [2, 0], "R-r16-5": [1, 3], "R-r16-6": [1, 0], "R-r16-7": [1, 0]}, "winners": {"L-fin": {"c": "fr", "n": "Francia"}, "R-fin": {"c": "jp", "n": "Japón"}, "champ": {"c": "jp", "n": "Japón"}, "L-qf-0": {"c": "fr", "n": "Francia"}, "L-qf-1": {"c": "nl", "n": "Países Bajos"}, "L-qf-2": {"c": "pt", "n": "Portugal"}, "L-qf-3": {"c": "us", "n": "Estados Unidos"}, "L-sf-0": {"c": "fr", "n": "Francia"}, "L-sf-1": {"c": "us", "n": "Estados Unidos"}, "R-qf-0": {"c": "jp", "n": "Japón"}, "R-qf-1": {"c": "gb-eng", "n": "Inglaterra"}, "R-qf-2": {"c": "ar", "n": "Argentina"}, "R-qf-3": {"c": "co", "n": "Colombia"}, "R-sf-0": {"c": "jp", "n": "Japón"}, "R-sf-1": {"c": "ar", "n": "Argentina"}, "L-r16-0": {"c": "de", "n": "Alemania"}, "L-r16-1": {"c": "fr", "n": "Francia"}, "L-r16-2": {"c": "ca", "n": "Canadá"}, "L-r16-3": {"c": "nl", "n": "Países Bajos"}, "L-r16-4": {"c": "pt", "n": "Portugal"}, "L-r16-5": {"c": "es", "n": "España"}, "L-r16-6": {"c": "us", "n": "Estados Unidos"}, "L-r16-7": {"c": "be", "n": "Bélgica"}, "R-r16-0": {"c": "jp", "n": "Japón"}, "R-r16-1": {"c": "ci", "n": "Costa de Marfil"}, "R-r16-2": {"c": "ec", "n": "Ecuador"}, "R-r16-3": {"c": "gb-eng", "n": "Inglaterra"}, "R-r16-4": {"c": "ar", "n": "Argentina"}, "R-r16-5": {"c": "eg", "n": "Egipto"}, "R-r16-6": {"c": "ch", "n": "Suiza"}, "R-r16-7": {"c": "co", "n": "Colombia"}}}', '2026-06-28 11:34:37.298969+00', '2026-06-28 11:34:37.298969+00'),
	('7d183ba3-410b-45d4-879b-d1bb0b97a22a', 'a6557604-f552-4cb8-8983-70d0062bb6d9', 'Jorvis', '{"scores": {"L-fin": [2, 2], "R-fin": [0, 2], "champ": [0, 1], "L-qf-0": [0, 1], "L-qf-1": [0, 2], "L-qf-2": [2, 1], "L-qf-3": [1, 0], "L-sf-0": [2, 2], "L-sf-1": [1, 0], "R-qf-0": [1, 0], "R-qf-1": [1, 1], "R-qf-2": [3, 1], "R-qf-3": [2, 2], "R-sf-0": [2, 2], "R-sf-1": [1, 1], "L-r16-0": [2, 1], "L-r16-1": [2, 2], "L-r16-2": [2, 3], "L-r16-3": [1, 1], "L-r16-4": [3, 1], "L-r16-5": [2, 1], "L-r16-6": [2, 1], "L-r16-7": [0, 1], "R-r16-0": [1, 1], "R-r16-1": [1, 2], "R-r16-2": [0, 2], "R-r16-3": [3, 0], "R-r16-4": [2, 0], "R-r16-5": [1, 2], "R-r16-6": [1, 2], "R-r16-7": [1, 0]}, "winners": {"L-fin": {"c": "ma", "n": "Marruecos"}, "R-fin": {"c": "ar", "n": "Argentina"}, "champ": {"c": "ar", "n": "Argentina"}, "L-qf-0": {"c": "fr", "n": "Francia"}, "L-qf-1": {"c": "ma", "n": "Marruecos"}, "L-qf-2": {"c": "pt", "n": "Portugal"}, "L-qf-3": {"c": "us", "n": "Estados Unidos"}, "L-sf-0": {"c": "ma", "n": "Marruecos"}, "L-sf-1": {"c": "pt", "n": "Portugal"}, "R-qf-0": {"c": "jp", "n": "Japón"}, "R-qf-1": {"c": "ec", "n": "Ecuador"}, "R-qf-2": {"c": "ar", "n": "Argentina"}, "R-qf-3": {"c": "co", "n": "Colombia"}, "R-sf-0": {"c": "jp", "n": "Japón"}, "R-sf-1": {"c": "ar", "n": "Argentina"}, "L-r16-0": {"c": "de", "n": "Alemania"}, "L-r16-1": {"c": "fr", "n": "Francia"}, "L-r16-2": {"c": "ca", "n": "Canadá"}, "L-r16-3": {"c": "ma", "n": "Marruecos"}, "L-r16-4": {"c": "pt", "n": "Portugal"}, "L-r16-5": {"c": "es", "n": "España"}, "L-r16-6": {"c": "us", "n": "Estados Unidos"}, "L-r16-7": {"c": "sn", "n": "Senegal"}, "R-r16-0": {"c": "jp", "n": "Japón"}, "R-r16-1": {"c": "no", "n": "Noruega"}, "R-r16-2": {"c": "ec", "n": "Ecuador"}, "R-r16-3": {"c": "gb-eng", "n": "Inglaterra"}, "R-r16-4": {"c": "ar", "n": "Argentina"}, "R-r16-5": {"c": "eg", "n": "Egipto"}, "R-r16-6": {"c": "dz", "n": "Argelia"}, "R-r16-7": {"c": "co", "n": "Colombia"}}}', '2026-06-28 14:36:43.783609+00', '2026-06-28 14:36:59.74562+00'),
	('8c37df14-2514-43a9-b9b7-136c5a848247', '8d392bdc-92f8-4cd3-95b8-6efcb670034e', 'Josué', '{"scores": {"L-fin": [2, 3], "R-fin": [0, 1], "champ": [2, 1], "L-qf-0": [0, 1], "L-qf-1": [0, 2], "L-qf-2": [0, 3], "L-qf-3": [1, 2], "L-sf-0": [1, 0], "L-sf-1": [2, 1], "R-qf-0": [2, 1], "R-qf-1": [1, 2], "R-qf-2": [2, 0], "R-qf-3": [1, 2], "R-sf-0": [0, 3], "R-sf-1": [1, 0], "L-r16-0": [3, 1], "L-r16-1": [3, 2], "L-r16-2": [1, 2], "L-r16-3": [2, 1], "L-r16-4": [1, 0], "L-r16-5": [3, 0], "L-r16-6": [2, 0], "L-r16-7": [2, 0], "R-r16-0": [2, 1], "R-r16-1": [2, 3], "R-r16-2": [1, 0], "R-r16-3": [3, 0], "R-r16-4": [3, 1], "R-r16-5": [0, 1], "R-r16-6": [2, 0], "R-r16-7": [3, 1]}, "winners": {"L-fin": {"c": "es", "n": "España"}, "R-fin": {"c": "ar", "n": "Argentina"}, "champ": {"c": "es", "n": "España"}, "L-qf-0": {"c": "fr", "n": "Francia"}, "L-qf-1": {"c": "nl", "n": "Países Bajos"}, "L-qf-2": {"c": "es", "n": "España"}, "L-qf-3": {"c": "be", "n": "Bélgica"}, "L-sf-0": {"c": "fr", "n": "Francia"}, "L-sf-1": {"c": "es", "n": "España"}, "R-qf-0": {"c": "br", "n": "Brasil"}, "R-qf-1": {"c": "gb-eng", "n": "Inglaterra"}, "R-qf-2": {"c": "ar", "n": "Argentina"}, "R-qf-3": {"c": "co", "n": "Colombia"}, "R-sf-0": {"c": "gb-eng", "n": "Inglaterra"}, "R-sf-1": {"c": "ar", "n": "Argentina"}, "L-r16-0": {"c": "de", "n": "Alemania"}, "L-r16-1": {"c": "fr", "n": "Francia"}, "L-r16-2": {"c": "ca", "n": "Canadá"}, "L-r16-3": {"c": "nl", "n": "Países Bajos"}, "L-r16-4": {"c": "pt", "n": "Portugal"}, "L-r16-5": {"c": "es", "n": "España"}, "L-r16-6": {"c": "us", "n": "Estados Unidos"}, "L-r16-7": {"c": "be", "n": "Bélgica"}, "R-r16-0": {"c": "br", "n": "Brasil"}, "R-r16-1": {"c": "no", "n": "Noruega"}, "R-r16-2": {"c": "mx", "n": "México"}, "R-r16-3": {"c": "gb-eng", "n": "Inglaterra"}, "R-r16-4": {"c": "ar", "n": "Argentina"}, "R-r16-5": {"c": "eg", "n": "Egipto"}, "R-r16-6": {"c": "ch", "n": "Suiza"}, "R-r16-7": {"c": "co", "n": "Colombia"}}}', '2026-06-28 15:48:00.95623+00', '2026-06-28 15:48:00.95623+00'),
	('3b88dd4c-e78b-43f1-835d-1ea0a8b1c8c8', '469111d9-54af-4f8f-acf0-bf8396f67d69', 'Jorman', '{"scores": {"L-fin": [1, 2], "R-fin": [1, 2], "champ": [1, 2], "L-qf-0": [1, 1], "L-qf-1": [1, 2], "L-qf-2": [1, 1], "L-qf-3": [2, 1], "L-sf-0": [0, 1], "L-sf-1": [1, 0], "R-qf-0": [2, 1], "R-qf-1": [1, 0], "R-qf-2": [2, 1], "R-qf-3": [0, 1], "R-sf-0": [0, 1], "R-sf-1": [1, 0], "L-r16-0": [2, 1], "L-r16-1": [2, 0], "L-r16-2": [1, 2], "L-r16-3": [0, 1], "L-r16-4": [2, 0], "L-r16-5": [3, 0], "L-r16-6": [3, 1], "L-r16-7": [2, 1], "R-r16-0": [1, 1], "R-r16-1": [2, 1], "R-r16-2": [1, 2], "R-r16-3": [3, 1], "R-r16-4": [2, 0], "R-r16-5": [1, 0], "R-r16-6": [1, 1], "R-r16-7": [3, 0]}, "winners": {"L-fin": {"c": "pt", "n": "Portugal"}, "R-fin": {"c": "ar", "n": "Argentina"}, "champ": {"c": "ar", "n": "Argentina"}, "L-qf-0": {"c": "de", "n": "Alemania"}, "L-qf-1": {"c": "ma", "n": "Marruecos"}, "L-qf-2": {"c": "pt", "n": "Portugal"}, "L-qf-3": {"c": "us", "n": "Estados Unidos"}, "L-sf-0": {"c": "ma", "n": "Marruecos"}, "L-sf-1": {"c": "pt", "n": "Portugal"}, "R-qf-0": {"c": "br", "n": "Brasil"}, "R-qf-1": {"c": "ec", "n": "Ecuador"}, "R-qf-2": {"c": "ar", "n": "Argentina"}, "R-qf-3": {"c": "co", "n": "Colombia"}, "R-sf-0": {"c": "ec", "n": "Ecuador"}, "R-sf-1": {"c": "ar", "n": "Argentina"}, "L-r16-0": {"c": "de", "n": "Alemania"}, "L-r16-1": {"c": "fr", "n": "Francia"}, "L-r16-2": {"c": "ca", "n": "Canadá"}, "L-r16-3": {"c": "ma", "n": "Marruecos"}, "L-r16-4": {"c": "pt", "n": "Portugal"}, "L-r16-5": {"c": "es", "n": "España"}, "L-r16-6": {"c": "us", "n": "Estados Unidos"}, "L-r16-7": {"c": "be", "n": "Bélgica"}, "R-r16-0": {"c": "br", "n": "Brasil"}, "R-r16-1": {"c": "ci", "n": "Costa de Marfil"}, "R-r16-2": {"c": "ec", "n": "Ecuador"}, "R-r16-3": {"c": "gb-eng", "n": "Inglaterra"}, "R-r16-4": {"c": "ar", "n": "Argentina"}, "R-r16-5": {"c": "au", "n": "Australia"}, "R-r16-6": {"c": "ch", "n": "Suiza"}, "R-r16-7": {"c": "co", "n": "Colombia"}}}', '2026-06-28 18:42:11.529496+00', '2026-06-28 18:42:11.529496+00');


--
-- Data for Name: official; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."official" ("id", "picks", "updated_at") VALUES
	(1, '{}', '2026-06-28 05:45:10.137377+00');


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."settings" ("id", "locked", "scoring", "updated_at") VALUES
	(1, true, '{"qf": 2, "sf": 4, "fin": 6, "r16": 1, "diff": 1, "champ": 10, "exact": 3}', '2026-06-28 19:06:58.383+00');


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 6, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict UkFOn2WLxLvFq1JhzaHFcVEZY3AKD41xbp3btnN9g1GlozgNjKm225UcnYxBOgX

RESET ALL;
