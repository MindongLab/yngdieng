CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL,
    CONSTRAINT pk___ef_migrations_history PRIMARY KEY (migration_id)
);

CREATE TYPE extension_scope AS ENUM ('contrib', 'dragon_boat');
CREATE TYPE sandhi_category AS ENUM ('unspecified', 'sandhi', 'bengzi');
CREATE TYPE variant AS ENUM ('unspecified', 'fuzhou_city', 'lianjiang', 'cikling');

CREATE TABLE speakers (
    speaker_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    display_name text NOT NULL,
    location text NULL,
    CONSTRAINT pk_speakers PRIMARY KEY (speaker_id)
);

CREATE TABLE word_lists (
    word_list_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    title text NOT NULL,
    description text NOT NULL,
    update_time timestamp NOT NULL,
    creation_time timestamp NOT NULL,
    CONSTRAINT pk_word_lists PRIMARY KEY (word_list_id)
);

CREATE TABLE words (
    word_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    hanzi text NOT NULL,
    hanzi_alternatives text[] NOT NULL,
    mandarin_words text[] NOT NULL,
    gloss text NULL,
    CONSTRAINT pk_words PRIMARY KEY (word_id)
);

CREATE TABLE audio_clips (
    audio_clip_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    speaker_id integer NULL,
    pronunciation text NOT NULL,
    blob_location text NOT NULL,
    mime_type text NOT NULL,
    creation_time timestamp NOT NULL,
    CONSTRAINT pk_audio_clips PRIMARY KEY (audio_clip_id),
    CONSTRAINT fk_audio_clips_speakers_speaker_id FOREIGN KEY (speaker_id) REFERENCES speakers (speaker_id) ON DELETE RESTRICT
);

CREATE TABLE extensions (
    word_id integer NOT NULL,
    extension_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    explanation text NOT NULL,
    contributors text[] NOT NULL,
    source text NOT NULL,
    scope extension_scope NOT NULL,
    CONSTRAINT pk_extensions PRIMARY KEY (word_id, extension_id),
    CONSTRAINT fk_extensions_words_word_id FOREIGN KEY (word_id) REFERENCES words (word_id) ON DELETE CASCADE
);

CREATE TABLE prons (
    word_id integer NOT NULL,
    pron_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    pronunciation text NOT NULL,
    weight bigint NULL,
    variant variant NULL,
    sandhi_category sandhi_category NULL,
    CONSTRAINT pk_prons PRIMARY KEY (word_id, pron_id),
    CONSTRAINT fk_prons_words_word_id FOREIGN KEY (word_id) REFERENCES words (word_id) ON DELETE CASCADE
);

CREATE TABLE word_list_words (
    word_list_id integer NOT NULL,
    word_id integer NOT NULL,
    ordering integer NOT NULL,
    CONSTRAINT pk_word_list_words PRIMARY KEY (word_list_id, word_id),
    CONSTRAINT fk_word_list_words_words_word_id FOREIGN KEY (word_id) REFERENCES words (word_id) ON DELETE CASCADE,
    CONSTRAINT fk_word_list_words_word_lists_word_list_id FOREIGN KEY (word_list_id) REFERENCES word_lists (word_list_id) ON DELETE CASCADE
);

CREATE TABLE pron_audio_clips (
    word_id integer NOT NULL,
    pron_id integer NOT NULL,
    audio_clip_id integer NOT NULL,
    CONSTRAINT pk_pron_audio_clips PRIMARY KEY (word_id, pron_id, audio_clip_id),
    CONSTRAINT fk_pron_audio_clips_prons_word_id_pron_id FOREIGN KEY (word_id, audio_clip_id) REFERENCES prons (word_id, pron_id) ON DELETE CASCADE
);

CREATE INDEX ix_audio_clips_speaker_id ON audio_clips (speaker_id);

CREATE INDEX ix_pron_audio_clips_word_id_audio_clip_id ON pron_audio_clips (word_id, audio_clip_id);

CREATE INDEX ix_word_list_words_word_id ON word_list_words (word_id);

INSERT INTO "__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20201016185536_Initial', '3.1.9');

INSERT INTO "__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20201017121917_Keyless', '3.1.9');

CREATE TYPE gender AS ENUM ('unspecified', 'male', 'female');

ALTER TABLE speakers ADD accent text NULL;

ALTER TABLE speakers ADD gender gender NOT NULL DEFAULT 'unspecified'::gender;

ALTER TABLE speakers ADD year_of_birth integer NULL;

INSERT INTO "__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20201018163503_SpeakersColumns', '3.1.9');

CREATE TABLE word_audio_clips (
    word_id integer NOT NULL,
    audio_clip_id integer NOT NULL,
    CONSTRAINT pk_word_audio_clips PRIMARY KEY (word_id, audio_clip_id),
    CONSTRAINT fk_word_audio_clips_prons_pron_word_id_pron_id FOREIGN KEY (word_id, audio_clip_id) REFERENCES prons (word_id, pron_id) ON DELETE CASCADE
);

INSERT INTO "__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20201023002148_WordAudioClip', '3.1.9');

ALTER TABLE pron_audio_clips DROP CONSTRAINT fk_pron_audio_clips_prons_word_id_pron_id;

ALTER TABLE word_audio_clips DROP CONSTRAINT fk_word_audio_clips_prons_pron_word_id_pron_id;

DROP INDEX ix_pron_audio_clips_word_id_audio_clip_id;

CREATE INDEX ix_word_audio_clips_audio_clip_id ON word_audio_clips (audio_clip_id);

CREATE INDEX ix_pron_audio_clips_audio_clip_id ON pron_audio_clips (audio_clip_id);

ALTER TABLE pron_audio_clips ADD CONSTRAINT fk_pron_audio_clips_audio_clips_audio_clip_id FOREIGN KEY (audio_clip_id) REFERENCES audio_clips (audio_clip_id) ON DELETE CASCADE;

ALTER TABLE pron_audio_clips ADD CONSTRAINT fk_pron_audio_clips_prons_word_id_pron_id FOREIGN KEY (word_id, pron_id) REFERENCES prons (word_id, pron_id) ON DELETE CASCADE;

ALTER TABLE word_audio_clips ADD CONSTRAINT fk_word_audio_clips_audio_clips_audio_clip_id FOREIGN KEY (audio_clip_id) REFERENCES audio_clips (audio_clip_id) ON DELETE CASCADE;

ALTER TABLE word_audio_clips ADD CONSTRAINT fk_word_audio_clips_words_word_id FOREIGN KEY (word_id) REFERENCES words (word_id) ON DELETE CASCADE;

INSERT INTO "__EFMigrationsHistory" (migration_id, product_version)
VALUES ('20201023115513_FixForeignKeys', '3.1.9');


