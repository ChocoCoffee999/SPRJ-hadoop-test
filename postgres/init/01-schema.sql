set client_min_messages = warning;

create table member (
  id           bigint not null,
  email        varchar(1024),
  password     varchar(1024),
  constraint pk_member primary key (id)
);

create table tag_date (
  id      BIGSERIAL  not null,
  year    integer,
  tag_id  bigint  not null,
  post_count     integer,
  constraint pk_tag_date primary key (id)
);

create table answer (
  id             bigint     not null,
  creation_date  timestamp,
  score          integer,
  body           TEXT,
  post_id      bigint     not null,
  constraint pk_answer primary key (id)
);

create table tag (
  id    bigint       not null,
  name  varchar(50),
  post_count   bigint,
  constraint pk_tag primary key (id)
);

create table tag_and_post (
  tag_id       bigint not null,
  post_id  bigint not null,
  constraint pk_tag_and_post primary key (tag_id, post_id)
);

create table member_tag (
  tag_id     bigint not null,
  member_id  bigint not null,
  constraint pk_member_tag primary key (tag_id, member_id)
);

create table post (
  id                   bigint     not null,
  accepted_answer_id   bigint,
  creation_date        timestamp,
  score                integer,
  view_count           integer,
  body                 TEXT,
  title                TEXT,
  constraint pk_post primary key (id)
);

-- FK (원문과 동일 관계만 유지)
alter table tag_and_post
  add constraint fk_tag_to_tag_and_post
  foreign key (tag_id) references tag (id);

alter table tag_and_post
  add constraint fk_post_to_tag_and_post
  foreign key (post_id) references post (id);

alter table member_tag
  add constraint fk_tag_to_member_tag
  foreign key (tag_id) references tag (id);

alter table member_tag
  add constraint fk_member_to_member_tag
  foreign key (member_id) references member (id);

alter table answer
  add constraint fk_answer_post_post
  foreign key (post_id) references post (id);

alter table post
  add constraint fk_post_accepted_answer
  foreign key (accepted_answer_id) references answer (id);

create index if not exists idx_tag_and_post_tag_id on tag_and_post(tag_id);
create index if not exists idx_tag_and_post_post_id on tag_and_post(post_id);
create index if not exists idx_member_tag_tag_id on member_tag(tag_id);
create index if not exists idx_member_tag_member_id on member_tag(member_id);
create index if not exists idx_answer_post_id on answer(post_id);
create index if not exists idx_post_accepted_answer_id on post(accepted_answer_id);