# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :redis_session_store, {
  key: '_taskzero-key',
  redis: {
    expire_after: 120.minutes,
    key_prefix: 'taskzero:session:',
    url: 'redis://127.0.0.1'
  }
}
