class Object # http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
  def meta_define name, &blk
    (class << self; self; end).instance_eval { define_method name, &blk }
  end
end