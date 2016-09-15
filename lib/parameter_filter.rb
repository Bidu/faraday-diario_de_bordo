class ParameterFilter
  FILTERED = '[FILTERED]'.freeze

  def initialize(filters)
    @filters = filters.map(&:to_s)
  end

  def call(params, parents = [])
    return params unless params.is_a?(Hash)
    filtered_params = {}

    params.each do |key, value|
      parents.push(key)
      if value.is_a?(Hash)
        value = call(value, parents)
      else
        joined = parents.join('.')
        value = FILTERED if @filters.include?(joined)
      end
      parents.pop
      filtered_params[key] = value
    end

    filtered_params
  end
end
