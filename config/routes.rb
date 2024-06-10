# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  devise_for :users, path: "auth"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
  mount ActionCable.server => "/cable"
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  resources :files, only: :show, controller: "shimmer/files"

  root to: "pages#home"
  resources :users
  resources :books do
    resources :accounts
    resources :categories
  end
end

# == Route Map
#
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                                 /assets                                                                                           Propshaft::Server
#                         new_user_session GET    /auth/sign_in(.:format)                                                                           devise/sessions#new
#                             user_session POST   /auth/sign_in(.:format)                                                                           devise/sessions#create
#                     destroy_user_session DELETE /auth/sign_out(.:format)                                                                          devise/sessions#destroy
#                        new_user_password GET    /auth/password/new(.:format)                                                                      devise/passwords#new
#                       edit_user_password GET    /auth/password/edit(.:format)                                                                     devise/passwords#edit
#                            user_password PATCH  /auth/password(.:format)                                                                          devise/passwords#update
#                                          PUT    /auth/password(.:format)                                                                          devise/passwords#update
#                                          POST   /auth/password(.:format)                                                                          devise/passwords#create
#                 cancel_user_registration GET    /auth/cancel(.:format)                                                                            devise/registrations#cancel
#                    new_user_registration GET    /auth/sign_up(.:format)                                                                           devise/registrations#new
#                   edit_user_registration GET    /auth/edit(.:format)                                                                              devise/registrations#edit
#                        user_registration PATCH  /auth(.:format)                                                                                   devise/registrations#update
#                                          PUT    /auth(.:format)                                                                                   devise/registrations#update
#                                          DELETE /auth(.:format)                                                                                   devise/registrations#destroy
#                                          POST   /auth(.:format)                                                                                   devise/registrations#create
#                              sidekiq_web        /sidekiq                                                                                          Sidekiq::Web
#                                                 /cable                                                                                            #<ActionCable::Server::Base:0x000000010de7fd20 @config=#<ActionCable::Server::Configuration:0x000000010d39cdb8 @log_tags=[], @connection_class=#<Proc:0x000000010a0add58 /Users/adeynack/.rbenv/versions/3.2.3/lib/ruby/gems/3.2.0/gems/actioncable-7.1.3/lib/action_cable/engine.rb:53 (lambda)>, @worker_pool_size=4, @disable_request_forgery_protection=false, @allow_same_origin_as_host=true, @filter_parameters=[:passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn], @health_check_application=#<Proc:0x000000010a24f440 /Users/adeynack/.rbenv/versions/3.2.3/lib/ruby/gems/3.2.0/gems/actioncable-7.1.3/lib/action_cable/engine.rb:29 (lambda)>, @logger=#<ActiveSupport::BroadcastLogger:0x000000010c957f60 @broadcasts=[#<ActiveSupport::Logger:0x000000010b7eb7e0 @level=0, @progname=nil, @default_formatter=#<Logger::Formatter:0x000000010c958eb0 @datetime_format=nil>, @formatter=#<ActiveSupport::Logger::SimpleFormatter:0x000000010c958460 @datetime_format=nil>, @logdev=#<Logger::LogDevice:0x000000010b7eb830 @shift_period_suffix="%Y%m%d", @shift_size=1048576, @shift_age=0, @filename="/Users/adeynack/src/github.com/Adeynack/finances_rails/log/development.log", @dev=#<File:/Users/adeynack/src/github.com/Adeynack/finances_rails/log/development.log>, @binmode=false, @mon_data=#<Monitor:0x000000010c958cd0>, @mon_data_owner_object_id=7760>>], @progname="Broadcast", @formatter=#<ActiveSupport::Logger::SimpleFormatter:0x000000010c958460 @datetime_format=nil>>, @cable={"adapter"=>"async"}, @mount_path="/cable", @precompile_assets=true, @allowed_request_origins=/https?:\/\/localhost:\d+/>, @mutex=#<Monitor:0x000000010ad4b768>, @pubsub=nil, @worker_pool=nil, @event_loop=nil, @remote_connections=nil>
#                                          GET    /sitemaps/*path(.:format)                                                                         shimmer/sitemaps#show
#                                     file GET    /files/:id(.:format)                                                                              shimmer/files#show
#                                     root GET    /                                                                                                 pages#home
#                                    users GET    /users(.:format)                                                                                  users#index
#                                          POST   /users(.:format)                                                                                  users#create
#                                 new_user GET    /users/new(.:format)                                                                              users#new
#                                edit_user GET    /users/:id/edit(.:format)                                                                         users#edit
#                                     user GET    /users/:id(.:format)                                                                              users#show
#                                          PATCH  /users/:id(.:format)                                                                              users#update
#                                          PUT    /users/:id(.:format)                                                                              users#update
#                                          DELETE /users/:id(.:format)                                                                              users#destroy
#                            book_accounts GET    /books/:book_id/accounts(.:format)                                                                accounts#index
#                                          POST   /books/:book_id/accounts(.:format)                                                                accounts#create
#                         new_book_account GET    /books/:book_id/accounts/new(.:format)                                                            accounts#new
#                        edit_book_account GET    /books/:book_id/accounts/:id/edit(.:format)                                                       accounts#edit
#                             book_account GET    /books/:book_id/accounts/:id(.:format)                                                            accounts#show
#                                          PATCH  /books/:book_id/accounts/:id(.:format)                                                            accounts#update
#                                          PUT    /books/:book_id/accounts/:id(.:format)                                                            accounts#update
#                                          DELETE /books/:book_id/accounts/:id(.:format)                                                            accounts#destroy
#                          book_categories GET    /books/:book_id/categories(.:format)                                                              categories#index
#                                          POST   /books/:book_id/categories(.:format)                                                              categories#create
#                        new_book_category GET    /books/:book_id/categories/new(.:format)                                                          categories#new
#                       edit_book_category GET    /books/:book_id/categories/:id/edit(.:format)                                                     categories#edit
#                            book_category GET    /books/:book_id/categories/:id(.:format)                                                          categories#show
#                                          PATCH  /books/:book_id/categories/:id(.:format)                                                          categories#update
#                                          PUT    /books/:book_id/categories/:id(.:format)                                                          categories#update
#                                          DELETE /books/:book_id/categories/:id(.:format)                                                          categories#destroy
#                                    books GET    /books(.:format)                                                                                  books#index
#                                          POST   /books(.:format)                                                                                  books#create
#                                 new_book GET    /books/new(.:format)                                                                              books#new
#                                edit_book GET    /books/:id/edit(.:format)                                                                         books#edit
#                                     book GET    /books/:id(.:format)                                                                              books#show
#                                          PATCH  /books/:id(.:format)                                                                              books#update
#                                          PUT    /books/:id(.:format)                                                                              books#update
#                                          DELETE /books/:id(.:format)                                                                              books#destroy
#         turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#         turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#        turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#            rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#        new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#            rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
# new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
# rails_conductor_inbound_email_incinerate POST   /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                       rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
