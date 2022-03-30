# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  devise_for :users
  authenticate :user, ->(user) { user.admin? } do
    mount Avo::Engine, at: Avo.configuration.root_path
    mount Sidekiq::Web => "/sidekiq"
  end
  mount ActionCable.server => "/cable"
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  resources :files, only: :show, controller: "shimmer/files"

  root "pages#home"
end

# == Route Map
#
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                         new_user_session GET    /users/sign_in(.:format)                                                                          devise/sessions#new
#                             user_session POST   /users/sign_in(.:format)                                                                          devise/sessions#create
#                     destroy_user_session DELETE /users/sign_out(.:format)                                                                         devise/sessions#destroy
#                        new_user_password GET    /users/password/new(.:format)                                                                     devise/passwords#new
#                       edit_user_password GET    /users/password/edit(.:format)                                                                    devise/passwords#edit
#                            user_password PATCH  /users/password(.:format)                                                                         devise/passwords#update
#                                          PUT    /users/password(.:format)                                                                         devise/passwords#update
#                                          POST   /users/password(.:format)                                                                         devise/passwords#create
#                 cancel_user_registration GET    /users/cancel(.:format)                                                                           devise/registrations#cancel
#                    new_user_registration GET    /users/sign_up(.:format)                                                                          devise/registrations#new
#                   edit_user_registration GET    /users/edit(.:format)                                                                             devise/registrations#edit
#                        user_registration PATCH  /users(.:format)                                                                                  devise/registrations#update
#                                          PUT    /users(.:format)                                                                                  devise/registrations#update
#                                          DELETE /users(.:format)                                                                                  devise/registrations#destroy
#                                          POST   /users(.:format)                                                                                  devise/registrations#create
#                                      avo        /avo                                                                                              Avo::Engine
#                              sidekiq_web        /sidekiq                                                                                          Sidekiq::Web
#                                                 /cable                                                                                            #<ActionCable::Server::Base:0x000000011479ff58 @config=#<ActionCable::Server::Configuration:0x00000001146adf78 @log_tags=[], @connection_class=#<Proc:0x000000011466ea30 /Users/adeynack/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/actioncable-7.0.2.3/lib/action_cable/engine.rb:46 (lambda)>, @worker_pool_size=4, @disable_request_forgery_protection=false, @allow_same_origin_as_host=true, @logger=#<ActiveSupport::Logger:0x000000011307faa8 @level=0, @progname=nil, @default_formatter=#<Logger::Formatter:0x000000011307ff58 @datetime_format=nil>, @formatter=#<ActiveSupport::Logger::SimpleFormatter:0x000000011307f9b8 @datetime_format=nil>, @logdev=#<Logger::LogDevice:0x000000011307fe18 @shift_period_suffix="%Y%m%d", @shift_size=1048576, @shift_age=0, @filename="/Users/adeynack/src/github.com/Adeynack/finances_rebirth/log/development.log", @dev=#<File:/Users/adeynack/src/github.com/Adeynack/finances_rebirth/log/development.log>, @binmode=false, @mon_data=#<Monitor:0x000000011307fdc8>, @mon_data_owner_object_id=57260>>, @cable={"adapter"=>"async"}, @mount_path="/cable", @precompile_assets=true, @allowed_request_origins=/https?:\/\/localhost:\d+/>, @mutex=#<Monitor:0x000000011479feb8>, @pubsub=nil, @worker_pool=nil, @event_loop=nil, @remote_connections=nil>
#                                          GET    /sitemaps/*path(.:format)                                                                         shimmer/sitemaps#show
#                                     file GET    /files/:id(.:format)                                                                              shimmer/files#show
#                                     root GET    /                                                                                                 pages#home
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
#       edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                                 rails/conductor/action_mailbox/inbound_emails#edit
#            rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#                                          PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
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
#
# Routes for Avo::Engine:
#                                root GET    /                                                                                                  avo/home#index
#                           resources GET    /resources(.:format)                                                                               redirect(301, /admin)
# rails_active_storage_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                     active_storage/direct_uploads#create
#                                     GET    /dashboards/:dashboard_id(.:format)                                                                avo/dashboards#show
#                                     GET    /dashboards/:dashboard_id/cards/:card_id(.:format)                                                 avo/dashboards#card
#                      avo_api_search GET    /avo_api/search(.:format)                                                                          avo/search#index
#                             avo_api GET    /avo_api/:resource_name/search(.:format)                                                           avo/search#show
#                                     POST   /avo_api/resources/:resource_name/:id/attachments(.:format)                                        avo/attachments#create
#                      failed_to_load GET    /failed_to_load(.:format)                                                                          avo/home#failed_to_load
#                                     DELETE /resources/:resource_name/:id/active_storage_attachments/:attachment_name/:attachment_id(.:format) avo/attachments#destroy
#                                     PATCH  /resources/:resource_name/:id/order(.:format)                                                      avo/resources#order
#        resources_associations_order PATCH  /resources/:resource_name/:id/:related_name/:related_id/order(.:format)                            avo/associations#order
#                                     GET    /resources/:resource_name(/:id)/actions/:action_id(.:format)                                       avo/actions#show
#                                     POST   /resources/:resource_name(/:id)/actions/:action_id(.:format)                                       avo/actions#handle
#                     resources_books GET    /resources/books(.:format)                                                                         avo/books#index
#                                     POST   /resources/books(.:format)                                                                         avo/books#create
#                  new_resources_book GET    /resources/books/new(.:format)                                                                     avo/books#new
#                 edit_resources_book GET    /resources/books/:id/edit(.:format)                                                                avo/books#edit
#                      resources_book GET    /resources/books/:id(.:format)                                                                     avo/books#show
#                                     PATCH  /resources/books/:id(.:format)                                                                     avo/books#update
#                                     PUT    /resources/books/:id(.:format)                                                                     avo/books#update
#                                     DELETE /resources/books/:id(.:format)                                                                     avo/books#destroy
#                     resources_users GET    /resources/users(.:format)                                                                         avo/users#index
#                                     POST   /resources/users(.:format)                                                                         avo/users#create
#                  new_resources_user GET    /resources/users/new(.:format)                                                                     avo/users#new
#                 edit_resources_user GET    /resources/users/:id/edit(.:format)                                                                avo/users#edit
#                      resources_user GET    /resources/users/:id(.:format)                                                                     avo/users#show
#                                     PATCH  /resources/users/:id(.:format)                                                                     avo/users#update
#                                     PUT    /resources/users/:id(.:format)                                                                     avo/users#update
#                                     DELETE /resources/users/:id(.:format)                                                                     avo/users#destroy
#                 resources_registers GET    /resources/registers(.:format)                                                                     avo/registers#index
#                                     POST   /resources/registers(.:format)                                                                     avo/registers#create
#              new_resources_register GET    /resources/registers/new(.:format)                                                                 avo/registers#new
#             edit_resources_register GET    /resources/registers/:id/edit(.:format)                                                            avo/registers#edit
#                  resources_register GET    /resources/registers/:id(.:format)                                                                 avo/registers#show
#                                     PATCH  /resources/registers/:id(.:format)                                                                 avo/registers#update
#                                     PUT    /resources/registers/:id(.:format)                                                                 avo/registers#update
#                                     DELETE /resources/registers/:id(.:format)                                                                 avo/registers#destroy
#          resources_associations_new GET    /resources/:resource_name/:id/:related_name/new(.:format)                                          avo/associations#new
#        resources_associations_index GET    /resources/:resource_name/:id/:related_name(.:format)                                              avo/associations#index
#         resources_associations_show GET    /resources/:resource_name/:id/:related_name/:related_id(.:format)                                  avo/associations#show
#       resources_associations_create POST   /resources/:resource_name/:id/:related_name(.:format)                                              avo/associations#create
#      resources_associations_destroy DELETE /resources/:resource_name/:id/:related_name/:related_id(.:format)                                  avo/associations#destroy
#                  avo_private_design GET    /avo_private/design(.:format)                                                                      avo/private#design
