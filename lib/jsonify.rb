class Jsonify
  def initialize(route, model)
    @route = route
    @model = model
  end

  def call(env)
    path = env['REQUEST_PATH']
    response = path == @route ? all : one(find_id(path))
    header = @model.http_cache_header.merge("Content-Type" => "application/json")
    [200, header, [response]]
  end

  private

  def all
    @model.all.to_json
  end

  def one(id)
    @model.find(id).to_json
  end

  def find_id(path)
    path[path.rindex('/') + 1, path.size]
  end
end
