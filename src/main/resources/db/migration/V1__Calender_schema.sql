CREATE TABLE admin_event_entity
(
    id               VARCHAR(36) NOT NULL,
    admin_event_time BIGINT,
    realm_id         VARCHAR(255),
    operation_type   VARCHAR(255),
    auth_realm_id    VARCHAR(255),
    auth_client_id   VARCHAR(255),
    auth_user_id     VARCHAR(255),
    ip_address       VARCHAR(255),
    resource_path    VARCHAR(2550),
    representation   TEXT,
    error            VARCHAR(255),
    resource_type    VARCHAR(64),
    CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id)
);

CREATE TABLE associated_policy
(
    policy_id            VARCHAR(36) NOT NULL,
    associated_policy_id VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id)
);

CREATE TABLE authentication_execution
(
    id                 VARCHAR(36)           NOT NULL,
    alias              VARCHAR(255),
    authenticator      VARCHAR(36),
    realm_id           VARCHAR(36),
    flow_id            VARCHAR(36),
    requirement        INTEGER,
    priority           INTEGER,
    authenticator_flow BOOLEAN DEFAULT FALSE NOT NULL,
    auth_flow_id       VARCHAR(36),
    auth_config        VARCHAR(36),
    CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id)
);

CREATE TABLE authentication_flow
(
    id          VARCHAR(36)                      NOT NULL,
    alias       VARCHAR(255),
    description VARCHAR(255),
    realm_id    VARCHAR(36),
    provider_id VARCHAR(36) DEFAULT 'basic-flow' NOT NULL,
    top_level   BOOLEAN     DEFAULT FALSE        NOT NULL,
    built_in    BOOLEAN     DEFAULT FALSE        NOT NULL,
    CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id)
);

CREATE TABLE authenticator_config
(
    id       VARCHAR(36) NOT NULL,
    alias    VARCHAR(255),
    realm_id VARCHAR(36),
    CONSTRAINT constraint_auth_pk PRIMARY KEY (id)
);

CREATE TABLE authenticator_config_entry
(
    authenticator_id VARCHAR(36)  NOT NULL,
    value            TEXT,
    name             VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name)
);

CREATE TABLE broker_link
(
    identity_provider   VARCHAR(255) NOT NULL,
    storage_provider_id VARCHAR(255),
    realm_id            VARCHAR(36)  NOT NULL,
    broker_user_id      VARCHAR(255),
    broker_username     VARCHAR(255),
    token               TEXT,
    user_id             VARCHAR(255) NOT NULL,
    CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id)
);

CREATE TABLE client
(
    id                           VARCHAR(36)           NOT NULL,
    enabled                      BOOLEAN DEFAULT FALSE NOT NULL,
    full_scope_allowed           BOOLEAN DEFAULT FALSE NOT NULL,
    client_id                    VARCHAR(255),
    not_before                   INTEGER,
    public_client                BOOLEAN DEFAULT FALSE NOT NULL,
    secret                       VARCHAR(255),
    base_url                     VARCHAR(255),
    bearer_only                  BOOLEAN DEFAULT FALSE NOT NULL,
    management_url               VARCHAR(255),
    surrogate_auth_required      BOOLEAN DEFAULT FALSE NOT NULL,
    realm_id                     VARCHAR(36),
    protocol                     VARCHAR(255),
    node_rereg_timeout           INTEGER DEFAULT 0,
    frontchannel_logout          BOOLEAN DEFAULT FALSE NOT NULL,
    consent_required             BOOLEAN DEFAULT FALSE NOT NULL,
    name                         VARCHAR(255),
    service_accounts_enabled     BOOLEAN DEFAULT FALSE NOT NULL,
    client_authenticator_type    VARCHAR(255),
    root_url                     VARCHAR(255),
    description                  VARCHAR(255),
    registration_token           VARCHAR(255),
    standard_flow_enabled        BOOLEAN DEFAULT TRUE  NOT NULL,
    implicit_flow_enabled        BOOLEAN DEFAULT FALSE NOT NULL,
    direct_access_grants_enabled BOOLEAN DEFAULT FALSE NOT NULL,
    always_display_in_console    BOOLEAN DEFAULT FALSE NOT NULL,
    CONSTRAINT constraint_7 PRIMARY KEY (id)
);

CREATE TABLE client_attributes
(
    client_id VARCHAR(36)  NOT NULL,
    name      VARCHAR(255) NOT NULL,
    value     TEXT,
    CONSTRAINT constraint_3c PRIMARY KEY (client_id, name)
);

CREATE TABLE client_auth_flow_bindings
(
    client_id    VARCHAR(36)  NOT NULL,
    flow_id      VARCHAR(36),
    binding_name VARCHAR(255) NOT NULL,
    CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name)
);

CREATE TABLE client_initial_access
(
    id              VARCHAR(36) NOT NULL,
    realm_id        VARCHAR(36) NOT NULL,
    timestamp       INTEGER,
    expiration      INTEGER,
    count           INTEGER,
    remaining_count INTEGER,
    CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id)
);

CREATE TABLE client_node_registrations
(
    client_id VARCHAR(36)  NOT NULL,
    value     INTEGER,
    name      VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_84 PRIMARY KEY (client_id, name)
);

CREATE TABLE client_scope
(
    id          VARCHAR(36) NOT NULL,
    name        VARCHAR(255),
    realm_id    VARCHAR(36),
    description VARCHAR(255),
    protocol    VARCHAR(255),
    CONSTRAINT pk_cli_template PRIMARY KEY (id)
);

CREATE TABLE client_scope_attributes
(
    scope_id VARCHAR(36)  NOT NULL,
    value    VARCHAR(2048),
    name     VARCHAR(255) NOT NULL,
    CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name)
);

CREATE TABLE client_scope_client
(
    client_id     VARCHAR(255)          NOT NULL,
    scope_id      VARCHAR(255)          NOT NULL,
    default_scope BOOLEAN DEFAULT FALSE NOT NULL,
    CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id)
);

CREATE TABLE client_scope_role_mapping
(
    scope_id VARCHAR(36) NOT NULL,
    role_id  VARCHAR(36) NOT NULL,
    CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id)
);

CREATE TABLE client_session
(
    id             VARCHAR(36) NOT NULL,
    client_id      VARCHAR(36),
    redirect_uri   VARCHAR(255),
    state          VARCHAR(255),
    timestamp      INTEGER,
    session_id     VARCHAR(36),
    auth_method    VARCHAR(255),
    realm_id       VARCHAR(255),
    auth_user_id   VARCHAR(36),
    current_action VARCHAR(36),
    CONSTRAINT constraint_8 PRIMARY KEY (id)
);

CREATE TABLE client_session_auth_status
(
    authenticator  VARCHAR(36) NOT NULL,
    status         INTEGER,
    client_session VARCHAR(36) NOT NULL
);

CREATE TABLE client_session_note
(
    name           VARCHAR(255) NOT NULL,
    value          VARCHAR(255),
    client_session VARCHAR(36)  NOT NULL
);

CREATE TABLE client_session_prot_mapper
(
    protocol_mapper_id VARCHAR(36) NOT NULL,
    client_session     VARCHAR(36) NOT NULL
);

CREATE TABLE client_session_role
(
    role_id        VARCHAR(255) NOT NULL,
    client_session VARCHAR(36)  NOT NULL
);

CREATE TABLE client_user_session_note
(
    name           VARCHAR(255) NOT NULL,
    value          VARCHAR(2048),
    client_session VARCHAR(36)  NOT NULL
);

CREATE TABLE component
(
    id            VARCHAR(36) NOT NULL,
    name          VARCHAR(255),
    parent_id     VARCHAR(36),
    provider_id   VARCHAR(36),
    provider_type VARCHAR(255),
    realm_id      VARCHAR(36),
    sub_type      VARCHAR(255),
    CONSTRAINT constr_component_pk PRIMARY KEY (id)
);

CREATE TABLE component_config
(
    id           VARCHAR(36)  NOT NULL,
    component_id VARCHAR(36)  NOT NULL,
    name         VARCHAR(255) NOT NULL,
    value        VARCHAR(4000),
    CONSTRAINT constr_component_config_pk PRIMARY KEY (id)
);

CREATE TABLE composite_role
(
    composite  VARCHAR(36) NOT NULL,
    child_role VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role)
);

CREATE TABLE credential
(
    id              VARCHAR(36) NOT NULL,
    salt            BYTEA,
    type            VARCHAR(255),
    user_id         VARCHAR(36),
    created_date    BIGINT,
    user_label      VARCHAR(255),
    secret_data     TEXT,
    credential_data TEXT,
    priority        INTEGER,
    CONSTRAINT constraint_f PRIMARY KEY (id)
);

CREATE TABLE default_client_scope
(
    realm_id      VARCHAR(36)           NOT NULL,
    scope_id      VARCHAR(36)           NOT NULL,
    default_scope BOOLEAN DEFAULT FALSE NOT NULL,
    CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id)
);

CREATE TABLE event_entity
(
    id           VARCHAR(36) NOT NULL,
    client_id    VARCHAR(255),
    details_json VARCHAR(2550),
    error        VARCHAR(255),
    ip_address   VARCHAR(255),
    realm_id     VARCHAR(255),
    session_id   VARCHAR(255),
    event_time   BIGINT,
    type         VARCHAR(255),
    user_id      VARCHAR(255),
    CONSTRAINT constraint_4 PRIMARY KEY (id)
);

CREATE TABLE fed_user_attribute
(
    id                  VARCHAR(36)  NOT NULL,
    name                VARCHAR(255) NOT NULL,
    user_id             VARCHAR(255) NOT NULL,
    realm_id            VARCHAR(36)  NOT NULL,
    storage_provider_id VARCHAR(36),
    value               VARCHAR(2024),
    CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id)
);

CREATE TABLE fed_user_consent
(
    id                      VARCHAR(36)  NOT NULL,
    client_id               VARCHAR(255),
    user_id                 VARCHAR(255) NOT NULL,
    realm_id                VARCHAR(36)  NOT NULL,
    storage_provider_id     VARCHAR(36),
    created_date            BIGINT,
    last_updated_date       BIGINT,
    client_storage_provider VARCHAR(36),
    external_client_id      VARCHAR(255),
    CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id)
);

CREATE TABLE fed_user_consent_cl_scope
(
    user_consent_id VARCHAR(36) NOT NULL,
    scope_id        VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id)
);

CREATE TABLE fed_user_credential
(
    id                  VARCHAR(36)  NOT NULL,
    salt                BYTEA,
    type                VARCHAR(255),
    created_date        BIGINT,
    user_id             VARCHAR(255) NOT NULL,
    realm_id            VARCHAR(36)  NOT NULL,
    storage_provider_id VARCHAR(36),
    user_label          VARCHAR(255),
    secret_data         TEXT,
    credential_data     TEXT,
    priority            INTEGER,
    CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id)
);

CREATE TABLE fed_user_group_membership
(
    group_id            VARCHAR(36)  NOT NULL,
    user_id             VARCHAR(255) NOT NULL,
    realm_id            VARCHAR(36)  NOT NULL,
    storage_provider_id VARCHAR(36),
    CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id)
);

CREATE TABLE fed_user_required_action
(
    required_action     VARCHAR(255) DEFAULT ' ' NOT NULL,
    user_id             VARCHAR(255)             NOT NULL,
    realm_id            VARCHAR(36)              NOT NULL,
    storage_provider_id VARCHAR(36),
    CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id)
);

CREATE TABLE fed_user_role_mapping
(
    role_id             VARCHAR(36)  NOT NULL,
    user_id             VARCHAR(255) NOT NULL,
    realm_id            VARCHAR(36)  NOT NULL,
    storage_provider_id VARCHAR(36),
    CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id)
);

CREATE TABLE federated_identity
(
    identity_provider  VARCHAR(255) NOT NULL,
    realm_id           VARCHAR(36),
    federated_user_id  VARCHAR(255),
    federated_username VARCHAR(255),
    token              TEXT,
    user_id            VARCHAR(36)  NOT NULL,
    CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id)
);

CREATE TABLE federated_user
(
    id                  VARCHAR(255) NOT NULL,
    storage_provider_id VARCHAR(255),
    realm_id            VARCHAR(36)  NOT NULL,
    CONSTRAINT constr_federated_user PRIMARY KEY (id)
);

CREATE TABLE group_attribute
(
    id       VARCHAR(36) DEFAULT 'sybase-needs-something-here' NOT NULL,
    name     VARCHAR(255)                                      NOT NULL,
    value    VARCHAR(255),
    group_id VARCHAR(36)                                       NOT NULL,
    CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id)
);

CREATE TABLE group_role_mapping
(
    role_id  VARCHAR(36) NOT NULL,
    group_id VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id)
);

CREATE TABLE identity_provider
(
    internal_id                VARCHAR(36)           NOT NULL,
    enabled                    BOOLEAN DEFAULT FALSE NOT NULL,
    provider_alias             VARCHAR(255),
    provider_id                VARCHAR(255),
    store_token                BOOLEAN DEFAULT FALSE NOT NULL,
    authenticate_by_default    BOOLEAN DEFAULT FALSE NOT NULL,
    realm_id                   VARCHAR(36),
    add_token_role             BOOLEAN DEFAULT TRUE  NOT NULL,
    trust_email                BOOLEAN DEFAULT FALSE NOT NULL,
    first_broker_login_flow_id VARCHAR(36),
    post_broker_login_flow_id  VARCHAR(36),
    provider_display_name      VARCHAR(255),
    link_only                  BOOLEAN DEFAULT FALSE NOT NULL,
    CONSTRAINT constraint_2b PRIMARY KEY (internal_id)
);

CREATE TABLE identity_provider_config
(
    identity_provider_id VARCHAR(36)  NOT NULL,
    value                TEXT,
    name                 VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name)
);

CREATE TABLE identity_provider_mapper
(
    id              VARCHAR(36)  NOT NULL,
    name            VARCHAR(255) NOT NULL,
    idp_alias       VARCHAR(255) NOT NULL,
    idp_mapper_name VARCHAR(255) NOT NULL,
    realm_id        VARCHAR(36)  NOT NULL,
    CONSTRAINT constraint_idpm PRIMARY KEY (id)
);

CREATE TABLE idp_mapper_config
(
    idp_mapper_id VARCHAR(36)  NOT NULL,
    value         TEXT,
    name          VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name)
);

CREATE TABLE keycloak_group
(
    id           VARCHAR(36) NOT NULL,
    name         VARCHAR(255),
    parent_group VARCHAR(36) NOT NULL,
    realm_id     VARCHAR(36),
    CONSTRAINT constraint_group PRIMARY KEY (id)
);

CREATE TABLE keycloak_role
(
    id                      VARCHAR(36)           NOT NULL,
    client_realm_constraint VARCHAR(255),
    client_role             BOOLEAN DEFAULT FALSE NOT NULL,
    description             VARCHAR(255),
    name                    VARCHAR(255),
    realm_id                VARCHAR(255),
    client                  VARCHAR(36),
    realm                   VARCHAR(36),
    CONSTRAINT constraint_a PRIMARY KEY (id)
);

CREATE TABLE migration_model
(
    id          VARCHAR(36)      NOT NULL,
    version     VARCHAR(36),
    update_time BIGINT DEFAULT 0 NOT NULL,
    CONSTRAINT constraint_migmod PRIMARY KEY (id)
);

CREATE TABLE offline_client_session
(
    user_session_id         VARCHAR(36)                  NOT NULL,
    client_id               VARCHAR(255)                 NOT NULL,
    offline_flag            VARCHAR(4)                   NOT NULL,
    timestamp               INTEGER,
    data                    TEXT,
    client_storage_provider VARCHAR(36)  DEFAULT 'local' NOT NULL,
    external_client_id      VARCHAR(255) DEFAULT 'local' NOT NULL
);

CREATE TABLE offline_user_session
(
    user_session_id      VARCHAR(36)       NOT NULL,
    user_id              VARCHAR(255)      NOT NULL,
    realm_id             VARCHAR(36)       NOT NULL,
    created_on           INTEGER           NOT NULL,
    offline_flag         VARCHAR(4)        NOT NULL,
    data                 TEXT,
    last_session_refresh INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag)
);

CREATE TABLE policy_config
(
    policy_id VARCHAR(36)  NOT NULL,
    name      VARCHAR(255) NOT NULL,
    value     TEXT,
    CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name)
);

CREATE TABLE protocol_mapper
(
    id                   VARCHAR(36)  NOT NULL,
    name                 VARCHAR(255) NOT NULL,
    protocol             VARCHAR(255) NOT NULL,
    protocol_mapper_name VARCHAR(255) NOT NULL,
    client_id            VARCHAR(36),
    client_scope_id      VARCHAR(36),
    CONSTRAINT constraint_pcm PRIMARY KEY (id)
);

CREATE TABLE protocol_mapper_config
(
    protocol_mapper_id VARCHAR(36)  NOT NULL,
    value              TEXT,
    name               VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name)
);

CREATE TABLE realm
(
    id                           VARCHAR(36)               NOT NULL,
    access_code_lifespan         INTEGER,
    user_action_lifespan         INTEGER,
    access_token_lifespan        INTEGER,
    account_theme                VARCHAR(255),
    admin_theme                  VARCHAR(255),
    email_theme                  VARCHAR(255),
    enabled                      BOOLEAN     DEFAULT FALSE NOT NULL,
    events_enabled               BOOLEAN     DEFAULT FALSE NOT NULL,
    events_expiration            BIGINT,
    login_theme                  VARCHAR(255),
    name                         VARCHAR(255),
    not_before                   INTEGER,
    password_policy              VARCHAR(2550),
    registration_allowed         BOOLEAN     DEFAULT FALSE NOT NULL,
    remember_me                  BOOLEAN     DEFAULT FALSE NOT NULL,
    reset_password_allowed       BOOLEAN     DEFAULT FALSE NOT NULL,
    social                       BOOLEAN     DEFAULT FALSE NOT NULL,
    ssl_required                 VARCHAR(255),
    sso_idle_timeout             INTEGER,
    sso_max_lifespan             INTEGER,
    update_profile_on_soc_login  BOOLEAN     DEFAULT FALSE NOT NULL,
    verify_email                 BOOLEAN     DEFAULT FALSE NOT NULL,
    master_admin_client          VARCHAR(36),
    login_lifespan               INTEGER,
    internationalization_enabled BOOLEAN     DEFAULT FALSE NOT NULL,
    default_locale               VARCHAR(255),
    reg_email_as_username        BOOLEAN     DEFAULT FALSE NOT NULL,
    admin_events_enabled         BOOLEAN     DEFAULT FALSE NOT NULL,
    admin_events_details_enabled BOOLEAN     DEFAULT FALSE NOT NULL,
    edit_username_allowed        BOOLEAN     DEFAULT FALSE NOT NULL,
    otp_policy_counter           INTEGER     DEFAULT 0,
    otp_policy_window            INTEGER     DEFAULT 1,
    otp_policy_period            INTEGER     DEFAULT 30,
    otp_policy_digits            INTEGER     DEFAULT 6,
    otp_policy_alg               VARCHAR(36) DEFAULT 'HmacSHA1',
    otp_policy_type              VARCHAR(36) DEFAULT 'totp',
    browser_flow                 VARCHAR(36),
    registration_flow            VARCHAR(36),
    direct_grant_flow            VARCHAR(36),
    reset_credentials_flow       VARCHAR(36),
    client_auth_flow             VARCHAR(36),
    offline_session_idle_timeout INTEGER     DEFAULT 0,
    revoke_refresh_token         BOOLEAN     DEFAULT FALSE NOT NULL,
    access_token_life_implicit   INTEGER     DEFAULT 0,
    login_with_email_allowed     BOOLEAN     DEFAULT TRUE  NOT NULL,
    duplicate_emails_allowed     BOOLEAN     DEFAULT FALSE NOT NULL,
    docker_auth_flow             VARCHAR(36),
    refresh_token_max_reuse      INTEGER     DEFAULT 0,
    allow_user_managed_access    BOOLEAN     DEFAULT FALSE NOT NULL,
    sso_max_lifespan_remember_me INTEGER     DEFAULT 0     NOT NULL,
    sso_idle_timeout_remember_me INTEGER     DEFAULT 0     NOT NULL,
    default_role                 VARCHAR(255),
    CONSTRAINT constraint_4a PRIMARY KEY (id)
);

CREATE TABLE realm_attribute
(
    name     VARCHAR(255) NOT NULL,
    realm_id VARCHAR(36)  NOT NULL,
    value    TEXT,
    CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id)
);

CREATE TABLE realm_default_groups
(
    realm_id VARCHAR(36) NOT NULL,
    group_id VARCHAR(36) NOT NULL,
    CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id)
);

CREATE TABLE realm_enabled_event_types
(
    realm_id VARCHAR(36)  NOT NULL,
    value    VARCHAR(255) NOT NULL,
    CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value)
);

CREATE TABLE realm_events_listeners
(
    realm_id VARCHAR(36)  NOT NULL,
    value    VARCHAR(255) NOT NULL,
    CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value)
);

CREATE TABLE realm_localizations
(
    realm_id VARCHAR(255) NOT NULL,
    locale   VARCHAR(255) NOT NULL,
    texts    TEXT         NOT NULL,
    CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale)
);

CREATE TABLE realm_required_credential
(
    type       VARCHAR(255)          NOT NULL,
    form_label VARCHAR(255),
    input      BOOLEAN DEFAULT FALSE NOT NULL,
    secret     BOOLEAN DEFAULT FALSE NOT NULL,
    realm_id   VARCHAR(36)           NOT NULL
);

CREATE TABLE realm_smtp_config
(
    realm_id VARCHAR(36)  NOT NULL,
    value    VARCHAR(255),
    name     VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_e PRIMARY KEY (realm_id, name)
);

CREATE TABLE realm_supported_locales
(
    realm_id VARCHAR(36)  NOT NULL,
    value    VARCHAR(255) NOT NULL,
    CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value)
);

CREATE TABLE redirect_uris
(
    client_id VARCHAR(36)  NOT NULL,
    value     VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value)
);

CREATE TABLE required_action_config
(
    required_action_id VARCHAR(36)  NOT NULL,
    value              TEXT,
    name               VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name)
);

CREATE TABLE required_action_provider
(
    id             VARCHAR(36)           NOT NULL,
    alias          VARCHAR(255),
    name           VARCHAR(255),
    realm_id       VARCHAR(36),
    enabled        BOOLEAN DEFAULT FALSE NOT NULL,
    default_action BOOLEAN DEFAULT FALSE NOT NULL,
    provider_id    VARCHAR(255),
    priority       INTEGER,
    CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id)
);

CREATE TABLE resource_attribute
(
    id          VARCHAR(36) DEFAULT 'sybase-needs-something-here' NOT NULL,
    name        VARCHAR(255)                                      NOT NULL,
    value       VARCHAR(255),
    resource_id VARCHAR(36)                                       NOT NULL,
    CONSTRAINT res_attr_pk PRIMARY KEY (id)
);

CREATE TABLE resource_policy
(
    resource_id VARCHAR(36) NOT NULL,
    policy_id   VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id)
);

CREATE TABLE resource_scope
(
    resource_id VARCHAR(36) NOT NULL,
    scope_id    VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id)
);

CREATE TABLE resource_server
(
    id                   VARCHAR(36)            NOT NULL,
    allow_rs_remote_mgmt BOOLEAN  DEFAULT FALSE NOT NULL,
    policy_enforce_mode  SMALLINT               NOT NULL,
    decision_strategy    SMALLINT DEFAULT 1     NOT NULL,
    CONSTRAINT pk_resource_server PRIMARY KEY (id)
);

CREATE TABLE resource_server_perm_ticket
(
    id                 VARCHAR(36)  NOT NULL,
    owner              VARCHAR(255) NOT NULL,
    requester          VARCHAR(255) NOT NULL,
    created_timestamp  BIGINT       NOT NULL,
    granted_timestamp  BIGINT,
    resource_id        VARCHAR(36)  NOT NULL,
    scope_id           VARCHAR(36),
    resource_server_id VARCHAR(36)  NOT NULL,
    policy_id          VARCHAR(36),
    CONSTRAINT constraint_fapmt PRIMARY KEY (id)
);

CREATE TABLE resource_server_policy
(
    id                 VARCHAR(36)  NOT NULL,
    name               VARCHAR(255) NOT NULL,
    description        VARCHAR(255),
    type               VARCHAR(255) NOT NULL,
    decision_strategy  SMALLINT,
    logic              SMALLINT,
    resource_server_id VARCHAR(36)  NOT NULL,
    owner              VARCHAR(255),
    CONSTRAINT constraint_farsrp PRIMARY KEY (id)
);

CREATE TABLE resource_server_resource
(
    id                   VARCHAR(36)           NOT NULL,
    name                 VARCHAR(255)          NOT NULL,
    type                 VARCHAR(255),
    icon_uri             VARCHAR(255),
    owner                VARCHAR(255)          NOT NULL,
    resource_server_id   VARCHAR(36)           NOT NULL,
    owner_managed_access BOOLEAN DEFAULT FALSE NOT NULL,
    display_name         VARCHAR(255),
    CONSTRAINT constraint_farsr PRIMARY KEY (id)
);

CREATE TABLE resource_server_scope
(
    id                 VARCHAR(36)  NOT NULL,
    name               VARCHAR(255) NOT NULL,
    icon_uri           VARCHAR(255),
    resource_server_id VARCHAR(36)  NOT NULL,
    display_name       VARCHAR(255),
    CONSTRAINT constraint_farsrs PRIMARY KEY (id)
);

CREATE TABLE resource_uris
(
    resource_id VARCHAR(36)  NOT NULL,
    value       VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value)
);

CREATE TABLE role_attribute
(
    id      VARCHAR(36)  NOT NULL,
    role_id VARCHAR(36)  NOT NULL,
    name    VARCHAR(255) NOT NULL,
    value   VARCHAR(255),
    CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id)
);

CREATE TABLE scope_mapping
(
    client_id VARCHAR(36) NOT NULL,
    role_id   VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id)
);

CREATE TABLE scope_policy
(
    scope_id  VARCHAR(36) NOT NULL,
    policy_id VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id)
);

CREATE TABLE user_attribute
(
    name    VARCHAR(255)                                      NOT NULL,
    value   VARCHAR(255),
    user_id VARCHAR(36)                                       NOT NULL,
    id      VARCHAR(36) DEFAULT 'sybase-needs-something-here' NOT NULL,
    CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id)
);

CREATE TABLE user_consent
(
    id                      VARCHAR(36) NOT NULL,
    client_id               VARCHAR(255),
    user_id                 VARCHAR(36) NOT NULL,
    created_date            BIGINT,
    last_updated_date       BIGINT,
    client_storage_provider VARCHAR(36),
    external_client_id      VARCHAR(255),
    CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id)
);

CREATE TABLE user_consent_client_scope
(
    user_consent_id VARCHAR(36) NOT NULL,
    scope_id        VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id)
);

CREATE TABLE user_entity
(
    id                          VARCHAR(36)           NOT NULL,
    email                       VARCHAR(255),
    email_constraint            VARCHAR(255),
    email_verified              BOOLEAN DEFAULT FALSE NOT NULL,
    enabled                     BOOLEAN DEFAULT FALSE NOT NULL,
    federation_link             VARCHAR(255),
    first_name                  VARCHAR(255),
    last_name                   VARCHAR(255),
    realm_id                    VARCHAR(255),
    username                    VARCHAR(255),
    created_timestamp           BIGINT,
    service_account_client_link VARCHAR(255),
    not_before                  INTEGER DEFAULT 0     NOT NULL,
    CONSTRAINT constraint_fb PRIMARY KEY (id)
);

CREATE TABLE user_federation_config
(
    user_federation_provider_id VARCHAR(36)  NOT NULL,
    value                       VARCHAR(255),
    name                        VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name)
);

CREATE TABLE user_federation_mapper
(
    id                     VARCHAR(36)  NOT NULL,
    name                   VARCHAR(255) NOT NULL,
    federation_provider_id VARCHAR(36)  NOT NULL,
    federation_mapper_type VARCHAR(255) NOT NULL,
    realm_id               VARCHAR(36)  NOT NULL,
    CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id)
);

CREATE TABLE user_federation_mapper_config
(
    user_federation_mapper_id VARCHAR(36)  NOT NULL,
    value                     VARCHAR(255),
    name                      VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name)
);

CREATE TABLE user_federation_provider
(
    id                  VARCHAR(36) NOT NULL,
    changed_sync_period INTEGER,
    display_name        VARCHAR(255),
    full_sync_period    INTEGER,
    last_sync           INTEGER,
    priority            INTEGER,
    provider_name       VARCHAR(255),
    realm_id            VARCHAR(36),
    CONSTRAINT constraint_5c PRIMARY KEY (id)
);

CREATE TABLE user_group_membership
(
    group_id VARCHAR(36) NOT NULL,
    user_id  VARCHAR(36) NOT NULL,
    CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id)
);

CREATE TABLE user_required_action
(
    user_id         VARCHAR(36)              NOT NULL,
    required_action VARCHAR(255) DEFAULT ' ' NOT NULL
);

CREATE TABLE user_role_mapping
(
    role_id VARCHAR(255) NOT NULL,
    user_id VARCHAR(36)  NOT NULL,
    CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id)
);

CREATE TABLE user_session
(
    id                   VARCHAR(36)           NOT NULL,
    auth_method          VARCHAR(255),
    ip_address           VARCHAR(255),
    last_session_refresh INTEGER,
    login_username       VARCHAR(255),
    realm_id             VARCHAR(255),
    remember_me          BOOLEAN DEFAULT FALSE NOT NULL,
    started              INTEGER,
    user_id              VARCHAR(255),
    user_session_state   INTEGER,
    broker_session_id    VARCHAR(255),
    broker_user_id       VARCHAR(255),
    CONSTRAINT constraint_57 PRIMARY KEY (id)
);

CREATE TABLE user_session_note
(
    user_session VARCHAR(36)  NOT NULL,
    name         VARCHAR(255) NOT NULL,
    value        VARCHAR(2048),
    CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name)
);

CREATE TABLE username_login_failure
(
    realm_id                VARCHAR(36)  NOT NULL,
    username                VARCHAR(255) NOT NULL,
    failed_login_not_before INTEGER,
    last_failure            BIGINT,
    last_ip_failure         VARCHAR(255),
    num_failures            INTEGER,
    CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username)
);

CREATE TABLE web_origins
(
    client_id VARCHAR(36)  NOT NULL,
    value     VARCHAR(255) NOT NULL,
    CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value)
);

ALTER TABLE client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);

ALTER TABLE client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);

ALTER TABLE client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);

ALTER TABLE realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);

ALTER TABLE client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);

ALTER TABLE client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);

ALTER TABLE offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider,
                                                           external_client_id, offline_flag);

ALTER TABLE user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);

ALTER TABLE keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);

ALTER TABLE realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);

ALTER TABLE keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);

ALTER TABLE identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);

ALTER TABLE client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);

ALTER TABLE client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);

ALTER TABLE user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);

ALTER TABLE resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);

ALTER TABLE resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);

ALTER TABLE resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);

ALTER TABLE resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);

ALTER TABLE user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);

ALTER TABLE realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);

ALTER TABLE user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);

CREATE INDEX idx_admin_event_time ON admin_event_entity (realm_id, admin_event_time);

CREATE INDEX idx_auth_exec_realm_flow ON authentication_execution (realm_id, flow_id);

CREATE INDEX idx_cl_clscope ON client_scope_client (scope_id);

CREATE INDEX idx_client_id ON client (client_id);

CREATE INDEX idx_clscope_cl ON client_scope_client (client_id);

CREATE INDEX idx_component_provider_type ON component (provider_type);

CREATE INDEX idx_defcls_scope ON default_client_scope (scope_id);

CREATE INDEX idx_event_time ON event_entity (realm_id, event_time);

CREATE INDEX idx_fedidentity_feduser ON federated_identity (federated_user_id);

CREATE INDEX idx_fu_attribute ON fed_user_attribute (user_id, realm_id, name);

CREATE INDEX idx_fu_cnsnt_ext ON fed_user_consent (user_id, client_storage_provider, external_client_id);

CREATE INDEX idx_fu_consent ON fed_user_consent (user_id, client_id);

CREATE INDEX idx_fu_consent_ru ON fed_user_consent (realm_id, user_id);

CREATE INDEX idx_fu_credential ON fed_user_credential (user_id, type);

CREATE INDEX idx_fu_credential_ru ON fed_user_credential (realm_id, user_id);

CREATE INDEX idx_fu_group_membership ON fed_user_group_membership (user_id, group_id);

CREATE INDEX idx_fu_group_membership_ru ON fed_user_group_membership (realm_id, user_id);

CREATE INDEX idx_fu_required_action ON fed_user_required_action (user_id, required_action);

CREATE INDEX idx_fu_required_action_ru ON fed_user_required_action (realm_id, user_id);

CREATE INDEX idx_fu_role_mapping ON fed_user_role_mapping (user_id, role_id);

CREATE INDEX idx_fu_role_mapping_ru ON fed_user_role_mapping (realm_id, user_id);

CREATE INDEX idx_keycloak_role_client ON keycloak_role (client);

CREATE INDEX idx_offline_css_preload ON offline_client_session (client_id, offline_flag);

CREATE INDEX idx_offline_uss_by_user ON offline_user_session (user_id, realm_id, offline_flag);

CREATE INDEX idx_offline_uss_by_usersess ON offline_user_session (realm_id, offline_flag, user_session_id);

CREATE INDEX idx_offline_uss_createdon ON offline_user_session (created_on);

CREATE INDEX idx_offline_uss_preload ON offline_user_session (offline_flag, created_on, user_session_id);

CREATE INDEX idx_realm_clscope ON client_scope (realm_id);

CREATE INDEX idx_realm_master_adm_cli ON realm (master_admin_client);

CREATE INDEX idx_role_clscope ON client_scope_role_mapping (role_id);

CREATE INDEX idx_scope_mapping_role ON scope_mapping (role_id);

CREATE INDEX idx_update_time ON migration_model (update_time);

CREATE INDEX idx_us_sess_id_on_cl_sess ON offline_client_session (user_session_id);

CREATE INDEX idx_user_attribute_name ON user_attribute (name, value);

CREATE INDEX idx_user_email ON user_entity (email);

CREATE INDEX idx_user_service_account ON user_entity (realm_id, service_account_client_link);

ALTER TABLE client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES client_session (id) ON DELETE NO ACTION;

ALTER TABLE identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_ident_prov_realm ON identity_provider (realm_id);

ALTER TABLE client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES client (id) ON DELETE NO ACTION;

ALTER TABLE federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES user_entity (id) ON DELETE NO ACTION;

CREATE INDEX idx_fedidentity_user ON federated_identity (user_id);

ALTER TABLE client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES client (id) ON DELETE NO ACTION;

ALTER TABLE client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES client_session (id) ON DELETE NO ACTION;

ALTER TABLE user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES user_session (id) ON DELETE NO ACTION;

ALTER TABLE client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES client_session (id) ON DELETE NO ACTION;

ALTER TABLE redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES client (id) ON DELETE NO ACTION;

CREATE INDEX idx_redir_uri_client ON redirect_uris (client_id);

ALTER TABLE user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_usr_fed_prv_realm ON user_federation_provider (realm_id);

ALTER TABLE client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES client_session (id) ON DELETE NO ACTION;

ALTER TABLE realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

ALTER TABLE resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES resource_server_resource (id) ON DELETE NO ACTION;

ALTER TABLE user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES user_entity (id) ON DELETE NO ACTION;

CREATE INDEX idx_user_attribute ON user_attribute (user_id);

ALTER TABLE user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES user_entity (id) ON DELETE NO ACTION;

CREATE INDEX idx_user_reqactions ON user_required_action (user_id);

ALTER TABLE keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_keycloak_role_realm ON keycloak_role (realm);

ALTER TABLE realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

ALTER TABLE realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_realm_attr_realm ON realm_attribute (realm_id);

ALTER TABLE composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES keycloak_role (id) ON DELETE NO ACTION;

CREATE INDEX idx_composite ON composite_role (composite);

ALTER TABLE authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES authentication_flow (id) ON DELETE NO ACTION;

CREATE INDEX idx_auth_exec_flow ON authentication_execution (flow_id);

ALTER TABLE authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

ALTER TABLE authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_auth_flow_realm ON authentication_flow (realm_id);

ALTER TABLE authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_auth_config_realm ON authenticator_config (realm_id);

ALTER TABLE client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES user_session (id) ON DELETE NO ACTION;

CREATE INDEX idx_client_session_session ON client_session (session_id);

ALTER TABLE user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES user_entity (id) ON DELETE NO ACTION;

CREATE INDEX idx_user_role_mapping ON user_role_mapping (user_id);

ALTER TABLE client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES client_scope (id) ON DELETE NO ACTION;

CREATE INDEX idx_clscope_attrs ON client_scope_attributes (scope_id);

ALTER TABLE client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES client_scope (id) ON DELETE NO ACTION;

CREATE INDEX idx_clscope_role ON client_scope_role_mapping (scope_id);

ALTER TABLE client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES client_session (id) ON DELETE NO ACTION;

ALTER TABLE protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES client_scope (id) ON DELETE NO ACTION;

CREATE INDEX idx_clscope_protmap ON protocol_mapper (client_scope_id);

ALTER TABLE client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_client_init_acc_realm ON client_initial_access (realm_id);

ALTER TABLE component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES component (id) ON DELETE NO ACTION;

CREATE INDEX idx_compo_config_compo ON component_config (component_id);

ALTER TABLE component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_component_realm ON component (realm_id);

ALTER TABLE realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_realm_def_grp_realm ON realm_default_groups (realm_id);

ALTER TABLE user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES user_federation_mapper (id) ON DELETE NO ACTION;

ALTER TABLE user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES user_federation_provider (id) ON DELETE NO ACTION;

CREATE INDEX idx_usr_fed_map_fed_prv ON user_federation_mapper (federation_provider_id);

ALTER TABLE user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_usr_fed_map_realm ON user_federation_mapper (realm_id);

ALTER TABLE associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES resource_server_policy (id) ON DELETE NO ACTION;

CREATE INDEX idx_assoc_pol_assoc_pol_id ON associated_policy (associated_policy_id);

ALTER TABLE scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES resource_server_policy (id) ON DELETE NO ACTION;

CREATE INDEX idx_scope_policy_policy ON scope_policy (policy_id);

ALTER TABLE resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES resource_server (id) ON DELETE NO ACTION;

ALTER TABLE resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES resource_server (id) ON DELETE NO ACTION;

CREATE INDEX idx_res_srv_res_res_srv ON resource_server_resource (resource_server_id);

ALTER TABLE resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES resource_server_resource (id) ON DELETE NO ACTION;

ALTER TABLE resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES resource_server_scope (id) ON DELETE NO ACTION;

ALTER TABLE associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES resource_server_policy (id) ON DELETE NO ACTION;

ALTER TABLE scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES resource_server_scope (id) ON DELETE NO ACTION;

ALTER TABLE resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES resource_server_policy (id) ON DELETE NO ACTION;

ALTER TABLE resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES resource_server (id) ON DELETE NO ACTION;

CREATE INDEX idx_res_serv_pol_res_serv ON resource_server_policy (resource_server_id);

ALTER TABLE resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES resource_server_resource (id) ON DELETE NO ACTION;

ALTER TABLE resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES resource_server_resource (id) ON DELETE NO ACTION;

ALTER TABLE resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES resource_server_policy (id) ON DELETE NO ACTION;

CREATE INDEX idx_res_policy_policy ON resource_policy (policy_id);

ALTER TABLE resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES resource_server_scope (id) ON DELETE NO ACTION;

CREATE INDEX idx_res_scope_scope ON resource_scope (scope_id);

ALTER TABLE resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES resource_server (id) ON DELETE NO ACTION;

CREATE INDEX idx_res_srv_scope_res_srv ON resource_server_scope (resource_server_id);

ALTER TABLE composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES keycloak_role (id) ON DELETE NO ACTION;

CREATE INDEX idx_composite_child ON composite_role (child_role);

ALTER TABLE user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES user_consent (id) ON DELETE NO ACTION;

CREATE INDEX idx_usconsent_clscope ON user_consent_client_scope (user_consent_id);

ALTER TABLE user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES user_entity (id) ON DELETE NO ACTION;

CREATE INDEX idx_user_consent ON user_consent (user_id);

ALTER TABLE group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES keycloak_group (id) ON DELETE NO ACTION;

CREATE INDEX idx_group_attr_group ON group_attribute (group_id);

ALTER TABLE group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES keycloak_group (id) ON DELETE NO ACTION;

CREATE INDEX idx_group_role_mapp_group ON group_role_mapping (group_id);

ALTER TABLE realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_realm_evt_types_realm ON realm_enabled_event_types (realm_id);

ALTER TABLE realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_realm_evt_list_realm ON realm_events_listeners (realm_id);

ALTER TABLE identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_id_prov_mapp_realm ON identity_provider_mapper (realm_id);

ALTER TABLE idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES identity_provider_mapper (id) ON DELETE NO ACTION;

ALTER TABLE web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES client (id) ON DELETE NO ACTION;

CREATE INDEX idx_web_orig_client ON web_origins (client_id);

ALTER TABLE scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES client (id) ON DELETE NO ACTION;

ALTER TABLE protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES client (id) ON DELETE NO ACTION;

CREATE INDEX idx_protocol_mapper_client ON protocol_mapper (client_id);

ALTER TABLE credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES user_entity (id) ON DELETE NO ACTION;

CREATE INDEX idx_user_credential ON credential (user_id);

ALTER TABLE protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES protocol_mapper (id) ON DELETE NO ACTION;

ALTER TABLE default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_defcls_realm ON default_client_scope (realm_id);

ALTER TABLE required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_req_act_prov_realm ON required_action_provider (realm_id);

ALTER TABLE resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES resource_server_resource (id) ON DELETE NO ACTION;

ALTER TABLE role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES keycloak_role (id) ON DELETE NO ACTION;

CREATE INDEX idx_role_attribute ON role_attribute (role_id);

ALTER TABLE realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE NO ACTION;

CREATE INDEX idx_realm_supp_local_realm ON realm_supported_locales (realm_id);

ALTER TABLE user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES user_federation_provider (id) ON DELETE NO ACTION;

ALTER TABLE user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES user_entity (id) ON DELETE NO ACTION;

CREATE INDEX idx_user_group_mapping ON user_group_membership (user_id);

ALTER TABLE policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES resource_server_policy (id) ON DELETE NO ACTION;

ALTER TABLE identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES identity_provider (internal_id) ON DELETE NO ACTION;