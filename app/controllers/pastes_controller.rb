class PastesController < ApplicationController
  PASTES_PREFIX = 'pastes'
  TIMESTAMPS_PREFIX = 'timestamps'

  before_action :authenticate_user!

  def create
    paste_contents = params[:paste][:contents]
    redis.set(user_paste_key, paste_contents)

    now = Time.now.to_i
    redis.set(user_timestamp_key, now)

    result = {paste: {contents: paste_contents, timestamp: now}}
    render json: result, content_type: 'application/json'
  end

  def show
    paste_contents = redis.get(user_paste_key)
    paste_timestamp = redis.get(user_timestamp_key)
    
    result = {paste: {contents: paste_contents, timestamp: paste_timestamp}}
    render json: result, content_type: 'application/json'

    # redis.set(user_paste_key, "set remotely")
    # now = Time.now.to_i
    # redis.set(user_timestamp_key, now)
  end  

  private

  def user_paste_key
    "#{PASTES_PREFIX}-#{user_id}-#{device_uuid}"
  end

  def user_timestamp_key
    "#{TIMESTAMPS_PREFIX}-#{user_id}-#{device_uuid}"
  end

  def user_id
    current_user.id.to_s
  end

  def device_uuid
    params[:paste]['device_uuid'][0..10]
  end

  def redis
    $redis
  end
end
