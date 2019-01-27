# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_27_201920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "aspects", force: :cascade do |t|
    t.string "name"
    t.string "alpha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "facet", null: false
    t.index ["alpha"], name: "index_aspects_on_alpha"
    t.index ["facet"], name: "index_aspects_on_facet"
  end

  create_table "aspects_works", id: false, force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "aspect_id", null: false
    t.index ["aspect_id", "work_id"], name: "index_aspects_works_on_aspect_id_and_work_id"
    t.index ["work_id", "aspect_id"], name: "by_work_and_aspect", unique: true
    t.index ["work_id", "aspect_id"], name: "index_aspects_works_on_work_id_and_aspect_id"
  end

  create_table "attributions", force: :cascade do |t|
    t.string "type"
    t.bigint "creator_id"
    t.bigint "work_id"
    t.bigint "role_id"
    t.string "alpha"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alpha"], name: "index_attributions_on_alpha"
    t.index ["creator_id"], name: "index_attributions_on_creator_id"
    t.index ["role_id"], name: "index_attributions_on_role_id"
    t.index ["work_id"], name: "index_attributions_on_work_id"
  end

  create_table "creator_identities", force: :cascade do |t|
    t.bigint "real_name_id"
    t.bigint "pseudonym_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pseudonym_id"], name: "index_creator_identities_on_pseudonym_id"
    t.index ["real_name_id"], name: "index_creator_identities_on_real_name_id"
  end

  create_table "creator_memberships", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_creator_memberships_on_group_id"
    t.index ["member_id"], name: "index_creator_memberships_on_member_id"
  end

  create_table "creators", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "primary", default: true, null: false
    t.boolean "individual", default: true, null: false
    t.string "alpha"
    t.index ["alpha"], name: "index_creators_on_alpha"
    t.index ["individual"], name: "index_creators_on_individual"
    t.index ["primary"], name: "index_creators_on_primary"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "links", force: :cascade do |t|
    t.string "linkable_type"
    t.bigint "linkable_id"
    t.string "url"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linkable_type", "linkable_id"], name: "index_links_on_linkable_type_and_linkable_id"
  end

  create_table "playlist_tracks", force: :cascade do |t|
    t.bigint "playlist_id"
    t.bigint "work_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_playlist_tracks_on_playlist_id"
    t.index ["work_id"], name: "index_playlist_tracks_on_work_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "title"
    t.bigint "author_id"
    t.string "alpha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alpha"], name: "index_playlists_on_alpha"
  end

  create_table "posts", force: :cascade do |t|
    t.string "type"
    t.bigint "author_id"
    t.string "title"
    t.bigint "playlist_id"
    t.bigint "work_id"
    t.text "body"
    t.text "summary"
    t.string "alpha"
    t.string "slug"
    t.integer "status", default: 0, null: false
    t.datetime "publish_on"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alpha"], name: "index_posts_on_alpha"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["playlist_id"], name: "index_posts_on_playlist_id"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["status"], name: "index_posts_on_status"
    t.index ["type"], name: "index_posts_on_type"
    t.index ["work_id"], name: "index_posts_on_work_id"
  end

  create_table "posts_tags", id: false, force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "tag_id", null: false
    t.index ["post_id", "tag_id"], name: "by_post_and_tag", unique: true
    t.index ["post_id", "tag_id"], name: "index_posts_tags_on_post_id_and_tag_id"
    t.index ["tag_id", "post_id"], name: "index_posts_tags_on_tag_id_and_post_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "alpha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "medium", null: false
    t.index ["alpha"], name: "index_roles_on_alpha"
    t.index ["medium"], name: "index_roles_on_medium"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "alpha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alpha"], name: "index_tags_on_alpha"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 10, null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "username", null: false
    t.text "bio"
    t.string "alpha"
    t.index ["alpha"], name: "index_users_on_alpha"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "work_milestones", force: :cascade do |t|
    t.bigint "work_id"
    t.integer "activity", null: false
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity"], name: "index_work_milestones_on_activity"
    t.index ["work_id"], name: "index_work_milestones_on_work_id"
  end

  create_table "work_relationships", force: :cascade do |t|
    t.bigint "target_id", null: false
    t.integer "connection", null: false
    t.bigint "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_work_relationships_on_source_id"
    t.index ["target_id"], name: "index_work_relationships_on_target_id"
  end

  create_table "works", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle"
    t.string "alpha"
    t.string "medium"
    t.string "display_makers"
    t.index ["alpha"], name: "index_works_on_alpha"
    t.index ["medium"], name: "index_works_on_medium"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attributions", "creators"
  add_foreign_key "attributions", "roles"
  add_foreign_key "attributions", "works"
  add_foreign_key "creator_identities", "creators", column: "pseudonym_id"
  add_foreign_key "creator_identities", "creators", column: "real_name_id"
  add_foreign_key "creator_memberships", "creators", column: "group_id"
  add_foreign_key "creator_memberships", "creators", column: "member_id"
  add_foreign_key "playlists", "users", column: "author_id"
  add_foreign_key "posts", "playlists"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "posts", "works"
  add_foreign_key "work_milestones", "works"
  add_foreign_key "work_relationships", "works", column: "source_id"
  add_foreign_key "work_relationships", "works", column: "target_id"
end
