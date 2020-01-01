CREATE DATABASE keycloak;

\c keycloak

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5 (Debian 11.5-1.pgdg90+1)
-- Dumped by pg_dump version 11.5

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO postgres;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO postgres;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO postgres;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO postgres;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO postgres;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO postgres;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO postgres;

--
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO postgres;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    value character varying(4000),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_attributes OWNER TO postgres;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO postgres;

--
-- Name: client_default_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_default_roles (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_default_roles OWNER TO postgres;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO postgres;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO postgres;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO postgres;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO postgres;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scope_client (
    client_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO postgres;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO postgres;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO postgres;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO postgres;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO postgres;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO postgres;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO postgres;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO postgres;

--
-- Name: component; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO postgres;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


ALTER TABLE public.component_config OWNER TO postgres;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO postgres;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO postgres;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO postgres;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO postgres;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO postgres;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


ALTER TABLE public.event_entity OWNER TO postgres;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO postgres;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO postgres;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO postgres;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO postgres;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO postgres;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO postgres;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO postgres;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO postgres;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO postgres;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO postgres;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO postgres;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO postgres;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO postgres;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO postgres;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO postgres;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36),
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO postgres;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(36),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO postgres;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO postgres;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(36) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO postgres;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO postgres;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO postgres;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO postgres;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO postgres;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.realm OWNER TO postgres;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_attribute OWNER TO postgres;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO postgres;

--
-- Name: realm_default_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_default_roles (
    realm_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_roles OWNER TO postgres;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO postgres;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO postgres;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO postgres;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO postgres;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO postgres;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO postgres;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO postgres;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO postgres;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO postgres;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO postgres;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO postgres;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode character varying(15) NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO postgres;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(36) NOT NULL,
    requester character varying(36) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO postgres;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy character varying(20),
    logic character varying(20),
    resource_server_id character varying(36) NOT NULL,
    owner character varying(36)
);


ALTER TABLE public.resource_server_policy OWNER TO postgres;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(36) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO postgres;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO postgres;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO postgres;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO postgres;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO postgres;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO postgres;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO postgres;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO postgres;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO postgres;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(36),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO postgres;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO postgres;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO postgres;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO postgres;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO postgres;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO postgres;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO postgres;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO postgres;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO postgres;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO postgres;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO postgres;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO postgres;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
6ea85c11-85a5-4b0b-a1fd-b83507508bc1	\N	auth-cookie	master	46311784-6b0a-49e0-abff-939380a1cafe	2	10	f	\N	\N
0d8f0f12-e75f-4f36-8296-05732df7f27b	\N	auth-spnego	master	46311784-6b0a-49e0-abff-939380a1cafe	3	20	f	\N	\N
35d79ff8-0029-4201-9dd4-84c0ab82887c	\N	identity-provider-redirector	master	46311784-6b0a-49e0-abff-939380a1cafe	2	25	f	\N	\N
a94e2bc0-07d3-4f10-b163-303f34a096d9	\N	\N	master	46311784-6b0a-49e0-abff-939380a1cafe	2	30	t	97adae52-39fe-405b-9d3a-98b98ad00f33	\N
ae729492-e61a-4495-826f-8bf14b32cd00	\N	auth-username-password-form	master	97adae52-39fe-405b-9d3a-98b98ad00f33	0	10	f	\N	\N
6fcb5fca-52be-4736-833d-6a63798633d9	\N	\N	master	97adae52-39fe-405b-9d3a-98b98ad00f33	1	20	t	ee0fafa2-31dd-486b-b8fb-97a3a624cc94	\N
f02bc577-dd49-4f35-83fb-5e5265e1abb6	\N	conditional-user-configured	master	ee0fafa2-31dd-486b-b8fb-97a3a624cc94	0	10	f	\N	\N
d3d586be-1f4b-4519-8bb4-f9f16256f5eb	\N	auth-otp-form	master	ee0fafa2-31dd-486b-b8fb-97a3a624cc94	0	20	f	\N	\N
c5c8fcdc-a773-4da5-a7b9-4a94db0abce5	\N	direct-grant-validate-username	master	b55f736c-b6b6-4657-88a7-b1584b274e62	0	10	f	\N	\N
d102445c-f2b9-4268-8a1c-204aca475cc6	\N	direct-grant-validate-password	master	b55f736c-b6b6-4657-88a7-b1584b274e62	0	20	f	\N	\N
3666e76d-928e-417c-9dda-399ef5c65ee4	\N	\N	master	b55f736c-b6b6-4657-88a7-b1584b274e62	1	30	t	e3f62e5c-394f-4b2e-ac35-50130e2a7b1e	\N
13d01674-16b9-4e55-a2ed-423bc763d4bc	\N	conditional-user-configured	master	e3f62e5c-394f-4b2e-ac35-50130e2a7b1e	0	10	f	\N	\N
ba487f67-1615-407d-a329-e0bd48128835	\N	direct-grant-validate-otp	master	e3f62e5c-394f-4b2e-ac35-50130e2a7b1e	0	20	f	\N	\N
3977f211-a3e3-41f1-8b82-a798d9c47d39	\N	registration-page-form	master	4cfab865-f306-4b7f-86cd-0294d9cec8df	0	10	t	e5d672a7-efbb-4a4c-8e97-5229b3bc8031	\N
cd8954f5-335a-476f-8aab-221ae53045e7	\N	registration-user-creation	master	e5d672a7-efbb-4a4c-8e97-5229b3bc8031	0	20	f	\N	\N
c1cdcd6a-76e8-4fa4-9a60-a7fa64da0bbd	\N	registration-profile-action	master	e5d672a7-efbb-4a4c-8e97-5229b3bc8031	0	40	f	\N	\N
26b44075-e423-4a70-ba6c-4b87dc3f67b8	\N	registration-password-action	master	e5d672a7-efbb-4a4c-8e97-5229b3bc8031	0	50	f	\N	\N
9d6a67a1-2d24-4bb9-85cc-93bfaf92dfc2	\N	registration-recaptcha-action	master	e5d672a7-efbb-4a4c-8e97-5229b3bc8031	3	60	f	\N	\N
39e77967-93b5-449e-93e5-9f2d9df832a4	\N	reset-credentials-choose-user	master	2bb6e8d6-d50e-48c3-891b-d6e5541cbb30	0	10	f	\N	\N
f20950aa-5cd7-473b-8d8f-8c9ebf2e38ce	\N	reset-credential-email	master	2bb6e8d6-d50e-48c3-891b-d6e5541cbb30	0	20	f	\N	\N
ef85ec94-18a4-4afc-a709-a2679bd742e7	\N	reset-password	master	2bb6e8d6-d50e-48c3-891b-d6e5541cbb30	0	30	f	\N	\N
8db5a1bb-76ae-4caa-a88c-c3149b25b436	\N	\N	master	2bb6e8d6-d50e-48c3-891b-d6e5541cbb30	1	40	t	583d3473-656f-4f4b-80a0-fad404eed6f7	\N
df2671e7-5d61-4fe7-aa8c-f544782f5e1e	\N	conditional-user-configured	master	583d3473-656f-4f4b-80a0-fad404eed6f7	0	10	f	\N	\N
27ef6638-6198-4792-be2d-61a7f08576d0	\N	reset-otp	master	583d3473-656f-4f4b-80a0-fad404eed6f7	0	20	f	\N	\N
e11b7e54-e6cb-4c2b-9aea-ef9312c9a7e7	\N	client-secret	master	5f05c917-b832-4ae0-bb50-30efcdb79a38	2	10	f	\N	\N
3633dc46-e5c9-47d8-9906-e3673b4d80c8	\N	client-jwt	master	5f05c917-b832-4ae0-bb50-30efcdb79a38	2	20	f	\N	\N
33ccab71-d2af-403b-9995-4f8e99dffca0	\N	client-secret-jwt	master	5f05c917-b832-4ae0-bb50-30efcdb79a38	2	30	f	\N	\N
3620c70d-d4e9-421b-8587-2a9173f7804d	\N	client-x509	master	5f05c917-b832-4ae0-bb50-30efcdb79a38	2	40	f	\N	\N
b5b99c3a-5950-4421-9ea6-5503647ad170	\N	idp-review-profile	master	8cdaa08d-53de-4a8a-bba1-2ad1ca4d7d93	0	10	f	\N	0fedab36-e8be-4732-8568-3ddadf7ee47f
a140e979-c046-4aa0-9b72-87acb8e851dd	\N	\N	master	8cdaa08d-53de-4a8a-bba1-2ad1ca4d7d93	0	20	t	aa13ef21-ea84-48c7-84a2-08f30fe5fef2	\N
55f7124f-d251-4f35-acaf-7239181d2734	\N	idp-create-user-if-unique	master	aa13ef21-ea84-48c7-84a2-08f30fe5fef2	2	10	f	\N	1296f916-f1ef-4a11-ab3a-01cf29d4c2da
e0fa926f-2a35-4b60-8d4d-bd631aceee64	\N	\N	master	aa13ef21-ea84-48c7-84a2-08f30fe5fef2	2	20	t	0261ec5b-2342-4689-a949-f0d6980c9e9e	\N
56937073-ab61-4dec-8385-f7f82008bae1	\N	idp-confirm-link	master	0261ec5b-2342-4689-a949-f0d6980c9e9e	0	10	f	\N	\N
872aa079-7d29-4c1a-996e-22885e7870a7	\N	\N	master	0261ec5b-2342-4689-a949-f0d6980c9e9e	0	20	t	08309708-cccc-478f-9502-52272095350b	\N
9e10aa95-44fc-4fbf-a9e4-8558241985ab	\N	idp-email-verification	master	08309708-cccc-478f-9502-52272095350b	2	10	f	\N	\N
3ab96768-f9a3-4078-ba20-1cafe43677b8	\N	\N	master	08309708-cccc-478f-9502-52272095350b	2	20	t	b3cc3a3c-0dd6-45f9-8bbd-55c1a6518bc3	\N
137c0cd5-063b-4963-b152-3f5acd55e187	\N	idp-username-password-form	master	b3cc3a3c-0dd6-45f9-8bbd-55c1a6518bc3	0	10	f	\N	\N
17eff631-5873-4bc8-925e-194e2b384daf	\N	\N	master	b3cc3a3c-0dd6-45f9-8bbd-55c1a6518bc3	1	20	t	18ecc4ef-79df-4f54-a3de-df1ec7a42c43	\N
2fbf5457-ef21-4dbb-ba7c-56daf390106e	\N	conditional-user-configured	master	18ecc4ef-79df-4f54-a3de-df1ec7a42c43	0	10	f	\N	\N
5a03ae5f-18a7-45f2-b463-2b7615f2b45d	\N	auth-otp-form	master	18ecc4ef-79df-4f54-a3de-df1ec7a42c43	0	20	f	\N	\N
fef9ac5a-d0ca-4ba3-8bb8-86d0e9c300a1	\N	http-basic-authenticator	master	9710f0bc-e545-4e65-9415-f4a9fe91b02d	0	10	f	\N	\N
4aa47d71-6275-4da8-9028-c594055ff6e4	\N	docker-http-basic-authenticator	master	628cf4f3-619b-4250-a06a-8f2713b9e492	0	10	f	\N	\N
1dee6601-6a7b-4fcf-a173-1f7303eb44ea	\N	no-cookie-redirect	master	9389d255-905e-46fc-a598-edfeee07419f	0	10	f	\N	\N
9a2d4f3d-ffdb-4c43-bfca-fd11e181db17	\N	\N	master	9389d255-905e-46fc-a598-edfeee07419f	0	20	t	1515a81a-1304-4851-9a0f-cf819f551710	\N
ba657967-bc8f-495d-83a4-b212ac63094b	\N	basic-auth	master	1515a81a-1304-4851-9a0f-cf819f551710	0	10	f	\N	\N
911fa21c-1bd6-42a1-b85a-fe89a6a1f164	\N	basic-auth-otp	master	1515a81a-1304-4851-9a0f-cf819f551710	3	20	f	\N	\N
51e913af-25e2-495d-9cf1-d99be7c0ffee	\N	auth-spnego	master	1515a81a-1304-4851-9a0f-cf819f551710	3	30	f	\N	\N
da34e33e-c924-4cf6-9e5b-dae3b0604b5f	\N	auth-cookie	libstack-test	3a720e53-b21f-463c-83ad-bf7b97057ae4	2	10	f	\N	\N
bb032b98-c0ee-47c5-925e-cc44f385ee13	\N	auth-spnego	libstack-test	3a720e53-b21f-463c-83ad-bf7b97057ae4	3	20	f	\N	\N
9866b1ca-fc00-4c52-a712-4a6b1ec506d0	\N	identity-provider-redirector	libstack-test	3a720e53-b21f-463c-83ad-bf7b97057ae4	2	25	f	\N	\N
ab673459-fd68-43a7-9504-1dedcc42a097	\N	\N	libstack-test	3a720e53-b21f-463c-83ad-bf7b97057ae4	2	30	t	1e747663-7ec7-46af-85b2-ece567bc23e8	\N
50789578-2995-4566-9f8c-93be8d6f1abd	\N	auth-username-password-form	libstack-test	1e747663-7ec7-46af-85b2-ece567bc23e8	0	10	f	\N	\N
75e4350b-d48b-4117-b648-25a1bde81706	\N	\N	libstack-test	1e747663-7ec7-46af-85b2-ece567bc23e8	1	20	t	d3b9b91f-bbbc-48ba-89f0-73dc142eacf6	\N
03959ae4-01cb-4019-9f78-b39629fe92e5	\N	conditional-user-configured	libstack-test	d3b9b91f-bbbc-48ba-89f0-73dc142eacf6	0	10	f	\N	\N
d7580042-6ede-43e5-9397-3df9162dc529	\N	auth-otp-form	libstack-test	d3b9b91f-bbbc-48ba-89f0-73dc142eacf6	0	20	f	\N	\N
8412d80c-49d9-42f2-903e-5f43e66632f7	\N	direct-grant-validate-username	libstack-test	d2a8385c-48de-46a7-b0ba-1612658a3ed8	0	10	f	\N	\N
770f611b-a999-423d-8424-5cffb25b93c6	\N	direct-grant-validate-password	libstack-test	d2a8385c-48de-46a7-b0ba-1612658a3ed8	0	20	f	\N	\N
7fbd3cf4-f9c1-4f61-8c5e-8e3290dbea3b	\N	\N	libstack-test	d2a8385c-48de-46a7-b0ba-1612658a3ed8	1	30	t	3c96f588-9dc4-4baa-80b3-44266c753178	\N
f22906af-5030-4cc7-bdeb-e96e72fa6f45	\N	conditional-user-configured	libstack-test	3c96f588-9dc4-4baa-80b3-44266c753178	0	10	f	\N	\N
33d950d6-ad08-4ed2-88e4-cde0da2028e5	\N	direct-grant-validate-otp	libstack-test	3c96f588-9dc4-4baa-80b3-44266c753178	0	20	f	\N	\N
f5926949-96cf-40ca-b078-b53371ec9cca	\N	registration-page-form	libstack-test	fe2a5c6d-5e4b-4e62-8e0b-791df4ce43d9	0	10	t	0e225cf3-a32b-4d65-894f-8563bd45d9a5	\N
c5ebf65a-3601-4c4c-b708-6e2779153ef3	\N	registration-user-creation	libstack-test	0e225cf3-a32b-4d65-894f-8563bd45d9a5	0	20	f	\N	\N
052c3936-be59-41c9-8098-d99b23071b67	\N	registration-profile-action	libstack-test	0e225cf3-a32b-4d65-894f-8563bd45d9a5	0	40	f	\N	\N
6e30a456-d685-437e-aab3-c6283969ebc2	\N	registration-password-action	libstack-test	0e225cf3-a32b-4d65-894f-8563bd45d9a5	0	50	f	\N	\N
8d4ff95a-96b7-4cfc-8a0b-d3881953717a	\N	registration-recaptcha-action	libstack-test	0e225cf3-a32b-4d65-894f-8563bd45d9a5	3	60	f	\N	\N
5056c86a-5507-48b6-8dee-e40e2d936ddc	\N	reset-credentials-choose-user	libstack-test	bcd5ed71-19fa-4548-a530-5f0361e8ed01	0	10	f	\N	\N
c1065a7f-9ffe-4873-868b-74c8cb77cdf8	\N	reset-credential-email	libstack-test	bcd5ed71-19fa-4548-a530-5f0361e8ed01	0	20	f	\N	\N
88c0f7c6-2072-4f3e-a82a-1ad57f682678	\N	reset-password	libstack-test	bcd5ed71-19fa-4548-a530-5f0361e8ed01	0	30	f	\N	\N
a7e043d8-7299-4853-9870-376982994729	\N	\N	libstack-test	bcd5ed71-19fa-4548-a530-5f0361e8ed01	1	40	t	2e18cdca-5d3f-4db6-bcb4-6bf2754c0e1b	\N
90fd331f-c77e-426f-970e-ae3eafcbbc04	\N	conditional-user-configured	libstack-test	2e18cdca-5d3f-4db6-bcb4-6bf2754c0e1b	0	10	f	\N	\N
c420352c-c959-495d-9942-faeb0c857deb	\N	reset-otp	libstack-test	2e18cdca-5d3f-4db6-bcb4-6bf2754c0e1b	0	20	f	\N	\N
b6d84f26-598d-4359-aa3c-2681ec1d8651	\N	client-secret	libstack-test	b178453c-ba6e-4bdb-b5ec-0eb8dfdb594e	2	10	f	\N	\N
8d0dd307-0fac-407f-ba0d-8cca0a5d120c	\N	client-jwt	libstack-test	b178453c-ba6e-4bdb-b5ec-0eb8dfdb594e	2	20	f	\N	\N
df1c4390-28b1-429b-92c7-06ae9993442b	\N	client-secret-jwt	libstack-test	b178453c-ba6e-4bdb-b5ec-0eb8dfdb594e	2	30	f	\N	\N
82662dad-4770-4b7e-bd34-dc6d5ca55346	\N	client-x509	libstack-test	b178453c-ba6e-4bdb-b5ec-0eb8dfdb594e	2	40	f	\N	\N
cd2e17e0-70da-47f1-a3b4-1a8a45862e8d	\N	idp-review-profile	libstack-test	cde95300-0f3b-4ab4-a0db-c0f7e4f6f809	0	10	f	\N	0740d4ba-1872-43d1-936d-0c892aec9858
dc6fd3c2-fa98-43a5-b63e-cd0bf394ffd9	\N	\N	libstack-test	cde95300-0f3b-4ab4-a0db-c0f7e4f6f809	0	20	t	b28c9146-8cce-4bee-9b72-1334d7352510	\N
0d92188a-71d9-42ad-810f-0140cac810fc	\N	idp-create-user-if-unique	libstack-test	b28c9146-8cce-4bee-9b72-1334d7352510	2	10	f	\N	2729949e-9be7-4926-994e-30c2899fce10
00c18b25-7ae9-4e94-b339-e9d6a34c309f	\N	\N	libstack-test	b28c9146-8cce-4bee-9b72-1334d7352510	2	20	t	40229038-5ba0-4285-9739-f3a38704012b	\N
d1e638f0-6913-401a-9bfb-369876787321	\N	idp-confirm-link	libstack-test	40229038-5ba0-4285-9739-f3a38704012b	0	10	f	\N	\N
9902ef1e-9d90-4584-9d53-0b250b30f1cc	\N	\N	libstack-test	40229038-5ba0-4285-9739-f3a38704012b	0	20	t	049c10b1-4224-45a3-ba57-f6a972ea0e7e	\N
e23cc052-7791-42a1-ad06-3573cf93dc4a	\N	idp-email-verification	libstack-test	049c10b1-4224-45a3-ba57-f6a972ea0e7e	2	10	f	\N	\N
f9c0b046-a37e-4748-ae92-97e4036ad8f6	\N	\N	libstack-test	049c10b1-4224-45a3-ba57-f6a972ea0e7e	2	20	t	32b6e79f-3515-4851-8d83-e2b49326bb7c	\N
e218af83-d82f-4086-bd12-bf147550008f	\N	idp-username-password-form	libstack-test	32b6e79f-3515-4851-8d83-e2b49326bb7c	0	10	f	\N	\N
6561da94-7f5f-4354-95cb-fe683a634999	\N	\N	libstack-test	32b6e79f-3515-4851-8d83-e2b49326bb7c	1	20	t	34345c39-5579-48b3-89ef-a739893019ac	\N
329a98c0-5c6a-4df9-aa7d-7c82cd154551	\N	conditional-user-configured	libstack-test	34345c39-5579-48b3-89ef-a739893019ac	0	10	f	\N	\N
e94424f2-6411-4cd6-8a74-0f23aedc6262	\N	auth-otp-form	libstack-test	34345c39-5579-48b3-89ef-a739893019ac	0	20	f	\N	\N
073c86e3-a54b-46be-9b84-e0148c37091b	\N	http-basic-authenticator	libstack-test	c02c30aa-a4ed-46f6-95ae-7bf4a86822e7	0	10	f	\N	\N
b3de75a2-184e-4c75-8fc6-9c759a59a50f	\N	docker-http-basic-authenticator	libstack-test	8d599221-184b-4057-8769-ed1c318eca6d	0	10	f	\N	\N
e48a0433-ab84-4a62-af46-5ed2e70ab1ba	\N	no-cookie-redirect	libstack-test	b0d34d36-6a44-4425-ab2d-1320ceb18996	0	10	f	\N	\N
896b84ba-19f7-4696-8941-3d869f8ec282	\N	\N	libstack-test	b0d34d36-6a44-4425-ab2d-1320ceb18996	0	20	t	b5d71a5a-03bf-4191-b0bf-d784e5f3bc95	\N
a4401427-03dd-40e8-8847-76edecc5bac6	\N	basic-auth	libstack-test	b5d71a5a-03bf-4191-b0bf-d784e5f3bc95	0	10	f	\N	\N
f5753c86-4d7d-4366-afef-d524750ac1c3	\N	basic-auth-otp	libstack-test	b5d71a5a-03bf-4191-b0bf-d784e5f3bc95	3	20	f	\N	\N
e8210d34-1e14-4aeb-b1b7-d4059ac6ca33	\N	auth-spnego	libstack-test	b5d71a5a-03bf-4191-b0bf-d784e5f3bc95	3	30	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
46311784-6b0a-49e0-abff-939380a1cafe	browser	browser based authentication	master	basic-flow	t	t
97adae52-39fe-405b-9d3a-98b98ad00f33	forms	Username, password, otp and other auth forms.	master	basic-flow	f	t
ee0fafa2-31dd-486b-b8fb-97a3a624cc94	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
b55f736c-b6b6-4657-88a7-b1584b274e62	direct grant	OpenID Connect Resource Owner Grant	master	basic-flow	t	t
e3f62e5c-394f-4b2e-ac35-50130e2a7b1e	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
4cfab865-f306-4b7f-86cd-0294d9cec8df	registration	registration flow	master	basic-flow	t	t
e5d672a7-efbb-4a4c-8e97-5229b3bc8031	registration form	registration form	master	form-flow	f	t
2bb6e8d6-d50e-48c3-891b-d6e5541cbb30	reset credentials	Reset credentials for a user if they forgot their password or something	master	basic-flow	t	t
583d3473-656f-4f4b-80a0-fad404eed6f7	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	master	basic-flow	f	t
5f05c917-b832-4ae0-bb50-30efcdb79a38	clients	Base authentication for clients	master	client-flow	t	t
8cdaa08d-53de-4a8a-bba1-2ad1ca4d7d93	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	master	basic-flow	t	t
aa13ef21-ea84-48c7-84a2-08f30fe5fef2	User creation or linking	Flow for the existing/non-existing user alternatives	master	basic-flow	f	t
0261ec5b-2342-4689-a949-f0d6980c9e9e	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	master	basic-flow	f	t
08309708-cccc-478f-9502-52272095350b	Account verification options	Method with which to verity the existing account	master	basic-flow	f	t
b3cc3a3c-0dd6-45f9-8bbd-55c1a6518bc3	Verify Existing Account by Re-authentication	Reauthentication of existing account	master	basic-flow	f	t
18ecc4ef-79df-4f54-a3de-df1ec7a42c43	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
9710f0bc-e545-4e65-9415-f4a9fe91b02d	saml ecp	SAML ECP Profile Authentication Flow	master	basic-flow	t	t
628cf4f3-619b-4250-a06a-8f2713b9e492	docker auth	Used by Docker clients to authenticate against the IDP	master	basic-flow	t	t
9389d255-905e-46fc-a598-edfeee07419f	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	master	basic-flow	t	t
1515a81a-1304-4851-9a0f-cf819f551710	Authentication Options	Authentication options.	master	basic-flow	f	t
3a720e53-b21f-463c-83ad-bf7b97057ae4	browser	browser based authentication	libstack-test	basic-flow	t	t
1e747663-7ec7-46af-85b2-ece567bc23e8	forms	Username, password, otp and other auth forms.	libstack-test	basic-flow	f	t
d3b9b91f-bbbc-48ba-89f0-73dc142eacf6	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	libstack-test	basic-flow	f	t
d2a8385c-48de-46a7-b0ba-1612658a3ed8	direct grant	OpenID Connect Resource Owner Grant	libstack-test	basic-flow	t	t
3c96f588-9dc4-4baa-80b3-44266c753178	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	libstack-test	basic-flow	f	t
fe2a5c6d-5e4b-4e62-8e0b-791df4ce43d9	registration	registration flow	libstack-test	basic-flow	t	t
0e225cf3-a32b-4d65-894f-8563bd45d9a5	registration form	registration form	libstack-test	form-flow	f	t
bcd5ed71-19fa-4548-a530-5f0361e8ed01	reset credentials	Reset credentials for a user if they forgot their password or something	libstack-test	basic-flow	t	t
2e18cdca-5d3f-4db6-bcb4-6bf2754c0e1b	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	libstack-test	basic-flow	f	t
b178453c-ba6e-4bdb-b5ec-0eb8dfdb594e	clients	Base authentication for clients	libstack-test	client-flow	t	t
cde95300-0f3b-4ab4-a0db-c0f7e4f6f809	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	libstack-test	basic-flow	t	t
b28c9146-8cce-4bee-9b72-1334d7352510	User creation or linking	Flow for the existing/non-existing user alternatives	libstack-test	basic-flow	f	t
40229038-5ba0-4285-9739-f3a38704012b	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	libstack-test	basic-flow	f	t
049c10b1-4224-45a3-ba57-f6a972ea0e7e	Account verification options	Method with which to verity the existing account	libstack-test	basic-flow	f	t
32b6e79f-3515-4851-8d83-e2b49326bb7c	Verify Existing Account by Re-authentication	Reauthentication of existing account	libstack-test	basic-flow	f	t
34345c39-5579-48b3-89ef-a739893019ac	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	libstack-test	basic-flow	f	t
c02c30aa-a4ed-46f6-95ae-7bf4a86822e7	saml ecp	SAML ECP Profile Authentication Flow	libstack-test	basic-flow	t	t
8d599221-184b-4057-8769-ed1c318eca6d	docker auth	Used by Docker clients to authenticate against the IDP	libstack-test	basic-flow	t	t
b0d34d36-6a44-4425-ab2d-1320ceb18996	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	libstack-test	basic-flow	t	t
b5d71a5a-03bf-4191-b0bf-d784e5f3bc95	Authentication Options	Authentication options.	libstack-test	basic-flow	f	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
0fedab36-e8be-4732-8568-3ddadf7ee47f	review profile config	master
1296f916-f1ef-4a11-ab3a-01cf29d4c2da	create unique user config	master
0740d4ba-1872-43d1-936d-0c892aec9858	review profile config	libstack-test
2729949e-9be7-4926-994e-30c2899fce10	create unique user config	libstack-test
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
0fedab36-e8be-4732-8568-3ddadf7ee47f	missing	update.profile.on.first.login
1296f916-f1ef-4a11-ab3a-01cf29d4c2da	false	require.password.update.after.registration
0740d4ba-1872-43d1-936d-0c892aec9858	missing	update.profile.on.first.login
2729949e-9be7-4926-994e-30c2899fce10	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled) FROM stdin;
41f7850a-c7c8-4967-8306-b1159db2d196	t	t	master-realm	0	f	11665313-705d-425a-8f57-be2fa8041f37	\N	t	\N	f	master	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f
0a536141-8431-46a7-a460-67309f864cb6	t	f	account	0	f	7bf746be-9e17-4c46-9f4b-1c8248af85db	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	t	f	broker	0	f	ebb24a45-97f2-4804-bff1-76190b781391	\N	f	\N	f	master	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f
4a0be8dd-196e-40a2-832e-d247de89160b	t	f	security-admin-console	0	t	44ac6ebe-82b0-494a-9d5e-29230869c379	/admin/master/console/	f	\N	f	master	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f
61420e54-c114-4453-94f7-6fe98a7075f6	t	f	admin-cli	0	t	05210e02-d0bb-42d1-ad36-e7c4c0bc2bfa	\N	f	\N	f	master	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t
1a5b8f72-366d-4f43-8b25-a174328287b3	t	t	libstack-test-realm	0	f	ad20f1ad-e6b0-4bc1-994d-05bd7697d8fa	\N	t	\N	f	master	\N	0	f	f	libstack-test Realm	f	client-secret	\N	\N	\N	t	f	f
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	f	realm-management	0	f	70c4dfce-c299-4a7e-a459-62b0f4f4858c	\N	t	\N	f	libstack-test	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	t	f	account	0	f	68a1a9a7-9a9f-467a-8781-7db252f17cae	/realms/libstack-test/account/	f	\N	f	libstack-test	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f
5b531888-4ae3-478d-bf7a-ad11eadf219c	t	f	broker	0	f	c3044796-c456-462b-a152-a678ff373e03	\N	f	\N	f	libstack-test	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f
70ec0242-448b-4902-a8d8-05edad4ba0c3	t	f	security-admin-console	0	t	9c12cc57-347c-426a-8300-d6f7b5119182	/admin/libstack-test/console/	f	\N	f	libstack-test	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	t	f	admin-cli	0	t	a0a1dc42-06aa-40b6-871e-ad349903f155	\N	f	\N	f	libstack-test	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t
eb347312-64e2-4ff6-89ff-0f544da6dde6	t	t	libstack	0	f	b71720d8-57d9-4d46-b7ca-7e07ae775539	\N	f	\N	f	libstack-test	openid-connect	-1	f	f	\N	t	client-secret	\N	\N	\N	f	f	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_attributes (client_id, value, name) FROM stdin;
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.server.signature
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.server.signature.keyinfo.ext
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.assertion.signature
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.client.signature
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.encrypt
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.authnstatement
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.onetimeuse.condition
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml_force_name_id_format
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.multivalued.roles
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	saml.force.post.binding
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	exclude.session.state.from.auth.response
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	tls.client.certificate.bound.access.tokens
eb347312-64e2-4ff6-89ff-0f544da6dde6	false	display.on.consent.screen
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_default_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_default_roles (client_id, role_id) FROM stdin;
0a536141-8431-46a7-a460-67309f864cb6	703444a6-2a4f-40e5-bf73-ad68f435ee22
0a536141-8431-46a7-a460-67309f864cb6	02014c5e-ba15-4e88-a6c9-143466c8f34d
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	e1eb8155-8344-46bb-b76c-1af1fc61d88b
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	6252b63a-b145-4b05-aee6-d19b9e3f00f8
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
7f94c342-de9a-4e80-9b70-8fcb05efa52b	offline_access	master	OpenID Connect built-in scope: offline_access	openid-connect
fa99a16f-3f6d-4330-a23f-9256730dd824	role_list	master	SAML role list	saml
c642cae1-5887-4459-a55c-f6ac0c128af5	profile	master	OpenID Connect built-in scope: profile	openid-connect
bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	email	master	OpenID Connect built-in scope: email	openid-connect
07c2e327-2e19-48ee-9969-7aad41094bd5	address	master	OpenID Connect built-in scope: address	openid-connect
96a61776-703d-477d-90b7-73b2dbe6ab7a	phone	master	OpenID Connect built-in scope: phone	openid-connect
e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	roles	master	OpenID Connect scope for add user roles to the access token	openid-connect
00df3752-f334-4b80-b1fb-37673fa38fd6	web-origins	master	OpenID Connect scope for add allowed web origins to the access token	openid-connect
54b63d5c-caf4-43f3-8ee1-911501a3168e	microprofile-jwt	master	Microprofile - JWT built-in scope	openid-connect
f0467d4e-099b-4002-89cb-e8c38727102d	offline_access	libstack-test	OpenID Connect built-in scope: offline_access	openid-connect
0a4586db-5629-4872-a0b3-ddb3d4a5eeab	role_list	libstack-test	SAML role list	saml
2943f901-c039-4e2e-b193-3fbd2fcad6b1	profile	libstack-test	OpenID Connect built-in scope: profile	openid-connect
e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	email	libstack-test	OpenID Connect built-in scope: email	openid-connect
7888003f-6f7b-4675-a612-0386029f7031	address	libstack-test	OpenID Connect built-in scope: address	openid-connect
3625a18f-22a1-423c-b840-602e55fd2cae	phone	libstack-test	OpenID Connect built-in scope: phone	openid-connect
a6e45681-0675-4153-9613-45bd45185d6f	roles	libstack-test	OpenID Connect scope for add user roles to the access token	openid-connect
70aad3f4-0342-4dcc-aeff-b29210ee0f99	web-origins	libstack-test	OpenID Connect scope for add allowed web origins to the access token	openid-connect
0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	microprofile-jwt	libstack-test	Microprofile - JWT built-in scope	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
7f94c342-de9a-4e80-9b70-8fcb05efa52b	true	display.on.consent.screen
7f94c342-de9a-4e80-9b70-8fcb05efa52b	${offlineAccessScopeConsentText}	consent.screen.text
fa99a16f-3f6d-4330-a23f-9256730dd824	true	display.on.consent.screen
fa99a16f-3f6d-4330-a23f-9256730dd824	${samlRoleListScopeConsentText}	consent.screen.text
c642cae1-5887-4459-a55c-f6ac0c128af5	true	display.on.consent.screen
c642cae1-5887-4459-a55c-f6ac0c128af5	${profileScopeConsentText}	consent.screen.text
c642cae1-5887-4459-a55c-f6ac0c128af5	true	include.in.token.scope
bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	true	display.on.consent.screen
bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	${emailScopeConsentText}	consent.screen.text
bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	true	include.in.token.scope
07c2e327-2e19-48ee-9969-7aad41094bd5	true	display.on.consent.screen
07c2e327-2e19-48ee-9969-7aad41094bd5	${addressScopeConsentText}	consent.screen.text
07c2e327-2e19-48ee-9969-7aad41094bd5	true	include.in.token.scope
96a61776-703d-477d-90b7-73b2dbe6ab7a	true	display.on.consent.screen
96a61776-703d-477d-90b7-73b2dbe6ab7a	${phoneScopeConsentText}	consent.screen.text
96a61776-703d-477d-90b7-73b2dbe6ab7a	true	include.in.token.scope
e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	true	display.on.consent.screen
e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	${rolesScopeConsentText}	consent.screen.text
e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	false	include.in.token.scope
00df3752-f334-4b80-b1fb-37673fa38fd6	false	display.on.consent.screen
00df3752-f334-4b80-b1fb-37673fa38fd6		consent.screen.text
00df3752-f334-4b80-b1fb-37673fa38fd6	false	include.in.token.scope
54b63d5c-caf4-43f3-8ee1-911501a3168e	false	display.on.consent.screen
54b63d5c-caf4-43f3-8ee1-911501a3168e	true	include.in.token.scope
f0467d4e-099b-4002-89cb-e8c38727102d	true	display.on.consent.screen
f0467d4e-099b-4002-89cb-e8c38727102d	${offlineAccessScopeConsentText}	consent.screen.text
0a4586db-5629-4872-a0b3-ddb3d4a5eeab	true	display.on.consent.screen
0a4586db-5629-4872-a0b3-ddb3d4a5eeab	${samlRoleListScopeConsentText}	consent.screen.text
2943f901-c039-4e2e-b193-3fbd2fcad6b1	true	display.on.consent.screen
2943f901-c039-4e2e-b193-3fbd2fcad6b1	${profileScopeConsentText}	consent.screen.text
2943f901-c039-4e2e-b193-3fbd2fcad6b1	true	include.in.token.scope
e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	true	display.on.consent.screen
e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	${emailScopeConsentText}	consent.screen.text
e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	true	include.in.token.scope
7888003f-6f7b-4675-a612-0386029f7031	true	display.on.consent.screen
7888003f-6f7b-4675-a612-0386029f7031	${addressScopeConsentText}	consent.screen.text
7888003f-6f7b-4675-a612-0386029f7031	true	include.in.token.scope
3625a18f-22a1-423c-b840-602e55fd2cae	true	display.on.consent.screen
3625a18f-22a1-423c-b840-602e55fd2cae	${phoneScopeConsentText}	consent.screen.text
3625a18f-22a1-423c-b840-602e55fd2cae	true	include.in.token.scope
a6e45681-0675-4153-9613-45bd45185d6f	true	display.on.consent.screen
a6e45681-0675-4153-9613-45bd45185d6f	${rolesScopeConsentText}	consent.screen.text
a6e45681-0675-4153-9613-45bd45185d6f	false	include.in.token.scope
70aad3f4-0342-4dcc-aeff-b29210ee0f99	false	display.on.consent.screen
70aad3f4-0342-4dcc-aeff-b29210ee0f99		consent.screen.text
70aad3f4-0342-4dcc-aeff-b29210ee0f99	false	include.in.token.scope
0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	false	display.on.consent.screen
0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
0a536141-8431-46a7-a460-67309f864cb6	fa99a16f-3f6d-4330-a23f-9256730dd824	t
61420e54-c114-4453-94f7-6fe98a7075f6	fa99a16f-3f6d-4330-a23f-9256730dd824	t
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	fa99a16f-3f6d-4330-a23f-9256730dd824	t
41f7850a-c7c8-4967-8306-b1159db2d196	fa99a16f-3f6d-4330-a23f-9256730dd824	t
4a0be8dd-196e-40a2-832e-d247de89160b	fa99a16f-3f6d-4330-a23f-9256730dd824	t
0a536141-8431-46a7-a460-67309f864cb6	c642cae1-5887-4459-a55c-f6ac0c128af5	t
0a536141-8431-46a7-a460-67309f864cb6	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	t
0a536141-8431-46a7-a460-67309f864cb6	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	t
0a536141-8431-46a7-a460-67309f864cb6	00df3752-f334-4b80-b1fb-37673fa38fd6	t
0a536141-8431-46a7-a460-67309f864cb6	7f94c342-de9a-4e80-9b70-8fcb05efa52b	f
0a536141-8431-46a7-a460-67309f864cb6	07c2e327-2e19-48ee-9969-7aad41094bd5	f
0a536141-8431-46a7-a460-67309f864cb6	96a61776-703d-477d-90b7-73b2dbe6ab7a	f
0a536141-8431-46a7-a460-67309f864cb6	54b63d5c-caf4-43f3-8ee1-911501a3168e	f
61420e54-c114-4453-94f7-6fe98a7075f6	c642cae1-5887-4459-a55c-f6ac0c128af5	t
61420e54-c114-4453-94f7-6fe98a7075f6	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	t
61420e54-c114-4453-94f7-6fe98a7075f6	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	t
61420e54-c114-4453-94f7-6fe98a7075f6	00df3752-f334-4b80-b1fb-37673fa38fd6	t
61420e54-c114-4453-94f7-6fe98a7075f6	7f94c342-de9a-4e80-9b70-8fcb05efa52b	f
61420e54-c114-4453-94f7-6fe98a7075f6	07c2e327-2e19-48ee-9969-7aad41094bd5	f
61420e54-c114-4453-94f7-6fe98a7075f6	96a61776-703d-477d-90b7-73b2dbe6ab7a	f
61420e54-c114-4453-94f7-6fe98a7075f6	54b63d5c-caf4-43f3-8ee1-911501a3168e	f
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	c642cae1-5887-4459-a55c-f6ac0c128af5	t
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	t
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	t
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	00df3752-f334-4b80-b1fb-37673fa38fd6	t
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	7f94c342-de9a-4e80-9b70-8fcb05efa52b	f
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	07c2e327-2e19-48ee-9969-7aad41094bd5	f
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	96a61776-703d-477d-90b7-73b2dbe6ab7a	f
4fc4d101-7e00-401f-a8b6-0b58a8e156b3	54b63d5c-caf4-43f3-8ee1-911501a3168e	f
41f7850a-c7c8-4967-8306-b1159db2d196	c642cae1-5887-4459-a55c-f6ac0c128af5	t
41f7850a-c7c8-4967-8306-b1159db2d196	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	t
41f7850a-c7c8-4967-8306-b1159db2d196	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	t
41f7850a-c7c8-4967-8306-b1159db2d196	00df3752-f334-4b80-b1fb-37673fa38fd6	t
41f7850a-c7c8-4967-8306-b1159db2d196	7f94c342-de9a-4e80-9b70-8fcb05efa52b	f
41f7850a-c7c8-4967-8306-b1159db2d196	07c2e327-2e19-48ee-9969-7aad41094bd5	f
41f7850a-c7c8-4967-8306-b1159db2d196	96a61776-703d-477d-90b7-73b2dbe6ab7a	f
41f7850a-c7c8-4967-8306-b1159db2d196	54b63d5c-caf4-43f3-8ee1-911501a3168e	f
4a0be8dd-196e-40a2-832e-d247de89160b	c642cae1-5887-4459-a55c-f6ac0c128af5	t
4a0be8dd-196e-40a2-832e-d247de89160b	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	t
4a0be8dd-196e-40a2-832e-d247de89160b	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	t
4a0be8dd-196e-40a2-832e-d247de89160b	00df3752-f334-4b80-b1fb-37673fa38fd6	t
4a0be8dd-196e-40a2-832e-d247de89160b	7f94c342-de9a-4e80-9b70-8fcb05efa52b	f
4a0be8dd-196e-40a2-832e-d247de89160b	07c2e327-2e19-48ee-9969-7aad41094bd5	f
4a0be8dd-196e-40a2-832e-d247de89160b	96a61776-703d-477d-90b7-73b2dbe6ab7a	f
4a0be8dd-196e-40a2-832e-d247de89160b	54b63d5c-caf4-43f3-8ee1-911501a3168e	f
1a5b8f72-366d-4f43-8b25-a174328287b3	fa99a16f-3f6d-4330-a23f-9256730dd824	t
1a5b8f72-366d-4f43-8b25-a174328287b3	c642cae1-5887-4459-a55c-f6ac0c128af5	t
1a5b8f72-366d-4f43-8b25-a174328287b3	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	t
1a5b8f72-366d-4f43-8b25-a174328287b3	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	t
1a5b8f72-366d-4f43-8b25-a174328287b3	00df3752-f334-4b80-b1fb-37673fa38fd6	t
1a5b8f72-366d-4f43-8b25-a174328287b3	7f94c342-de9a-4e80-9b70-8fcb05efa52b	f
1a5b8f72-366d-4f43-8b25-a174328287b3	07c2e327-2e19-48ee-9969-7aad41094bd5	f
1a5b8f72-366d-4f43-8b25-a174328287b3	96a61776-703d-477d-90b7-73b2dbe6ab7a	f
1a5b8f72-366d-4f43-8b25-a174328287b3	54b63d5c-caf4-43f3-8ee1-911501a3168e	f
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	0a4586db-5629-4872-a0b3-ddb3d4a5eeab	t
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	0a4586db-5629-4872-a0b3-ddb3d4a5eeab	t
5b531888-4ae3-478d-bf7a-ad11eadf219c	0a4586db-5629-4872-a0b3-ddb3d4a5eeab	t
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	0a4586db-5629-4872-a0b3-ddb3d4a5eeab	t
70ec0242-448b-4902-a8d8-05edad4ba0c3	0a4586db-5629-4872-a0b3-ddb3d4a5eeab	t
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	2943f901-c039-4e2e-b193-3fbd2fcad6b1	t
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	t
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	a6e45681-0675-4153-9613-45bd45185d6f	t
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	70aad3f4-0342-4dcc-aeff-b29210ee0f99	t
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	f0467d4e-099b-4002-89cb-e8c38727102d	f
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	7888003f-6f7b-4675-a612-0386029f7031	f
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	3625a18f-22a1-423c-b840-602e55fd2cae	f
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	f
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	2943f901-c039-4e2e-b193-3fbd2fcad6b1	t
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	t
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	a6e45681-0675-4153-9613-45bd45185d6f	t
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	70aad3f4-0342-4dcc-aeff-b29210ee0f99	t
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	f0467d4e-099b-4002-89cb-e8c38727102d	f
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	7888003f-6f7b-4675-a612-0386029f7031	f
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	3625a18f-22a1-423c-b840-602e55fd2cae	f
7733eb3e-0f0c-4878-aa66-fb7de5387d0e	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	f
5b531888-4ae3-478d-bf7a-ad11eadf219c	2943f901-c039-4e2e-b193-3fbd2fcad6b1	t
5b531888-4ae3-478d-bf7a-ad11eadf219c	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	t
5b531888-4ae3-478d-bf7a-ad11eadf219c	a6e45681-0675-4153-9613-45bd45185d6f	t
5b531888-4ae3-478d-bf7a-ad11eadf219c	70aad3f4-0342-4dcc-aeff-b29210ee0f99	t
5b531888-4ae3-478d-bf7a-ad11eadf219c	f0467d4e-099b-4002-89cb-e8c38727102d	f
5b531888-4ae3-478d-bf7a-ad11eadf219c	7888003f-6f7b-4675-a612-0386029f7031	f
5b531888-4ae3-478d-bf7a-ad11eadf219c	3625a18f-22a1-423c-b840-602e55fd2cae	f
5b531888-4ae3-478d-bf7a-ad11eadf219c	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	f
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	2943f901-c039-4e2e-b193-3fbd2fcad6b1	t
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	t
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	a6e45681-0675-4153-9613-45bd45185d6f	t
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	70aad3f4-0342-4dcc-aeff-b29210ee0f99	t
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	f0467d4e-099b-4002-89cb-e8c38727102d	f
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	7888003f-6f7b-4675-a612-0386029f7031	f
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	3625a18f-22a1-423c-b840-602e55fd2cae	f
ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	f
70ec0242-448b-4902-a8d8-05edad4ba0c3	2943f901-c039-4e2e-b193-3fbd2fcad6b1	t
70ec0242-448b-4902-a8d8-05edad4ba0c3	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	t
70ec0242-448b-4902-a8d8-05edad4ba0c3	a6e45681-0675-4153-9613-45bd45185d6f	t
70ec0242-448b-4902-a8d8-05edad4ba0c3	70aad3f4-0342-4dcc-aeff-b29210ee0f99	t
70ec0242-448b-4902-a8d8-05edad4ba0c3	f0467d4e-099b-4002-89cb-e8c38727102d	f
70ec0242-448b-4902-a8d8-05edad4ba0c3	7888003f-6f7b-4675-a612-0386029f7031	f
70ec0242-448b-4902-a8d8-05edad4ba0c3	3625a18f-22a1-423c-b840-602e55fd2cae	f
70ec0242-448b-4902-a8d8-05edad4ba0c3	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	f
eb347312-64e2-4ff6-89ff-0f544da6dde6	0a4586db-5629-4872-a0b3-ddb3d4a5eeab	t
eb347312-64e2-4ff6-89ff-0f544da6dde6	2943f901-c039-4e2e-b193-3fbd2fcad6b1	t
eb347312-64e2-4ff6-89ff-0f544da6dde6	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	t
eb347312-64e2-4ff6-89ff-0f544da6dde6	a6e45681-0675-4153-9613-45bd45185d6f	t
eb347312-64e2-4ff6-89ff-0f544da6dde6	70aad3f4-0342-4dcc-aeff-b29210ee0f99	t
eb347312-64e2-4ff6-89ff-0f544da6dde6	f0467d4e-099b-4002-89cb-e8c38727102d	f
eb347312-64e2-4ff6-89ff-0f544da6dde6	7888003f-6f7b-4675-a612-0386029f7031	f
eb347312-64e2-4ff6-89ff-0f544da6dde6	3625a18f-22a1-423c-b840-602e55fd2cae	f
eb347312-64e2-4ff6-89ff-0f544da6dde6	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
7f94c342-de9a-4e80-9b70-8fcb05efa52b	1080c26c-1edb-4bf3-bbf2-7858ba751ebd
f0467d4e-099b-4002-89cb-e8c38727102d	7c6d1c8f-5f08-4a4f-98e7-c0b6bb4d17ef
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
94f358e3-0971-43ea-99d6-2820208765c3	Trusted Hosts	master	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
769cd033-3357-45da-8fa6-286592e706ce	Consent Required	master	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
005f5de7-b4c2-4d89-b6e5-a40720c2dc7a	Full Scope Disabled	master	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
9d3e3dcf-06d5-4901-b9a1-008a293df73b	Max Clients Limit	master	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
3eded17d-0746-4c56-b02f-ca3d597998d7	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
d12d6ade-a49d-4503-93ac-f213b11be750	Allowed Client Scopes	master	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
64aa4a2f-0630-4f33-9d02-f34cb1a56404	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
6e60d81b-b78d-4477-9cbd-18fe45e6ccc6	Allowed Client Scopes	master	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
91846d02-e435-45d5-831b-f7071aadb27a	rsa-generated	master	rsa-generated	org.keycloak.keys.KeyProvider	master	\N
8012c93e-702a-473b-a01f-008419e33158	hmac-generated	master	hmac-generated	org.keycloak.keys.KeyProvider	master	\N
a0972eea-d65d-4b5c-ae33-c588a73965da	aes-generated	master	aes-generated	org.keycloak.keys.KeyProvider	master	\N
658819d7-af21-4d21-b45a-91ed9563b1c3	rsa-generated	libstack-test	rsa-generated	org.keycloak.keys.KeyProvider	libstack-test	\N
8f60880f-9570-4e7f-bdb7-9a03434bd9cd	hmac-generated	libstack-test	hmac-generated	org.keycloak.keys.KeyProvider	libstack-test	\N
6ad8daa8-6c84-4cc5-ab8e-1dca847db97e	aes-generated	libstack-test	aes-generated	org.keycloak.keys.KeyProvider	libstack-test	\N
35b8258c-6074-41e0-a25f-fc419e849e90	Trusted Hosts	libstack-test	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	libstack-test	anonymous
a22022e3-6752-4fef-bbf2-8ae99b5b890d	Consent Required	libstack-test	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	libstack-test	anonymous
87566d4d-cc21-4f17-939c-049caeac7cbe	Full Scope Disabled	libstack-test	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	libstack-test	anonymous
5212eace-f44b-4f67-87e4-c1acd686d84f	Max Clients Limit	libstack-test	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	libstack-test	anonymous
eebb4b64-c6ba-4c06-a1a5-1473479df4df	Allowed Protocol Mapper Types	libstack-test	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	libstack-test	anonymous
4240f5fa-c9e2-49b2-b122-00facf4dbac0	Allowed Client Scopes	libstack-test	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	libstack-test	anonymous
e98c9a3b-0774-4365-93a8-1aa63b6e4697	Allowed Protocol Mapper Types	libstack-test	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	libstack-test	authenticated
255a5b6e-5590-4096-9a20-b991a4dc74ed	Allowed Client Scopes	libstack-test	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	libstack-test	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
c80324aa-96e5-4484-9ace-e8423852f3eb	64aa4a2f-0630-4f33-9d02-f34cb1a56404	allowed-protocol-mapper-types	saml-role-list-mapper
75af6fbd-08cf-4fd9-8cfb-b2a2f6effb93	64aa4a2f-0630-4f33-9d02-f34cb1a56404	allowed-protocol-mapper-types	oidc-full-name-mapper
22138d0f-9456-4dfc-9360-c7eab18e82d5	64aa4a2f-0630-4f33-9d02-f34cb1a56404	allowed-protocol-mapper-types	oidc-address-mapper
ae805380-661c-42e6-b679-37cf90c7e18e	64aa4a2f-0630-4f33-9d02-f34cb1a56404	allowed-protocol-mapper-types	saml-user-property-mapper
45f6d0c8-d8d7-43c7-b0c8-7054f1f49dc4	64aa4a2f-0630-4f33-9d02-f34cb1a56404	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
b61afbab-fe3e-4961-98dd-473d0b4b8657	64aa4a2f-0630-4f33-9d02-f34cb1a56404	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
1bdea005-101d-4dd6-b913-64bc5bdfe3f6	64aa4a2f-0630-4f33-9d02-f34cb1a56404	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
27406c12-4a72-4dac-b3a1-c7dff6b68cb9	64aa4a2f-0630-4f33-9d02-f34cb1a56404	allowed-protocol-mapper-types	saml-user-attribute-mapper
f29fdb5a-34fa-447d-a2ba-23f7b7f065f3	9d3e3dcf-06d5-4901-b9a1-008a293df73b	max-clients	200
23144fe0-cb7d-4d9d-a629-6eb761330500	94f358e3-0971-43ea-99d6-2820208765c3	host-sending-registration-request-must-match	true
a6c7afb3-d6b6-4645-a7e1-5c09ed303df6	94f358e3-0971-43ea-99d6-2820208765c3	client-uris-must-match	true
9fb62be8-3b23-4758-a7f8-835e93d5ef4e	6e60d81b-b78d-4477-9cbd-18fe45e6ccc6	allow-default-scopes	true
e3dfed6c-7f4d-4777-a2be-62da6ed14175	3eded17d-0746-4c56-b02f-ca3d597998d7	allowed-protocol-mapper-types	oidc-full-name-mapper
7de4c734-b495-4960-8717-32e25f24869c	3eded17d-0746-4c56-b02f-ca3d597998d7	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
b316b6a9-e09c-43f7-96c0-90be0b00afa6	3eded17d-0746-4c56-b02f-ca3d597998d7	allowed-protocol-mapper-types	oidc-address-mapper
3f2e8e9d-bef4-4ed8-b626-7abc4fc7aff8	3eded17d-0746-4c56-b02f-ca3d597998d7	allowed-protocol-mapper-types	saml-user-attribute-mapper
d7d497b6-5e08-4bbc-b560-6c936628d3a0	3eded17d-0746-4c56-b02f-ca3d597998d7	allowed-protocol-mapper-types	saml-role-list-mapper
83cacef9-999e-4824-ba84-d198d6bc403b	3eded17d-0746-4c56-b02f-ca3d597998d7	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
6743afa3-2b83-4b84-978c-bfe91f2104cf	3eded17d-0746-4c56-b02f-ca3d597998d7	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
352cc0f8-63bf-4c99-bae3-0b0130ef5964	3eded17d-0746-4c56-b02f-ca3d597998d7	allowed-protocol-mapper-types	saml-user-property-mapper
b4dec9d9-46d8-4e6b-8c0f-9003acc107cc	d12d6ade-a49d-4503-93ac-f213b11be750	allow-default-scopes	true
fa07a204-847e-46fc-b08a-34e6d44eb6f6	a0972eea-d65d-4b5c-ae33-c588a73965da	priority	100
d4d1160f-2f77-4e22-9202-b25dbe33d275	a0972eea-d65d-4b5c-ae33-c588a73965da	kid	add0181b-9d4c-4e13-b2aa-fd1e6362b995
1ada1d88-a2a7-4e47-b1c5-f9ca2dd9a00f	a0972eea-d65d-4b5c-ae33-c588a73965da	secret	sruLER9AUG21BmSOgOU8hw
c01157ec-809e-4986-854b-97b8f621d35a	8012c93e-702a-473b-a01f-008419e33158	priority	100
8a50dd80-6874-4b7b-9f5a-eba3a674776d	8012c93e-702a-473b-a01f-008419e33158	secret	cUQfFY0pXBg_I3GH2YJ2I5jFzePeEAnfJaDjCOeTDqrhZvE0sZHHQflLpbaBsCIwfbJobZCrToNysf_VUMARkQ
11f12501-4428-4af2-aa17-09a2be1cffba	8012c93e-702a-473b-a01f-008419e33158	kid	51ce90d7-fbf6-4283-92e5-6990189d1a3b
c36153b5-177e-4ed2-83f5-1729a8338f59	8012c93e-702a-473b-a01f-008419e33158	algorithm	HS256
d13f184a-3360-4b85-a9b3-8d425a27b75e	91846d02-e435-45d5-831b-f7071aadb27a	privateKey	MIIEowIBAAKCAQEA0FgkzIsQDw4IObJrQuHZeUauAAsTJR6a2EzUt0klmUxJGnI+t3XIw2GJMQaZuEyNY7qjAgv+fRdJm0XtqxXIOjftdGQRYTfs9UhdkuM1bZlPschPpEc4mEBgEsMhy4Bjv6Tr0kxsY7MOmLF89U211Oe2zWx/WH/HYpZYNl/TaDLAM/JK+0pRmTb7OD15vTw9cFp81Owa2z0nlqPCsMBXNLtDfXjPT/s2zYdgpxur1d3/VWIafO6u/bYL/pWlhIjK9V6k18shNHT/VTzxV9rHnC2lnX15pqLw800ucI5PdWGA4RViyt+XZ/gfsHvnZmuriKnN/evAkBj47Kdxl3IoUQIDAQABAoIBAAfzZSwdHnbEnVG+WlOKFOeI5/j+czOWcGhSvkdkVjf8bknBFF2h9BBot3iUfOdInJiytafNV1/ktJ1lVMWTpjl6iuhHLVadcMCHi3KgkxhkomLxdwCY6zL8Oe5dXfvLIYNdwtYaroQ7gBIZq+AcoBTI5vP98PoqnixH+oPQsluminIXFse/+v6DnojUjElbmhZULo9bIljHRKR6Ig5OgcWP0DNUpL1hOOdXnPdnEzsLfqos2zdSkjePG2BrNqTtoBZwtCxDAA7iLi8YgkwfS5LcMvlKa2lgd7fLdU9SKrq5advn9NTg1C1zmdZiLsoBC4I0cvs/DM11OFwdBMcmnUECgYEA/0MewCOHVJv8x2Xn28sxZTnwqUSbJkZnOLWh5aAVML03myrLx4IOU/uGJmqP3EXqyOyWXxBUNrT1AHphB1ssofEzWWHOSOR0JTZYywlV07FAfZr9KT/m7xMUf07miLVrUGwvDtjzoiHajuGOSCWkbQ1ONDHlZxm57SvFSpW+RmkCgYEA0PJOl1jcZkQZcUscFEg9d32Gf5MCRY5tLT3esye+fPQGfyjt6z5r/KjNtZPaqjBf8pQ+vl/UjfiS4zxKASDWK6vAkuk566uXG7Rd6qtMYR5vrltpNh2pkq/j0VeMv5iJ76Fx3sLE2epSdKlCDPZ7jFn+OvD5I+BptbzaSCdUpakCgYEA8AV1DMZbojtq3TP9aLcPo1dv7DoOiVb6CGEB8qEsS8AgYU9EfjzUrDN+WPEqhL1Zn8SXQJxiE27kUabBReF9fmkHF6zYA8KNU9BefcwxX/Tz5yetlPP5eiQ+ydau/y1X0y9msFdf/7xFfsSovT5n9gLk3j9srh2KrnDR+ugDGsECgYBf56gdHcNkCUPoVYJY6OOVsf8HFXIIfRwtlOVgNBDiB5vnx+CUhn1IZi6tdmT6kuOnU1YNSa0lUQAS3vxU0j6bouTsSbK1MnhUVhB5gxC2zyKR1BFRroHD+4nE77uBwcEmRWMfzSRPpZcdRwczLft9a10erracOggrS7ihP7RBqQKBgGNEnnRwHvkCVJxR+NedDLNigUNPTcrx1MQHxS4gPgeyifn53EtxqDQUs4he0t4vRbJqlJks0PpQNoPLsAMZl80HuxeVEuGT63PlZwa9tN+uvdPc5H2oNvspjJmONx1kERvpHRId3M878HW5wOXHMyElIazy8N5utz31546NiW4J
f2a23700-2a7a-4391-a620-7e672a923602	91846d02-e435-45d5-831b-f7071aadb27a	priority	100
b4ce4643-0b13-4ae4-bc36-480dd68b415c	91846d02-e435-45d5-831b-f7071aadb27a	certificate	MIICmzCCAYMCBgFu8WuSqDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMTkxMjEwMjAwNDQ5WhcNMjkxMjEwMjAwNjI5WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQWCTMixAPDgg5smtC4dl5Rq4ACxMlHprYTNS3SSWZTEkacj63dcjDYYkxBpm4TI1juqMCC/59F0mbRe2rFcg6N+10ZBFhN+z1SF2S4zVtmU+xyE+kRziYQGASwyHLgGO/pOvSTGxjsw6YsXz1TbXU57bNbH9Yf8dillg2X9NoMsAz8kr7SlGZNvs4PXm9PD1wWnzU7BrbPSeWo8KwwFc0u0N9eM9P+zbNh2CnG6vV3f9VYhp87q79tgv+laWEiMr1XqTXyyE0dP9VPPFX2secLaWdfXmmovDzTS5wjk91YYDhFWLK35dn+B+we+dma6uIqc3968CQGPjsp3GXcihRAgMBAAEwDQYJKoZIhvcNAQELBQADggEBADzaonq7oyOCx5kZWjOsbo1Y5mMjSuemS7gmE+FvN/bO0Wmg7dxO2mczR6uoCpJsIM2I5ArLq5zwNQSCAJ9Z9Hm1IHFiOEavMRbpAOPyM/jFBv9GECyYe0SKPTpcYhmTFkERgka3Y/38PxFTXSTf0avB71P6zUK01SVCRIfGWUxiWvS+7KP+xpBzpVyYqV2stfBGpLoyQSh67+GgpBRehibFRLwdqAbneydKsLevvVDl+Mp1BDG3P7z+2gbybfPIVTXnH/GXr/HOCiYvZZSt7FdQxX+wpCovXWaIPPzSxLX8MmsKeK/ErpCxqczB1ccgYYZ5hEOLYNJ0a0+p5kZ8nNs=
b1c0b7f8-9087-4b12-9587-c0ce5f09f290	6ad8daa8-6c84-4cc5-ab8e-1dca847db97e	kid	5ffe3efe-bcda-440a-b04a-0760fe0035dc
efde5f9d-0fda-4286-934a-9fb4b19e6a79	6ad8daa8-6c84-4cc5-ab8e-1dca847db97e	secret	khpsspDQrN3e4pRST9K9qQ
c8c420f2-77d9-4ddb-8fa9-cbcd6201a134	6ad8daa8-6c84-4cc5-ab8e-1dca847db97e	priority	100
7759e9d1-d840-48e6-9901-51f53cd8cd4a	8f60880f-9570-4e7f-bdb7-9a03434bd9cd	priority	100
6be79d56-df80-4f5a-9190-f6c54556e9ad	8f60880f-9570-4e7f-bdb7-9a03434bd9cd	secret	gbkV37oLM0UUfhh13CcnVKsZ6796s65SDKLmPmrQ_rCVKp--TAc-u7iDauJLurdXbma8d04HyVpfcTQDIkgggw
b7489d24-a8e7-4807-9874-9c56ea2c40df	8f60880f-9570-4e7f-bdb7-9a03434bd9cd	kid	6738e5bc-b12e-49a1-9d13-17aaf233b799
c80d78a4-a67f-49bc-82b1-fa077dbf4265	8f60880f-9570-4e7f-bdb7-9a03434bd9cd	algorithm	HS256
01b4c79d-6ee4-4b31-b246-a5b20c2a0fea	658819d7-af21-4d21-b45a-91ed9563b1c3	priority	100
9af000e3-52eb-4f59-847f-830ee869ac9f	658819d7-af21-4d21-b45a-91ed9563b1c3	privateKey	MIIEowIBAAKCAQEAiQAstTOfho0y10JHnywkDvwZ21UKl+DqiLXKhbVAdlvXf473WGt6Md6NmH2g+lbSANeUO4QrbvrLl+Kj7gShQyLC98UHTHnD1wCmeaWXiXBDhXJdh1m4r7vV73iMNa93RlmiWE6265b9LQYEgk+gAHjnpTNdNy1B1vazB3ZihF9Bagb0vt8S04apYj7TSXbhYFkb/wwExQgKx/aMEEbnjJSXZBZ1N3GllhFK5hg+7Ol0oyVpDj/UnzX4QM4cM1R9Nlf+IAQr2MIgE/Ip+sA4IK0hneya8Vvy12abWcJFqfiiGLChOoOaQT9vOCpy/SPE8FSk5/wX2vBlbJMXB8ZESwIDAQABAoIBAHDm9PErpubizCg7lfymCt1SgxiO/9jkYUPi1RDVq1cfHvwfXNXAVQZuCzDFL3m/PPe2sZFOveCKzGfSPhh0NlW2ewhnljk/C9bO0WLkxXpdSzfZZRybIymn2YmtRZckkF4oljLCQ9rpJqIJGIQvjIN3ICezqblEEcNOsYGP3WaKSMhPtKPDkU0ZghgG8A4Y6me5ccoofr3LRhd+GDrvqA/lKLb4vrN1sCw812+7tlUGlxcwepTQpfBGFhAb9oeOKuSfqYy51aw1Qr58agcK3VrVcLvIlLYQWdFbhjVmnq8x8pXGV8QENVHIjMHvXuRF6yc89O+3O/9d0wy3jx5j2PkCgYEAw/HZNoo4swn8gninay5V4TCB0jLLu4yyenTvULW9f8Zk94kK/5F6pCvtM2kTP5HjXID/2k/j0cJ65aahNHvV8lyluUJqFt8Xw7vjOWkFzDGQ5t4xYF1C+JxvyqvJ2grH4W+HEPL7GMzwqGXsJCkD0K/GObjRlA0h5dX8H6I2Gk8CgYEAsv16XohC+1lqwiXnBLuUxFPnOe4tp1vdZabTMEHdpzwYk25+M3t7zAdl9HUX92mjL2chFsKD6JRe3C1dbzmKgP878KdhODdyQQ/grOUSPwxRnhtTHkJMySKjFzmASmokhRJKQdiDpBH6Yk22uPLE/hApMQRh6XpO+j8ButWpw0UCgYB0Za+F0Zga6xzAGJJDfjPv4JPN3PTfhZXkXqBnDn7yb1U9IoCRDseOzLVMa+fORIiOQ+c4tWp9CY1d7J0og0O1hEnCAmzpBz+ju3IggX27LdqI+obUWrJU4wEZoPD4gJz6EvlmHSECO4PeVSVw2Zh1mGUllt+QljiDwpjR5ddDywKBgHlxRn+xUFEd4DOOZ+psI4n5q59AnTU6PUNlJ1FMv0limwIdK/9ePya1tlVgxTwXLqNRA8BfhgRd9ubI2OZIUlMn2dF0n5/27sx6K2Tjn7ercg0mWQTk0xh9Kc7uMr9KuTCYsk1uzBKcKBhexiVCgqom6OvbH1u8oq1j5paPtblJAoGBAKkYF/270veRFO0VAeICf+UDqiN+RSxZKqnXZJw1pdZBbOJUMPY5z+PUlZH6hUJqyJLBF0rRFB62uXyzFIb/F1lnMAa5ZTw8AQy6f7nQT0zVG1qyNAqpg3ZIDKPeh+dbFkQzov5UdwiVZhK/vZAvYJ4iAapOQ48KkxnZRfsLeeMb
3d8d5ced-655f-4dea-be54-2aad13597eb9	658819d7-af21-4d21-b45a-91ed9563b1c3	certificate	MIICqTCCAZECBgFu8XhZtDANBgkqhkiG9w0BAQsFADAYMRYwFAYDVQQDDA1saWJzdGFjay10ZXN0MB4XDTE5MTIxMDIwMTg0NloXDTI5MTIxMDIwMjAyNlowGDEWMBQGA1UEAwwNbGlic3RhY2stdGVzdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAIkALLUzn4aNMtdCR58sJA78GdtVCpfg6oi1yoW1QHZb13+O91hrejHejZh9oPpW0gDXlDuEK276y5fio+4EoUMiwvfFB0x5w9cApnmll4lwQ4VyXYdZuK+71e94jDWvd0ZZolhOtuuW/S0GBIJPoAB456UzXTctQdb2swd2YoRfQWoG9L7fEtOGqWI+00l24WBZG/8MBMUICsf2jBBG54yUl2QWdTdxpZYRSuYYPuzpdKMlaQ4/1J81+EDOHDNUfTZX/iAEK9jCIBPyKfrAOCCtIZ3smvFb8tdmm1nCRan4ohiwoTqDmkE/bzgqcv0jxPBUpOf8F9rwZWyTFwfGREsCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEASqXta61QgVBoACWqQRo5sZRhWIav6QMQ/Zvpelp2Fe2qGdGhRp5ioTBiPJ/oGuYLULoynSRFNJGfHtZFlNGS/WORmxWCdH8muT5sc5HRN6r3Q1xec6W8QZZjLxri9/M+ibnA+q/Zto7GLnMU4V3twibR2lbOq/QvJqq3WtrOUTcOmHR5r2H6CPiWvV3DEfYYiw3WcRijCzsGCFMW8r8LpQF+GIcWNIQk0YxKsqKJqLOViqqCeGRuEBbStJHzD/ZTpBx+NVMQ4B2qvEU21V9zD3QeNlTnBXxdRsBh3bDk14aBWvzebM2tnyV5nykGza/jRnY6NKU+FKxu+5VRXS7cCg==
53b8f8c9-5541-4df5-a1ea-c3ee5d3b4774	35b8258c-6074-41e0-a25f-fc419e849e90	client-uris-must-match	true
dd811abb-37ea-4df5-9ca6-86554cd254c4	35b8258c-6074-41e0-a25f-fc419e849e90	host-sending-registration-request-must-match	true
c74e91c4-0f88-45b6-9c76-74a26ff53dd8	e98c9a3b-0774-4365-93a8-1aa63b6e4697	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
91857962-0cfc-4049-bb09-c34584503e85	e98c9a3b-0774-4365-93a8-1aa63b6e4697	allowed-protocol-mapper-types	saml-user-attribute-mapper
4951447d-1672-4000-a449-b203c6c09b68	e98c9a3b-0774-4365-93a8-1aa63b6e4697	allowed-protocol-mapper-types	saml-role-list-mapper
d7fedeae-fc42-4419-9ead-85a93d57d74f	e98c9a3b-0774-4365-93a8-1aa63b6e4697	allowed-protocol-mapper-types	oidc-full-name-mapper
49aa70cf-5559-4539-8579-a4f18a6c95d0	e98c9a3b-0774-4365-93a8-1aa63b6e4697	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
527d6ae0-a8dc-4356-8c68-ffe8a750e770	e98c9a3b-0774-4365-93a8-1aa63b6e4697	allowed-protocol-mapper-types	saml-user-property-mapper
42f03353-efe2-4fcd-b84d-ffe3cbb6e9f7	e98c9a3b-0774-4365-93a8-1aa63b6e4697	allowed-protocol-mapper-types	oidc-address-mapper
9edd1fe9-c496-49a3-95cd-2f0fc085613d	e98c9a3b-0774-4365-93a8-1aa63b6e4697	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
0900d2ee-9371-468e-b603-64a8e35c7875	255a5b6e-5590-4096-9a20-b991a4dc74ed	allow-default-scopes	true
a2b08b1d-dd41-43fd-ab02-3158eda3dcee	5212eace-f44b-4f67-87e4-c1acd686d84f	max-clients	200
ec9a2c17-328c-4cc5-9875-27c53e8b989a	eebb4b64-c6ba-4c06-a1a5-1473479df4df	allowed-protocol-mapper-types	oidc-full-name-mapper
ae22f7fd-c945-417a-8f70-91f4a00d3d4a	eebb4b64-c6ba-4c06-a1a5-1473479df4df	allowed-protocol-mapper-types	oidc-address-mapper
5552023f-3c85-476c-9421-241de171b024	eebb4b64-c6ba-4c06-a1a5-1473479df4df	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
06b6bd78-3654-4517-b597-188f688096e8	eebb4b64-c6ba-4c06-a1a5-1473479df4df	allowed-protocol-mapper-types	saml-user-property-mapper
7e30abd7-aaa3-4e48-99ff-d75eed41200b	eebb4b64-c6ba-4c06-a1a5-1473479df4df	allowed-protocol-mapper-types	saml-role-list-mapper
061c7036-131b-42c0-be48-c61e36c6f88c	eebb4b64-c6ba-4c06-a1a5-1473479df4df	allowed-protocol-mapper-types	saml-user-attribute-mapper
d861ee29-04f6-4285-8fdf-ff0aeff154d4	eebb4b64-c6ba-4c06-a1a5-1473479df4df	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
37c05a9a-567a-4c44-9941-28dec371c8b3	eebb4b64-c6ba-4c06-a1a5-1473479df4df	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
769d270e-50a5-4a69-9d8e-e471e059200c	4240f5fa-c9e2-49b2-b122-00facf4dbac0	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.composite_role (composite, child_role) FROM stdin;
c021dbe3-97c8-4322-9198-3f5ad81a3262	d3359040-51b4-407a-be7a-718505a6cd9c
c021dbe3-97c8-4322-9198-3f5ad81a3262	c03ede1b-0648-429c-8ef2-33a1462ce1e6
c021dbe3-97c8-4322-9198-3f5ad81a3262	1e4d08ea-eb25-49ab-8823-bb47d915e4b0
c021dbe3-97c8-4322-9198-3f5ad81a3262	95991681-9101-41e7-8d68-38392fc22a97
c021dbe3-97c8-4322-9198-3f5ad81a3262	61ced7eb-78d9-4ce9-9209-e25918661b3b
c021dbe3-97c8-4322-9198-3f5ad81a3262	c873673f-f89e-4d36-8722-bbf2e183f382
c021dbe3-97c8-4322-9198-3f5ad81a3262	dcd8e4a0-f163-416b-9ef1-b1e172796475
c021dbe3-97c8-4322-9198-3f5ad81a3262	7a9857f6-d19a-4736-a4e5-2d031e1fb6fd
c021dbe3-97c8-4322-9198-3f5ad81a3262	b2bc4984-a87d-447b-8d2a-a7d1e2534595
c021dbe3-97c8-4322-9198-3f5ad81a3262	5798388f-422a-486b-9ec5-3e9b640512f4
c021dbe3-97c8-4322-9198-3f5ad81a3262	eb2fb949-9589-4ec8-82b2-45f6bf5a1b24
c021dbe3-97c8-4322-9198-3f5ad81a3262	ee3d9798-14fb-4b46-8385-11ad9e2efbf0
c021dbe3-97c8-4322-9198-3f5ad81a3262	df0a1e5d-df67-4519-872e-0e9267d2884d
c021dbe3-97c8-4322-9198-3f5ad81a3262	5ae510e3-cb97-4c49-a313-6ad8d9bda3c5
c021dbe3-97c8-4322-9198-3f5ad81a3262	0a53aaeb-aea1-4304-bcf3-f4a6b16cde6d
c021dbe3-97c8-4322-9198-3f5ad81a3262	f066eff6-8c77-4250-8b56-14432aa380bf
c021dbe3-97c8-4322-9198-3f5ad81a3262	e411e6bd-d93b-4204-90d4-9923a65ac9ba
c021dbe3-97c8-4322-9198-3f5ad81a3262	bfb96aec-a583-4e98-a08a-b752123aee90
95991681-9101-41e7-8d68-38392fc22a97	0a53aaeb-aea1-4304-bcf3-f4a6b16cde6d
95991681-9101-41e7-8d68-38392fc22a97	bfb96aec-a583-4e98-a08a-b752123aee90
61ced7eb-78d9-4ce9-9209-e25918661b3b	f066eff6-8c77-4250-8b56-14432aa380bf
02014c5e-ba15-4e88-a6c9-143466c8f34d	412e738a-4e33-40ec-867b-3936eabac097
c021dbe3-97c8-4322-9198-3f5ad81a3262	91b695c3-9a2d-4248-bae0-9be901041358
c021dbe3-97c8-4322-9198-3f5ad81a3262	7422dee6-ebb9-42a1-80b4-c8a72e7110a7
c021dbe3-97c8-4322-9198-3f5ad81a3262	eefc2c49-3cf5-4331-ba83-585bda9445a2
c021dbe3-97c8-4322-9198-3f5ad81a3262	663cf08a-8aca-4219-bba1-f066d0841e28
c021dbe3-97c8-4322-9198-3f5ad81a3262	d48021fd-6838-4c05-8db4-c66cbd8e78cc
c021dbe3-97c8-4322-9198-3f5ad81a3262	e05c0706-79be-46ad-afa1-452c1db0259d
c021dbe3-97c8-4322-9198-3f5ad81a3262	c160a599-bb45-453e-9cd5-ef9117b05556
c021dbe3-97c8-4322-9198-3f5ad81a3262	231579a8-0e93-4fce-8b07-23d9147daf12
c021dbe3-97c8-4322-9198-3f5ad81a3262	18b4addf-0822-401b-a580-69ab559757de
c021dbe3-97c8-4322-9198-3f5ad81a3262	c4b5c5b9-94be-4176-898e-66ae6bd045a4
c021dbe3-97c8-4322-9198-3f5ad81a3262	d7dba609-709e-4a84-8268-d377f091d940
c021dbe3-97c8-4322-9198-3f5ad81a3262	f0cf4d85-c9f4-4198-9cc2-d918e193556b
c021dbe3-97c8-4322-9198-3f5ad81a3262	7e2a76c3-ad95-4348-a9e5-4b858d0d1db9
c021dbe3-97c8-4322-9198-3f5ad81a3262	1120c22f-d6e6-4fbe-a307-06d918112bb5
c021dbe3-97c8-4322-9198-3f5ad81a3262	3ba21bcd-84e8-4c0f-a6e9-bf0d4aaca62a
c021dbe3-97c8-4322-9198-3f5ad81a3262	bff814ce-986d-4d0c-b319-dcf78ae9b241
c021dbe3-97c8-4322-9198-3f5ad81a3262	afc6dc54-a222-4819-a0a0-9c4d63a3bdb9
c021dbe3-97c8-4322-9198-3f5ad81a3262	da8dd9b8-683d-42d0-9caf-ee57f0db6c22
663cf08a-8aca-4219-bba1-f066d0841e28	3ba21bcd-84e8-4c0f-a6e9-bf0d4aaca62a
663cf08a-8aca-4219-bba1-f066d0841e28	da8dd9b8-683d-42d0-9caf-ee57f0db6c22
d48021fd-6838-4c05-8db4-c66cbd8e78cc	bff814ce-986d-4d0c-b319-dcf78ae9b241
ab9866ce-d635-486a-a0ce-f4dbd2559025	f1dd23ca-2e93-4863-9078-4e5af7567867
ab9866ce-d635-486a-a0ce-f4dbd2559025	c75e6bb7-9dcf-491c-948e-0978c12ca51b
ab9866ce-d635-486a-a0ce-f4dbd2559025	6254574c-0745-4870-9311-1da726857d6c
ab9866ce-d635-486a-a0ce-f4dbd2559025	15a40e75-b3b7-4956-9132-0441715c2b3a
ab9866ce-d635-486a-a0ce-f4dbd2559025	c8f07c62-3ff0-4cd7-851e-ef2f0b49d3d7
ab9866ce-d635-486a-a0ce-f4dbd2559025	06fe59c2-d661-422a-a829-785e79a53c21
ab9866ce-d635-486a-a0ce-f4dbd2559025	d9188779-ff57-46d8-9f23-17cfe22b6121
ab9866ce-d635-486a-a0ce-f4dbd2559025	6295f867-2016-4e93-9f1f-58c51f580001
ab9866ce-d635-486a-a0ce-f4dbd2559025	165597b6-f1a7-4198-a336-2cd230f1b5e7
ab9866ce-d635-486a-a0ce-f4dbd2559025	73798b9e-0c83-4e4a-93da-6f9a407d221d
ab9866ce-d635-486a-a0ce-f4dbd2559025	a3f1f832-b14e-4586-bc11-75f539006eb4
ab9866ce-d635-486a-a0ce-f4dbd2559025	ff553bf5-25c1-4955-b881-c527a8b54eb8
ab9866ce-d635-486a-a0ce-f4dbd2559025	17d26268-42f2-4c1d-9f1e-168b9e156a3c
ab9866ce-d635-486a-a0ce-f4dbd2559025	b9cf9521-8ece-4c96-9bf1-2d3dd50638c1
ab9866ce-d635-486a-a0ce-f4dbd2559025	5de009b4-6947-44ff-be7f-c01a3bd973f3
ab9866ce-d635-486a-a0ce-f4dbd2559025	b055464c-193f-44b3-aa51-b8e1582a6687
ab9866ce-d635-486a-a0ce-f4dbd2559025	2b0b6515-c0ef-4c00-900d-f27671b5021a
6254574c-0745-4870-9311-1da726857d6c	2b0b6515-c0ef-4c00-900d-f27671b5021a
6254574c-0745-4870-9311-1da726857d6c	b9cf9521-8ece-4c96-9bf1-2d3dd50638c1
15a40e75-b3b7-4956-9132-0441715c2b3a	5de009b4-6947-44ff-be7f-c01a3bd973f3
c021dbe3-97c8-4322-9198-3f5ad81a3262	ad916223-4bcb-406f-9d80-6d3cec533d6d
6252b63a-b145-4b05-aee6-d19b9e3f00f8	7ab30215-b46e-4e59-98e3-c5e450374695
ab9866ce-d635-486a-a0ce-f4dbd2559025	7c19bfd4-0813-4f64-ba12-57e2bc51431c
7ab9c608-d338-49bc-ac85-675b60db4b68	bca22a2a-8b1d-4d7a-be73-522c60b12377
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
51473aaa-e0dc-4bcd-965b-a872474531fe	\N	password	ffa86902-bac5-427d-8565-676476629599	1576008389706	\N	{"value":"1QXpFrcAdhy6+4wkYFVoGfSbLObYMo/XRK6m8upsFjCgPQ6YqbBq4/4ipbVKMuq28I44wZKGtlccam5z/FEpiA==","salt":"OHUSjhIF6SnlQm0/EsHfeg=="}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256"}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2019-12-10 20:06:22.911007	1	EXECUTED	7:4e70412f24a3f382c82183742ec79317	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	6008382499
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2019-12-10 20:06:22.941044	2	MARK_RAN	7:cb16724583e9675711801c6875114f28	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	6008382499
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2019-12-10 20:06:22.981515	3	EXECUTED	7:0310eb8ba07cec616460794d42ade0fa	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	3.5.4	\N	\N	6008382499
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2019-12-10 20:06:22.984864	4	EXECUTED	7:5d25857e708c3233ef4439df1f93f012	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	6008382499
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2019-12-10 20:06:23.061172	5	EXECUTED	7:c7a54a1041d58eb3817a4a883b4d4e84	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	6008382499
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2019-12-10 20:06:23.065733	6	MARK_RAN	7:2e01012df20974c1c2a605ef8afe25b7	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	6008382499
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2019-12-10 20:06:23.295551	7	EXECUTED	7:0f08df48468428e0f30ee59a8ec01a41	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	6008382499
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2019-12-10 20:06:23.299462	8	MARK_RAN	7:a77ea2ad226b345e7d689d366f185c8c	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	6008382499
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2019-12-10 20:06:23.307364	9	EXECUTED	7:a3377a2059aefbf3b90ebb4c4cc8e2ab	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	3.5.4	\N	\N	6008382499
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2019-12-10 20:06:23.411518	10	EXECUTED	7:04c1dbedc2aa3e9756d1a1668e003451	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	3.5.4	\N	\N	6008382499
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2019-12-10 20:06:23.452532	11	EXECUTED	7:36ef39ed560ad07062d956db861042ba	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	6008382499
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2019-12-10 20:06:23.455213	12	MARK_RAN	7:d909180b2530479a716d3f9c9eaea3d7	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	6008382499
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2019-12-10 20:06:23.467566	13	EXECUTED	7:cf12b04b79bea5152f165eb41f3955f6	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	6008382499
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2019-12-10 20:06:23.479182	14	EXECUTED	7:7e32c8f05c755e8675764e7d5f514509	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	3.5.4	\N	\N	6008382499
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2019-12-10 20:06:23.480812	15	MARK_RAN	7:980ba23cc0ec39cab731ce903dd01291	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	6008382499
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2019-12-10 20:06:23.482659	16	MARK_RAN	7:2fa220758991285312eb84f3b4ff5336	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	3.5.4	\N	\N	6008382499
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2019-12-10 20:06:23.484067	17	EXECUTED	7:d41d8cd98f00b204e9800998ecf8427e	empty		\N	3.5.4	\N	\N	6008382499
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2019-12-10 20:06:23.513961	18	EXECUTED	7:91ace540896df890cc00a0490ee52bbc	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	3.5.4	\N	\N	6008382499
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2019-12-10 20:06:23.536051	19	EXECUTED	7:c31d1646dfa2618a9335c00e07f89f24	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	6008382499
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2019-12-10 20:06:23.539189	20	EXECUTED	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	6008382499
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2019-12-10 20:06:23.847102	45	EXECUTED	7:6a48ce645a3525488a90fbf76adf3bb3	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	6008382499
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2019-12-10 20:06:23.540779	21	MARK_RAN	7:f987971fe6b37d963bc95fee2b27f8df	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	6008382499
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2019-12-10 20:06:23.543107	22	MARK_RAN	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	6008382499
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2019-12-10 20:06:23.557379	23	EXECUTED	7:ed2dc7f799d19ac452cbcda56c929e47	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	3.5.4	\N	\N	6008382499
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2019-12-10 20:06:23.561286	24	EXECUTED	7:80b5db88a5dda36ece5f235be8757615	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	6008382499
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2019-12-10 20:06:23.563262	25	MARK_RAN	7:1437310ed1305a9b93f8848f301726ce	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	6008382499
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2019-12-10 20:06:23.581873	26	EXECUTED	7:b82ffb34850fa0836be16deefc6a87c4	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	3.5.4	\N	\N	6008382499
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2019-12-10 20:06:23.627201	27	EXECUTED	7:9cc98082921330d8d9266decdd4bd658	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	3.5.4	\N	\N	6008382499
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2019-12-10 20:06:23.632531	28	EXECUTED	7:03d64aeed9cb52b969bd30a7ac0db57e	update tableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	6008382499
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2019-12-10 20:06:23.671907	29	EXECUTED	7:f1f9fd8710399d725b780f463c6b21cd	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	3.5.4	\N	\N	6008382499
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2019-12-10 20:06:23.687515	30	EXECUTED	7:53188c3eb1107546e6f765835705b6c1	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	3.5.4	\N	\N	6008382499
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2019-12-10 20:06:23.709539	31	EXECUTED	7:d6e6f3bc57a0c5586737d1351725d4d4	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	3.5.4	\N	\N	6008382499
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2019-12-10 20:06:23.713316	32	EXECUTED	7:454d604fbd755d9df3fd9c6329043aa5	customChange		\N	3.5.4	\N	\N	6008382499
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2019-12-10 20:06:23.718226	33	EXECUTED	7:57e98a3077e29caf562f7dbf80c72600	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	6008382499
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2019-12-10 20:06:23.72017	34	MARK_RAN	7:e4c7e8f2256210aee71ddc42f538b57a	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	6008382499
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2019-12-10 20:06:23.73948	35	EXECUTED	7:09a43c97e49bc626460480aa1379b522	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	6008382499
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2019-12-10 20:06:23.743324	36	EXECUTED	7:26bfc7c74fefa9126f2ce702fb775553	addColumn tableName=REALM		\N	3.5.4	\N	\N	6008382499
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2019-12-10 20:06:23.746867	37	EXECUTED	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	6008382499
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2019-12-10 20:06:23.749787	38	EXECUTED	7:37fc1781855ac5388c494f1442b3f717	addColumn tableName=FED_USER_CONSENT		\N	3.5.4	\N	\N	6008382499
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2019-12-10 20:06:23.752254	39	EXECUTED	7:13a27db0dae6049541136adad7261d27	addColumn tableName=IDENTITY_PROVIDER		\N	3.5.4	\N	\N	6008382499
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2019-12-10 20:06:23.753682	40	MARK_RAN	7:550300617e3b59e8af3a6294df8248a3	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	6008382499
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2019-12-10 20:06:23.755532	41	MARK_RAN	7:e3a9482b8931481dc2772a5c07c44f17	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	6008382499
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2019-12-10 20:06:23.7606	42	EXECUTED	7:72b07d85a2677cb257edb02b408f332d	customChange		\N	3.5.4	\N	\N	6008382499
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2019-12-10 20:06:23.840249	43	EXECUTED	7:a72a7858967bd414835d19e04d880312	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	3.5.4	\N	\N	6008382499
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2019-12-10 20:06:23.843708	44	EXECUTED	7:94edff7cf9ce179e7e85f0cd78a3cf2c	addColumn tableName=USER_ENTITY		\N	3.5.4	\N	\N	6008382499
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2019-12-10 20:06:23.851652	46	EXECUTED	7:e64b5dcea7db06077c6e57d3b9e5ca14	customChange		\N	3.5.4	\N	\N	6008382499
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2019-12-10 20:06:23.860908	47	MARK_RAN	7:fd8cf02498f8b1e72496a20afc75178c	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	6008382499
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2019-12-10 20:06:23.887238	48	EXECUTED	7:542794f25aa2b1fbabb7e577d6646319	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	3.5.4	\N	\N	6008382499
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2019-12-10 20:06:23.889864	49	EXECUTED	7:edad604c882df12f74941dac3cc6d650	addColumn tableName=REALM		\N	3.5.4	\N	\N	6008382499
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2019-12-10 20:06:23.91375	50	EXECUTED	7:0f88b78b7b46480eb92690cbf5e44900	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	3.5.4	\N	\N	6008382499
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2019-12-10 20:06:23.929317	51	EXECUTED	7:d560e43982611d936457c327f872dd59	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	3.5.4	\N	\N	6008382499
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2019-12-10 20:06:23.931308	52	EXECUTED	7:c155566c42b4d14ef07059ec3b3bbd8e	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	6008382499
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2019-12-10 20:06:23.933085	53	EXECUTED	7:b40376581f12d70f3c89ba8ddf5b7dea	update tableName=REALM		\N	3.5.4	\N	\N	6008382499
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2019-12-10 20:06:23.935268	54	EXECUTED	7:a1132cc395f7b95b3646146c2e38f168	update tableName=CLIENT		\N	3.5.4	\N	\N	6008382499
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2019-12-10 20:06:23.953958	55	EXECUTED	7:d8dc5d89c789105cfa7ca0e82cba60af	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	3.5.4	\N	\N	6008382499
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2019-12-10 20:06:23.956612	56	EXECUTED	7:7822e0165097182e8f653c35517656a3	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	3.5.4	\N	\N	6008382499
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2019-12-10 20:06:23.967696	57	EXECUTED	7:c6538c29b9c9a08f9e9ea2de5c2b6375	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	3.5.4	\N	\N	6008382499
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2019-12-10 20:06:24.032939	58	EXECUTED	7:6d4893e36de22369cf73bcb051ded875	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	3.5.4	\N	\N	6008382499
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2019-12-10 20:06:24.051368	59	EXECUTED	7:57960fc0b0f0dd0563ea6f8b2e4a1707	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	3.5.4	\N	\N	6008382499
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2019-12-10 20:06:24.056351	60	EXECUTED	7:2b4b8bff39944c7097977cc18dbceb3b	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	6008382499
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2019-12-10 20:06:24.060888	61	EXECUTED	7:2aa42a964c59cd5b8ca9822340ba33a8	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	3.5.4	\N	\N	6008382499
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2019-12-10 20:06:24.069505	62	EXECUTED	7:9ac9e58545479929ba23f4a3087a0346	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	3.5.4	\N	\N	6008382499
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2019-12-10 20:06:24.072816	63	EXECUTED	7:14d407c35bc4fe1976867756bcea0c36	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	6008382499
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2019-12-10 20:06:24.075263	64	EXECUTED	7:241a8030c748c8548e346adee548fa93	update tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	6008382499
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2019-12-10 20:06:24.077157	65	EXECUTED	7:7d3182f65a34fcc61e8d23def037dc3f	update tableName=RESOURCE_SERVER_RESOURCE		\N	3.5.4	\N	\N	6008382499
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2019-12-10 20:06:24.084371	66	EXECUTED	7:b30039e00a0b9715d430d1b0636728fa	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	3.5.4	\N	\N	6008382499
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2019-12-10 20:06:24.08798	67	EXECUTED	7:3797315ca61d531780f8e6f82f258159	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	3.5.4	\N	\N	6008382499
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2019-12-10 20:06:24.091192	68	EXECUTED	7:c7aa4c8d9573500c2d347c1941ff0301	addColumn tableName=REALM		\N	3.5.4	\N	\N	6008382499
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2019-12-10 20:06:24.097107	69	EXECUTED	7:b207faee394fc074a442ecd42185a5dd	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	3.5.4	\N	\N	6008382499
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2019-12-10 20:06:24.100797	70	EXECUTED	7:ab9a9762faaba4ddfa35514b212c4922	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	3.5.4	\N	\N	6008382499
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2019-12-10 20:06:24.1031	71	EXECUTED	7:b9710f74515a6ccb51b72dc0d19df8c4	addColumn tableName=RESOURCE_SERVER		\N	3.5.4	\N	\N	6008382499
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2019-12-10 20:06:24.106424	72	EXECUTED	7:ec9707ae4d4f0b7452fee20128083879	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	6008382499
8.0.0-updating-credential-data-not-oracle	keycloak	META-INF/jpa-changelog-8.0.0.xml	2019-12-10 20:06:24.109777	73	EXECUTED	7:03b3f4b264c3c68ba082250a80b74216	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	6008382499
8.0.0-updating-credential-data-oracle	keycloak	META-INF/jpa-changelog-8.0.0.xml	2019-12-10 20:06:24.110989	74	MARK_RAN	7:64c5728f5ca1f5aa4392217701c4fe23	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	6008382499
8.0.0-credential-cleanup	keycloak	META-INF/jpa-changelog-8.0.0.xml	2019-12-10 20:06:24.120287	75	EXECUTED	7:41f3566ac5177459e1ed3ce8f0ad35d2	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	3.5.4	\N	\N	6008382499
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2019-12-10 20:06:24.124603	76	EXECUTED	7:a73379915c23bfad3e8f5c6d5c0aa4bd	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	3.5.4	\N	\N	6008382499
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
master	7f94c342-de9a-4e80-9b70-8fcb05efa52b	f
master	fa99a16f-3f6d-4330-a23f-9256730dd824	t
master	c642cae1-5887-4459-a55c-f6ac0c128af5	t
master	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de	t
master	07c2e327-2e19-48ee-9969-7aad41094bd5	f
master	96a61776-703d-477d-90b7-73b2dbe6ab7a	f
master	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e	t
master	00df3752-f334-4b80-b1fb-37673fa38fd6	t
master	54b63d5c-caf4-43f3-8ee1-911501a3168e	f
libstack-test	f0467d4e-099b-4002-89cb-e8c38727102d	f
libstack-test	0a4586db-5629-4872-a0b3-ddb3d4a5eeab	t
libstack-test	2943f901-c039-4e2e-b193-3fbd2fcad6b1	t
libstack-test	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba	t
libstack-test	7888003f-6f7b-4675-a612-0386029f7031	f
libstack-test	3625a18f-22a1-423c-b840-602e55fd2cae	f
libstack-test	a6e45681-0675-4153-9613-45bd45185d6f	t
libstack-test	70aad3f4-0342-4dcc-aeff-b29210ee0f99	t
libstack-test	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
c021dbe3-97c8-4322-9198-3f5ad81a3262	master	f	${role_admin}	admin	master	\N	master
d3359040-51b4-407a-be7a-718505a6cd9c	master	f	${role_create-realm}	create-realm	master	\N	master
c03ede1b-0648-429c-8ef2-33a1462ce1e6	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_create-client}	create-client	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
1e4d08ea-eb25-49ab-8823-bb47d915e4b0	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_view-realm}	view-realm	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
95991681-9101-41e7-8d68-38392fc22a97	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_view-users}	view-users	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
61ced7eb-78d9-4ce9-9209-e25918661b3b	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_view-clients}	view-clients	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
c873673f-f89e-4d36-8722-bbf2e183f382	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_view-events}	view-events	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
dcd8e4a0-f163-416b-9ef1-b1e172796475	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_view-identity-providers}	view-identity-providers	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
7a9857f6-d19a-4736-a4e5-2d031e1fb6fd	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_view-authorization}	view-authorization	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
b2bc4984-a87d-447b-8d2a-a7d1e2534595	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_manage-realm}	manage-realm	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
5798388f-422a-486b-9ec5-3e9b640512f4	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_manage-users}	manage-users	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
eb2fb949-9589-4ec8-82b2-45f6bf5a1b24	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_manage-clients}	manage-clients	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
ee3d9798-14fb-4b46-8385-11ad9e2efbf0	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_manage-events}	manage-events	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
df0a1e5d-df67-4519-872e-0e9267d2884d	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_manage-identity-providers}	manage-identity-providers	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
5ae510e3-cb97-4c49-a313-6ad8d9bda3c5	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_manage-authorization}	manage-authorization	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
0a53aaeb-aea1-4304-bcf3-f4a6b16cde6d	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_query-users}	query-users	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
f066eff6-8c77-4250-8b56-14432aa380bf	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_query-clients}	query-clients	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
e411e6bd-d93b-4204-90d4-9923a65ac9ba	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_query-realms}	query-realms	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
bfb96aec-a583-4e98-a08a-b752123aee90	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_query-groups}	query-groups	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
703444a6-2a4f-40e5-bf73-ad68f435ee22	0a536141-8431-46a7-a460-67309f864cb6	t	${role_view-profile}	view-profile	master	0a536141-8431-46a7-a460-67309f864cb6	\N
02014c5e-ba15-4e88-a6c9-143466c8f34d	0a536141-8431-46a7-a460-67309f864cb6	t	${role_manage-account}	manage-account	master	0a536141-8431-46a7-a460-67309f864cb6	\N
412e738a-4e33-40ec-867b-3936eabac097	0a536141-8431-46a7-a460-67309f864cb6	t	${role_manage-account-links}	manage-account-links	master	0a536141-8431-46a7-a460-67309f864cb6	\N
8324eac2-7595-4504-8c7e-ecaff9f86daa	4fc4d101-7e00-401f-a8b6-0b58a8e156b3	t	${role_read-token}	read-token	master	4fc4d101-7e00-401f-a8b6-0b58a8e156b3	\N
91b695c3-9a2d-4248-bae0-9be901041358	41f7850a-c7c8-4967-8306-b1159db2d196	t	${role_impersonation}	impersonation	master	41f7850a-c7c8-4967-8306-b1159db2d196	\N
1080c26c-1edb-4bf3-bbf2-7858ba751ebd	master	f	${role_offline-access}	offline_access	master	\N	master
16385a66-ae65-43f6-a2ed-bf0b7fbc34a8	master	f	${role_uma_authorization}	uma_authorization	master	\N	master
7422dee6-ebb9-42a1-80b4-c8a72e7110a7	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_create-client}	create-client	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
eefc2c49-3cf5-4331-ba83-585bda9445a2	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_view-realm}	view-realm	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
663cf08a-8aca-4219-bba1-f066d0841e28	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_view-users}	view-users	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
d48021fd-6838-4c05-8db4-c66cbd8e78cc	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_view-clients}	view-clients	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
e05c0706-79be-46ad-afa1-452c1db0259d	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_view-events}	view-events	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
c160a599-bb45-453e-9cd5-ef9117b05556	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_view-identity-providers}	view-identity-providers	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
231579a8-0e93-4fce-8b07-23d9147daf12	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_view-authorization}	view-authorization	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
18b4addf-0822-401b-a580-69ab559757de	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_manage-realm}	manage-realm	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
c4b5c5b9-94be-4176-898e-66ae6bd045a4	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_manage-users}	manage-users	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
d7dba609-709e-4a84-8268-d377f091d940	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_manage-clients}	manage-clients	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
f0cf4d85-c9f4-4198-9cc2-d918e193556b	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_manage-events}	manage-events	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
7e2a76c3-ad95-4348-a9e5-4b858d0d1db9	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_manage-identity-providers}	manage-identity-providers	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
1120c22f-d6e6-4fbe-a307-06d918112bb5	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_manage-authorization}	manage-authorization	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
3ba21bcd-84e8-4c0f-a6e9-bf0d4aaca62a	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_query-users}	query-users	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
bff814ce-986d-4d0c-b319-dcf78ae9b241	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_query-clients}	query-clients	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
afc6dc54-a222-4819-a0a0-9c4d63a3bdb9	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_query-realms}	query-realms	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
da8dd9b8-683d-42d0-9caf-ee57f0db6c22	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_query-groups}	query-groups	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
ab9866ce-d635-486a-a0ce-f4dbd2559025	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_realm-admin}	realm-admin	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
f1dd23ca-2e93-4863-9078-4e5af7567867	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_create-client}	create-client	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
c75e6bb7-9dcf-491c-948e-0978c12ca51b	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_view-realm}	view-realm	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
6254574c-0745-4870-9311-1da726857d6c	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_view-users}	view-users	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
15a40e75-b3b7-4956-9132-0441715c2b3a	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_view-clients}	view-clients	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
c8f07c62-3ff0-4cd7-851e-ef2f0b49d3d7	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_view-events}	view-events	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
06fe59c2-d661-422a-a829-785e79a53c21	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_view-identity-providers}	view-identity-providers	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
d9188779-ff57-46d8-9f23-17cfe22b6121	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_view-authorization}	view-authorization	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
6295f867-2016-4e93-9f1f-58c51f580001	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_manage-realm}	manage-realm	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
165597b6-f1a7-4198-a336-2cd230f1b5e7	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_manage-users}	manage-users	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
73798b9e-0c83-4e4a-93da-6f9a407d221d	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_manage-clients}	manage-clients	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
a3f1f832-b14e-4586-bc11-75f539006eb4	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_manage-events}	manage-events	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
ff553bf5-25c1-4955-b881-c527a8b54eb8	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_manage-identity-providers}	manage-identity-providers	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
17d26268-42f2-4c1d-9f1e-168b9e156a3c	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_manage-authorization}	manage-authorization	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
b9cf9521-8ece-4c96-9bf1-2d3dd50638c1	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_query-users}	query-users	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
5de009b4-6947-44ff-be7f-c01a3bd973f3	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_query-clients}	query-clients	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
b055464c-193f-44b3-aa51-b8e1582a6687	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_query-realms}	query-realms	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
2b0b6515-c0ef-4c00-900d-f27671b5021a	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_query-groups}	query-groups	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
e1eb8155-8344-46bb-b76c-1af1fc61d88b	1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	t	${role_view-profile}	view-profile	libstack-test	1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	\N
6252b63a-b145-4b05-aee6-d19b9e3f00f8	1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	t	${role_manage-account}	manage-account	libstack-test	1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	\N
7ab30215-b46e-4e59-98e3-c5e450374695	1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	t	${role_manage-account-links}	manage-account-links	libstack-test	1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	\N
ad916223-4bcb-406f-9d80-6d3cec533d6d	1a5b8f72-366d-4f43-8b25-a174328287b3	t	${role_impersonation}	impersonation	master	1a5b8f72-366d-4f43-8b25-a174328287b3	\N
7c19bfd4-0813-4f64-ba12-57e2bc51431c	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	t	${role_impersonation}	impersonation	libstack-test	ecf395a7-8f1b-4ae7-ad00-aacbacf5843f	\N
0b07bb89-40ab-47ba-8ef4-2506afc76a58	5b531888-4ae3-478d-bf7a-ad11eadf219c	t	${role_read-token}	read-token	libstack-test	5b531888-4ae3-478d-bf7a-ad11eadf219c	\N
7c6d1c8f-5f08-4a4f-98e7-c0b6bb4d17ef	libstack-test	f	${role_offline-access}	offline_access	libstack-test	\N	libstack-test
064afaea-c7b1-491d-b3ae-339354fc9a1c	libstack-test	f	${role_uma_authorization}	uma_authorization	libstack-test	\N	libstack-test
bca22a2a-8b1d-4d7a-be73-522c60b12377	eb347312-64e2-4ff6-89ff-0f544da6dde6	t	\N	test	libstack-test	eb347312-64e2-4ff6-89ff-0f544da6dde6	\N
7ab9c608-d338-49bc-ac85-675b60db4b68	libstack-test	f	\N	libstack-tester	libstack-test	\N	libstack-test
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migration_model (id, version, update_time) FROM stdin;
l9hyl	8.0.1	1576008387
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
0e2a1b55-9641-4fc2-9975-2d8f1be9144c	locale	openid-connect	oidc-usermodel-attribute-mapper	4a0be8dd-196e-40a2-832e-d247de89160b	\N
8f35fffe-b6c0-4786-8721-f7acf7ff695a	role list	saml	saml-role-list-mapper	\N	fa99a16f-3f6d-4330-a23f-9256730dd824
074cb31a-7889-4b03-a590-aac92263c09b	full name	openid-connect	oidc-full-name-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
3c6cd5a5-8dc2-4180-bab9-35c2eb9050f6	family name	openid-connect	oidc-usermodel-property-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
43ca662f-05ff-4f49-850d-9dc2b92fc6db	given name	openid-connect	oidc-usermodel-property-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
19638ec3-96e2-42e8-a78f-7aa7b415ce59	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
82c74b06-5651-4a9c-8339-d25ee41a5ab7	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
844c7e3c-13c8-4687-9fe6-54b40ab092ff	username	openid-connect	oidc-usermodel-property-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
6283bfaa-02a8-4922-adf0-2bb5779c1b99	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
58d26e45-f071-40ae-b709-dadc90d0c488	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
c25576a5-6d93-44f9-ba34-3d6d61f92b6d	website	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
e5376475-32e7-4eb5-9ea0-bf55386964c7	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
7fd51a54-9233-4f00-84cd-eac8ae386694	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
bbda8b87-7c85-4985-aae0-386e746ffc6f	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
043ca65b-9b80-45e6-ad83-9ad447466f80	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
e62215b1-c7d5-4308-8fc6-da3f20ba9915	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	c642cae1-5887-4459-a55c-f6ac0c128af5
7fea41ab-86bd-4528-ba0f-ba09a4fef6b7	email	openid-connect	oidc-usermodel-property-mapper	\N	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de
6caa72f4-8a62-4951-8a8c-fa228841e812	email verified	openid-connect	oidc-usermodel-property-mapper	\N	bf71eb7d-bb6c-47f7-b38e-5cf6a6e6b6de
84b42f52-d9c8-441a-9b05-764f4d60e425	address	openid-connect	oidc-address-mapper	\N	07c2e327-2e19-48ee-9969-7aad41094bd5
b9ca83d0-4eac-43bb-b130-974f03a4e28e	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	96a61776-703d-477d-90b7-73b2dbe6ab7a
f07c8ab8-4f5b-46bd-b59d-3d6fc96febde	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	96a61776-703d-477d-90b7-73b2dbe6ab7a
21c174b5-1046-48b2-a271-1e93c4c29b95	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e
8a04fd4d-aa72-4791-9756-d0c82b4cf11c	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e
de9a5734-0db2-4dcf-86af-db169cf77042	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	e408e704-0c5a-442c-b5d0-2ce1fd11ad4e
97a068bc-16a2-403a-9393-fd9bfcb36eca	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	00df3752-f334-4b80-b1fb-37673fa38fd6
e29a373e-6ff1-4bc1-93ba-60d4a68f8476	upn	openid-connect	oidc-usermodel-property-mapper	\N	54b63d5c-caf4-43f3-8ee1-911501a3168e
9dac2ad1-e174-422b-98f4-8b23ac1a6569	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	54b63d5c-caf4-43f3-8ee1-911501a3168e
85b5e6ae-fb58-44ba-8920-3bf8776f3180	role list	saml	saml-role-list-mapper	\N	0a4586db-5629-4872-a0b3-ddb3d4a5eeab
d79fc4b6-901f-41c3-a0e6-f21a6c06af01	full name	openid-connect	oidc-full-name-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
99491ecf-e444-4f6d-ab4b-8926ff7b572a	family name	openid-connect	oidc-usermodel-property-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
d00999c9-3de3-4dcf-b445-d6524e998ab5	given name	openid-connect	oidc-usermodel-property-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
0ca2c106-2286-4723-9192-f33eecf94a5d	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
ccda2f4f-53b2-41fa-800e-10fc974c0bbe	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
ed310b93-33e3-4728-aeeb-bfa2c919b02c	username	openid-connect	oidc-usermodel-property-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
9416bdfd-082f-474b-b022-ca8c0e1e5681	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
327336e8-ddce-445e-b58d-c3e2a22c26d1	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
f57102ba-c9b6-41f1-b15c-a3666f532869	website	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
7ceaef29-9b18-4df2-91b9-731a3d6b2f64	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
60b68312-bbf5-4773-a9d4-fc2407c78ff2	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
2a626ff1-7998-4e7b-9d2e-45f8c76380d2	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
e0d9045d-d178-47cb-a7fe-3062ebe56154	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
008fd3e6-6499-4e91-a1be-c582d8643561	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	2943f901-c039-4e2e-b193-3fbd2fcad6b1
6467823d-3ff7-471d-9ac5-948ea94f5f66	email	openid-connect	oidc-usermodel-property-mapper	\N	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba
dd5873e2-4efb-4a86-bf79-55a06e05d24e	email verified	openid-connect	oidc-usermodel-property-mapper	\N	e0a5d6e5-7d5c-4a43-b457-a9ace0c071ba
5df445f8-cd0a-49ac-9658-3da8658f92fb	address	openid-connect	oidc-address-mapper	\N	7888003f-6f7b-4675-a612-0386029f7031
4907434f-c064-4e23-8e03-bc256c775205	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	3625a18f-22a1-423c-b840-602e55fd2cae
01fcdec6-9c78-43c7-8d21-438cbc66d794	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	3625a18f-22a1-423c-b840-602e55fd2cae
3bac2167-45d0-4507-beea-791eb1ff205a	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	a6e45681-0675-4153-9613-45bd45185d6f
2e26d344-41cf-494b-a15a-c316d49293e6	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	a6e45681-0675-4153-9613-45bd45185d6f
76e0b174-e1c5-4437-b570-84577f4484bb	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	a6e45681-0675-4153-9613-45bd45185d6f
63d8826a-2feb-4bfa-a6ee-abee202579d0	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	70aad3f4-0342-4dcc-aeff-b29210ee0f99
23d50203-1105-4e83-8ec2-c2bdbf4e2a00	upn	openid-connect	oidc-usermodel-property-mapper	\N	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a
774fc48e-34ee-4af9-aa56-52b30ae6cb04	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	0fd63a34-8a51-4dcd-9e47-3afd9dedd56a
dcf66934-5597-4153-a515-0a3e31407659	locale	openid-connect	oidc-usermodel-attribute-mapper	70ec0242-448b-4902-a8d8-05edad4ba0c3	\N
abbeb78d-4cbc-4b43-9247-617463c75855	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	eb347312-64e2-4ff6-89ff-0f544da6dde6	\N
87ba51b5-8558-44e2-9213-ea68986e3c1d	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	eb347312-64e2-4ff6-89ff-0f544da6dde6	\N
b08f323c-291b-4e9f-a4d6-8748829c97de	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	eb347312-64e2-4ff6-89ff-0f544da6dde6	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
0e2a1b55-9641-4fc2-9975-2d8f1be9144c	true	userinfo.token.claim
0e2a1b55-9641-4fc2-9975-2d8f1be9144c	locale	user.attribute
0e2a1b55-9641-4fc2-9975-2d8f1be9144c	true	id.token.claim
0e2a1b55-9641-4fc2-9975-2d8f1be9144c	true	access.token.claim
0e2a1b55-9641-4fc2-9975-2d8f1be9144c	locale	claim.name
0e2a1b55-9641-4fc2-9975-2d8f1be9144c	String	jsonType.label
8f35fffe-b6c0-4786-8721-f7acf7ff695a	false	single
8f35fffe-b6c0-4786-8721-f7acf7ff695a	Basic	attribute.nameformat
8f35fffe-b6c0-4786-8721-f7acf7ff695a	Role	attribute.name
074cb31a-7889-4b03-a590-aac92263c09b	true	userinfo.token.claim
074cb31a-7889-4b03-a590-aac92263c09b	true	id.token.claim
074cb31a-7889-4b03-a590-aac92263c09b	true	access.token.claim
3c6cd5a5-8dc2-4180-bab9-35c2eb9050f6	true	userinfo.token.claim
3c6cd5a5-8dc2-4180-bab9-35c2eb9050f6	lastName	user.attribute
3c6cd5a5-8dc2-4180-bab9-35c2eb9050f6	true	id.token.claim
3c6cd5a5-8dc2-4180-bab9-35c2eb9050f6	true	access.token.claim
3c6cd5a5-8dc2-4180-bab9-35c2eb9050f6	family_name	claim.name
3c6cd5a5-8dc2-4180-bab9-35c2eb9050f6	String	jsonType.label
43ca662f-05ff-4f49-850d-9dc2b92fc6db	true	userinfo.token.claim
43ca662f-05ff-4f49-850d-9dc2b92fc6db	firstName	user.attribute
43ca662f-05ff-4f49-850d-9dc2b92fc6db	true	id.token.claim
43ca662f-05ff-4f49-850d-9dc2b92fc6db	true	access.token.claim
43ca662f-05ff-4f49-850d-9dc2b92fc6db	given_name	claim.name
43ca662f-05ff-4f49-850d-9dc2b92fc6db	String	jsonType.label
19638ec3-96e2-42e8-a78f-7aa7b415ce59	true	userinfo.token.claim
19638ec3-96e2-42e8-a78f-7aa7b415ce59	middleName	user.attribute
19638ec3-96e2-42e8-a78f-7aa7b415ce59	true	id.token.claim
19638ec3-96e2-42e8-a78f-7aa7b415ce59	true	access.token.claim
19638ec3-96e2-42e8-a78f-7aa7b415ce59	middle_name	claim.name
19638ec3-96e2-42e8-a78f-7aa7b415ce59	String	jsonType.label
82c74b06-5651-4a9c-8339-d25ee41a5ab7	true	userinfo.token.claim
82c74b06-5651-4a9c-8339-d25ee41a5ab7	nickname	user.attribute
82c74b06-5651-4a9c-8339-d25ee41a5ab7	true	id.token.claim
82c74b06-5651-4a9c-8339-d25ee41a5ab7	true	access.token.claim
82c74b06-5651-4a9c-8339-d25ee41a5ab7	nickname	claim.name
82c74b06-5651-4a9c-8339-d25ee41a5ab7	String	jsonType.label
844c7e3c-13c8-4687-9fe6-54b40ab092ff	true	userinfo.token.claim
844c7e3c-13c8-4687-9fe6-54b40ab092ff	username	user.attribute
844c7e3c-13c8-4687-9fe6-54b40ab092ff	true	id.token.claim
844c7e3c-13c8-4687-9fe6-54b40ab092ff	true	access.token.claim
844c7e3c-13c8-4687-9fe6-54b40ab092ff	preferred_username	claim.name
844c7e3c-13c8-4687-9fe6-54b40ab092ff	String	jsonType.label
6283bfaa-02a8-4922-adf0-2bb5779c1b99	true	userinfo.token.claim
6283bfaa-02a8-4922-adf0-2bb5779c1b99	profile	user.attribute
6283bfaa-02a8-4922-adf0-2bb5779c1b99	true	id.token.claim
6283bfaa-02a8-4922-adf0-2bb5779c1b99	true	access.token.claim
6283bfaa-02a8-4922-adf0-2bb5779c1b99	profile	claim.name
6283bfaa-02a8-4922-adf0-2bb5779c1b99	String	jsonType.label
58d26e45-f071-40ae-b709-dadc90d0c488	true	userinfo.token.claim
58d26e45-f071-40ae-b709-dadc90d0c488	picture	user.attribute
58d26e45-f071-40ae-b709-dadc90d0c488	true	id.token.claim
58d26e45-f071-40ae-b709-dadc90d0c488	true	access.token.claim
58d26e45-f071-40ae-b709-dadc90d0c488	picture	claim.name
58d26e45-f071-40ae-b709-dadc90d0c488	String	jsonType.label
c25576a5-6d93-44f9-ba34-3d6d61f92b6d	true	userinfo.token.claim
c25576a5-6d93-44f9-ba34-3d6d61f92b6d	website	user.attribute
c25576a5-6d93-44f9-ba34-3d6d61f92b6d	true	id.token.claim
c25576a5-6d93-44f9-ba34-3d6d61f92b6d	true	access.token.claim
c25576a5-6d93-44f9-ba34-3d6d61f92b6d	website	claim.name
c25576a5-6d93-44f9-ba34-3d6d61f92b6d	String	jsonType.label
e5376475-32e7-4eb5-9ea0-bf55386964c7	true	userinfo.token.claim
e5376475-32e7-4eb5-9ea0-bf55386964c7	gender	user.attribute
e5376475-32e7-4eb5-9ea0-bf55386964c7	true	id.token.claim
e5376475-32e7-4eb5-9ea0-bf55386964c7	true	access.token.claim
e5376475-32e7-4eb5-9ea0-bf55386964c7	gender	claim.name
e5376475-32e7-4eb5-9ea0-bf55386964c7	String	jsonType.label
7fd51a54-9233-4f00-84cd-eac8ae386694	true	userinfo.token.claim
7fd51a54-9233-4f00-84cd-eac8ae386694	birthdate	user.attribute
7fd51a54-9233-4f00-84cd-eac8ae386694	true	id.token.claim
7fd51a54-9233-4f00-84cd-eac8ae386694	true	access.token.claim
7fd51a54-9233-4f00-84cd-eac8ae386694	birthdate	claim.name
7fd51a54-9233-4f00-84cd-eac8ae386694	String	jsonType.label
bbda8b87-7c85-4985-aae0-386e746ffc6f	true	userinfo.token.claim
bbda8b87-7c85-4985-aae0-386e746ffc6f	zoneinfo	user.attribute
bbda8b87-7c85-4985-aae0-386e746ffc6f	true	id.token.claim
bbda8b87-7c85-4985-aae0-386e746ffc6f	true	access.token.claim
bbda8b87-7c85-4985-aae0-386e746ffc6f	zoneinfo	claim.name
bbda8b87-7c85-4985-aae0-386e746ffc6f	String	jsonType.label
043ca65b-9b80-45e6-ad83-9ad447466f80	true	userinfo.token.claim
043ca65b-9b80-45e6-ad83-9ad447466f80	locale	user.attribute
043ca65b-9b80-45e6-ad83-9ad447466f80	true	id.token.claim
043ca65b-9b80-45e6-ad83-9ad447466f80	true	access.token.claim
043ca65b-9b80-45e6-ad83-9ad447466f80	locale	claim.name
043ca65b-9b80-45e6-ad83-9ad447466f80	String	jsonType.label
e62215b1-c7d5-4308-8fc6-da3f20ba9915	true	userinfo.token.claim
e62215b1-c7d5-4308-8fc6-da3f20ba9915	updatedAt	user.attribute
e62215b1-c7d5-4308-8fc6-da3f20ba9915	true	id.token.claim
e62215b1-c7d5-4308-8fc6-da3f20ba9915	true	access.token.claim
e62215b1-c7d5-4308-8fc6-da3f20ba9915	updated_at	claim.name
e62215b1-c7d5-4308-8fc6-da3f20ba9915	String	jsonType.label
7fea41ab-86bd-4528-ba0f-ba09a4fef6b7	true	userinfo.token.claim
7fea41ab-86bd-4528-ba0f-ba09a4fef6b7	email	user.attribute
7fea41ab-86bd-4528-ba0f-ba09a4fef6b7	true	id.token.claim
7fea41ab-86bd-4528-ba0f-ba09a4fef6b7	true	access.token.claim
7fea41ab-86bd-4528-ba0f-ba09a4fef6b7	email	claim.name
7fea41ab-86bd-4528-ba0f-ba09a4fef6b7	String	jsonType.label
6caa72f4-8a62-4951-8a8c-fa228841e812	true	userinfo.token.claim
6caa72f4-8a62-4951-8a8c-fa228841e812	emailVerified	user.attribute
6caa72f4-8a62-4951-8a8c-fa228841e812	true	id.token.claim
6caa72f4-8a62-4951-8a8c-fa228841e812	true	access.token.claim
6caa72f4-8a62-4951-8a8c-fa228841e812	email_verified	claim.name
6caa72f4-8a62-4951-8a8c-fa228841e812	boolean	jsonType.label
84b42f52-d9c8-441a-9b05-764f4d60e425	formatted	user.attribute.formatted
84b42f52-d9c8-441a-9b05-764f4d60e425	country	user.attribute.country
84b42f52-d9c8-441a-9b05-764f4d60e425	postal_code	user.attribute.postal_code
84b42f52-d9c8-441a-9b05-764f4d60e425	true	userinfo.token.claim
84b42f52-d9c8-441a-9b05-764f4d60e425	street	user.attribute.street
84b42f52-d9c8-441a-9b05-764f4d60e425	true	id.token.claim
84b42f52-d9c8-441a-9b05-764f4d60e425	region	user.attribute.region
84b42f52-d9c8-441a-9b05-764f4d60e425	true	access.token.claim
84b42f52-d9c8-441a-9b05-764f4d60e425	locality	user.attribute.locality
b9ca83d0-4eac-43bb-b130-974f03a4e28e	true	userinfo.token.claim
b9ca83d0-4eac-43bb-b130-974f03a4e28e	phoneNumber	user.attribute
b9ca83d0-4eac-43bb-b130-974f03a4e28e	true	id.token.claim
b9ca83d0-4eac-43bb-b130-974f03a4e28e	true	access.token.claim
b9ca83d0-4eac-43bb-b130-974f03a4e28e	phone_number	claim.name
b9ca83d0-4eac-43bb-b130-974f03a4e28e	String	jsonType.label
f07c8ab8-4f5b-46bd-b59d-3d6fc96febde	true	userinfo.token.claim
f07c8ab8-4f5b-46bd-b59d-3d6fc96febde	phoneNumberVerified	user.attribute
f07c8ab8-4f5b-46bd-b59d-3d6fc96febde	true	id.token.claim
f07c8ab8-4f5b-46bd-b59d-3d6fc96febde	true	access.token.claim
f07c8ab8-4f5b-46bd-b59d-3d6fc96febde	phone_number_verified	claim.name
f07c8ab8-4f5b-46bd-b59d-3d6fc96febde	boolean	jsonType.label
21c174b5-1046-48b2-a271-1e93c4c29b95	true	multivalued
21c174b5-1046-48b2-a271-1e93c4c29b95	foo	user.attribute
21c174b5-1046-48b2-a271-1e93c4c29b95	true	access.token.claim
21c174b5-1046-48b2-a271-1e93c4c29b95	realm_access.roles	claim.name
21c174b5-1046-48b2-a271-1e93c4c29b95	String	jsonType.label
8a04fd4d-aa72-4791-9756-d0c82b4cf11c	true	multivalued
8a04fd4d-aa72-4791-9756-d0c82b4cf11c	foo	user.attribute
8a04fd4d-aa72-4791-9756-d0c82b4cf11c	true	access.token.claim
8a04fd4d-aa72-4791-9756-d0c82b4cf11c	resource_access.${client_id}.roles	claim.name
8a04fd4d-aa72-4791-9756-d0c82b4cf11c	String	jsonType.label
e29a373e-6ff1-4bc1-93ba-60d4a68f8476	true	userinfo.token.claim
e29a373e-6ff1-4bc1-93ba-60d4a68f8476	username	user.attribute
e29a373e-6ff1-4bc1-93ba-60d4a68f8476	true	id.token.claim
e29a373e-6ff1-4bc1-93ba-60d4a68f8476	true	access.token.claim
e29a373e-6ff1-4bc1-93ba-60d4a68f8476	upn	claim.name
e29a373e-6ff1-4bc1-93ba-60d4a68f8476	String	jsonType.label
9dac2ad1-e174-422b-98f4-8b23ac1a6569	true	multivalued
9dac2ad1-e174-422b-98f4-8b23ac1a6569	foo	user.attribute
9dac2ad1-e174-422b-98f4-8b23ac1a6569	true	id.token.claim
9dac2ad1-e174-422b-98f4-8b23ac1a6569	true	access.token.claim
9dac2ad1-e174-422b-98f4-8b23ac1a6569	groups	claim.name
9dac2ad1-e174-422b-98f4-8b23ac1a6569	String	jsonType.label
85b5e6ae-fb58-44ba-8920-3bf8776f3180	false	single
85b5e6ae-fb58-44ba-8920-3bf8776f3180	Basic	attribute.nameformat
85b5e6ae-fb58-44ba-8920-3bf8776f3180	Role	attribute.name
d79fc4b6-901f-41c3-a0e6-f21a6c06af01	true	userinfo.token.claim
d79fc4b6-901f-41c3-a0e6-f21a6c06af01	true	id.token.claim
d79fc4b6-901f-41c3-a0e6-f21a6c06af01	true	access.token.claim
99491ecf-e444-4f6d-ab4b-8926ff7b572a	true	userinfo.token.claim
99491ecf-e444-4f6d-ab4b-8926ff7b572a	lastName	user.attribute
99491ecf-e444-4f6d-ab4b-8926ff7b572a	true	id.token.claim
99491ecf-e444-4f6d-ab4b-8926ff7b572a	true	access.token.claim
99491ecf-e444-4f6d-ab4b-8926ff7b572a	family_name	claim.name
99491ecf-e444-4f6d-ab4b-8926ff7b572a	String	jsonType.label
d00999c9-3de3-4dcf-b445-d6524e998ab5	true	userinfo.token.claim
d00999c9-3de3-4dcf-b445-d6524e998ab5	firstName	user.attribute
d00999c9-3de3-4dcf-b445-d6524e998ab5	true	id.token.claim
d00999c9-3de3-4dcf-b445-d6524e998ab5	true	access.token.claim
d00999c9-3de3-4dcf-b445-d6524e998ab5	given_name	claim.name
d00999c9-3de3-4dcf-b445-d6524e998ab5	String	jsonType.label
0ca2c106-2286-4723-9192-f33eecf94a5d	true	userinfo.token.claim
0ca2c106-2286-4723-9192-f33eecf94a5d	middleName	user.attribute
0ca2c106-2286-4723-9192-f33eecf94a5d	true	id.token.claim
0ca2c106-2286-4723-9192-f33eecf94a5d	true	access.token.claim
0ca2c106-2286-4723-9192-f33eecf94a5d	middle_name	claim.name
0ca2c106-2286-4723-9192-f33eecf94a5d	String	jsonType.label
ccda2f4f-53b2-41fa-800e-10fc974c0bbe	true	userinfo.token.claim
ccda2f4f-53b2-41fa-800e-10fc974c0bbe	nickname	user.attribute
ccda2f4f-53b2-41fa-800e-10fc974c0bbe	true	id.token.claim
ccda2f4f-53b2-41fa-800e-10fc974c0bbe	true	access.token.claim
ccda2f4f-53b2-41fa-800e-10fc974c0bbe	nickname	claim.name
ccda2f4f-53b2-41fa-800e-10fc974c0bbe	String	jsonType.label
ed310b93-33e3-4728-aeeb-bfa2c919b02c	true	userinfo.token.claim
ed310b93-33e3-4728-aeeb-bfa2c919b02c	username	user.attribute
ed310b93-33e3-4728-aeeb-bfa2c919b02c	true	id.token.claim
ed310b93-33e3-4728-aeeb-bfa2c919b02c	true	access.token.claim
ed310b93-33e3-4728-aeeb-bfa2c919b02c	preferred_username	claim.name
ed310b93-33e3-4728-aeeb-bfa2c919b02c	String	jsonType.label
9416bdfd-082f-474b-b022-ca8c0e1e5681	true	userinfo.token.claim
9416bdfd-082f-474b-b022-ca8c0e1e5681	profile	user.attribute
9416bdfd-082f-474b-b022-ca8c0e1e5681	true	id.token.claim
9416bdfd-082f-474b-b022-ca8c0e1e5681	true	access.token.claim
9416bdfd-082f-474b-b022-ca8c0e1e5681	profile	claim.name
9416bdfd-082f-474b-b022-ca8c0e1e5681	String	jsonType.label
327336e8-ddce-445e-b58d-c3e2a22c26d1	true	userinfo.token.claim
327336e8-ddce-445e-b58d-c3e2a22c26d1	picture	user.attribute
327336e8-ddce-445e-b58d-c3e2a22c26d1	true	id.token.claim
327336e8-ddce-445e-b58d-c3e2a22c26d1	true	access.token.claim
327336e8-ddce-445e-b58d-c3e2a22c26d1	picture	claim.name
327336e8-ddce-445e-b58d-c3e2a22c26d1	String	jsonType.label
f57102ba-c9b6-41f1-b15c-a3666f532869	true	userinfo.token.claim
f57102ba-c9b6-41f1-b15c-a3666f532869	website	user.attribute
f57102ba-c9b6-41f1-b15c-a3666f532869	true	id.token.claim
f57102ba-c9b6-41f1-b15c-a3666f532869	true	access.token.claim
f57102ba-c9b6-41f1-b15c-a3666f532869	website	claim.name
f57102ba-c9b6-41f1-b15c-a3666f532869	String	jsonType.label
7ceaef29-9b18-4df2-91b9-731a3d6b2f64	true	userinfo.token.claim
7ceaef29-9b18-4df2-91b9-731a3d6b2f64	gender	user.attribute
7ceaef29-9b18-4df2-91b9-731a3d6b2f64	true	id.token.claim
7ceaef29-9b18-4df2-91b9-731a3d6b2f64	true	access.token.claim
7ceaef29-9b18-4df2-91b9-731a3d6b2f64	gender	claim.name
7ceaef29-9b18-4df2-91b9-731a3d6b2f64	String	jsonType.label
60b68312-bbf5-4773-a9d4-fc2407c78ff2	true	userinfo.token.claim
60b68312-bbf5-4773-a9d4-fc2407c78ff2	birthdate	user.attribute
60b68312-bbf5-4773-a9d4-fc2407c78ff2	true	id.token.claim
60b68312-bbf5-4773-a9d4-fc2407c78ff2	true	access.token.claim
60b68312-bbf5-4773-a9d4-fc2407c78ff2	birthdate	claim.name
60b68312-bbf5-4773-a9d4-fc2407c78ff2	String	jsonType.label
2a626ff1-7998-4e7b-9d2e-45f8c76380d2	true	userinfo.token.claim
2a626ff1-7998-4e7b-9d2e-45f8c76380d2	zoneinfo	user.attribute
2a626ff1-7998-4e7b-9d2e-45f8c76380d2	true	id.token.claim
2a626ff1-7998-4e7b-9d2e-45f8c76380d2	true	access.token.claim
2a626ff1-7998-4e7b-9d2e-45f8c76380d2	zoneinfo	claim.name
2a626ff1-7998-4e7b-9d2e-45f8c76380d2	String	jsonType.label
e0d9045d-d178-47cb-a7fe-3062ebe56154	true	userinfo.token.claim
e0d9045d-d178-47cb-a7fe-3062ebe56154	locale	user.attribute
e0d9045d-d178-47cb-a7fe-3062ebe56154	true	id.token.claim
e0d9045d-d178-47cb-a7fe-3062ebe56154	true	access.token.claim
e0d9045d-d178-47cb-a7fe-3062ebe56154	locale	claim.name
e0d9045d-d178-47cb-a7fe-3062ebe56154	String	jsonType.label
008fd3e6-6499-4e91-a1be-c582d8643561	true	userinfo.token.claim
008fd3e6-6499-4e91-a1be-c582d8643561	updatedAt	user.attribute
008fd3e6-6499-4e91-a1be-c582d8643561	true	id.token.claim
008fd3e6-6499-4e91-a1be-c582d8643561	true	access.token.claim
008fd3e6-6499-4e91-a1be-c582d8643561	updated_at	claim.name
008fd3e6-6499-4e91-a1be-c582d8643561	String	jsonType.label
6467823d-3ff7-471d-9ac5-948ea94f5f66	true	userinfo.token.claim
6467823d-3ff7-471d-9ac5-948ea94f5f66	email	user.attribute
6467823d-3ff7-471d-9ac5-948ea94f5f66	true	id.token.claim
6467823d-3ff7-471d-9ac5-948ea94f5f66	true	access.token.claim
6467823d-3ff7-471d-9ac5-948ea94f5f66	email	claim.name
6467823d-3ff7-471d-9ac5-948ea94f5f66	String	jsonType.label
dd5873e2-4efb-4a86-bf79-55a06e05d24e	true	userinfo.token.claim
dd5873e2-4efb-4a86-bf79-55a06e05d24e	emailVerified	user.attribute
dd5873e2-4efb-4a86-bf79-55a06e05d24e	true	id.token.claim
dd5873e2-4efb-4a86-bf79-55a06e05d24e	true	access.token.claim
dd5873e2-4efb-4a86-bf79-55a06e05d24e	email_verified	claim.name
dd5873e2-4efb-4a86-bf79-55a06e05d24e	boolean	jsonType.label
5df445f8-cd0a-49ac-9658-3da8658f92fb	formatted	user.attribute.formatted
5df445f8-cd0a-49ac-9658-3da8658f92fb	country	user.attribute.country
5df445f8-cd0a-49ac-9658-3da8658f92fb	postal_code	user.attribute.postal_code
5df445f8-cd0a-49ac-9658-3da8658f92fb	true	userinfo.token.claim
5df445f8-cd0a-49ac-9658-3da8658f92fb	street	user.attribute.street
5df445f8-cd0a-49ac-9658-3da8658f92fb	true	id.token.claim
5df445f8-cd0a-49ac-9658-3da8658f92fb	region	user.attribute.region
5df445f8-cd0a-49ac-9658-3da8658f92fb	true	access.token.claim
5df445f8-cd0a-49ac-9658-3da8658f92fb	locality	user.attribute.locality
4907434f-c064-4e23-8e03-bc256c775205	true	userinfo.token.claim
4907434f-c064-4e23-8e03-bc256c775205	phoneNumber	user.attribute
4907434f-c064-4e23-8e03-bc256c775205	true	id.token.claim
4907434f-c064-4e23-8e03-bc256c775205	true	access.token.claim
4907434f-c064-4e23-8e03-bc256c775205	phone_number	claim.name
4907434f-c064-4e23-8e03-bc256c775205	String	jsonType.label
01fcdec6-9c78-43c7-8d21-438cbc66d794	true	userinfo.token.claim
01fcdec6-9c78-43c7-8d21-438cbc66d794	phoneNumberVerified	user.attribute
01fcdec6-9c78-43c7-8d21-438cbc66d794	true	id.token.claim
01fcdec6-9c78-43c7-8d21-438cbc66d794	true	access.token.claim
01fcdec6-9c78-43c7-8d21-438cbc66d794	phone_number_verified	claim.name
01fcdec6-9c78-43c7-8d21-438cbc66d794	boolean	jsonType.label
3bac2167-45d0-4507-beea-791eb1ff205a	true	multivalued
3bac2167-45d0-4507-beea-791eb1ff205a	foo	user.attribute
3bac2167-45d0-4507-beea-791eb1ff205a	true	access.token.claim
3bac2167-45d0-4507-beea-791eb1ff205a	realm_access.roles	claim.name
3bac2167-45d0-4507-beea-791eb1ff205a	String	jsonType.label
2e26d344-41cf-494b-a15a-c316d49293e6	true	multivalued
2e26d344-41cf-494b-a15a-c316d49293e6	foo	user.attribute
2e26d344-41cf-494b-a15a-c316d49293e6	true	access.token.claim
2e26d344-41cf-494b-a15a-c316d49293e6	resource_access.${client_id}.roles	claim.name
2e26d344-41cf-494b-a15a-c316d49293e6	String	jsonType.label
23d50203-1105-4e83-8ec2-c2bdbf4e2a00	true	userinfo.token.claim
23d50203-1105-4e83-8ec2-c2bdbf4e2a00	username	user.attribute
23d50203-1105-4e83-8ec2-c2bdbf4e2a00	true	id.token.claim
23d50203-1105-4e83-8ec2-c2bdbf4e2a00	true	access.token.claim
23d50203-1105-4e83-8ec2-c2bdbf4e2a00	upn	claim.name
23d50203-1105-4e83-8ec2-c2bdbf4e2a00	String	jsonType.label
774fc48e-34ee-4af9-aa56-52b30ae6cb04	true	multivalued
774fc48e-34ee-4af9-aa56-52b30ae6cb04	foo	user.attribute
774fc48e-34ee-4af9-aa56-52b30ae6cb04	true	id.token.claim
774fc48e-34ee-4af9-aa56-52b30ae6cb04	true	access.token.claim
774fc48e-34ee-4af9-aa56-52b30ae6cb04	groups	claim.name
774fc48e-34ee-4af9-aa56-52b30ae6cb04	String	jsonType.label
dcf66934-5597-4153-a515-0a3e31407659	true	userinfo.token.claim
dcf66934-5597-4153-a515-0a3e31407659	locale	user.attribute
dcf66934-5597-4153-a515-0a3e31407659	true	id.token.claim
dcf66934-5597-4153-a515-0a3e31407659	true	access.token.claim
dcf66934-5597-4153-a515-0a3e31407659	locale	claim.name
dcf66934-5597-4153-a515-0a3e31407659	String	jsonType.label
abbeb78d-4cbc-4b43-9247-617463c75855	clientId	user.session.note
abbeb78d-4cbc-4b43-9247-617463c75855	true	id.token.claim
abbeb78d-4cbc-4b43-9247-617463c75855	true	access.token.claim
abbeb78d-4cbc-4b43-9247-617463c75855	clientId	claim.name
abbeb78d-4cbc-4b43-9247-617463c75855	String	jsonType.label
87ba51b5-8558-44e2-9213-ea68986e3c1d	clientHost	user.session.note
87ba51b5-8558-44e2-9213-ea68986e3c1d	true	id.token.claim
87ba51b5-8558-44e2-9213-ea68986e3c1d	true	access.token.claim
87ba51b5-8558-44e2-9213-ea68986e3c1d	clientHost	claim.name
87ba51b5-8558-44e2-9213-ea68986e3c1d	String	jsonType.label
b08f323c-291b-4e9f-a4d6-8748829c97de	clientAddress	user.session.note
b08f323c-291b-4e9f-a4d6-8748829c97de	true	id.token.claim
b08f323c-291b-4e9f-a4d6-8748829c97de	true	access.token.claim
b08f323c-291b-4e9f-a4d6-8748829c97de	clientAddress	claim.name
b08f323c-291b-4e9f-a4d6-8748829c97de	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me) FROM stdin;
master	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	41f7850a-c7c8-4967-8306-b1159db2d196	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	46311784-6b0a-49e0-abff-939380a1cafe	4cfab865-f306-4b7f-86cd-0294d9cec8df	b55f736c-b6b6-4657-88a7-b1584b274e62	2bb6e8d6-d50e-48c3-891b-d6e5541cbb30	5f05c917-b832-4ae0-bb50-30efcdb79a38	2592000	f	900	t	f	628cf4f3-619b-4250-a06a-8f2713b9e492	0	f	0	0
libstack-test	60	300	300	\N	\N	\N	t	f	0	\N	libstack-test	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	1a5b8f72-366d-4f43-8b25-a174328287b3	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	3a720e53-b21f-463c-83ad-bf7b97057ae4	fe2a5c6d-5e4b-4e62-8e0b-791df4ce43d9	d2a8385c-48de-46a7-b0ba-1612658a3ed8	bcd5ed71-19fa-4548-a530-5f0361e8ed01	b178453c-ba6e-4bdb-b5ec-0eb8dfdb594e	2592000	f	900	t	f	8d599221-184b-4057-8769-ed1c318eca6d	0	f	0	0
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_attribute (name, value, realm_id) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly		master
_browser_header.xContentTypeOptions	nosniff	master
_browser_header.xRobotsTag	none	master
_browser_header.xFrameOptions	SAMEORIGIN	master
_browser_header.contentSecurityPolicy	frame-src 'self'; frame-ancestors 'self'; object-src 'none';	master
_browser_header.xXSSProtection	1; mode=block	master
_browser_header.strictTransportSecurity	max-age=31536000; includeSubDomains	master
bruteForceProtected	false	master
permanentLockout	false	master
maxFailureWaitSeconds	900	master
minimumQuickLoginWaitSeconds	60	master
waitIncrementSeconds	60	master
quickLoginCheckMilliSeconds	1000	master
maxDeltaTimeSeconds	43200	master
failureFactor	30	master
displayName	Keycloak	master
displayNameHtml	<div class="kc-logo-text"><span>Keycloak</span></div>	master
offlineSessionMaxLifespanEnabled	false	master
offlineSessionMaxLifespan	5184000	master
_browser_header.contentSecurityPolicyReportOnly		libstack-test
_browser_header.xContentTypeOptions	nosniff	libstack-test
_browser_header.xRobotsTag	none	libstack-test
_browser_header.xFrameOptions	SAMEORIGIN	libstack-test
_browser_header.contentSecurityPolicy	frame-src 'self'; frame-ancestors 'self'; object-src 'none';	libstack-test
_browser_header.xXSSProtection	1; mode=block	libstack-test
_browser_header.strictTransportSecurity	max-age=31536000; includeSubDomains	libstack-test
bruteForceProtected	false	libstack-test
permanentLockout	false	libstack-test
maxFailureWaitSeconds	900	libstack-test
minimumQuickLoginWaitSeconds	60	libstack-test
waitIncrementSeconds	60	libstack-test
quickLoginCheckMilliSeconds	1000	libstack-test
maxDeltaTimeSeconds	43200	libstack-test
failureFactor	30	libstack-test
offlineSessionMaxLifespanEnabled	false	libstack-test
offlineSessionMaxLifespan	5184000	libstack-test
actionTokenGeneratedByAdminLifespan	43200	libstack-test
actionTokenGeneratedByUserLifespan	300	libstack-test
webAuthnPolicyRpEntityName	keycloak	libstack-test
webAuthnPolicySignatureAlgorithms	ES256	libstack-test
webAuthnPolicyRpId		libstack-test
webAuthnPolicyAttestationConveyancePreference	not specified	libstack-test
webAuthnPolicyAuthenticatorAttachment	not specified	libstack-test
webAuthnPolicyRequireResidentKey	not specified	libstack-test
webAuthnPolicyUserVerificationRequirement	not specified	libstack-test
webAuthnPolicyCreateTimeout	0	libstack-test
webAuthnPolicyAvoidSameAuthenticatorRegister	false	libstack-test
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_default_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_default_roles (realm_id, role_id) FROM stdin;
master	1080c26c-1edb-4bf3-bbf2-7858ba751ebd
master	16385a66-ae65-43f6-a2ed-bf0b7fbc34a8
libstack-test	7c6d1c8f-5f08-4a4f-98e7-c0b6bb4d17ef
libstack-test	064afaea-c7b1-491d-b3ae-339354fc9a1c
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
master	jboss-logging
libstack-test	jboss-logging
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	master
password	password	t	t	libstack-test
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.redirect_uris (client_id, value) FROM stdin;
0a536141-8431-46a7-a460-67309f864cb6	/realms/master/account/*
4a0be8dd-196e-40a2-832e-d247de89160b	/admin/master/console/*
1ef3b5bc-5216-4c3e-8e32-20ecb4f810c6	/realms/libstack-test/account/*
70ec0242-448b-4902-a8d8-05edad4ba0c3	/admin/libstack-test/console/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
f5ef05ec-b8e1-4596-b827-d78fd2ff5226	VERIFY_EMAIL	Verify Email	master	t	f	VERIFY_EMAIL	50
f85ac42f-bcde-4e21-b8ad-0bbf6b94d2b6	UPDATE_PROFILE	Update Profile	master	t	f	UPDATE_PROFILE	40
15b569aa-401b-4826-8a85-2547990d0d2e	CONFIGURE_TOTP	Configure OTP	master	t	f	CONFIGURE_TOTP	10
1b104779-f337-4055-932a-49f596aae2f6	UPDATE_PASSWORD	Update Password	master	t	f	UPDATE_PASSWORD	30
587dfc35-043b-4b0f-93ba-d1982fb3dc91	terms_and_conditions	Terms and Conditions	master	f	f	terms_and_conditions	20
51147fb0-f5af-4552-a24b-95cc54df95e3	VERIFY_EMAIL	Verify Email	libstack-test	t	f	VERIFY_EMAIL	50
cb94e417-ea97-4af0-9dc0-4d9c76c609a7	UPDATE_PROFILE	Update Profile	libstack-test	t	f	UPDATE_PROFILE	40
dfa3ff96-795e-476b-a5ee-2028d8252cc4	CONFIGURE_TOTP	Configure OTP	libstack-test	t	f	CONFIGURE_TOTP	10
2349a5c3-22e0-429a-a0e9-22d6ad46b8b7	UPDATE_PASSWORD	Update Password	libstack-test	t	f	UPDATE_PASSWORD	30
d78c0f4f-d2ba-48d9-91ba-ddf6447c6423	terms_and_conditions	Terms and Conditions	libstack-test	f	f	terms_and_conditions	20
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
ffa86902-bac5-427d-8565-676476629599	\N	fdf57c93-98f5-419b-8558-93d90c1d459c	f	t	\N	\N	\N	master	admin	1576008389603	\N	0
4c76bdbc-1250-4524-93ca-fd0601eaae61	\N	0d13e3c0-7749-43a8-9129-947c7ae47e5a	f	t	\N	\N	\N	libstack-test	service-account-libstack	1576009238844	eb347312-64e2-4ff6-89ff-0f544da6dde6	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
16385a66-ae65-43f6-a2ed-bf0b7fbc34a8	ffa86902-bac5-427d-8565-676476629599
02014c5e-ba15-4e88-a6c9-143466c8f34d	ffa86902-bac5-427d-8565-676476629599
1080c26c-1edb-4bf3-bbf2-7858ba751ebd	ffa86902-bac5-427d-8565-676476629599
703444a6-2a4f-40e5-bf73-ad68f435ee22	ffa86902-bac5-427d-8565-676476629599
c021dbe3-97c8-4322-9198-3f5ad81a3262	ffa86902-bac5-427d-8565-676476629599
064afaea-c7b1-491d-b3ae-339354fc9a1c	4c76bdbc-1250-4524-93ca-fd0601eaae61
7c6d1c8f-5f08-4a4f-98e7-c0b6bb4d17ef	4c76bdbc-1250-4524-93ca-fd0601eaae61
e1eb8155-8344-46bb-b76c-1af1fc61d88b	4c76bdbc-1250-4524-93ca-fd0601eaae61
6252b63a-b145-4b05-aee6-d19b9e3f00f8	4c76bdbc-1250-4524-93ca-fd0601eaae61
ab9866ce-d635-486a-a0ce-f4dbd2559025	4c76bdbc-1250-4524-93ca-fd0601eaae61
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.web_origins (client_id, value) FROM stdin;
4a0be8dd-196e-40a2-832e-d247de89160b	+
70ec0242-448b-4902-a8d8-05edad4ba0c3	+
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: client_default_roles constr_client_default_roles; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT constr_client_default_roles PRIMARY KEY (client_id, role_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: realm_default_roles constraint_realm_default_roles; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT constraint_realm_default_roles PRIMARY KEY (realm_id, role_id);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client_default_roles uk_8aelwnibji49avxsrtuf6xjow; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT uk_8aelwnibji49avxsrtuf6xjow UNIQUE (role_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: realm_default_roles uk_h4wpd7w4hsoolni3h0sw7btje; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT uk_h4wpd7w4hsoolni3h0sw7btje UNIQUE (role_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_def_roles_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_def_roles_client ON public.client_default_roles USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_def_roles_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_def_roles_realm ON public.realm_default_roles USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_default_roles fk_8aelwnibji49avxsrtuf6xjow; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT fk_8aelwnibji49avxsrtuf6xjow FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_client fk_c_cli_scope_client; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT fk_c_cli_scope_client FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_scope_client fk_c_cli_scope_scope; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT fk_c_cli_scope_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_role FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_roles fk_evudb1ppw84oxfax2drs03icc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT fk_evudb1ppw84oxfax2drs03icc FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: keycloak_group fk_group_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT fk_group_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_role FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_default_roles fk_h4wpd7w4hsoolni3h0sw7btje; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT fk_h4wpd7w4hsoolni3h0sw7btje FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: keycloak_role fk_kjho5le2c0ral09fl8cm9wfw9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_kjho5le2c0ral09fl8cm9wfw9 FOREIGN KEY (client) REFERENCES public.client(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_default_roles fk_nuilts7klwqw2h8m2b5joytky; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT fk_nuilts7klwqw2h8m2b5joytky FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_p3rh9grku11kqfrs4fltt7rnq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_p3rh9grku11kqfrs4fltt7rnq FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: client fk_p56ctinxxb9gsk57fo49f9tac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT fk_p56ctinxxb9gsk57fo49f9tac FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_scope; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope fk_realm_cli_scope; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT fk_realm_cli_scope FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: realm fk_traf444kk6qrkms7n56aiwq5y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT fk_traf444kk6qrkms7n56aiwq5y FOREIGN KEY (master_admin_client) REFERENCES public.client(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

