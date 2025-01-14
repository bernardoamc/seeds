class User < OpenStruct
  def self.create(username, attributes={})
    user = new({username: username, email: "#{username}@example.com"}.merge(attributes))
    id = TARGET[:users].insert(user.to_h)
    user.id = id
    LifecycleEvent.track('joined', id, user.created_at)
    user
  end

  def self.find(username)
    new(TARGET[:users].where(username: username).first)
  end

  def initialize(attributes)
    super(default_attributes.update(attributes))
  end

  private

  def at
    @at ||= Timestamp.random
  end

  def default_attributes
    {
      key: Key.user,
      github_id: GitHub.id,
      created_at: at,
      updated_at: at,
      track_mentor: [].to_yaml,
      avatar_url: Avatar.random
    }
  end
end
